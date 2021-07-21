-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;

drop table if exists RalentissementWaze;
drop table if exists AlerteWaze;
drop table if exists HistoAlerteWaze;
drop table if exists TypeAlerteWaze;