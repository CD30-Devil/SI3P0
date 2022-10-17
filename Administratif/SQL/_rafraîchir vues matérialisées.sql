-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;

refresh materialized view Occitanie;
refresh materialized view Gard;
refresh materialized view GardEtLimitrophes;