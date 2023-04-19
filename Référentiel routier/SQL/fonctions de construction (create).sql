-- Recherche les giratoires du réseau en postulant que :
-- - Chaque tronçon d'un giratoire n'est pas à double sens.
-- - Chaque tronçon d'un giratoire n'a pas une taille supérieure à la valeur du paramètre _LongueurTronconMax.
-- - Chaque tronçon d'un giratoire a un tronçon précédent et un tronçon suivant (cycle).
-- - L'angle décrit par le tronçon avec son suivant et son précédent est entre _AngleMin et _AngleMax.
-- Paramètres :
-- - _LongueurTronconMax (défaut : 150) : La longueur maximale en mètres d'un tronçon pouvant participer à un giratoire.
-- - _AngleMin (défaut : 90) : L'angle minimal en degrés.
-- - _AngleMax (défaut : 200) : L'angle maximal en degrés. Un angle plus grand peut permettre de rattraper des approximations de numérisation et de retrouver les giratoires en forme de 8.
-- Résultats :
-- - Peuple la table Giratoire.
-- - Peuple la table TronconGiratoire
create or replace function RechercherGiratoires(_LongueurTronconMax integer default 150, _AngleMin integer default 90, _AngleMax integer default 200) returns void as $$
begin

    -- premiers filtres :
    -- - retrait des tronçons à double sens
    -- - retrait des tronçons d'une taille supérieure à _LongueurTronconMax
    create temporary table RechercheGiratoire on commit drop as (
        select
            t.NumeroRoute,
            t.IdIGN,
            case SensCirculation -- en profite pour mettre les tronçons dans le sens de circulation
                when 'Sens inverse' then ST_Reverse(Geom)
                else Geom
            end as Geom
        from BDT2RR_Troncon t
        inner join Route r on t.NumeroRoute = r.NumeroRoute
        where SensCirculation is distinct from 'Double sens'
        and ST_3DLength(Geom) < _LongueurTronconMax
        and not Fictif
    );
    
    -- filtres suivants, retrait par itérations successives des tronçons qui n'ont pas de suivant ou de précedent respectant les critéres d'angles donnés
    loop
    
        with Angles as materialized (
            select
                rg.IdIGN,
                degrees(
                    ST_Angle( -- calcul de l'angle formé par :
                        ST_PointN(rgprec.Geom, ST_NPoints(rgprec.Geom) - 1), -- l'avant dernier point du tronçon qui précède
                        ST_StartPoint(rg.Geom), -- le premier point du tronçon
                        ST_PointN(rg.Geom, 2) -- le deuxième point du tronçon
                    )
                ) as AnglePrec,
                degrees(
                    ST_Angle( -- calcul de l'angle formé par :
                        ST_PointN(rg.Geom, ST_NPoints(rg.Geom) - 1), -- l'avant dernier point du tronçon
                        ST_EndPoint(rg.Geom), -- le dernier point du tronçon
                        ST_PointN(rgsuiv.Geom, 2) -- le deuxième point du tronçon qui suit
                    )
                ) as AngleSuiv
            from RechercheGiratoire rg
            inner join RechercheGiratoire rgprec on rg.NumeroRoute = rgprec.NumeroRoute and rg.IdIGN <> rgprec.IdIGN and ST_Equals(ST_Force2D(ST_StartPoint(rg.Geom)), ST_Force2D(ST_EndPoint(rgprec.Geom))) -- l'égalité n'est jugée que sur le plan car la BDTopo a parfois des pb de topologie sur l'axe Z
            inner join RechercheGiratoire rgsuiv on rg.NumeroRoute = rgsuiv.NumeroRoute and rg.IdIGN <> rgsuiv.IdIGN and ST_Equals(ST_Force2D(ST_EndPoint(rg.Geom)), ST_Force2D(ST_StartPoint(rgsuiv.Geom))) -- l'égalité n'est jugée que sur le plan car la BDTopo a parfois des pb de topologie sur l'axe Z
        )
        delete from RechercheGiratoire rg
        where not exists (
            select true
            from Angles a
            where rg.IdIGN = a.IdIGN
            and a.AnglePrec between _AngleMin and _AngleMax
            and a.AngleSuiv between _AngleMin and _AngleMax
        );
        
        exit when not found;
    end loop;
    
    -- peuplement de la table Giratoire
    with RechercheGiratoireAgregee as (
        select NumeroRoute, ST_CollectionExtract(unnest(ST_ClusterIntersecting(Geom)), 2) as Geom
        from RechercheGiratoire
        group by NumeroRoute
    )
    insert into Giratoire (IdGiratoire, NumeroRoute, Geom)
    select
        concat(round(ST_X(ST_Transform(ST_Centroid(Geom), 4326))::numeric, 5), '-', round(ST_Y(ST_Transform(ST_Centroid(Geom), 4326))::numeric, 5)) as IdGiratoire, -- calcul d'un identifiant sur la base du X,Y WGS84 arrondi à 5 décimales (~1m)
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
        inner join Route r on t.NumeroRoute = r.NumeroRoute
        left join TronconGiratoire tg on tg.IdIGN = t.IdIGN
        where t.ClasseAdmin = 'Départementale'
        and tg.IdIGN is null
    ),

    -- sélection des extrémités de route
    Extremite as materialized (
        -- extrémité en début suivant le sens de numérisation
        select tdhg.NumeroRoute, tdhg.IdIGN, 'd'::character as PositionExtremite, ST_StartPoint(tdhg.Geom) as Geom
        from TronconDepartementalHorsGiratoire tdhg
        left join TronconDepartementalHorsGiratoire tdhgprec
        on tdhg.NumeroRoute = tdhgprec.NumeroRoute
        and tdhg.IdIGN <> tdhgprec.IdIGN
        and ST_Intersects(ST_StartPoint(tdhg.Geom), tdhgprec.Geom)
        where tdhgprec.IdIGN is null

        union all
        
        -- extrémité en fin suivant le sens de numérisation
        select tdhg.NumeroRoute, tdhg.IdIGN, 'f'::character as PositionExtremite, ST_EndPoint(tdhg.Geom) as Geom
        from TronconDepartementalHorsGiratoire tdhg
        left join TronconDepartementalHorsGiratoire tdhgsuiv
        on tdhg.NumeroRoute = tdhgsuiv.NumeroRoute
        and tdhg.IdIGN <> tdhgsuiv.IdIGN
        and ST_Intersects(ST_EndPoint(tdhg.Geom), tdhgsuiv.Geom)
        where tdhgsuiv.IdIGN is null
    ),
    
    -- sélection de la valeur minimale de PRA par route c'est à dire de la valeur de PRA des PR de début
    PRDeb as (
        select NumeroRoute, min(PRA) as PRA
        from BDT2RR_PR
        group by NumeroRoute
    ),
    
    -- sélection des extrémités proches d'un PR de début
    ExtremiteDeb as (
        select distinct e.NumeroRoute, pr.PRA, e.IdIGN, e.PositionExtremite
        from Extremite e
        inner join PRDeb prd on prd.NumeroRoute = e.NumeroRoute
        inner join BDT2RR_PR pr on pr.NumeroRoute = prd.NumeroRoute and pr.PRA = prd.PRA and ST_DWithin(pr.Geom, e.Geom, _RayonRecherche)
    )
    
    -- jointure externe pour avoir toutes les RD même celles dont on ne trouve pas de PR de début
    select
        case edeb.PositionExtremite
            when 'd' then '-- ' || r.NumeroRoute || E'\n' || 'insert into PR (NumeroRoute, PRA, CumulDist, Geom) select ''' || r.NumeroRoute || '''::character varying, ' || edeb.PRA || '::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = ''' || r.NumeroRoute || ''' and IdIGN = ''' || edeb.IdIGN || ''';' || E'\n'
            when 'f' then '-- ' || r.NumeroRoute || E'\n' || 'insert into PR (NumeroRoute, PRA, CumulDist, Geom) select ''' || r.NumeroRoute || '''::character varying, ' || edeb.PRA || '::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = ''' || r.NumeroRoute || ''' and IdIGN = ''' || edeb.IdIGN || ''';' || E'\n'
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

    insert into Troncon (
        NumeroRoute,
        COGCommuneGauche,
        COGCommuneDroite,
        SirenProprietaire,
        SirenGestionCourante,
        SirenVH,
        IdIGN,
        IdIGNRoute,
        CumulDistD,
        CumulDistF,
        Fictif,
        Importance,
        Nature,
        NbVoies,
        Largeur,
        PositionSol,
        GueOuRadier,
        Urbain,
        Prive,
        SensCirculation,
        ItineraireVert,
        Delestage,
        MatDangereusesInterdites,
        RestrictionLongueur,
        RestrictionLargeur,
        RestrictionPoidsParEssieu,
        RestrictionPoidsTotal,
        RestrictionHauteur,
        NatureRestriction,
        PeriodeFermeture,
        AccesPieton,
        AccesVL,
        VitessemoyenneVL,
        ReserveBus,
        SensAmngtCyclableGauche,
        SensAmngtCyclableDroit,
        AmngtCyclableGauche,
        AmngtCyclableDroit,
        PrecisionPlani,
        PrecisionAlti,
        Geom
    )
    select
        t.NumeroRoute,
        case -- la géométrie est mise dans le sens croissant des PR aussi, si nécessaire, inverse COGCommuneGauche et CodeInseeDroit
            when ST_Equals(ST_Force2D(pr.Geom), ST_Force2D(ST_StartPoint(t.Geom))) then COGCommuneGauche -- l'égalité n'est jugée que sur le plan car la BDTopo a parfois des pb de topologie sur l'axe Z
            else COGCommuneDroite
        end,
        case
            when ST_Equals(ST_Force2D(pr.Geom), ST_Force2D(ST_StartPoint(t.Geom))) then COGCommuneDroite -- l'égalité n'est jugée que sur le plan car la BDTopo a parfois des pb de topologie sur l'axe Z
            else COGCommuneGauche
        end,
        t.SirenGestionnaireRoute,
        t.SirenGestionnaireRoute,
        t.SirenGestionnaireRoute,
        t.IdIGN,
        t.IdIGNRoute,
        0,
        case t.Fictif -- la taille du tronçon n'est prise en compte que s'il n'est pas fictif
            when true then 0
            else ST_3DLength(t.Geom)
        end,
        t.Fictif,
        t.Importance,
        t.Nature,
        t.NbVoies,
        t.Largeur,
        t.PositionSol,
        t.GueOuRadier,
        t.Urbain,
        t.Prive,
        case -- détermine le sens de circulation par rapport au sens des PR : 1 croissant, 2 décroissant, 3 double
            when t.SensCirculation = 'Double sens' then 3
            when t.SensCirculation = 'Sens direct' and ST_Equals(ST_Force2D(pr.Geom), ST_Force2D(ST_StartPoint(t.Geom))) then 1 -- l'égalité n'est jugée que sur le plan car la BDTopo a parfois des pb de topologie sur l'axe Z
            when t.SensCirculation = 'Sens direct' and ST_Equals(ST_Force2D(pr.Geom), ST_Force2D(ST_EndPoint(t.Geom))) then 2 -- l'égalité n'est jugée que sur le plan car la BDTopo a parfois des pb de topologie sur l'axe Z
            when t.SensCirculation = 'Sens inverse' and ST_Equals(ST_Force2D(pr.Geom), ST_Force2D(ST_StartPoint(t.Geom))) then 2 -- l'égalité n'est jugée que sur le plan car la BDTopo a parfois des pb de topologie sur l'axe Z
            when t.SensCirculation = 'Sens inverse' and ST_Equals(ST_Force2D(pr.Geom), ST_Force2D(ST_EndPoint(t.Geom))) then 1 -- l'égalité n'est jugée que sur le plan car la BDTopo a parfois des pb de topologie sur l'axe Z
        end,
        t.ItineraireVert,
        t.Delestage,
        t.MatDangereusesInterdites,
        t.RestrictionLongueur,
        t.RestrictionLargeur,
        t.RestrictionPoidsParEssieu,
        t.RestrictionPoidsTotal,
        t.RestrictionHauteur,
        t.NatureRestriction,
        t.PeriodeFermeture,
        t.AccesPieton,
        t.AccesVL,
        t.VitessemoyenneVL,
        t.ReserveBus,
        t.SensAmngtCyclableGauche,
        t.SensAmngtCyclableDroit,
        t.AmngtCyclableGauche,
        t.AmngtCyclableDroit,
        t.PrecisionPlani,
        t.PrecisionAlti,
        case -- en profite pour mettre les tronçons dans le sens croissant des PR
            when ST_Equals(ST_Force2D(pr.Geom), ST_Force2D(ST_StartPoint(t.Geom))) then ST_Force4D(t.Geom) -- l'égalité n'est jugée que sur le plan car la BDTopo a parfois des pb de topologie sur l'axe Z
            else ST_Reverse(ST_Force4D(t.Geom))
        end
    from BDT2RR_Troncon t
    inner join PR pr on pr.NumeroRoute = t.NumeroRoute and (ST_Equals(ST_Force2D(pr.Geom), ST_Force2D(ST_StartPoint(t.Geom))) or ST_Equals(ST_Force2D(pr.Geom), ST_Force2D(ST_EndPoint(t.Geom)))) -- l'égalité n'est jugée que sur le plan car la BDTopo a parfois des pb de topologie sur l'axe Z
    left join TronconGiratoire tg on tg.IdIGN = t.IdIGN
    where t.NumeroRoute = _NumeroRoute
    and pr.CumulDist = 0
    and tg.IdIGN is null;
    
$$ language sql;

-- Ajout au référentiel du/des premiers tronçons participant à un giratoire d'une route.
-- Les premiers tronçons sont déterminés au regard de leur proximité avec les PR de début recalés.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route dont on souhaite ajouter le premier tronçon giratoire.
-- Résultats :
-- - Ajoute à la table Troncon le premier tronçon giratoire.
create or replace function AjouterPremierTronconGiratoire(_NumeroRoute character varying) returns void as $$

    insert into Troncon (
        NumeroRoute,
        IdGiratoire,
        COGCommuneGauche,
        COGCommuneDroite,
        SirenProprietaire,
        SirenGestionCourante,
        SirenVH,
        IdIGN,
        IdIGNRoute,
        CumulDistD,
        CumulDistF,
        Fictif,
        Importance,
        Nature,
        NbVoies,
        Largeur,
        PositionSol,
        GueOuRadier,
        Urbain,
        Prive,
        SensCirculation,
        ItineraireVert,
        Delestage,
        MatDangereusesInterdites,
        RestrictionLongueur,
        RestrictionLargeur,
        RestrictionPoidsParEssieu,
        RestrictionPoidsTotal,
        RestrictionHauteur,
        NatureRestriction,
        PeriodeFermeture,
        AccesPieton,
        AccesVL,
        VitessemoyenneVL,
        ReserveBus,
        SensAmngtCyclableGauche,
        SensAmngtCyclableDroit,
        AmngtCyclableGauche,
        AmngtCyclableDroit,
        PrecisionPlani,
        PrecisionAlti,
        Geom
    )
    select
        pr.NumeroRoute,
        tg.IdGiratoire,
        t.COGCommuneGauche,
        t.COGCommuneDroite,
        t.SirenGestionnaireRoute,
        t.SirenGestionnaireRoute,
        t.SirenGestionnaireRoute,
        t.IdIGN,
        t.IdIGNRoute,
        0,
        0, -- ignore les giratoires pour les calculs de distances et les fonctions de géocodage
        t.Fictif,
        t.Importance,
        t.Nature,
        t.NbVoies,
        t.Largeur,
        t.PositionSol,
        t.GueOuRadier,
        t.Urbain,
        t.Prive,
        1,
        t.ItineraireVert,
        t.Delestage,
        t.MatDangereusesInterdites,
        t.RestrictionLongueur,
        t.RestrictionLargeur,
        t.RestrictionPoidsParEssieu,
        t.RestrictionPoidsTotal,
        t.RestrictionHauteur,
        t.NatureRestriction,
        t.PeriodeFermeture,
        t.AccesPieton,
        t.AccesVL,
        t.VitessemoyenneVL,
        t.ReserveBus,
        t.SensAmngtCyclableGauche,
        t.SensAmngtCyclableDroit,
        t.AmngtCyclableGauche,
        t.AmngtCyclableDroit,
        t.PrecisionPlani,
        t.PrecisionAlti,
        ST_Force4D(tg.Geom)
        
    from TronconGiratoire tg
    inner join BDT2RR_Troncon t on tg.IdIGN = t.IdIGN
    inner join PR pr on ST_Equals(ST_Force2D(pr.Geom), ST_Force2D(ST_StartPoint(tg.Geom)))  -- l'égalité n'est jugée que sur le plan car la BDTopo a parfois des pb de topologie sur l'axe Z - le numero de route est ignoré car le giratoire n'est pas forcément affecté à la même route
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
            select t.*, prec.IdIGN as IdIGNPrec, prec.CumulDistF as CumulDistFPrec, ST_Equals(ST_Force2D(ST_EndPoint(prec.Geom)), ST_Force2D(ST_EndPoint(t.Geom))) as InverserGeom -- l'égalité n'est jugée que sur le plan car la BDTopo a parfois des pb de topologie sur l'axe Z
            from BDT2RR_Troncon t
            inner join Troncon prec
            on prec.NumeroRoute = t.NumeroRoute
            and ST_Intersects(prec.Geom, t.Geom) -- pour profiter de l'index géographique
            and (
                ST_Equals(ST_Force2D(ST_EndPoint(prec.Geom)), ST_Force2D(ST_StartPoint(t.Geom))) -- l'égalité n'est jugée que sur le plan car la BDTopo a parfois des pb de topologie sur l'axe Z
                or ST_Equals(ST_Force2D(ST_EndPoint(prec.Geom)), ST_Force2D(ST_EndPoint(t.Geom))) -- l'égalité n'est jugée que sur le plan car la BDTopo a parfois des pb de topologie sur l'axe Z
            )
            left join TronconGiratoire tg on tg.IdIGN = t.IdIGN
            left join Troncon tref on tref.IdIGN = t.IdIGN
            where t.NumeroRoute = _NumeroRoute
            and tg.IdIGN is null
            and tref.IdIGN is null
            order by            -- ordonne par :
                CumulDistFPrec, -- - CumulDistF pour privilégier le chemin le plus court
                IdIGNPrec       -- - IdIGNPrec pour que l'algo soit déterministe si le min de CumulDistF n'est pas unique
            limit 1
        )
        
        insert into Troncon (
            NumeroRoute,
            COGCommuneGauche,
            COGCommuneDroite,
            SirenProprietaire,
            SirenGestionCourante,
            SirenVH,
            IdIGN,
            IdIGNPrec,
            IdIGNRoute,
            CumulDistD,
            CumulDistF,
            Fictif,
            Importance,
            Nature,
            NbVoies,
            Largeur,
            PositionSol,
            GueOuRadier,
            Urbain,
            Prive,
            SensCirculation,
            ItineraireVert,
            Delestage,
            MatDangereusesInterdites,
            RestrictionLongueur,
            RestrictionLargeur,
            RestrictionPoidsParEssieu,
            RestrictionPoidsTotal,
            RestrictionHauteur,
            NatureRestriction,
            PeriodeFermeture,
            AccesPieton,
            AccesVL,
            VitessemoyenneVL,
            ReserveBus,
            SensAmngtCyclableGauche,
            SensAmngtCyclableDroit,
            AmngtCyclableGauche,
            AmngtCyclableDroit,
            PrecisionPlani,
            PrecisionAlti,
            Geom
        )
        select
            NumeroRoute,
            case -- la géométrie est mise dans le sens croissant des PR aussi, si nécessaire, inverse COGCommuneGauche et CodeInseeDroit
                when not(InverserGeom) then COGCommuneGauche
                else COGCommuneDroite
            end,
            case
                when not(InverserGeom) then COGCommuneDroite
                else COGCommuneGauche
            end,
            SirenGestionnaireRoute,
            SirenGestionnaireRoute,
            SirenGestionnaireRoute,
            IdIGN,
            IdIGNPrec,
            IdIGNRoute,
            CumulDistFPrec,
            case Fictif -- la taille du tronçon n'est prise en compte que s'il n'est pas fictif
                when true then CumulDistFPrec -- pour ceux qui le souhaitent, ajouter ici une taille "virtuelle" au tronçon fictif, par exemple 1 mètre
                else CumulDistFPrec + ST_3DLength(Geom)
            end,
            Fictif,
            Importance,
            Nature,
            NbVoies,
            Largeur,
            PositionSol,
            GueOuRadier,
            Urbain,
            Prive,
            case -- détermine le sens de circulation par rapport au sens des PR : 1 croissant, 2 décroissant, 3 double
                when SensCirculation = 'Double sens' then 3
                when SensCirculation = 'Sens direct' and not(InverserGeom) then 1
                when SensCirculation = 'Sens direct' and InverserGeom then 2
                when SensCirculation = 'Sens inverse' and not(InverserGeom) then 2
                when SensCirculation = 'Sens inverse' and InverserGeom then 1
            end,
            ItineraireVert,
            Delestage,
            MatDangereusesInterdites,
            RestrictionLongueur,
            RestrictionLargeur,
            RestrictionPoidsParEssieu,
            RestrictionPoidsTotal,
            RestrictionHauteur,
            NatureRestriction,
            PeriodeFermeture,
            AccesPieton,
            AccesVL,
            VitessemoyenneVL,
            ReserveBus,
            SensAmngtCyclableGauche,
            SensAmngtCyclableDroit,
            AmngtCyclableGauche,
            AmngtCyclableDroit,
            PrecisionPlani,
            PrecisionAlti,
            case -- met la géométrie des tronçons dans le sens croissant des PR
                when not(InverserGeom) then ST_Force4D(Geom)
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
            and ST_Intersects(prec.Geom, tg.Geom) -- pour profiter de l'index géographique
            and ST_Equals(ST_Force2D(ST_EndPoint(prec.Geom)), ST_Force2D(ST_StartPoint(tg.Geom))) -- l'égalité n'est jugée que sur le plan car la BDTopo a parfois des pb de topologie sur l'axe Z
            left join Troncon tref on tref.NumeroRoute = _NumeroRoute and tref.IdIGN = t.IdIGN
            where tref.IdIGN is null
            order by            -- ordonne par :
                CumulDistFPrec, -- - CumulDistF pour privilégier le chemin le plus court
                IdIGNPrec       -- - IdIGNPrec pour que l'algo soit déterministe si le min de CumulDistF n'est pas unique
            limit 1
        )
        
        insert into Troncon (
            NumeroRoute,
            IdGiratoire,
            COGCommuneGauche,
            COGCommuneDroite,
            SirenProprietaire,
            SirenGestionCourante,
            SirenVH,
            IdIGN,
            IdIGNPrec,
            IdIGNRoute,
            CumulDistD,
            CumulDistF,
            Fictif,
            Importance,
            Nature,
            NbVoies,
            Largeur,
            PositionSol,
            GueOuRadier,
            Urbain,
            Prive,
            SensCirculation,
            ItineraireVert,
            Delestage,
            MatDangereusesInterdites,
            RestrictionLongueur,
            RestrictionLargeur,
            RestrictionPoidsParEssieu,
            RestrictionPoidsTotal,
            RestrictionHauteur,
            NatureRestriction,
            PeriodeFermeture,
            AccesPieton,
            AccesVL,
            VitessemoyenneVL,
            ReserveBus,
            SensAmngtCyclableGauche,
            SensAmngtCyclableDroit,
            AmngtCyclableGauche,
            AmngtCyclableDroit,
            PrecisionPlani,
            PrecisionAlti,
            Geom
        )
        select
            _NumeroRoute,
            IdGiratoire,
            COGCommuneGauche,
            COGCommuneDroite,
            SirenGestionnaireRoute,
            SirenGestionnaireRoute,
            SirenGestionnaireRoute,
            IdIGN,
            IdIGNPrec,
            IdIGNRoute,
            CumulDistFPrec,
            CumulDistFPrec, -- ignore les giratoires pour les calculs de distances et les fonctions de géocodage
            Fictif,
            Importance,
            Nature,
            NbVoies,
            Largeur,
            PositionSol,
            GueOuRadier,
            Urbain,
            Prive,
            1,
            ItineraireVert,
            Delestage,
            MatDangereusesInterdites,
            RestrictionLongueur,
            RestrictionLargeur,
            RestrictionPoidsParEssieu,
            RestrictionPoidsTotal,
            RestrictionHauteur,
            NatureRestriction,
            PeriodeFermeture,
            AccesPieton,
            AccesVL,
            VitessemoyenneVL,
            ReserveBus,
            SensAmngtCyclableGauche,
            SensAmngtCyclableDroit,
            AmngtCyclableGauche,
            AmngtCyclableDroit,
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

    insert into PR (NumeroRoute, PRA, Geom)
    select
        pr.NumeroRoute as NumeroRoute,
        pr.PRA,
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
    and pr.PRA > all (
        select PRA
        from PR
        where NumeroRoute = _NumeroRoute
        and CumulDist = 0
    );
    
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
            t.COGCommuneGauche,
            t.COGCommuneDroite,
            t.SirenProprietaire,
            t.SirenGestionCourante,
            t.SirenVH,
            t.IdIGN,
            t.IdIGNPrec,
            t.IdIGNRoute,
            t.CumulDistD,
            t.CumulDistF,
            t.Fictif,
            t.Importance,
            t.Nature,
            t.NbVoies,
            t.Largeur,
            t.PositionSol,
            t.GueOuRadier,
            t.Urbain,
            t.Prive,
            t.SensCirculation,
            t.ItineraireVert,
            t.Delestage,
            t.MatDangereusesInterdites,
            t.RestrictionLongueur,
            t.RestrictionLargeur,
            t.RestrictionPoidsParEssieu,
            t.RestrictionPoidsTotal,
            t.RestrictionHauteur,
            t.NatureRestriction,
            t.PeriodeFermeture,
            t.AccesPieton,
            t.AccesVL,
            t.VitessemoyenneVL,
            t.ReserveBus,
            t.SensAmngtCyclableGauche,
            t.SensAmngtCyclableDroit,
            t.AmngtCyclableGauche,
            t.AmngtCyclableDroit,
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
                insert into Troncon (
                    NumeroRoute,
                    IdGiratoire,
                    COGCommuneGauche,
                    COGCommuneDroite,
                    SirenProprietaire,
                    SirenGestionCourante,
                    SirenVH,
                    IdIGN,
                    IdIGNPrec,
                    IdIGNRoute,
                    CumulDistD,
                    CumulDistF,
                    Fictif,
                    Importance,
                    Nature,
                    NbVoies,
                    Largeur,
                    PositionSol,
                    GueOuRadier,
                    Urbain,
                    Prive,
                    SensCirculation,
                    ItineraireVert,
                    Delestage,
                    MatDangereusesInterdites,
                    RestrictionLongueur,
                    RestrictionLargeur,
                    RestrictionPoidsParEssieu,
                    RestrictionPoidsTotal,
                    RestrictionHauteur,
                    NatureRestriction,
                    PeriodeFermeture,
                    AccesPieton,
                    AccesVL,
                    VitessemoyenneVL,
                    ReserveBus,
                    SensAmngtCyclableGauche,
                    SensAmngtCyclableDroit,
                    AmngtCyclableGauche,
                    AmngtCyclableDroit,
                    PrecisionPlani,
                    PrecisionAlti,
                    Geom
                )
                values (
                    _NumeroRoute,
                    _Decoupage.IdGiratoire,
                    _Decoupage.COGCommuneGauche,
                    _Decoupage.COGCommuneDroite,
                    _Decoupage.SirenProprietaire,
                    _Decoupage.SirenGestionCourante,
                    _Decoupage.SirenVH,
                    _Decoupage.IdIGN,
                    _Decoupage.IdIGNPrec,
                    _Decoupage.IdIGNRoute,
                    _Decoupage.CumulDistD,
                    _Decoupage.CumulDistD + ST_3DLength(_Geom1),
                    _Decoupage.Fictif,
                    _Decoupage.Importance,
                    _Decoupage.Nature,
                    _Decoupage.NbVoies,
                    _Decoupage.Largeur,
                    _Decoupage.PositionSol,
                    _Decoupage.GueOuRadier,
                    _Decoupage.Urbain,
                    _Decoupage.Prive,
                    _Decoupage.SensCirculation,
                    _Decoupage.ItineraireVert,
                    _Decoupage.Delestage,
                    _Decoupage.MatDangereusesInterdites,
                    _Decoupage.RestrictionLongueur,
                    _Decoupage.RestrictionLargeur,
                    _Decoupage.RestrictionPoidsParEssieu,
                    _Decoupage.RestrictionPoidsTotal,
                    _Decoupage.RestrictionHauteur,
                    _Decoupage.NatureRestriction,
                    _Decoupage.PeriodeFermeture,
                    _Decoupage.AccesPieton,
                    _Decoupage.AccesVL,
                    _Decoupage.VitessemoyenneVL,
                    _Decoupage.ReserveBus,
                    _Decoupage.SensAmngtCyclableGauche,
                    _Decoupage.SensAmngtCyclableDroit,
                    _Decoupage.AmngtCyclableGauche,
                    _Decoupage.AmngtCyclableDroit,
                    _Decoupage.PrecisionPlani,
                    _Decoupage.PrecisionAlti,
                    ST_AddMeasure(_Geom1, _Decoupage.CumulDistD, _Decoupage.CumulDistD + ST_3DLength(_Geom1))
                ),
                (
                    _NumeroRoute,
                    _Decoupage.IdGiratoire,
                    _Decoupage.COGCommuneGauche,
                    _Decoupage.COGCommuneDroite,
                    _Decoupage.SirenProprietaire,
                    _Decoupage.SirenGestionCourante,
                    _Decoupage.SirenVH,
                    _Decoupage.IdIGN,
                    _Decoupage.IdIGNPrec,
                    _Decoupage.IdIGNRoute,
                    _Decoupage.CumulDistD + ST_3DLength(_Geom1),
                    _Decoupage.CumulDistF,
                    _Decoupage.Fictif,
                    _Decoupage.Importance,
                    _Decoupage.Nature,
                    _Decoupage.NbVoies,
                    _Decoupage.Largeur,
                    _Decoupage.PositionSol,
                    _Decoupage.GueOuRadier,
                    _Decoupage.Urbain,
                    _Decoupage.Prive,
                    _Decoupage.SensCirculation,
                    _Decoupage.ItineraireVert,
                    _Decoupage.Delestage,
                    _Decoupage.MatDangereusesInterdites,
                    _Decoupage.RestrictionLongueur,
                    _Decoupage.RestrictionLargeur,
                    _Decoupage.RestrictionPoidsParEssieu,
                    _Decoupage.RestrictionPoidsTotal,
                    _Decoupage.RestrictionHauteur,
                    _Decoupage.NatureRestriction,
                    _Decoupage.PeriodeFermeture,
                    _Decoupage.AccesPieton,
                    _Decoupage.AccesVL,
                    _Decoupage.VitessemoyenneVL,
                    _Decoupage.ReserveBus,
                    _Decoupage.SensAmngtCyclableGauche,
                    _Decoupage.SensAmngtCyclableDroit,
                    _Decoupage.AmngtCyclableGauche,
                    _Decoupage.AmngtCyclableDroit,
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
            t.COGCommuneGauche,
            t.COGCommuneDroite,
            t.SirenProprietaire,
            t.SirenGestionCourante,
            t.SirenVH,
            t.IdIGN,
            t.IdIGNPrec,
            t.IdIGNRoute,
            t.CumulDistD,
            t.CumulDistF,
            t.Fictif,
            t.Importance,
            t.Nature,
            t.NbVoies,
            t.Largeur,
            t.PositionSol,
            t.GueOuRadier,
            t.Urbain,
            t.Prive,
            t.SensCirculation,
            t.ItineraireVert,
            t.Delestage,
            t.MatDangereusesInterdites,
            t.RestrictionLongueur,
            t.RestrictionLargeur,
            t.RestrictionPoidsParEssieu,
            t.RestrictionPoidsTotal,
            t.RestrictionHauteur,
            t.NatureRestriction,
            t.PeriodeFermeture,
            t.AccesPieton,
            t.AccesVL,
            t.VitessemoyenneVL,
            t.ReserveBus,
            t.SensAmngtCyclableGauche,
            t.SensAmngtCyclableDroit,
            t.AmngtCyclableGauche,
            t.AmngtCyclableDroit,
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
            insert into Troncon (
                NumeroRoute,
                IdGiratoire,
                COGCommuneGauche,
                COGCommuneDroite,
                SirenProprietaire,
                SirenGestionCourante,
                SirenVH,
                IdIGN,
                IdIGNPrec,
                IdIGNRoute,
                CumulDistD,
                CumulDistF,
                Fictif,
                Importance,
                Nature,
                NbVoies,
                Largeur,
                PositionSol,
                GueOuRadier,
                Urbain,
                Prive,
                SensCirculation,
                ItineraireVert,
                Delestage,
                MatDangereusesInterdites,
                RestrictionLongueur,
                RestrictionLargeur,
                RestrictionPoidsParEssieu,
                RestrictionPoidsTotal,
                RestrictionHauteur,
                NatureRestriction,
                PeriodeFermeture,
                AccesPieton,
                AccesVL,
                VitessemoyenneVL,
                ReserveBus,
                SensAmngtCyclableGauche,
                SensAmngtCyclableDroit,
                AmngtCyclableGauche,
                AmngtCyclableDroit,
                PrecisionPlani,
                PrecisionAlti,
                Geom
            )
            values (
                _NumeroRoute,
                _Decoupage.IdGiratoire,
                _Decoupage.COGCommuneGauche,
                _Decoupage.COGCommuneDroite,
                _Decoupage.SirenProprietaire,
                _Decoupage.SirenGestionCourante,
                _Decoupage.SirenVH,
                _Decoupage.IdIGN,
                _Decoupage.IdIGNPrec,
                _Decoupage.IdIGNRoute,
                _Decoupage.CumulDistD,
                _Decoupage.CumulDistD + ST_3DLength(_Decoupage.Moitie1),
                _Decoupage.Fictif,
                _Decoupage.Importance,
                _Decoupage.Nature,
                _Decoupage.NbVoies,
                _Decoupage.Largeur,
                _Decoupage.PositionSol,
                _Decoupage.GueOuRadier,
                _Decoupage.Urbain,
                _Decoupage.Prive,
                _Decoupage.SensCirculation,
                _Decoupage.ItineraireVert,
                _Decoupage.Delestage,
                _Decoupage.MatDangereusesInterdites,
                _Decoupage.RestrictionLongueur,
                _Decoupage.RestrictionLargeur,
                _Decoupage.RestrictionPoidsParEssieu,
                _Decoupage.RestrictionPoidsTotal,
                _Decoupage.RestrictionHauteur,
                _Decoupage.NatureRestriction,
                _Decoupage.PeriodeFermeture,
                _Decoupage.AccesPieton,
                _Decoupage.AccesVL,
                _Decoupage.VitessemoyenneVL,
                _Decoupage.ReserveBus,
                _Decoupage.SensAmngtCyclableGauche,
                _Decoupage.SensAmngtCyclableDroit,
                _Decoupage.AmngtCyclableGauche,
                _Decoupage.AmngtCyclableDroit,
                _Decoupage.PrecisionPlani,
                _Decoupage.PrecisionAlti,
                ST_AddMeasure(_Decoupage.Moitie1, _Decoupage.CumulDistD, _Decoupage.CumulDistD + ST_3DLength(_Decoupage.Moitie1))
            ),
            (
                _NumeroRoute,
                _Decoupage.IdGiratoire,
                _Decoupage.COGCommuneGauche,
                _Decoupage.COGCommuneDroite,
                _Decoupage.SirenProprietaire,
                _Decoupage.SirenGestionCourante,
                _Decoupage.SirenVH,
                _Decoupage.IdIGN,
                _Decoupage.IdIGNPrec,
                _Decoupage.IdIGNRoute,
                _Decoupage.CumulDistD + ST_3DLength(_Decoupage.Moitie1),
                _Decoupage.CumulDistF,
                _Decoupage.Fictif,
                _Decoupage.Importance,
                _Decoupage.Nature,
                _Decoupage.NbVoies,
                _Decoupage.Largeur,
                _Decoupage.PositionSol,
                _Decoupage.GueOuRadier,
                _Decoupage.Urbain,
                _Decoupage.Prive,
                _Decoupage.SensCirculation,
                _Decoupage.ItineraireVert,
                _Decoupage.Delestage,
                _Decoupage.MatDangereusesInterdites,
                _Decoupage.RestrictionLongueur,
                _Decoupage.RestrictionLargeur,
                _Decoupage.RestrictionPoidsParEssieu,
                _Decoupage.RestrictionPoidsTotal,
                _Decoupage.RestrictionHauteur,
                _Decoupage.NatureRestriction,
                _Decoupage.PeriodeFermeture,
                _Decoupage.AccesPieton,
                _Decoupage.AccesVL,
                _Decoupage.VitessemoyenneVL,
                _Decoupage.ReserveBus,
                _Decoupage.SensAmngtCyclableGauche,
                _Decoupage.SensAmngtCyclableDroit,
                _Decoupage.AmngtCyclableGauche,
                _Decoupage.AmngtCyclableDroit,
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

-- Inversion de tronçons et de leurs successeurs.
-- Cette fonction est utile pour gérer le cas des tronçons placés avant le PR de début.
-- Elle passe en négatif les distances cumulées et inverse la géométrie.
-- /!\ La fonction ne modifie pas les attributs IdIGNPrec.
-- Paramètres :
-- - _IdIGN : L'identifiant IGN des tronçons à inverser, par récursivité, inverse aussi les tronçons qui leurs succèdent.
-- Résultats :
-- - CumulDistD prend la valeur de -CumulDistF.
-- - CumulDistF prend la valeur de -CumulDistD.
-- - COGCommuneGauche prend la valeur de COGCommuneDroite
-- - COGCommuneDroite prend la valeur de COGCommuneGauche
-- - Inverse la géométrie des tronçons (ST_Reverse).
-- - Repositionne les valeurs M en conséquence (ST_AddMeasure).
create or replace function InverserTroncons(_IdIGN varchar[]) returns table (NumeroRoute varchar, IdIGN varchar, Longueur float) as $$

    with recursive TronconAInverser as (
        
        select IdTroncon, IdIGN
        from Troncon
        where IdIGN = any(_IdIGN)
        
        union all
        
        select t.IdTroncon, t.IdIGN
        from TronconAInverser prec
        inner join m.Troncon t on t.IdIGNPrec = prec.IdIGN
    )
    update Troncon
    set
        CumulDistD = -CumulDistF,
        CumulDistF = -CumulDistD,
        COGCommuneGauche = COGCommuneDroite,
        COGCommuneDroite = COGCommuneGauche,
        Geom = ST_AddMeasure(ST_Reverse(Geom), -CumulDistF, -CumulDistD)
    where IdTroncon in (select IdTroncon from TronconAInverser)
    returning NumeroRoute, IdIGN, ST_Length(Geom);
    
$$ language sql;