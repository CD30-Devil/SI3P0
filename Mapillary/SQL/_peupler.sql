-- schémas spécifiques SI3P0 (d = données, m = modèle, f = fonctions, tmp = temporaire)
set search_path to d, m, f, tmp, public;

start transaction;

set constraints all deferred;

drop table if exists Mapillary_Feature;

create table Mapillary_Feature as
with Feature as (
    select
        id::bigint,
        first_seen_at::timestamp,
        last_seen_at::timestamp ,
        object_type::varchar,
        object_value::varchar,
        replace(aligned_direction, ',', '.')::numeric as aligned_direction,
        TransformerEnL93(FabriquerPointWGS84(replace(x, ',', '.')::numeric, replace(y, ',', '.')::numeric)) as Geom
    from source_mapillary
)
select distinct f.*
from Feature f
where exists (select true from TronconReel t where ST_DWithin(t.Geom, f.Geom, 25)); -- ne conserve que les "features" à moins de 25m d'un tronçon

commit;