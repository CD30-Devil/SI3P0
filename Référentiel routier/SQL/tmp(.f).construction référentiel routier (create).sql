-- Création d'un lien (éventuellement fictif) entre deux tronçons.
-- Le lien est créé seulement si les deux tronçons ont le même numéro de route.
-- Paramètres :
-- - _IdIGN1 : L'identifiant IGN du premier tronçon.
-- - _IdIGN2 : L'identifiant IGN du second tronçon.
-- - _Extremites : Les extremités à relier, valeur parmi dd, ff, df, fd.
-- - _Fictif (défaut : true) : Booléen indiquant si le lien doit être fictif.
-- Résultats :
-- - Ajoute à la BDTopo (au travers de la vue BDT2RR_SourceTronconDeRoute) un lien entre les deux tronçons.
-- - Retourne un texte indiquant si le lien a bien été créé.
create or replace function LierTroncons(_IdIGN1 character varying, _IdIGN2 character varying, _Extremites character varying, _Fictif boolean default true) returns varchar as $$
begin
    
    with Lien as (
        select
            'L' || right(t1.cleabs, 11) || '-' || right(t2.cleabs, 11)::character varying as cleabs,
            _Fictif as fictif,
            t1.cpx_numero,
            t1.cpx_classement_administratif,
            t1.cpx_gestionnaire,
            case lower(_Extremites)
                when 'dd' then ST_MakeLine(ST_StartPoint(t1.geometrie), ST_StartPoint(t2.geometrie))
                when 'ff' then ST_MakeLine(ST_EndPoint(t1.geometrie), ST_EndPoint(t2.geometrie))
                when 'df' then ST_MakeLine(ST_StartPoint(t1.geometrie), ST_EndPoint(t2.geometrie))
                when 'fd' then ST_MakeLine(ST_EndPoint(t1.geometrie), ST_StartPoint(t2.geometrie))
            end as geometrie
        from BDT2RR_SourceTronconDeRoute t1
        inner join BDT2RR_SourceTronconDeRoute t2 on t1.cpx_numero = t2.cpx_numero -- pour ne pas relier deux routes distinctes
        where t1.cleabs = _IdIGN1
        and t2.cleabs = _IdIGN2
    )
    insert into BDT2RR_SourceTronconDeRoute (cleabs, fictif, cpx_numero, cpx_classement_administratif, cpx_gestionnaire, geometrie)
    select *
    from Lien l
    where not exists (select true from BDT2RR_SourceTronconDeRoute where cleabs = l.cleabs limit 1);
    
    if (FOUND) then
        return ('Lien entre ' || _IdIGN1 || ' et ' || _IdIGN2 || ' créé.')::varchar;
    else
        return ('Avertissement : Lien entre ' || _IdIGN1 || ' et ' || _IdIGN2 || ' non créé.')::varchar;
    end if;
    
end;
$$ language plpgsql;

