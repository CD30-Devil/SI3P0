-- schémas spécifiques SI3P0 (d = données, tmp = temporaire, f = fonctions)
set search_path to d, tmp, f, public;

start transaction;

set constraints all deferred;

-- nettoyage préalable
drop table if exists d30_osm_route_departementale;

-- création de la table OSM des routes départementales
create table d30_osm_route_departementale as
select
    e ->> 'id' as id,
    e -> 'tags' ->> 'highway' as highway,
    upper(regexp_replace(e -> 'tags' ->> 'ref', '\s+' , '', 'g')) as ref,
    TransformerEnL93(
        ST_MakeLine(
            FabriquerPointWGS84((g.value->> 'lon')::numeric, (g.value ->> 'lat')::numeric)
            order by g.ordinality
        )
    ) as geom
from source_osm_route_departementale rd
cross join jsonb_array_elements((rd.json -> 'elements')) e
cross join jsonb_array_elements((e -> 'geometry')) with ordinality g
group by id, highway, ref;

commit;