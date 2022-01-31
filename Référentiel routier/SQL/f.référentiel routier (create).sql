-- schémas spécifiques SI3P0 (f = fonctions, m = modèle)
set search_path to f, m, public;

-- Conversion d'un PR+Abs en texte (ex: 10+354).
-- Paramètres :
-- - _PRA : Le PR+Abs sous la forme 10000 * PR + Abscisse.
-- Résultats :
-- - Retourne le PR+Abs en texte.
create or replace function PRAEnTexte(_PRA integer) returns character varying as $$
    select (_PRA / 10000) || '+' || (_PRA % 10000);
$$ language sql;

-- Conversion d'une distance cumulée depuis le début de la route en PR+Abs sous la forme 10000 * PR + Abscisse.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route concernée.
-- - _CumulDist : La distance cumulée à convertir.
-- Résultats :
-- - Retourne le PR+Abs sous la forme 10000 * PR + Abscisse.
create or replace function CumulDistVersPRA(_NumeroRoute character varying, _CumulDist numeric) returns integer as $$

    with PRAvant as (
        select PRA, CumulDist
        from PR
        where NumeroRoute = _NumeroRoute
        and CumulDist <= _CumulDist
        order by PRA desc
        limit 1
    )
    select PRA + round(_CumulDist - CumulDist)::integer
    from PRAvant;

$$ language sql;

-- Conversion d'un PR+Abs en distance cumulée depuis le début de la route.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route concernée.
-- - _PRA : Le PR+Abs sous la forme 10000 * PR + Abscisse.
-- Résultats :
-- - Retourne la distance cumulée depuis le début de la route.
create or replace function PRAVersCumulDist(_NumeroRoute character varying, _PRA integer) returns numeric as $$

    with PRAvant as (
        select PRA, CumulDist
        from PR
        where NumeroRoute = _NumeroRoute
        and PRA <= _PRA
        and (PRA / 10000) = (_PRA / 10000)
        order by PRA desc
        limit 1
    )
    select CumulDist + (_PRA - PRA)::numeric
    from PRAvant;
    
$$ language sql;

-- Conversion d'un point en distance cumulée depuis le début de la route.
-- Paramètres :
-- - _Point : Le point.
-- - _RayonRecherche (défaut : 100) : Le rayon de recherche du point sur une route.
-- Résultats :
-- - Retourne le numéro de route et la distance cumulée du point le plus proche du point donnée.
create or replace function PointVersCumulDist(_Point geometry, _RayonRecherche integer default 100) returns table (_NumeroRoute character varying, _CumulDist numeric) as $$
    
    select NumeroRoute, (ST_3DLength(Geom) * ST_LineLocatePoint(Geom, TransformerEnL93(_Point)))::numeric + CumulDistD
    from Troncon
    where not Fictif
    and IdGiratoire is null -- ignore les giratoires pour les calculs de distances et les fonctions de géocodage
    and ST_DWithin(Geom, TransformerEnL93(_Point), _RayonRecherche)
    order by Geom <-> TransformerEnL93(_Point)
    limit 1;
    
$$ language sql;

-- Conversion d'un point en distance cumulée depuis le début d'une route donnée.
-- Paramètres :
-- - _Point : Le point.
-- - _NumeroRoute : Le numéro de route concernée.
-- - _RayonRecherche (défaut : 100) : Le rayon de recherche du point sur la route.
-- Résultats :
-- - Retourne la distance cumulée du point le plus proche du point donnée sur la route concernée.
create or replace function PointVersCumulDist(_Point geometry, _NumeroRoute character varying, _RayonRecherche integer default 100) returns numeric as $$

    select (ST_3DLength(Geom) * ST_LineLocatePoint(Geom, TransformerEnL93(_Point)))::numeric + CumulDistD
    from Troncon
    where NumeroRoute = _NumeroRoute
    and not Fictif
    and IdGiratoire is null -- ignore les giratoires pour les calculs de distances et les fonctions de géocodage
    and ST_DWithin(Geom, TransformerEnL93(_Point), _RayonRecherche)
    order by Geom <-> TransformerEnL93(_Point)
    limit 1;
    
