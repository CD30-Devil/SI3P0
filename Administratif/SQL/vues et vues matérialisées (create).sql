-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;

create materialized view Occitanie as select * from Region where COGRegion = '76';
create materialized view Gard as select * from Departement where COGDepartement = '30';
create materialized view GardEtLimitrophes as select * from Departement where COGDepartement in ('07', '12', '13', '26', '30', '34', '48', '84');