-- Recherche les giratoires du réseau en postulant que :
-- - Chaque tronçon d'un giratoire n'est pas à double sens.
-- - Chaque tronçon d'un giratoire n'a pas une taille supérieure à la valeur du paramètre _LongueurTronconMax.
-- - Chaque tronçon d'un giratoire a un tronçon précédent et un tronçon suivant (cycle).
-- - L'angle décrit par le tronçon avec son suivant et son précédent est entre (_BorneAngleGauche et 360) et (0 et _BorneAngleDroit) dans le sens anti-trigonométrique.
-- Paramètres :
-- - _LongueurTronconMax (défaut : 150) : La longueur maximale en mètres d'un tronçon pouvant participer à un giratoire.
-- - _BorneAngleGauche (défaut : 270) : L'angle maximal à gauche en degrés.
-- - _BorneAngleDroit (défaut : 20) : L'angle maximal à droite en degrés. Un angle plus grand peut permettre de rattraper des approximations de numérisation et de retrouver les giratoires en forme de 8.
-- Résultats :
-- - Peuple la table Giratoire.
-- - Peuple la table TronconGiratoire
create or replace function RechercherGiratoires(_LongueurTronconMax integer default 150, _BorneAngleGauche integer default 270, _BorneAngleDroit integer default 20) returns void as $$
begin

    -- premiers filtres :
    -- - retrait des tronçons à double sens
    -- - retrait des tronçons d'une taille supérieure à _LongueurTronconMax
    create temporary table RechercheGiratoire on commit drop as (
        select
            NumeroRoute,
            IdIGN,
            case SensCirculation -- en profite pour mettre les tronçons dans le sens de circulation
                when 'Sens inverse' then ST_Reverse(Geom)
                else Geom
            end as Geom
        from BDT2RR_Troncon
        where SensCirculation is distinct from 'Double sens' and ST_3DLength(Geom) < _LongueurTronconMax and not Fictif
    );
    
    -- filtres suivants, retrait par itérations successives des tronçons qui n'ont pas de suivant ou de précedent respectant les critéres d'angles donnés
    loop
    
        with Angles as (
            select
                rg.*,
                -- TODO remplacer par ST_Angle après updgrade en PG 2.5 mni
                degrees(
                    ST_Azimuth(
                        ST_StartPoint(rg.Geom),
                        ST_PointN(
                            ST_Rotate(rg.Geom, ST_Azimuth(ST_PointN(rgprec.Geom, ST_NPoints(rgprec.Geom) - 1), ST_EndPoint(rgprec.Geom)), ST_StartPoint(rg.Geom))
                            , 2
                        )
                    )
                ) as AnglePrec, -- calcul de l'angle du tronçon avec son précédent
                degrees(
                    ST_Azimuth(
                        ST_StartPoint(rgsuiv.Geom),
                        ST_PointN(
                            ST_Rotate(rgsuiv.Geom, ST_Azimuth(ST_PointN(rg.Geom, ST_NPoints(rg.Geom) - 1), ST_EndPoint(rg.Geom)), ST_StartPoint(rgsuiv.Geom))
                            , 2
                        )
                    )
                ) as AngleSuiv -- calcul de l'angle du tronçon avec son suivant
            from RechercheGiratoire rg
            inner join RechercheGiratoire rgprec on rg.NumeroRoute = rgprec.NumeroRoute and rg.IdIGN <> rgprec.IdIGN and ST_Equals(ST_Force2D(ST_StartPoint(rg.Geom)), ST_Force2D(ST_EndPoint(rgprec.Geom)))
            inner join RechercheGiratoire rgsuiv on rg.NumeroRoute = rgsuiv.NumeroRoute and rg.IdIGN <> rgsuiv.IdIGN and ST_Equals(ST_Force2D(ST_EndPoint(rg.Geom)), ST_Force2D(ST_StartPoint(rgsuiv.Geom)))
        )
        delete from RechercheGiratoire rg
        where not exists (
            select true
            from Angles a
            where rg.IdIGN = a.IdIGN
            and ((a.AnglePrec >= _BorneAngleGauche) or (a.AnglePrec <= _BorneAngleDroit))
            and ((a.AngleSuiv >= _BorneAngleGauche) or (a.AngleSuiv <= _BorneAngleDroit))
            limit 1
        );
        
        exit when not found;
    end loop;
    
    -- peuplement de la table Giratoire
    with RechercheGiratoireAgregee as (
        select NumeroRoute, ST_CollectionExtract(unnest(ST_ClusterWithin(Geom, 1)), 2) as Geom
        from RechercheGiratoire
        group by NumeroRoute
    )
    insert into Giratoire (IdGiratoire, NumeroRoute, Geom)
    select
        round(ST_X(ST_Transform(ST_Centroid(Geom), 4326))::numeric, 5)::character varying || '-' || Round(ST_Y(ST_Transform(ST_Centroid(Geom), 4326))::numeric, 5)::character varying as IdGiratoire, -- calcul d'un identifiant sur la base du X,Y WGS84 arrondi à 5 décimales (~1m)
        NumeroRoute,
        Geom
    from RechercheGiratoireAgregee;
    
    -- peuplement de la table TronconGiratoire
    insert into TronconGiratoire (IdGiratoire, IdIGN, NumeroRoute, Geom)
    select g.IdGiratoire, rg.IdIGN, rg.NumeroRoute, rg.Geom
    from Giratoire g
    inner join RechercheGiratoire rg on g.NumeroRoute = rg.NumeroRoute and ST_Contains(g.Geom, rg.Geom);
    
end;
$$ language plpgsql;

