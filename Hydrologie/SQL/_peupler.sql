-- schémas spécifiques SI3P0 (m = modèle, f = fonctions, tmp = temporaire)
set search_path to m, f, tmp, public;

start transaction;

set constraints all deferred;

delete from ReleveHydro;
delete from StationHydro;
delete from TronconHydro;

insert into TronconHydro (CodeTronconHydro, Libelle)
select CodeTroncon, Libelle
from source_tronconhydro;

insert into StationHydro (CodeStationHydro, CodeTronconHydro, Libelle, Geom)
select CodeStation, CodeTroncon, Libelle, FabriquerPointL93(X::numeric, Y::numeric)
from source_stationhydro;

commit;