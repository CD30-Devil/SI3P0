-- schémas spécifiques SI3P0 (d = données)

-- carroyage filosifi 1000m du Gard
begin;

set search_path to d, public;

create table d30_insee_filosofi_carroyage_1000m as
select i.*
from insee_filosofi_carroyage_1000m i
inner join bdtopo_departement g on g.code_insee = '30' and ST_Intersects(i.geom, g.geometrie);

commit;

-- carroyage filosifi 200m
begin;

set search_path to d, public;

create table d30_insee_filosofi_carroyage_200m as
select i.*
from insee_filosofi_carroyage_200m i
inner join bdtopo_departement g on g.code_insee = '30' and ST_Intersects(i.geom, g.geometrie);

commit;