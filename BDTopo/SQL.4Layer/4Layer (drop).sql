-- schémas spécifiques SI3P0 (tmp = temporaire)
set search_path to tmp, public;

drop view if exists Autoroute_4Layer;
drop view if exists D30Autoroute_4Layer;
drop view if exists RN_4Layer;
drop view if exists D30RN_4Layer;
drop view if exists D30VoieFerreeAgregee_4Layer;