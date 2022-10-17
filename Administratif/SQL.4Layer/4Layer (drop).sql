-- schémas spécifiques SI3P0 (tmp = temporaire)
set search_path to tmp, public;

drop view if exists Region_4SHP;
drop view if exists Region_4Layer;

drop view if exists Departement_4SHP;
drop view if exists Departement_4Layer;

drop view if exists EPCI_4SHP;
drop view if exists EPCI_4Layer;

drop view if exists Commune_4SHP;
drop view if exists Commune_4Layer;

drop view if exists Canton_4SHP;
drop view if exists Canton_4Layer;