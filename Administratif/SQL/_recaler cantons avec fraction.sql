-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;

-- Etape 1 :
--    On réaligne sur les communes entières du canton.
--    On ne conserve que les fractions significatives pour les communes non entières.
with NbCantonsCommune as (
    -- calcul du nombre de cantons par commune
    select COGCommune, count(COGCanton) as NbCantons
    from Commune_Canton
    group by COGCommune
),
CantonAvecFractionCommune as (
    -- recherche des cantons avec fractions de communes
    select distinct COGCanton
    from Commune_Canton cc
    inner join NbCantonsCommune ncc on ncc.NbCantons > 1 and ncc.COGCommune = cc.COGCommune
),
FractionCommune as (
    -- recherche pour chaque couple canton/commune de la géométrie des fractions de communes pour le canton
    select
        ca.COGCanton,
        co.COGCommune,
        co.Geom as GeomCommune,
        (ST_Dump(ST_CollectionExtract(ST_Intersection(co.Geom, ca.Geom), 3))).Geom as GeomFraction
    from CantonAvecFractionCommune cafc
    inner join Canton ca on ca.COGCanton = cafc.COGCanton
    inner join Commune_Canton cc on cc.COGCanton = ca.COGCanton
    inner join Commune co on co.COGCommune = cc.COGCommune
    inner join NbCantonsCommune ncc on ncc.NbCantons > 1 and ncc.COGCommune = co.COGCommune
),
RecalageCanton as (
    -- pour le recalage, on conserve :
    select COGCanton, ST_Multi(ST_Union(Geom)) as Geom
    from (
        -- la géométrie des fractions significatives c-a-d les fractions dont la surface est >= à 1,5% de la surface de la commune
        select fcc.COGCanton, fcc.GeomFraction as Geom
        from FractionCommune fcc
        where ST_Area(fcc.GeomFraction) / ST_Area(fcc.GeomCommune) >= 0.015
        
        union
        
        -- la géométrie des communes entières
        select cafc.COGCanton, co.Geom
        from CantonAvecFractionCommune cafc
        inner join Commune_Canton cc ON cc.COGCanton = cafc.COGCanton
        inner join Commune co ON co.COGCommune = cc.COGCommune
        inner join NbCantonsCommune ncc on ncc.NbCantons = 1 and ncc.COGCommune = co.COGCommune
    ) t
    group by COGCanton
)
update Canton ca
set Geom = rc.Geom
from RecalageCanton rc
where ca.COGCanton = rc.COGCanton;

-- Etape 2 :
--    On recale par extension successives des fractions sans déborder de la commune non entière ni sur les cantons limitrophes.
with CommuneMultiCantons as (
    select COGCommune
    from Commune_Canton
    group by COGCommune
    having count(COGCanton) > 1
),
CantonAvecFractionCommune as (
    select distinct COGCanton
    from Commune_Canton cc
    inner join CommuneMultiCantons cmc on cmc.COGCommune = cc.COGCommune
),
FractionCommune as (
    select
        co.COGCommune,
        ca.COGCanton,
        co.Geom as GeomCommune,
        (ST_Dump(ST_CollectionExtract(ST_Intersection(co.Geom, ca.Geom), 3))).Geom as GeomFraction
    from CommuneMultiCantons cmc
    inner join Commune co on co.COGCommune = cmc.COGCommune
    inner join Commune_Canton cc on cc.COGCommune = co.COGCommune
    inner join Canton ca on ca.COGCanton = cc.COGCanton
),
BufferFractionSignificativeCommune as (
    select COGCommune, COGCanton, gs as TailleBuffer, GeomCommune, ST_Buffer(GeomFraction, gs) AS BufferFraction
    from generate_series(5, 50, 5) gs, FractionCommune
    where ST_Area(GeomFraction) / ST_Area(GeomCommune) >= 0.015
),
BufferSansDebordement as (
    select
        bfmc1.COGCommune,
        bfmc1.COGCanton,
        ST_Intersection(bfmc1.GeomCommune, ST_Difference(bfmc1.BufferFraction, ST_Union(bfmc2.BufferFraction))) as Geom
    from BufferFractionSignificativeCommune bfmc1
    inner join BufferFractionSignificativeCommune bfmc2 on bfmc1.TailleBuffer = bfmc2.TailleBuffer and bfmc1.COGCommune = bfmc2.COGCommune and bfmc1.COGCanton <> bfmc2.COGCanton
    group by bfmc1.COGCommune, bfmc1.COGCanton, bfmc1.GeomCommune, bfmc1.BufferFraction
),
UnionBuffer as (
    select COGCanton, ST_Union(Geom) as Geom
    from BufferSansDebordement
    group by COGCanton
)
update Canton ca
set Geom = ST_Multi(ST_CollectionExtract(ST_Union(ca.Geom, ub.Geom), 3))
from UnionBuffer ub
where ca.COGCanton = ub.COGCanton;