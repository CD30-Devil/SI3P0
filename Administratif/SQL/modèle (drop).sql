-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;

drop table if exists Commune_Canton;
drop table if exists Canton;
drop table if exists Commune;
drop table if exists EPCIFederative;
drop table if exists Departement;
drop table if exists Region;