-- NDLR : schémas spécifiques SI3P0 (m = modèle)
-- TODO : adapter le search_path en fonction de la structure de la BDD cible
set search_path to m, public;

drop view if exists TronconReel;