$$ language sql;

-- Conversion d'un point en PR+Abs.
-- Paramètres :
-- - _Point : Le point.
-- - _RayonRecherche (défaut : 100) : Le rayon de recherche du point sur une route.
-- Résultats :
-- - Retourne le numéro de route et le PR+Abs du point le plus proche du point donnée.
create or replace function PointVersPRA(_Point geometry, _RayonRecherche integer default 100) returns table (_NumeroRoute character varying, _PRA integer) as $$
    
    select pvcd._NumeroRoute, CumulDistVersPRA(pvcd._NumeroRoute, pvcd._CumulDist)
    from PointVersCumulDist(_Point, _RayonRecherche) pvcd;
    
$$ language sql;

-- Conversion d'un point en PR+Abs sur une route donnée.
-- Paramètres :
-- - _Point : Le point.
-- - _NumeroRoute : Le numéro de route concernée.
-- - _RayonRecherche (défaut : 100) : Le rayon de recherche du point sur la route.
-- Résultats :
-- - Retourne le PR+Abs du point le plus proche du point donnée sur la route concernée.
create or replace function PointVersPRA(_Point geometry, _NumeroRoute character varying, _RayonRecherche integer default 100) returns integer as $$

    select CumulDistVersPRA(_NumeroRoute, PointVersCumulDist(_Point, _NumeroRoute, _RayonRecherche));
    
$$ language sql;

-- Conversion d'une distance cumulée en points géographiques.
-- Une route pouvant avoir plusieurs embranchements, autour des giratoires notamment, cette fonction peut renvoyer plusieurs résultats.
-- Utiliser le paramètre _Limit pour limiter le nombre de points renvoyés.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route concernée.
-- - _CumulDist : La distance cumulée.
-- - _Limit (défaut : 1000) : Le nombre maximal de points à retourner.
-- Résultats :
-- - Le/les points géographiques.
create or replace function CumulDistVersPoint(_NumeroRoute character varying, _CumulDist numeric, _Limit integer default 1000) returns table (_Point geometry) as $$
    
    with Point as (
        select distinct
            case -- permet de résoudre le problème d'arrondi entre les types numeric (CumulDist) et double precision (ST_M)
                when _CumulDist < ST_M(ST_StartPoint(Geom))::numeric then ST_StartPoint(Geom) 
                when _CumulDist > ST_M(ST_EndPoint(Geom))::numeric then ST_EndPoint(Geom)
                else ST_GeometryN(ST_LocateAlong(Geom, _CumulDist), 1)
            end as Geom,
            SensCirculation, CumulDistD
        from Troncon
        where not Fictif
        and IdGiratoire is null -- ignore les giratoires pour les calculs de distances et les fonctions de géocodage
        and NumeroRoute = _NumeroRoute
        and _CumulDist between CumulDistD and CumulDistF
    )
    select Geom
    from Point
    order by SensCirculation, CumulDistD
    limit _Limit;
    
$$ language sql;

-- Conversion d'un PR+Abs en points géographiques.
-- Une route pouvant avoir plusieurs embranchements, autour des giratoires notamment, cette fonction peut renvoyer plusieurs résultats.
-- Utiliser le paramètre _Limit pour limiter le nombre de points renvoyés.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route concernée.
-- - _PRA : Le PR+Abs sous la forme 10000 * PR + Abscisse.
-- - _Limit (défaut : 1000) : Le nombre maximal de points à retourner.
-- Résultats :
-- - Le/les points géographiques.
create or replace function PRAVersPoint(_NumeroRoute character varying, _PRA integer, _Limit integer default 1000) returns table (_Point geometry) as $$

    select *
    from CumulDistVersPoint(_NumeroRoute, PRAVersCumulDist(_NumeroRoute, _PRA), _Limit);
    
$$ language sql;

