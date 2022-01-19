-- cours d'eau du département du Gard
begin;

drop table if exists pc.d30_bdtopo_cours_d_eau;

create table pc.d30_bdtopo_cours_d_eau as
select
    bd.*
from d.bdtopo_cours_d_eau bd
inner join v.Gard g on ST_Intersects(bd.Geometrie, g.Geom);

commit;

-- plans d'eau du département du Gard
begin;

drop table if exists pc.d30_bdtopo_plan_d_eau;

create table pc.d30_bdtopo_plan_d_eau as
select
    bd.*,
    case
        when ST_CoveredBy(bd.geometrie, g.Geom) then ST_Multi(ST_Force2D(bd.geometrie))
        else ST_CollectionExtract(ST_Intersection(ST_Force2D(bd.geometrie), g.Geom), 3)
    end as GeoIntersect
from d.bdtopo_plan_d_eau bd
inner join v.Gard g on ST_Intersects(bd.Geometrie, g.Geom);

commit;

-- surfaces hydrographiques du département du Gard
begin;

drop table if exists pc.d30_bdtopo_surface_hydrographique;

create table pc.d30_bdtopo_surface_hydrographique as
select
    bd.*,
    case
        when ST_CoveredBy(bd.geometrie, g.Geom) then ST_Multi(ST_Force2D(bd.geometrie))
        else ST_CollectionExtract(ST_Intersection(ST_Force2D(bd.geometrie), g.Geom), 3)
    end as GeoIntersect
from d.bdtopo_surface_hydrographique bd
inner join v.Gard g on ST_Intersects(bd.Geometrie, g.Geom);

commit;

-- bâtiments du département du Gard
begin;

drop table if exists pc.d30_bdtopo_batiment;

create table pc.d30_bdtopo_batiment as
select
    bd.*
from d.bdtopo_batiment bd
inner join v.Gard g on ST_Intersects(bd.Geometrie, g.Geom);

commit;

-- tronçons de route du département du Gard
begin;

drop table if exists pc.d30_bdtopo_troncon_de_route;

create table pc.d30_bdtopo_troncon_de_route as
select
    bd.*
from d.bdtopo_troncon_de_route bd
inner join v.Gard g on ST_Intersects(bd.Geometrie, g.Geom);

commit;

-- tronçons de route du département du Gard et limitrophes
begin;

drop table if exists pc.d30limit_bdtopo_troncon_de_route;

create table pc.d30limit_bdtopo_troncon_de_route as
with UnionGardEtLimitrophes as (
    select ST_Union(Geom) as Geom
    from v.GardEtLimitrophes
)
select
    bd.*
from d.bdtopo_troncon_de_route bd
inner join UnionGardEtLimitrophes u on ST_Intersects(bd.Geometrie, u.Geom);

commit;

-- tronçons de voie ferrée du département du Gard
begin;

drop table if exists pc.d30_bdtopo_troncon_de_voie_ferree;

create table pc.d30_bdtopo_troncon_de_voie_ferree as
select
    bd.*
from d.bdtopo_troncon_de_voie_ferree bd
inner join v.Gard g on ST_Intersects(bd.Geometrie, g.Geom);

commit;

-- tronçons hydrographiques du département du Gard
begin;

drop table if exists pc.d30_bdtopo_troncon_hydrographique;

create table pc.d30_bdtopo_troncon_hydrographique as
select
    bd.*
from d.bdtopo_troncon_hydrographique bd
inner join v.Gard g on ST_Intersects(bd.Geometrie, g.Geom);

commit;

-- tronçons de nature Rond-point, Bretelle, Route à 1 chaussée, Route à 2 chaussées, Type autoroutier
begin;

drop table if exists pc.bdtopo_troncon_de_route_revetu;

create table pc.bdtopo_troncon_de_route_revetu as
select *
from d.bdtopo_troncon_de_route
where nature in ('Rond-point', 'Bretelle', 'Route à 1 chaussée', 'Route à 2 chaussées', 'Type autoroutier');

commit;

-- autoroutes de France
begin;

drop table if exists pc.bdtopo_troncon_d_autoroute;

create table pc.bdtopo_troncon_d_autoroute as
select *
from d.bdtopo_troncon_de_route
where cpx_classement_administratif ilike '%autoroute%';

commit;

-- autoroutes du département du Gard
begin;

drop table if exists pc.d30_bdtopo_troncon_d_autoroute;

create table pc.d30_bdtopo_troncon_d_autoroute as
select
    bd.*
from d.bdtopo_troncon_de_route bd
inner join v.Gard g on ST_Intersects(bd.Geometrie, g.Geom)
where bd.cpx_classement_administratif ilike '%autoroute%';

commit;

-- nationales de France
begin;

drop table if exists pc.bdtopo_troncon_de_nationale;

create table pc.bdtopo_troncon_de_nationale as
select *
from d.bdtopo_troncon_de_route
where cpx_classement_administratif ilike '%nationale%';

commit;

-- nationales du département du Gard
begin;

drop table if exists pc.d30_bdtopo_troncon_de_nationale;

create table pc.d30_bdtopo_troncon_de_nationale as
select
    bd.*
from d.bdtopo_troncon_de_route bd
inner join v.Gard g on ST_Intersects(bd.Geometrie, g.Geom)
where bd.cpx_classement_administratif ilike '%nationale%';

commit;