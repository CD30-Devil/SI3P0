-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;

drop table if exists ReleveHydro;
drop table if exists StationHydro;
drop table if exists TronconHydro;
drop table if exists VigilanceHydro;