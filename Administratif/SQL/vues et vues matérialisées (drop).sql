-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;

drop materialized view if exists Occitanie;
drop materialized view if exists Gard;
drop materialized view if exists GardEtLimitrophes;