-- Recalage d'un point sur le réseau routier.
-- Paramètres :
-- - _Point : Le point à recaler.
-- - _InclureGiratoire (défaut : false) : Pour indiquer si le point peut être repositionné sur l'anneau d'un giratoire.
-- - _RayonRecherche (défaut : 100) : Le rayon de recherche du point sur une route.
-- Résultats :
-- - Retourne le point recalé si celui-ci se trouve dans le rayon de recherche.
create or replace function RecalerPointSurRoute(_Point geometry, _InclureGiratoire boolean default false, _RayonRecherche integer default 100) returns geometry as $$

    select ST_ClosestPoint(t.Geom, _Point)
    from Troncon t
    left join Giratoire g on t.IdGiratoire = g.IdGiratoire and t.NumeroRoute = g.NumeroRoute
    where not t.Fictif
    and (t.IdGiratoire is null or (_InclureGiratoire and g.IdGiratoire is not null))
    and ST_DWithin(t.Geom, TransformerEnL93(_Point), _RayonRecherche)
    order by t.Geom <-> TransformerEnL93(_Point)
    limit 1;
    
$$ language sql;

-- Recalage d'un point sur une route donnée.
-- Paramètres :
-- - _Point : Le point à recaler.
-- - _NumeroRoute : La route sur laquelle le point doit être recalé.
-- - _InclureGiratoire (défaut : false) : Pour indiquer si le point peut être repositionné sur l'anneau d'un giratoire.
-- - _RayonRecherche (défaut : 100) : Le rayon de recherche du point sur une route.
-- Résultats :
-- - Retourne le point recalé si celui-ci se trouve dans le rayon de recherche.
create or replace function RecalerPointSurRoute(_Point geometry, _NumeroRoute character varying, _InclureGiratoire boolean default false, _RayonRecherche integer default 100) returns geometry as $$

    select ST_ClosestPoint(t.Geom, _Point)
    from Troncon t
    left join Giratoire g on t.IdGiratoire = g.IdGiratoire and t.NumeroRoute = g.NumeroRoute
    where t.NumeroRoute = _NumeroRoute
    and not t.Fictif
    and (t.IdGiratoire is null or (_InclureGiratoire and g.IdGiratoire is not null))
    and ST_DWithin(t.Geom, TransformerEnL93(_Point), _RayonRecherche)
    order by t.Geom <-> TransformerEnL93(_Point)
    limit 1;
    
$$ language sql;

-- Recherche des tronçons non fictifs présents sur une emprise.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route dont on recherche les tronçons.
-- - _CumulDistD : La distance cumulée de début de l'emprise.
-- - _CumulDistF : La distance cumulée de fin de l'emprise.
-- - _InclureGiratoire (défaut : false) : Pour indiquer si les tronçons formant les anneaux des giratoires sont à retourner.
-- Résultats :
-- - Retourne les tronçons sur l'emprise donnée.
create or replace function RechercherTronconSurEmprise(_NumeroRoute character varying, _CumulDistD numeric, _CumulDistF numeric, _InclureGiratoire boolean default false) returns setof Troncon as $$

    select t.*
    from Troncon t
    left join Giratoire g on t.IdGiratoire = g.IdGiratoire and t.NumeroRoute = g.NumeroRoute
    where t.NumeroRoute = _NumeroRoute
    and not t.Fictif
    and (t.IdGiratoire is null or (_InclureGiratoire and g.IdGiratoire is not null))
    and (
        (CumulDistD between _CumulDistD and _CumulDistF) -- cas 1, le début du tronçon est inclus dans l'emprise
        or (CumulDistF between _CumulDistD and _CumulDistF) -- cas 2, la fin du tronçon est inclus dans l'emprise
        or (CumulDistD <= _CumulDistD and CumulDistF >= _CumulDistF) -- cas 3, le tronçon dépasse l'emprise de part et d'autre
    );
        
$$ language sql;

