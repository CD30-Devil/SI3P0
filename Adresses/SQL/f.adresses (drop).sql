-- schémas spécifiques SI3P0 (f = fonctions)
set search_path to f, public;

drop function if exists RechercherAdresse(_Point geometry, _COGCommune character varying, _Limit integer);
drop function if exists RechercherAdresse(_Adresse character varying, _COGCommune character varying, _SeuilPertinence integer, _Limit integer);
drop function if exists RechercherAdresse(_Numero integer, _Repetition character varying, _NomVoie character varying, _COGCommune character varying, _SeuilPertinence integer, _Limit integer);