﻿-- schémas spécifiques SI3P0 (tmp = temporaire, m = modèle, f = fonctions)
set search_path to tmp, m, f, public;

create view Waze_4Notif as
with Alerte2hProcheRD as (
    select
        IdAlerteWaze,
        DateCreation,
        Fiabilite,
        case
            when IdTypeAlerteWaze = 'ACCIDENT' then 'ACCIDENT'
            when IdTypeAlerteWaze = 'ROAD_CLOSED' then 'ROAD_CLOSED'
            when IdSousTypeAlerteWaze = 'HAZARD_ON_ROAD_ICE' then 'HAZARD_ON_ROAD_ICE'
            when IdSousTypeAlerteWaze = 'HAZARD_ON_ROAD_OBJECT' then 'HAZARD_ON_ROAD_OBJECT'
            when IdSousTypeAlerteWaze = 'HAZARD_ON_ROAD_OIL' then 'HAZARD_ON_ROAD_OIL'
            when IdSousTypeAlerteWaze = 'HAZARD_ON_ROAD_ROAD_KILL' then 'HAZARD_ON_ROAD_ROAD_KILL'
            when IdSousTypeAlerteWaze = 'HAZARD_WEATHER_FLOOD' then 'HAZARD_WEATHER_FLOOD'
            when IdSousTypeAlerteWaze = 'HAZARD_WEATHER_FOG' then 'HAZARD_WEATHER_FOG'
            when IdSousTypeAlerteWaze = 'HAZARD_WEATHER_FREEZING_RAIN' then 'HAZARD_WEATHER_FREEZING_RAIN'
            when IdSousTypeAlerteWaze = 'HAZARD_WEATHER_HAIL' then 'HAZARD_WEATHER_HAIL'
            when IdSousTypeAlerteWaze = 'HAZARD_WEATHER_HEAVY_RAIN' then 'HAZARD_WEATHER_HEAVY_RAIN'
            when IdSousTypeAlerteWaze = 'HAZARD_WEATHER_HEAVY_SNOW' then 'HAZARD_WEATHER_HEAVY_SNOW'
            else '...'
        end as TypeAlerte,
        case
            when IdSousTypeAlerteWaze = 'ACCIDENT_MAJOR' then 2
            when IdSousTypeAlerteWaze = 'ACCIDENT_MINOR' then 1
            when IdTypeAlerteWaze = 'ACCIDENT' then 0
        end as Gravite,
        Geom
    from AlerteWaze a
    where Age(Now(), DateCreation) < '2 hour'::interval
    and exists (select t.IdTroncon from Troncon t where not Fictif and ST_DWithin(a.Geom, t.Geom, 25) limit 1)
),
HistoAlerte2hProcheRD as (
    select
        IdHistoAlerteWaze,
        DateCreation,
        Fiabilite,
        case
            when IdTypeAlerteWaze = 'ACCIDENT' then 'ACCIDENT'
            when IdTypeAlerteWaze = 'ROAD_CLOSED' then 'ROAD_CLOSED'
            when IdSousTypeAlerteWaze = 'HAZARD_ON_ROAD_ICE' then 'HAZARD_ON_ROAD_ICE'
            when IdSousTypeAlerteWaze = 'HAZARD_ON_ROAD_OBJECT' then 'HAZARD_ON_ROAD_OBJECT'
            when IdSousTypeAlerteWaze = 'HAZARD_ON_ROAD_OIL' then 'HAZARD_ON_ROAD_OIL'
            when IdSousTypeAlerteWaze = 'HAZARD_ON_ROAD_ROAD_KILL' then 'HAZARD_ON_ROAD_ROAD_KILL'
            when IdSousTypeAlerteWaze = 'HAZARD_WEATHER_FLOOD' then 'HAZARD_WEATHER_FLOOD'
            when IdSousTypeAlerteWaze = 'HAZARD_WEATHER_FOG' then 'HAZARD_WEATHER_FOG'
            when IdSousTypeAlerteWaze = 'HAZARD_WEATHER_FREEZING_RAIN' then 'HAZARD_WEATHER_FREEZING_RAIN'
            when IdSousTypeAlerteWaze = 'HAZARD_WEATHER_HAIL' then 'HAZARD_WEATHER_HAIL'
            when IdSousTypeAlerteWaze = 'HAZARD_WEATHER_HEAVY_RAIN' then 'HAZARD_WEATHER_HEAVY_RAIN'
            when IdSousTypeAlerteWaze = 'HAZARD_WEATHER_HEAVY_SNOW' then 'HAZARD_WEATHER_HEAVY_SNOW'
            else '...'
        end as TypeAlerte,
        case
            when IdSousTypeAlerteWaze = 'ACCIDENT_MAJOR' then 2
            when IdSousTypeAlerteWaze = 'ACCIDENT_MINOR' then 1
            when IdTypeAlerteWaze = 'ACCIDENT' then 0
        end as Gravite,
        Geom
    from HistoAlerteWaze ah
    where Age(Now(), DateCreation) < '2 hour'::interval
    and exists (select t.IdTroncon from Troncon t where not Fictif and ST_DWithin(ah.Geom, t.Geom, 25) limit 1)
),
Cluster as (
    select TypeAlerte, ST_CollectionExtract(unnest(ST_ClusterWithin(Geom, 500)), 1) as GeomCluster
    from Alerte2hProcheRD
    group by TypeAlerte
),
HistoCluster as (
    select TypeAlerte, ST_CollectionExtract(unnest(ST_ClusterWithin(Geom, 500)), 1) as GeomCluster
    from HistoAlerte2hProcheRD
    group by TypeAlerte
),
NouveauCluster as (
    select row_number() over() as IdCluster, c.*
    from Cluster c
    left join HistoCluster hc on ST_DWithin(c.GeomCluster, hc.GeomCluster, 500)
    where hc.GeomCluster is null
),
DetailsNouveauCluster as (
    select
        c.IdCluster,
        c.TypeAlerte,
        a.Gravite,
        c.GeomCluster,
        a.IdAlerteWaze,
        a.DateCreation,
        a.Fiabilite,
        r.Geom as GeomRalentissement
    from NouveauCluster c
    inner join Alerte2hProcheRD a on c.TypeAlerte = a.TypeAlerte and ST_Intersects(c.GeomCluster, a.Geom)
    left join RalentissementWaze r on ST_DWithin(c.GeomCluster, r.Geom, 100)
)
select
    c.TypeAlerte,
    max(c.Gravite) as Gravite,
    ST_NumGeometries(c.GeomCluster) as NbSignalements,
    max(c.Fiabilite) as Fiabilite,
    to_char(min(c.DateCreation), 'HH24:mi') as HeurePremierSignalement,
    to_char(max(c.DateCreation), 'HH24:mi') as HeureDernierSignalement,
    (PointVersPRA(ST_Centroid(c.GeomCluster)))._NumeroRoute as NumeroRoute,
    PRAEnTexte((PointVersPRA(ST_Centroid(c.GeomCluster)))._PRA) as PRA,
    coalesce(round(ST_Length(ST_Collect(distinct c.GeomRalentissement))::numeric, 0), 0) as LongueurRalentissements,
    string_agg(distinct co.Nom, ', ' order by co.Nom) as Communes,
    string_agg(distinct o.LibelleClair, ', ' order by o.LibelleClair) as PER,
    ST_X(TransformerEnWGS84(ST_Centroid(c.GeomCluster))) as X,
    ST_Y(TransformerEnWGS84(ST_Centroid(c.GeomCluster))) as Y,
    'https://embed.waze.com/fr/iframe?zoom=15&lat=' || round(ST_Y(TransformerEnWGS84(ST_Centroid(c.GeomCluster)))::numeric, 6) || '&lon=' || round(ST_X(TransformerEnWGS84(ST_Centroid(c.GeomCluster)))::numeric, 6) as LienWazeEmbed,
    'https://www.waze.com/live-map?lat=' || round(ST_Y(TransformerEnWGS84(ST_Centroid(c.GeomCluster)))::numeric, 6) || '&lon=' || round(ST_X(TransformerEnWGS84(ST_Centroid(c.GeomCluster)))::numeric, 6) as LienWazeLiveMap
from DetailsNouveauCluster c
left join Commune co on ST_Intersects(co.Geom, c.GeomCluster)
left join v.LimiteGestionPER per on ST_Intersects(per.Geom, c.GeomCluster)
left join v.Organigramme o on o.CodeStructureRH = per.CodeStructureRH
where c.TypeAlerte <> '...'
group by c.IdCluster, c.TypeAlerte, c.GeomCluster;