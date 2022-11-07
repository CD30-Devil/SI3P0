-- schémas spécifiques SI3P0 (d = données)
set search_path to d, public;

create index if not exists bdtopo_departement_code_insee on bdtopo_departement (code_insee);
create index if not exists bdtopo_departement_geometrie on bdtopo_departement using gist (geometrie);

create unique index if not exists bdtopo_troncon_de_route_cleabs on bdtopo_troncon_de_route (cleabs);
create index if not exists bdtopo_troncon_de_route_nature on bdtopo_troncon_de_route (nature);
create index if not exists bdtopo_troncon_de_route_cpx_numero on bdtopo_troncon_de_route (cpx_numero);
create index if not exists bdtopo_troncon_de_route_cpx_cl_admin on bdtopo_troncon_de_route (cpx_classement_administratif);
create index if not exists bdtopo_troncon_de_route_geometrie on bdtopo_troncon_de_route using gist (geometrie);

create index if not exists bdtopo_troncon_de_voie_ferree_cleabs on bdtopo_troncon_de_voie_ferree (cleabs);