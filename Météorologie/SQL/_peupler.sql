-- schémas spécifiques SI3P0 (m = modèle, tmp = temporaire)
set search_path to m, tmp, public;

start transaction;

set constraints all deferred;

delete from ReleveMeteo;
delete from StationMeteo;

-- insertion des stations météo
insert into StationMeteo (Source, IdSource, Nom, Geom)
select
	'https://www.infoclimat.fr',
	s.id,
	s.name,
	s.geom
from tmp.source_stationmeteo s
inner join m.Gard g on ST_DWithin(g.Geom, s.Geom, 10000)
where to_date(s.last_activity, 'YYYY-MM-DD') > now() - '7 days'::interval;

commit;