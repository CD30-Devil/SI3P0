-- schémas spécifiques SI3P0 (d = données)
set search_path to d, public;

drop table if exists d30_bdtopo_batiment;
drop table if exists d30_bdtopo_cours_d_eau;
drop table if exists d30_bdtopo_plan_d_eau;
drop table if exists d30_bdtopo_surface_hydrographique;
drop table if exists d30_bdtopo_troncon_hydrographique;
drop table if exists d30_bdtopo_troncon_de_route;
drop table if exists d30_bdtopo_troncon_de_voie_ferree;
drop table if exists d30_bdtopo_troncon_d_autoroute;
drop table if exists d30_bdtopo_troncon_de_nationale;

drop table if exists d30limit_bdtopo_troncon_de_route;

drop table if exists bdtopo_troncon_d_autoroute;
drop table if exists bdtopo_troncon_de_nationale;