-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;

drop table if exists ParcelleCadastrale_UniteLegale;
drop table if exists DroitCadastral;
drop table if exists ParcelleCadastrale;
drop table if exists SectionCadastrale;
drop table if exists LieuDit;