-- Recalage des PR de début aux extrémités des routes départementales.
-- Cette fonction n'est pas en mesure de recaler les PR de début des routes qui démarrent par un cycle (ilot).
-- Elle peut aussi retourner de faux PR pour les petites routes types bretelles au regard du rayon de recherche.
-- De fait, la fonction ne peuple pas directement la table PR mais retourne le code SQL des requêtes d'insertion.
-- Il convient de vérifier/corriger manuellement le résultat obtenu avant de jouer les requêtes.
-- Paramètres :
-- - _RayonRecherche (défaut : 100) : Le rayon de recherche d'une extrémité de route autour du premier PR.
-- Résultats :
-- - Retourne les requêtes SQL d'insertion des PR de début dans la table PR.
create or replace function RecalerPRDeb(_RayonRecherche integer default 100) returns table (SQL character varying) as $$

    -- sélection des tronçons départementaux hors giratoire
    with TronconDepartementalHorsGiratoire as (
        select t.NumeroRoute, t.IdIGN, t.Geom
        from BDT2RR_Troncon t
        where t.ClasseAdmin = 'Départementale'
        and not exists (select true from TronconGiratoire where IdIGN = t.IdIGN limit 1)
    ),

    -- sélection des extrémités de route
    Extremite as (
        -- extrémité en début suivant le sens de numérisation
        select tdhg.NumeroRoute, tdhg.IdIGN, 'd'::character as PositionExtremite, ST_StartPoint(tdhg.Geom) as Geom
        from TronconDepartementalHorsGiratoire tdhg
        where not exists (
            select true
            from TronconDepartementalHorsGiratoire tdhgprec
            where tdhg.NumeroRoute = tdhgprec.NumeroRoute
            and tdhg.IdIGN <> tdhgprec.IdIGN
            and ST_Intersects(ST_Force2D(ST_StartPoint(tdhg.Geom)), ST_Force2D(tdhgprec.Geom)) -- l'égalité n'est jugée que sur le plan ST_Force2D
            limit 1
        )

        union all
        
        -- extrémité en fin suivant le sens de numérisation
        select tdhg.NumeroRoute, tdhg.IdIGN, 'f'::character as PositionExtremite, ST_EndPoint(tdhg.Geom) as Geom
        from TronconDepartementalHorsGiratoire tdhg
        where not exists (
            select true
            from TronconDepartementalHorsGiratoire tdhgsuiv
            where tdhg.NumeroRoute = tdhgsuiv.NumeroRoute
            and tdhg.IdIGN <> tdhgsuiv.IdIGN
            and ST_Intersects(ST_Force2D(ST_EndPoint(tdhg.Geom)), ST_Force2D(tdhgsuiv.Geom)) -- l'égalité n'est jugée que sur le plan ST_Force2D
            limit 1
        )
    ),
    
    -- sélection des extrémités proches d'un PR de début (est considéré comme PR de début celui ayant la plus petite valeur de PRA)
    ExtremiteDeb as (
        select distinct e.NumeroRoute, pr.PRA, e.IdIGN, e.PositionExtremite
        from Extremite e
        inner join BDT2RR_PR pr on e.NumeroRoute = pr.NumeroRoute and ST_DWithin(e.Geom, pr.Geom, 25)
        where pr.PRA = (select min(PRA) from BDT2RR_PR where NumeroRoute = pr.NumeroRoute)
    )
    
    -- jointure externe pour avoir toutes les RD même celles dont on ne trouve pas de PR de début
    select
        case edeb.PositionExtremite
            when 'd' then '-- ' || r.NumeroRoute || E'\n' || 'insert into PR (NumeroRoute, PRA, CumulDist, Geom) select ''' || r.NumeroRoute || '''::character varying, ' || edeb.PRA || '::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where IdIGN = ''' || edeb.IdIGN || ''';' || E'\n'
            when 'f' then '-- ' || r.NumeroRoute || E'\n' || 'insert into PR (NumeroRoute, PRA, CumulDist, Geom) select ''' || r.NumeroRoute || '''::character varying, ' || edeb.PRA || '::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where IdIGN = ''' || edeb.IdIGN || ''';' || E'\n'
            else  '-- ' || r.NumeroRoute || E'\n' || '-- non trouvé' || E'\n'
        end as SQL
    from Route r
    left join ExtremiteDeb edeb on r.NumeroRoute = edeb.NumeroRoute
    where r.ClasseAdmin = 'Départementale'
    order by SQL;
    
$$ language sql;

-- Ajout au référentiel du/des premiers tronçons linéaires (c-a-d ne participant pas à un giratoire) d'une route.
-- Les premiers tronçons sont déterminés au regard de leur proximité avec les PR de début recalés.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route dont on souhaite ajouter le/les premiers tronçons linéaires.
-- Résultats :
-- - Ajoute à la table Troncon le/les premiers tronçons linéaires.
create or replace function AjouterPremierTronconLineaire(_NumeroRoute character varying) returns void as $$

    insert into Troncon (NumeroRoute, CodeInseeGauche, CodeInseeDroite, CumulDistD, CumulDistF, IdIGN, Etat, Niveau, ItineraireVert, Fictif, Nature, SensCirculation, NbVoies, Largeur, PositionSol, AccesVL, ReserveBus, BandeCyclable, AccesPieton, Prive, Urbain, VitesseMoyenneVL, PrecisionPlani, PrecisionAlti, Geom)
    select
        t.NumeroRoute,
        t.CodeInseeGauche,
        t.CodeInseeDroite,
        0,
        case t.Fictif -- la taille du tronçon n'est prise en compte que s'il n'est pas fictif
            when true then 0
            else ST_3DLength(t.Geom)
        end,
        t.IdIGN,
        t.Etat,
        t.Niveau,
        t.ItineraireVert,
        t.Fictif,
        t.Nature,
        case -- détermine le sens de circulation par rapport au sens des PR, 0 double, 1 croissant, 2 décroissant
            when t.SensCirculation = 'Double sens' then 0
            when t.SensCirculation = 'Sens direct' and ST_Equals(pr.Geom, ST_StartPoint(t.Geom)) then 1
            when t.SensCirculation = 'Sens direct' and ST_Equals(pr.Geom, ST_EndPoint(t.Geom)) then 2
            when t.SensCirculation = 'Sens inverse' and ST_Equals(pr.Geom, ST_StartPoint(t.Geom)) then 2
            when t.SensCirculation = 'Sens inverse' and ST_Equals(pr.Geom, ST_EndPoint(t.Geom)) then 1
            else null::integer
        end,
        t.NbVoies,
        t.Largeur,
        t.PositionSol,
        t.AccesVL,
        t.ReserveBus,
        t.BandeCyclable,
        t.AccesPieton,
        t.Prive,
        t.Urbain,
        t.VitesseMoyenneVL,
        t.PrecisionPlani,
        t.PrecisionAlti,
        case -- en profite pour mettre les tronçons dans le sens croissant des PR
            when ST_Equals(pr.Geom, ST_StartPoint(t.Geom)) then ST_Force4D(t.Geom)
            else ST_Reverse(ST_Force4D(t.Geom))
        end
    from BDT2RR_Troncon t
    inner join PR pr on pr.NumeroRoute = t.NumeroRoute and pr.CumulDist = 0
    where t.NumeroRoute = _NumeroRoute
    and not exists (select true from TronconGiratoire where IdIGN = t.IdIGN limit 1)
    and (ST_Equals(pr.Geom, ST_StartPoint(t.Geom)) or ST_Equals(pr.Geom, ST_EndPoint(t.Geom))); -- l'égalité est jugée aux deux extrémités du tronçon
    
$$ language sql;

-- Ajout au référentiel du/des premiers tronçons participant à un giratoire d'une route.
-- Les premiers tronçons sont déterminés au regard de leur proximité avec les PR de début recalés.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route dont on souhaite ajouter le premier tronçon giratoire.
-- Résultats :
-- - Ajoute à la table Troncon le premier tronçon giratoire.
create or replace function AjouterPremierTronconGiratoire(_NumeroRoute character varying) returns void as $$

    insert into Troncon (NumeroRoute, IdGiratoire, CodeInseeGauche, CodeInseeDroite, CumulDistD, CumulDistF, IdIGN, Etat, Niveau, ItineraireVert, Fictif, Nature, SensCirculation, NbVoies, Largeur, PositionSol, AccesVL, ReserveBus, BandeCyclable, AccesPieton, Prive, Urbain, VitesseMoyenneVL, PrecisionPlani, PrecisionAlti, Geom)
    select
        pr.NumeroRoute,
        tg.IdGiratoire,
        t.CodeInseeGauche,
        t.CodeInseeDroite,
        0,
        0, -- ignore les giratoires pour les calculs de distances et les fonctions de géocodage
        tg.IdIGN,
        t.Etat,
        t.Niveau,
        t.ItineraireVert,
        t.Fictif,
        t.Nature,
        1,
        t.NbVoies,
        t.Largeur,
        t.PositionSol,
        t.AccesVL,
        t.ReserveBus,
        t.BandeCyclable,
        t.AccesPieton,
        t.Prive,
        t.Urbain,
        t.VitesseMoyenneVL,
        t.PrecisionPlani,
        t.PrecisionAlti,
        ST_Force4D(tg.Geom)
    from TronconGiratoire tg
    inner join BDT2RR_Troncon t on tg.IdIGN = t.IdIGN
    inner join PR pr on ST_Equals(pr.Geom, ST_StartPoint(tg.Geom)) -- l'égalité est jugée seulement en début de tronçon, ceux-ci étant dans le sens de circulation, le numero de route est ignoré car le giratoire n'est pas forcément affecté à la même route
    where pr.NumeroRoute = _NumeroRoute
    and pr.CumulDist = 0;
    
$$ language sql;

-- Ajout au référentiel des tronçons linéaires d'une route.
-- Les tronçons sont ajoutés de façon successive au regard de leur proximité avec un tronçon de la même route déjà présent dans le référentiel.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route dont on souhaite ajouter les tronçons linéaires.
-- Résultats :
-- - Ajoute à la table Troncon les tronçons linéaires.
-- - Retourne le nombre de tronçons ajoutés.
create or replace function AjouterLineaire(_NumeroRoute character varying) returns integer as $$
declare
    _NbBoucles integer;
begin

    _NbBoucles = 0;
    
    loop
        
        -- détermine le tronçon elu pour l'ajout au référentiel lors de l'itération courante
        -- est elu le tronçon :
        -- - qui appartient à la route en construction
        -- - qui n'est pas présent dans la partie déjà construite de la route
        -- - qui ne participe pas à un giratoire
        -- - qui touche le dernier point d'un tronçon de la partie déjà construite de la route
        -- - dont le tronçon qui précède à la valeur minimale de CumulDistF
        with TronconElu as (
            select t.*, prec.IdIGN as IdIGNPrec, prec.CumulDistF as CumulDistFPrec, prec.Geom as GeomPrec
            from BDT2RR_Troncon t
            inner join Troncon prec
            on prec.NumeroRoute = t.NumeroRoute
            and ST_Intersects(prec.Geom, t.Geom) -- pour profiter de l'index géographique
            and (
                ST_Equals(ST_Force2D(ST_EndPoint(prec.Geom)), ST_Force2D(ST_StartPoint(t.Geom))) -- l'égalité est vue sur le plan car la BDTopo n'est pas toujours topologiquement correcte dans l'espace
                or ST_Equals(ST_Force2D(ST_EndPoint(prec.Geom)), ST_Force2D(ST_EndPoint(t.Geom))) -- l'égalité est vue sur le plan car la BDTopo n'est pas toujours topologiquement correcte dans l'espace
            )
            where t.NumeroRoute = _NumeroRoute
            and not exists (select true from Troncon where IdIGN = t.IdIGN limit 1)
            and not exists (select true from TronconGiratoire where IdIGN = t.IdIGN limit 1)
            order by            -- ordonne par :
                CumulDistFPrec, -- - CumulDistF pour privilégier le chemin le plus court
                IdIGNPrec       -- - IdIGN pour que l'algo soit déterministe si le min de CumulDistF n'est pas unique
            limit 1
        )
        
        insert into Troncon (NumeroRoute, CodeInseeGauche, CodeInseeDroite, CumulDistD, CumulDistF, IdIGN, IdIGNPrec, Etat, Niveau, ItineraireVert, Fictif, Nature, SensCirculation, NbVoies, Largeur, PositionSol, AccesVL, ReserveBus, BandeCyclable, AccesPieton, Prive, Urbain, VitesseMoyenneVL, PrecisionPlani, PrecisionAlti, Geom)
        select
            NumeroRoute,
            CodeInseeGauche,
            CodeInseeDroite,
            CumulDistFPrec,
            case Fictif -- la taille du tronçon n'est prise en compte que s'il n'est pas fictif
                when true then CumulDistFPrec -- pour ceux qui le souhaitent, ajouter ici une taille "virtuelle" au tronçon fictif, par exemple 1 mètre
                else CumulDistFPrec + ST_3DLength(Geom)
            end,
            IdIGN,
            IdIGNPrec,
            Etat,
            Niveau,
            ItineraireVert,
            Fictif,
            Nature,
            case -- détermine le sens de circulation par rapport au sens des PR, 1 croissant, 2 décroissant, 0 double
                when SensCirculation = 'Double sens' then 0
                when SensCirculation = 'Sens direct' and ST_Equals(ST_Force2D(ST_EndPoint(GeomPrec)), ST_Force2D(ST_StartPoint(Geom))) then 1
                when SensCirculation = 'Sens direct' and ST_Equals(ST_Force2D(ST_EndPoint(GeomPrec)), ST_Force2D(ST_EndPoint(Geom))) then 2
                when SensCirculation = 'Sens inverse' and ST_Equals(ST_Force2D(ST_EndPoint(GeomPrec)), ST_Force2D(ST_StartPoint(Geom))) then 2
                when SensCirculation = 'Sens inverse' and ST_Equals(ST_Force2D(ST_EndPoint(GeomPrec)), ST_Force2D(ST_EndPoint(Geom))) then 1
                else null::integer
            end,
            NbVoies,
            Largeur,
            PositionSol,
            AccesVL,
            ReserveBus,
            BandeCyclable,
            AccesPieton,
            Prive,
            Urbain,
            VitesseMoyenneVL,
            PrecisionPlani,
            PrecisionAlti,
            case -- met la géométrie des tronçons dans le sens croissant des PR
                when ST_Equals(ST_Force2D(ST_EndPoint(GeomPrec)), ST_Force2D(ST_StartPoint(Geom))) then ST_Force4D(Geom)
                else ST_Force4D(ST_Reverse(Geom))
            end
        from TronconElu; 
        
        exit when not found;
        
        _NbBoucles = _NbBoucles + 1;
        
    end loop;
    
    return _NbBoucles;
    
end;
$$ language plpgsql;

-- Ajout au référentiel des tronçons giratoires d'une route.
-- Les tronçons sont ajoutés de façon successive au regard de leur proximité avec un tronçon de la même route déjà présent dans le référentiel.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route dont on souhaite ajouter les tronçons giratoires.
-- Résultats :
-- - Ajoute à la table Troncon les tronçons giratoires.
-- - Retourne le nombre de tronçons ajoutés.
create or replace function AjouterGiratoire(_NumeroRoute character varying) returns integer as $$
declare
    _NbBoucles integer;
begin

    _NbBoucles = 0;
    
    loop
        
        -- détermine le tronçon elu pour l'ajout au référentiel lors de l'itération courante
        -- est elu le tronçon :
        -- - qui participe à un giratoire
        -- - qui n'est pas présent dans la partie déjà construite de la route
        -- - dont le premier point est égal au dernier point d'un tronçon de la partie déjà construite de la route
        -- - dont le tronçon qui précède à la valeur minimale de CumulDistF
        with TronconElu as (
            select t.*, tg.IdGiratoire, tg.Geom as GeomGir, prec.IdIGN as IdIGNPrec, prec.CumulDistF as CumulDistFPrec
            from TronconGiratoire tg
            inner join BDT2RR_Troncon t on t.IdIGN = tg.IdIGN
            inner join Troncon prec
            on prec.NumeroRoute = _NumeroRoute
            and ST_Intersects(prec.Geom, tg.Geom) -- pour profiter de l'index
            and ST_Equals(ST_Force2D(ST_EndPoint(prec.Geom)), ST_Force2D(ST_StartPoint(tg.Geom))) -- l'égalité est vue sur le plan car la BDTopo n'est pas toujours topologiquement correcte dans l'espace
            where not exists (select true from Troncon where IdIGN = t.IdIGN and NumeroRoute = _NumeroRoute limit 1)
            order by            -- ordonne par :
                CumulDistFPrec, -- - CumulDistF pour privilégier le chemin le plus court
                IdIGNPrec       -- - IdIGN pour que l'algo soit déterministe si le min de CumulDistF n'est pas unique
            limit 1
        )
        
        insert into Troncon (NumeroRoute, IdGiratoire, CodeInseeGauche, CodeInseeDroite, CumulDistD, CumulDistF, IdIGN, IdIGNPrec, Etat, Niveau, ItineraireVert, Fictif, Nature, SensCirculation, NbVoies, Largeur, PositionSol, AccesVL, ReserveBus, BandeCyclable, AccesPieton, Prive, Urbain, VitesseMoyenneVL, PrecisionPlani, PrecisionAlti, Geom)
        select
            _NumeroRoute,
            IdGiratoire,
            CodeInseeGauche,
            CodeInseeDroite,
            CumulDistFPrec,
            CumulDistFPrec, -- ignore les giratoires pour les calculs de distances et les fonctions de géocodage
            IdIGN,
            IdIGNPrec,
            Etat,
            Niveau,
            ItineraireVert,
            Fictif,
            Nature,
            1,
            NbVoies,
            Largeur,
            PositionSol,
            AccesVL,
            ReserveBus,
            BandeCyclable,
            AccesPieton,
            Prive,
            Urbain,
            VitesseMoyenneVL,
            PrecisionPlani,
            PrecisionAlti,
            ST_Force4D(GeomGir)
        from TronconElu;
        
        exit when not found;
        _NbBoucles = _NbBoucles + 1;
    end loop;
    
    return _NbBoucles;
    
end;
$$ language plpgsql;

-- Recalage des PR sur les routes départementales.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route dont on souhaite recaler les PR.
-- - _RayonRecherche (défaut : 100) : Le rayon de recherche d'une route autour du PR.
-- Résultats :
-- - Ajoute à la table PR les PR recalés s'ils se trouvent à moins de _RayonRecherche de la route.
create or replace function RecalerPR(_NumeroRoute character varying, _RayonRecherche integer default 100) returns void as $$

    insert into PR (NumeroRoute, PRA, CumulDist, Geom)
    select
        pr.NumeroRoute as NumeroRoute,
        pr.PRA,
        null::numeric as CumulDist,
        prochevoisin.Geom
    from BDT2RR_PR pr
    cross join lateral (
        select ST_3DClosestPoint(t.geom, pr.geom) as Geom
        from Troncon t
        where t.NumeroRoute = pr.NumeroRoute
        and not t.Fictif
        and t.IdGiratoire is null -- ignore les giratoires pour les calculs de distances et les fonctions de géocodage
        and ST_DWithin(t.geom, pr.geom, _RayonRecherche)
        order by t.Geom <-> pr.Geom
        limit 1
    ) prochevoisin
    where pr.NumeroRoute = _NumeroRoute
    and pr.PRA > (select max(PRA) from PR where NumeroRoute = _NumeroRoute and CumulDist = 0);
    
$$ language sql;

-- Calcul de la distance cumulée du PR depuis de début de la route.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route dont on souhaite calculer la distance cumulée de chaque PR.
-- Résultats :
-- - Met à jour le champ CumulDist dans la table PR.
create or replace function CalculerCumulDistPR(_NumeroRoute character varying) returns void as $$

    with CumulDistPR as (
        select pr.IdPr, t.CumulDist
        from PR pr
        cross join lateral (
            select ST_3DLength(Geom) * ST_LineLocatePoint(geom, pr.geom) + CumulDistD as CumulDist
            from Troncon
            where NumeroRoute = pr.NumeroRoute
            and not Fictif
            and IdGiratoire is null -- ignore les giratoires pour les calculs de distances et les fonctions de géocodage
            and ST_DWithin(geom, pr.geom, 1)
            order by Geom <-> pr.Geom
            limit 1
        ) t
        where pr.NumeroRoute = _NumeroRoute
        and pr.CumulDist is null
        order by pr.PRA
    )
    update PR pr
    set CumulDist = cdpr.CumulDist
    from CumulDistPR cdpr
    where pr.IdPR = cdpr.IdPR
    
$$ language sql;

-- Découpage des tronçons sur les PR.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route dont on souhaite découper les tronçons sur les PR.
-- Résultats :
-- - Remplace, dans la table Troncon, les tronçons originaux par les tronçons découpés.
create or replace function DecouperTronconSurPR(_NumeroRoute character varying) returns void as $$
declare
    _CumulDist numeric;
    _Decoupage record;
    _Geom1 geometry;
    _Geom2 geometry;
begin

    for _CumulDist in select CumulDist from PR where NumeroRoute = _NumeroRoute order by PRA
    loop
    
        for _Decoupage in (select
            t.NumeroRoute,
            t.IdGiratoire,
            t.CodeInseeGauche,
            t.CodeInseeDroite,
            t.CumulDistD,
            t.CumulDistF,
            t.IdIGN,
            t.IdIGNPrec,
            t.Etat,
            t.Niveau,
            t.RGC,
            t.ItineraireVert,
            t.Fictif,
            t.Nature,
            t.SensCirculation,
            t.NbVoies,
            t.Largeur,
            t.PositionSol,
            t.AccesVL,
            t.ReserveBus,
            t.BandeCyclable,
            t.AccesPieton,
            t.Prive,
            t.Urbain,
            t.VitesseMoyenneVL,
            t.PrecisionPlani,
            t.PrecisionAlti,
            t.Geom as GeomOriginale,
            ST_Split(ST_Snap(t.Geom, ST_GeometryN(ST_LocateAlong(t.Geom, _CumulDist), 1), 1), ST_GeometryN(ST_LocateAlong(t.Geom, _CumulDist), 1)) as GeomDecoupee
        from Troncon t
        where t.NumeroRoute = _NumeroRoute
        and _CumulDist between t.CumulDistD and t.CumulDistF
        and not t.Fictif
        and t.IdGiratoire is null) -- ignore les giratoires pour les calculs de distances et les fonctions de géocodage
        loop
        
            if (ST_NumGeometries(_Decoupage.GeomDecoupee) = 2) then
                
                -- supprime le tronçon initial
                delete from Troncon where NumeroRoute = _NumeroRoute and IdIGN = _Decoupage.IdIGN and ST_Equals(Geom, _Decoupage.GeomOriginale);
                
                _Geom1 = ST_GeometryN(_Decoupage.GeomDecoupee, 1);
                _Geom2 = ST_GeometryN(_Decoupage.GeomDecoupee, 2);
                
                -- ajoute les deux parties
                insert into Troncon (NumeroRoute, IdGiratoire, CodeInseeGauche, CodeInseeDroite, CumulDistD, CumulDistF, IdIGN, IdIGNPrec, Etat, Niveau, RGC, ItineraireVert, Fictif, Nature, SensCirculation, NbVoies, Largeur, PositionSol, AccesVL, ReserveBus, BandeCyclable, AccesPieton, Prive, Urbain, VitesseMoyenneVL, PrecisionPlani, PrecisionAlti, Geom)
                values (
                    _NumeroRoute,
                    _Decoupage.IdGiratoire,
                    _Decoupage.CodeInseeGauche,
                    _Decoupage.CodeInseeDroite,
                    _Decoupage.CumulDistD,
                    _Decoupage.CumulDistD + ST_3DLength(_Geom1),
                    _Decoupage.IdIGN,
                    _Decoupage.IdIGNPrec,
                    _Decoupage.Etat,
                    _Decoupage.Niveau,
                    _Decoupage.RGC,
                    _Decoupage.ItineraireVert,
                    _Decoupage.Fictif,
                    _Decoupage.Nature,
                    _Decoupage.SensCirculation,
                    _Decoupage.NbVoies,
                    _Decoupage.Largeur,
                    _Decoupage.PositionSol,
                    _Decoupage.AccesVL,
                    _Decoupage.ReserveBus,
                    _Decoupage.BandeCyclable,
                    _Decoupage.AccesPieton,
                    _Decoupage.Prive,
                    _Decoupage.Urbain,
                    _Decoupage.VitesseMoyenneVL,
                    _Decoupage.PrecisionPlani,
                    _Decoupage.PrecisionAlti,
                    ST_AddMeasure(_Geom1, _Decoupage.CumulDistD, _Decoupage.CumulDistD + ST_3DLength(_Geom1))
                ),
                (
                    _NumeroRoute,
                    _Decoupage.IdGiratoire,
                    _Decoupage.CodeInseeGauche,
                    _Decoupage.CodeInseeDroite,
                    _Decoupage.CumulDistD + ST_3DLength(_Geom1),
                    _Decoupage.CumulDistF,
                    _Decoupage.IdIGN,
                    _Decoupage.IdIGNPrec,
                    _Decoupage.Etat,
                    _Decoupage.Niveau,
                    _Decoupage.RGC,
                    _Decoupage.ItineraireVert,
                    _Decoupage.Fictif,
                    _Decoupage.Nature,
                    _Decoupage.SensCirculation,
                    _Decoupage.NbVoies,
                    _Decoupage.Largeur,
                    _Decoupage.PositionSol,
                    _Decoupage.AccesVL,
                    _Decoupage.ReserveBus,
                    _Decoupage.BandeCyclable,
                    _Decoupage.AccesPieton,
                    _Decoupage.Prive,
                    _Decoupage.Urbain,
                    _Decoupage.VitesseMoyenneVL,
                    _Decoupage.PrecisionPlani,
                    _Decoupage.PrecisionAlti,
                    ST_AddMeasure(_Geom2, _Decoupage.CumulDistD + ST_3DLength(_Geom1), _Decoupage.CumulDistF)
                );
            
            end if;
        
        end loop;
    
    end loop;
    
end;
$$ language plpgsql;

-- Découpage des tronçons dont la longueur dépasse une valeur donnée.
-- La fonction découpe en deux les tronçons de façon itérative jusqu'à ce que plus aucun tronçon ne dépasse la longueur donnée.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route dont on souhaite découper les tronçons.
-- - _Longueur : La longueur maximale souhaitée pour un tronçon.
-- Résultats :
-- - Remplace, dans la table Troncon, les tronçons originaux par les tronçons découpés.
create or replace function DecouperTronconSuperieurA(_NumeroRoute character varying, _Longueur integer) returns void as $$
declare
    _Decoupage record;
    _Existe boolean;
begin

    _Existe = true;
    
    while (_Existe)
    loop
        _Existe = false;
        
        for _Decoupage in (select
            t.NumeroRoute,
            t.IdGiratoire,
            t.CodeInseeGauche,
            t.CodeInseeDroite,
            t.CumulDistD,
            t.CumulDistF,
            t.IdIGN,
            t.IdIGNPrec,
            t.Etat,
            t.Niveau,
            t.RGC,
            t.ItineraireVert,
            t.Fictif,
            t.Nature,
            t.SensCirculation,
            t.NbVoies,
            t.Largeur,
            t.PositionSol,
            t.AccesVL,
            t.ReserveBus,
            t.BandeCyclable,
            t.AccesPieton,
            t.Prive,
            t.Urbain,
            t.VitesseMoyenneVL,
            t.PrecisionPlani,
            t.PrecisionAlti,
            t.Geom as GeomOriginale,
            ST_LineSubstring(t.Geom, 0, 0.5) as Moitie1,
            ST_LineSubstring(t.Geom, 0.5, 1) as Moitie2
        from Troncon t
        where not(Fictif)
        and IdGiratoire is null -- ignore les giratoires pour les calculs de distances et les fonctions de géocodage
        and t.NumeroRoute = _NumeroRoute
        and ST_3DLength(t.Geom) > _Longueur)
        
        loop
            _Existe = true;
            
             -- supprime le tronçon original
            delete from Troncon where NumeroRoute = _NumeroRoute and IdIGN = _Decoupage.IdIGN and ST_Equals(Geom, _Decoupage.GeomOriginale);
            
            -- ajoute les deux moitiés de tronçon
            insert into Troncon (NumeroRoute, IdGiratoire, CodeInseeGauche, CodeInseeDroite, CumulDistD, CumulDistF, IdIGN, IdIGNPrec, Etat, Niveau, RGC, ItineraireVert, Fictif, Nature, SensCirculation, NbVoies, Largeur, PositionSol, AccesVL, ReserveBus, BandeCyclable, AccesPieton, Prive, Urbain, VitesseMoyenneVL, PrecisionPlani, PrecisionAlti, Geom)
            values (
                _NumeroRoute,
                _Decoupage.IdGiratoire,
                _Decoupage.CodeInseeGauche,
                _Decoupage.CodeInseeDroite,
                _Decoupage.CumulDistD,
                _Decoupage.CumulDistD + ST_3DLength(_Decoupage.Moitie1),
                _Decoupage.IdIGN,
                _Decoupage.IdIGNPrec,
                _Decoupage.Etat,
                _Decoupage.Niveau,
                _Decoupage.RGC,
                _Decoupage.ItineraireVert,
                _Decoupage.Fictif,
                _Decoupage.Nature,
                _Decoupage.SensCirculation,
                _Decoupage.NbVoies,
                _Decoupage.Largeur,
                _Decoupage.PositionSol,
                _Decoupage.AccesVL,
                _Decoupage.ReserveBus,
                _Decoupage.BandeCyclable,
                _Decoupage.AccesPieton,
                _Decoupage.Prive,
                _Decoupage.Urbain,
                _Decoupage.VitesseMoyenneVL,
                _Decoupage.PrecisionPlani,
                _Decoupage.PrecisionAlti,
                ST_AddMeasure(_Decoupage.Moitie1, _Decoupage.CumulDistD, _Decoupage.CumulDistD + ST_3DLength(_Decoupage.Moitie1))
            ),
            (
                _NumeroRoute,
                _Decoupage.IdGiratoire,
                _Decoupage.CodeInseeGauche,
                _Decoupage.CodeInseeDroite,
                _Decoupage.CumulDistD + ST_3DLength(_Decoupage.Moitie1),
                _Decoupage.CumulDistF,
                _Decoupage.IdIGN,
                _Decoupage.IdIGNPrec,
                _Decoupage.Etat,
                _Decoupage.Niveau,
                _Decoupage.RGC,
                _Decoupage.ItineraireVert,
                _Decoupage.Fictif,
                _Decoupage.Nature,
                _Decoupage.SensCirculation,
                _Decoupage.NbVoies,
                _Decoupage.Largeur,
                _Decoupage.PositionSol,
                _Decoupage.AccesVL,
                _Decoupage.ReserveBus,
                _Decoupage.BandeCyclable,
                _Decoupage.AccesPieton,
                _Decoupage.Prive,
                _Decoupage.Urbain,
                _Decoupage.VitesseMoyenneVL,
                _Decoupage.PrecisionPlani,
                _Decoupage.PrecisionAlti,
                ST_AddMeasure(_Decoupage.Moitie2, _Decoupage.CumulDistD + ST_3DLength(_Decoupage.Moitie1), _Decoupage.CumulDistF)
            );
            
        end loop;
        
    end loop;
    
end;
$$ language plpgsql;

-- Construction d'une route.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route à construire.
-- - _RayonRecherchePR (défaut : 100) : Le rayon de recherche pour le recalage des PR.
-- - _LongueurMaxTroncon (défaut : 200) : La taille maximale pour un tronçon.
-- Résultats :
-- - Ajoute à la table Troncon les tronçons de la route avec leurs informations de distances.
-- - Ajoute à la table PR les PR recalés de la route.
-- - Retourne le nombre de tronçons et le nombre de PR constituant la route après construction.
create or replace function ConstruireRoute(_NumeroRoute character varying, _RayonRecherchePR integer default 100, _LongueurMaxTroncon integer default 200) returns table (NbTroncons bigint, NbPR bigint) as $$
begin

    -- ajout des premiers tronçons
    perform AjouterPremierTronconLineaire(_NumeroRoute);
    perform AjouterPremierTronconGiratoire(_NumeroRoute);
    
    -- ajout des tronçons suivants
    while (select AjouterLineaire(_NumeroRoute) + AjouterGiratoire(_NumeroRoute) > 0) loop
    end loop;
    
    -- mise à jour de la dimension M des tronçons
    update Troncon
    set Geom = ST_AddMeasure(Geom, CumulDistD, CumulDistF)
    where NumeroRoute = _NumeroRoute;
    
    -- recalage des PR
    perform RecalerPR(_NumeroRoute, _RayonRecherchePR);
    
    -- calcul des distances cumulées des PR
    perform CalculerCumulDistPR(_NumeroRoute);
    
    -- découpage des tronçons sur les PR
    perform DecouperTronconSurPR(_NumeroRoute);
    
    -- découpage des grands tronçons
    perform DecouperTronconSuperieurA(_NumeroRoute, _LongueurMaxTroncon);
    
    -- calcul du nombre de tronçons et de PR
    return query with CompteurTroncons as (
        select count(*) as NbTroncons
        from Troncon
        where NumeroRoute = _NumeroRoute
    ),
    CompteurPR as (
        select count(*) as NbPR
        from PR
        where NumeroRoute = _NumeroRoute
    )
    select ct.NbTroncons, cpr.NbPR from CompteurTroncons ct, CompteurPR cpr;
    return;
    
end;
$$ language plpgsql;