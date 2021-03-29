select '***************************************************************************************************';
select 'Métriques';
select '***************************************************************************************************';
select '';

select 'Nombre d''itinéraires : ' || count(*)
from m.ItineraireCyclable;

select 'Nombre de portions : ' || count(*)
from m.PortionCyclable;

select 'Nombre de segments : ' || count(*)
from m.SegmentCyclable;

select '';

select 'Nombre de segments par source : ';
select SourceGeometrie, count(*)
from m.SegmentCyclable
group by SourceGeometrie
order by SourceGeometrie;
select '';

select '';
select '***************************************************************************************************';
select 'Vérification des itinéraires';
select '***************************************************************************************************';
select '';

select 'Liste des itinéraires (NumeroItineraireCyclable | NomOfficiel | NomUsage) sans portion :';
select NumeroItineraireCyclable, NomOfficiel, NomUsage
from m.ItineraireCyclable
where NumeroItineraireCyclable not in (
    select NumeroItineraireCyclable from m.PortionCyclable_ItineraireCyclable
);
select 'Remarque : cette liste devrait être vide.';
select '';

select '';
select '***************************************************************************************************';
select 'Vérification des portions';
select '***************************************************************************************************';
select '';

select 'Liste des portions (IdPortionCyclable | Nom) sans segment :';
select IdPortionCyclable, Nom
from m.PortionCyclable
where IdPortionCyclable not in (
    select IdPortionCyclable from m.SegmentCyclable_PortionCyclable
);
select 'Remarque : cette liste devrait être vide.';
select '';

select 'Liste des portions (Nom | Nombre de morceaux) présentant des discontinuités :';
select pc.Nom, array_length((st_ClusterWithin(sc.Geom, 1)), 1) as NbClusters
from m.SegmentCyclable sc
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
group by pc.Nom
having array_length((st_ClusterWithin(sc.Geom, 1)), 1) > 1;
select 'Remarque : cette liste devrait être vide.';
select '';

select 'Liste des portions (IdPortionCyclable | Nom | Description) ayant de multiples états d''avancement :';
select distinct pc.IdPortionCyclable, pc.Nom, pc.Description
from m.PortionCyclable pc
inner join m.SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
group by pc.IdPortionCyclable, pc.Nom, pc.Description
having count (distinct sc.CodeEtatAvancement3V) > 1;
select 'Remarque : vérifier manuellement la cohérence de cette liste.';
select '';

select '';
select '***************************************************************************************************';
select 'Vérification des segments';
select '***************************************************************************************************';
select '';

select 'Liste des segments (IdSegmentCyclable | SourceGeometrie | IdGeometrie) ouverts mais dont la géographie n''est pas issue des tronçons de route de la BDTOPO :';
select IdSegmentCyclable, SourceGeometrie, IdGeometrie
from
m.SegmentCyclable
where CodeEtatAvancement3V = 4
and SourceGeometrie <> 'bdtopo.troncon_de_route'
order by SourceGeometrie, IdGeometrie;
select 'Remarque : cette liste est à notifier à l''IGN pour correction de la BDTOPO.';
select '';

select 'Liste des segments (IdSegmentCyclable | SourceGeometrie | IdGeometrie) non rattachés à une portion :';
select IdSegmentCyclable, SourceGeometrie, IdGeometrie
from m.SegmentCyclable
where IdSegmentCyclable not in (
    select IdSegmentCyclable from m.SegmentCyclable_PortionCyclable
);
select 'Remarque : cette liste devrait être vide.';
select '';

select 'Liste des segments (IdSegmentCyclable | SourceGeometrie | IdGeometrie) ayant une géographie nulle :';
select IdSegmentCyclable, SourceGeometrie, IdGeometrie
from m.SegmentCyclable
where Geom is null;
select 'Remarque : cette liste devrait être vide.';
select '';

select 'Liste des segments (IdSegmentCyclable | SourceGeometrie | IdGeometrie) non-ouverts mais avec une date d''ouverture non nulle :';
select IdSegmentCyclable, SourceGeometrie, IdGeometrie
from
m.SegmentCyclable
where CodeEtatAvancement3V < 4 and AnneeOuverture is not null
and SourceGeometrie <> 'bdtopo.troncon_de_route'
order by SourceGeometrie, IdGeometrie;
select 'Remarque : cette liste devrait être vide.';
select '';

select 'Liste des segments (IdSegmentCyclable 1 | SourceGeometrie 1 | IdGeometrie 1 | CodeEtatAvancement3V 1 | CodeRevetement3V 1 | Fictif 1 | IdSegmentCyclable 2 | SourceGeometrie 2 | IdGeometrie 2 | CodeEtatAvancement3V 2 | CodeRevetement3V 2 | Fictif 2) différents mais géographiquement égaux :';
select sc1.IdSegmentCyclable, sc1.SourceGeometrie, sc1.IdGeometrie, sc1.CodeEtatAvancement3V, sc1.CodeRevetement3V, sc1.Fictif, sc2.IdSegmentCyclable, sc2.SourceGeometrie, sc2.IdGeometrie, sc2.CodeEtatAvancement3V, sc2.CodeRevetement3V, sc2.Fictif
from m.SegmentCyclable sc1, m.SegmentCyclable sc2
where sc1.IdSegmentCyclable > sc2.IdSegmentCyclable
and ST_Equals(sc1.Geom, sc2.Geom);
select 'Remarque : vérifier attentivement que ces différences sont souhaitées.';
select '';

select 'Liste des segments cyclables (IdSegmentCyclable | IdGeometrie) RTE et non fictifs dont le Gard est (co-)propriétaire mais qui ne sont pas dans le référentiel routier :';
select sc.IdSegmentCyclable, sc.IdGeometrie
from m.SegmentCyclable sc
where not sc.Fictif
and sc.CodeStatut3V = 'RTE'
and exists (select * from m.SegmentCyclable_Proprietaire sp where sp.IdSegmentCyclable = sc.IdSegmentCyclable and sp.Siren = '223000019' limit 1)
and not exists (select * from m.Troncon where IdIGN = sc.IdGeometrie limit 1);
select 'Remarque : cette liste devrait être vide.';
select '';

select 'Liste des segments cyclables (IdSegmentCyclable | IdGeometrie) RTE et non fictifs dont le Gard n''est pas (co-)propriétaire mais qui sont dans le référentiel routier :';
select sc.IdSegmentCyclable, sc.IdGeometrie
from SegmentCyclable sc
where not sc.Fictif
and sc.CodeStatut3V = 'RTE'
and not exists (select * from SegmentCyclable_Proprietaire sp where sp.IdSegmentCyclable = sc.IdSegmentCyclable and sp.Siren = '223000019' limit 1)
and exists (select * from m.Troncon where IdIGN = sc.IdGeometrie limit 1);
select 'Remarque : cette liste devrait être vide.';
select '';

select 'Liste des segments (IdSegmentCyclable | IdGeometrie | SensUnique | sens_de_circulation) présentant une incohérence de sens de circulation avec la BDTOPO :';
select sc.IdSegmentCyclable, sc.IdGeometrie, sc.SensUnique, t.sens_de_circulation
from m.SegmentCyclable sc
inner join d.bdtopo_troncon_de_route t on sc.SourceGeometrie = 'bdtopo.troncon_de_route' and sc.IdGeometrie = t.cleabs
where (sc.SensUnique and t.sens_de_circulation = 'Double sens')
or (not(sc.SensUnique) and t.sens_de_circulation in ('Sens direct', 'Sens inverse'))
order by t.sens_de_circulation, sc.IdGeometrie;
select 'Remarque : cette liste devrait être vide.';
select '';