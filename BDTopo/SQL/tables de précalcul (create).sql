-- schémas spécifiques SI3P0 (d = données)

-- bâtiments du département du Gard
begin;

set search_path to d, public;

create table d30_bdtopo_batiment as
select
    bd.*
from bdtopo_batiment bd
inner join bdtopo_departement g on g.code_insee = '30' and ST_Intersects(bd.geometrie, g.geometrie);

commit;

-- cours d'eau du département du Gard
begin;

set search_path to d, public;

create table d30_bdtopo_cours_d_eau as
select
    bd.*
from bdtopo_cours_d_eau bd
inner join bdtopo_departement g on g.code_insee = '30' and ST_Intersects(bd.geometrie, g.geometrie);

commit;

-- plans d'eau du département du Gard
begin;

set search_path to d, public;

create table d30_bdtopo_plan_d_eau as
select
    bd.*,
    case
        when ST_CoveredBy(bd.geometrie, g.geometrie) then ST_Multi(ST_Force2D(bd.geometrie))
        else ST_CollectionExtract(ST_Intersection(ST_Force2D(bd.geometrie), g.geometrie), 3)
    end as GeoIntersect
from bdtopo_plan_d_eau bd
inner join bdtopo_departement g on g.code_insee = '30' and ST_Intersects(bd.geometrie, g.geometrie);

commit;

-- surfaces hydrographiques du département du Gard
begin;

set search_path to d, public;

create table d30_bdtopo_surface_hydrographique as
select
    bd.*,
    case
        when ST_CoveredBy(bd.geometrie, g.geometrie) then ST_Multi(ST_Force2D(bd.geometrie))
        else ST_CollectionExtract(ST_Intersection(ST_Force2D(bd.geometrie), g.geometrie), 3)
    end as GeoIntersect
from bdtopo_surface_hydrographique bd
inner join bdtopo_departement g on g.code_insee = '30' and ST_Intersects(bd.geometrie, g.geometrie);

commit;

-- tronçons hydrographiques du département du Gard
begin;

set search_path to d, public;

create table d30_bdtopo_troncon_hydrographique as
select
    bd.*
from bdtopo_troncon_hydrographique bd
inner join bdtopo_departement g on g.code_insee = '30' and ST_Intersects(bd.geometrie, g.geometrie);

commit;

-- tronçons de route du département du Gard
begin;

set search_path to d, public;

create table d30_bdtopo_troncon_de_route as
select
    bd.*
from bdtopo_troncon_de_route bd
inner join bdtopo_departement g on g.code_insee = '30' and ST_Intersects(bd.geometrie, g.geometrie);

commit;

-- tronçons de voie ferrée du département du Gard
begin;

set search_path to d, public;

create table d30_bdtopo_troncon_de_voie_ferree as
select
    bd.*
from bdtopo_troncon_de_voie_ferree bd
inner join bdtopo_departement g on g.code_insee = '30' and ST_Intersects(bd.geometrie, g.geometrie);

commit;

-- autoroutes du département du Gard
begin;

set search_path to d, public;

create table d30_bdtopo_troncon_d_autoroute as
select
    bd.*
from bdtopo_troncon_de_route bd
inner join bdtopo_departement g on g.code_insee = '30' and ST_Intersects(bd.geometrie, g.geometrie)
where bd.cpx_classement_administratif ilike '%autoroute%';

commit;

-- nationales du département du Gard
begin;

set search_path to d, public;

create table d30_bdtopo_troncon_de_nationale as
select
    bd.*
from bdtopo_troncon_de_route bd
inner join bdtopo_departement g on g.code_insee = '30' and ST_Intersects(bd.geometrie, g.geometrie)
where bd.cpx_classement_administratif ilike '%nationale%';

commit;

-- tronçons de route du département du Gard et limitrophes
begin;

set search_path to d, public;

create table d30limit_bdtopo_troncon_de_route as
with UnionGardEtLimitrophes as (
    select ST_Union(geometrie) as geometrie
    from bdtopo_departement
    where code_insee in ('07', '12', '13', '26', '30', '34', '48', '84')
)
select
    bd.*
from bdtopo_troncon_de_route bd
inner join UnionGardEtLimitrophes u on ST_Intersects(bd.geometrie, u.geometrie);

commit;

-- autoroutes de France
begin;

set search_path to d, public;

create table bdtopo_troncon_d_autoroute as
select *
from bdtopo_troncon_de_route
where cpx_classement_administratif ilike '%autoroute%';

commit;

-- nationales de France
begin;

set search_path to d, public;

create table bdtopo_troncon_de_nationale as
select *
from bdtopo_troncon_de_route
where cpx_classement_administratif ilike '%nationale%';

commit;