-- Recherche des tronçons non fictifs présents sur une emprise.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route dont on recherche les tronçons.
-- - _PRAD : Le PR+Abs de début de l'emprise sous la forme 10000 * PR + Abscisse.
-- - _PRAF : Le PR+Abs de fin de l'emprise sous la forme 10000 * PR + Abscisse.
-- - _InclureGiratoire (défaut : false) : Pour indiquer si les tronçons formant les anneaux des giratoires sont à retourner.
-- Résultats :
-- - Retourne les tronçons sur l'emprise donnée.
create or replace function RechercherTronconSurEmprise(_NumeroRoute character varying, _PRAD integer, _PRAF integer, _InclureGiratoire boolean default false) returns setof Troncon as $$

    select *
    from RechercherTronconSurEmprise(_NumeroRoute, PRAVersCumulDist(_NumeroRoute, _PRAD), PRAVersCumulDist(_NumeroRoute, _PRAF), _InclureGiratoire);
        
$$ language sql;

-- Recherche des tronçons non fictifs au niveau d'une distance cumulée.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route dont on recherche les tronçons.
-- - _CumulDist : La distance cumulée de recherche.
-- - _InclureGiratoire (défaut : false) : Pour indiquer si les tronçons formant les anneaux des giratoires sont à retourner.
-- Résultats :
-- - Retourne les tronçons à la distance cumulée donnée.
create or replace function RechercherTronconSurEmprise(_NumeroRoute character varying, _CumulDist numeric, _InclureGiratoire boolean default false) returns setof Troncon as $$

    select *
    from RechercherTronconSurEmprise(_NumeroRoute, _CumulDist, _CumulDist, _InclureGiratoire);
    
$$ language sql;

-- Recherche des tronçons non fictifs au niveau d'un PR+Abs.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route dont on recherche les tronçons.
-- - _PRA : Le PR+Abs de recherche sous la forme 10000 * PR + Abscisse.
-- - _InclureGiratoire (défaut : false) : Pour indiquer si les tronçons formant les anneaux des giratoires sont à retourner.
-- Résultats :
-- - Retourne les tronçons au PR+Abs donnée.
create or replace function RechercherTronconSurEmprise(_NumeroRoute character varying, _PRA integer, _InclureGiratoire boolean default false) returns setof Troncon as $$

    select *
    from RechercherTronconSurEmprise(_NumeroRoute, PRAVersCumulDist(_NumeroRoute, _PRA), _InclureGiratoire);
    
$$ language sql;

-- Recherche des tronçons entre les tronçons d'identifiants IGN donnés (giratoires compris).
-- Paramètres :
-- - _NumeroRoute : Le numéro de route dont on recherche les tronçons.
-- - _IdIGNDebut : Les identifiants IGN des tronçons de début.
-- - _IdIGNFin : Les identifiants IGN des tronçons de fin.
-- Résultats :
-- - Retourne les tronçons entre les tronçons d'identifiants IGN donnés.
-- - Aucun tronçon si un des identifiants IGN donnés est introuvable.
create or replace function RechercherTronconsEntreIdIGN(_NumeroRoute varchar, _IdIGNDebut varchar[], _IdIGNFin varchar[]) returns table(_IdIGN varchar) as $$
declare
    NbTronconsDebut integer;
    NbTronconsFin integer;
begin
    
    -- validation des paramètres d'appel : les tronçons doivent exister dans la table Troncon
    select count(distinct IdIGN) into strict NbTronconsDebut
    from Troncon
    where NumeroRoute = _NumeroRoute and IdIGN = any(_IdIGNDebut);
    
    select count(distinct IdIGN) into strict NbTronconsFin
    from Troncon
    where NumeroRoute = _NumeroRoute and IdIGN = any(_IdIGNFin);
    
    if (array_length(_IdIGNDebut, 1) <> NbTronconsDebut) or (array_length(_IdIGNFin, 1) <> NbTronconsFin) then
    
        return;
        
    else
        -- recherches des tronçons entre les identifiants IGN données
        return query with recursive TronconsEntreIdIGN(IdIGN) as (
            -- sélection des tronçons de début et fin
            select IdIGN
            from Troncon
            where NumeroRoute = _NumeroRoute
            and (IdIGN = any(_IdIGNDebut) or IdIGN = any(_IdIGNFin))
            
            union
            
            -- sélection de façon récursive des tronçons ayant pour précédent un tronçon de la liste
            select t.IdIGN
            from Troncon t
            inner join TronconsEntreIdIGN te on t.NumeroRoute = _NumeroRoute and t.IdIGNPrec = te.IdIGN and te.IdIGN <> all(_IdIGNFin)
        )
        select distinct IdIGN
        from TronconsEntreIdIGN;
    
        return;
        
    end if;
