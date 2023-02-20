-- schémas spécifiques SI3P0 (tmp = temporaire)
set search_path to tmp, public;

drop view if exists D30_InfosItineraires;
drop view if exists D30_VoteAssemblee_3VLineaireParItineraire_4Sheet;
drop view if exists D30_3VItineraire_4Sheet;