-- schémas spécifiques SI3P0 (tmp = temporaire)
set search_path to tmp, public;

drop materialized view if exists D30_OpenData_3V_4Part;

drop view if exists D30_OpenData_Troncon_4Part;
drop view if exists D30_OpenData_PR_4Part;
drop view if exists D30_OpenData_Giratoire_4Part;
drop view if exists D30_OpenData_RDAgregeeParNiveau_4Part;
drop view if exists D30_OpenData_ComparatifRefRoutierOSM_4Part;