end;
$$ language plpgsql;

-- Recherche du giratoire le plus proche d'une distance cumulée donnée.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route à proximité de laquelle le giratoire est recherché.
-- - _CumulDist : La distance cumulée à proximitée du giratoire recherché.
-- Résultats :
-- - Retourne le giratoire le plus proche de la distance cumulée donnée.
create or replace function RechercherGiratoireAProximite(_NumeroRoute character varying, _CumulDist numeric) returns Giratoire as $$

    with Localisation as (
        select * from CumulDistVersPoint(_NumeroRoute, _CumulDist)
    )
    select g.*
    from Giratoire g, Localisation l
    order by ST_Centroid(g.Geom) <-> l._Point
    limit 1;
    
$$ language sql;

-- Recherche du giratoire le plus proche d'un PR+Abs donné.
-- Paramètres :
-- - _NumeroRoute : Le numéro de route à proximité de laquelle le giratoire est recherché.
-- - _PRA : Le PR+Abs à proximité du giratoire recherché sous la forme 10000 * PR + Abscisse.
-- Résultats :
-- - Retourne le giratoire le plus proche du PR+Abs donné.
create or replace function RechercherGiratoireAProximite(_NumeroRoute character varying, _PRA integer) returns Giratoire as $$

    select *
    from RechercherGiratoireAProximite(_NumeroRoute, PRAVersCumulDist(_NumeroRoute, _PRA));
    
$$ language sql;

-- Extraction d'une sous-partie d'un tronçon.
-- Paramètres :
-- - _Troncon : Le tronçon dont il faut extraire une sous-partie.
-- - _CumulDistD : La distance cumulée de début d'extraction.
-- - _CumulDistF : La distance cumulée de fin d'extraction.
-- Résultats :
-- - Retourne la géométrie correspondante à la sous-partie à extraire.
create or replace function ExtraireSousTroncon(_Troncon Troncon, _CumulDistD numeric, _CumulDistF numeric) returns geometry as $$
begin
    -- cas 1 : l'intervalle est incohérent
    if (_CumulDistD >= _CumulDistF) then
        return null;
    -- cas 2 : le tronçon est exclu de l'intervalle
    elsif (_CumulDistD >= _Troncon.CumulDistF or _CumulDistF <= _Troncon.CumulDistD) then
        return null;
    -- cas 3 : le tronçon est inclus dans l'intervalle
    elsif (_CumulDistD <= _Troncon.CumulDistD and _CumulDistF >= _Troncon.CumulDistF) then
        return _Troncon.Geom;
    -- cas 4 : il faut extraire une sous-partie du tronçon
    else
        return ST_GeometryN(ST_LocateBetween(_Troncon.Geom, _CumulDistD, _CumulDistF), 1);
    end if;
end;
$$ language plpgsql;

-- Extraction d'une sous-partie d'un tronçon.
-- Paramètres :
-- - _Troncon : Le tronçon dont il faut extraire une sous-partie.
-- - _PRAD : Le PR+Abs de début d'extraction sous la forme 10000 * PR + Abscisse.
-- - _PRAF : Le PR+Abs de fin d'extraction sous la forme 10000 * PR + Abscisse.
-- Résultats :
-- - Retourne la géométrie correspondante à la sous-partie à extraire.
create or replace function ExtraireSousTroncon(_Troncon Troncon, _PRAD integer, _PRAF integer) returns geometry as $$
    
    select *
    from ExtraireSousTroncon(_Troncon, PRAVersCumulDist(_Troncon.NumeroRoute, _PRAD), PRAVersCumulDist(_Troncon.NumeroRoute, _PRAF))
    
$$ language sql;