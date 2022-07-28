select '***************************************************************************************************';
select 'Métriques 3V';
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
select 'Remarque : les segments ouverts doivent en mojorité être présents dans la BDTOPO.';
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

select 'Liste des couples de segments (IdGeometrie_1 | Fictif_1 | Statut_1 | EtatAvancement_1 | IdGeometrie_2 | Fictif_2 | Statut_2 | EtatAvancement_2) différents mais géographiquement égaux :';
select
    sc1.IdGeometrie as "IdGeometrie_1",
    sc1.Fictif as "Fictif_1",
    st1.Description as "Statut_1",
    ea1.Description as "EtatAvancement_1",
    sc2.IdGeometrie as "IdGeometrie_2",
    sc2.Fictif as "Fictif_2",
    st2.Description as "Statut_2",
    ea2.Description as "EtatAvancement_2"
from m.SegmentCyclable sc1
inner join m.Statut3V st1 on st1.CodeStatut3V = sc1.CodeStatut3V
inner join m.EtatAvancement3V ea1 on ea1.CodeEtatAvancement3V = sc1.CodeEtatAvancement3V
inner join m.SegmentCyclable sc2 on ST_Equals(sc1.Geom, sc2.Geom)
inner join m.Statut3V st2 on st2.CodeStatut3V = sc2.CodeStatut3V
inner join m.EtatAvancement3V ea2 on ea2.CodeEtatAvancement3V = sc2.CodeEtatAvancement3V
where sc1.IdSegmentCyclable > sc2.IdSegmentCyclable;
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

select 'Liste des segments cyclables (IdSegmentCyclable | IdGeometrie | CodeInsee) dont le propriétaire défini ne correspond pas à la BDTOPO :';
with CodeInseeSegmentViaProprio as (
    select sc.IdSegmentCyclable, sc.IdGeometrie, se.codeinsee
    from m.SegmentCyclable sc
    inner join m.SegmentCyclable_Proprietaire scp on sc.IdSegmentCyclable = scp.IdSegmentCyclable
    inner join d.sirene_etablissement se on scp.Siren = se.siren
    where sc.SourceGeometrie = 'bdtopo.troncon_de_route'
    and se.siege
    and scp.Siren <> '223000019' -- Département du Gard
    and scp.Siren <> '223400011' -- Département de l'Hérault
    and scp.Siren <> '130017791' -- Voies Navigables de France
    and scp.Siren <> '550200661' -- BRL
    and scp.Siren <> '957520901' -- Compagnie Nationale du Rhône
),
CodeInseeSegmentViaTroncon as (
    select sc.IdSegmentCyclable, sc.IdGeometrie, tr.insee_commune_gauche
    from m.SegmentCyclable sc
    inner join d.bdtopo_troncon_de_route tr on sc.IdGeometrie = tr.cleabs
    union
    select sc.IdSegmentCyclable, sc.IdGeometrie, tr.insee_commune_droite
    from m.SegmentCyclable sc
    inner join d.bdtopo_troncon_de_route tr on sc.IdGeometrie = tr.cleabs
)
select *
from CodeInseeSegmentViaProprio
except
select *
from CodeInseeSegmentViaTroncon
order by CodeInsee;
select 'Remarque : vérifier que le propriétaire de ces segments est correct.';
select '';

select 'Liste des segments (IdSegmentCyclable | IdGeometrie | Description) présentant une incohérence de sens de circulation avec la BDTOPO :';
select
    sc.IdSegmentCyclable,
    sc.IdGeometrie,
    case
        when (sc.SensUnique and t.sens_de_circulation = 'Double sens') then 'Segment : sens unique - Tronçon : double sens'
        when (not sc.SensUnique and t.sens_de_circulation in ('Sens direct', 'Sens inverse'))  then 'Segment : double sens - Tronçon : sens unique'
        when (sc.SensUnique and t.sens_de_circulation = 'Sens direct' and not ST_OrderingEquals(sc.Geom, t.Geometrie)) then 'Incohérence de sens de circulation (direct)'
        when (sc.SensUnique and t.sens_de_circulation = 'Sens inverse' and not ST_OrderingEquals(sc.Geom, ST_Reverse(t.Geometrie))) then 'Incohérence de sens de circulation (indirect)'
    end as Description
from m.SegmentCyclable sc
inner join d.bdtopo_troncon_de_route t on sc.SourceGeometrie = 'bdtopo.troncon_de_route' and sc.IdGeometrie = t.cleabs
where (sc.SensUnique and t.sens_de_circulation = 'Double sens')
or (not sc.SensUnique and t.sens_de_circulation in ('Sens direct', 'Sens inverse'))
or (sc.SensUnique and t.sens_de_circulation = 'Sens direct' and not ST_OrderingEquals(sc.Geom, t.Geometrie))
or (sc.SensUnique and t.sens_de_circulation = 'Sens inverse' and not ST_OrderingEquals(sc.Geom, ST_Reverse(t.Geometrie)))
order by Description, sc.IdGeometrie;
select 'Remarque : vérifier cette liste pour être sûr que les cyclistes ne sont pas invités à prendre des sens interdits.';
select '';

-- TODO voir s'il est utile d'activer cette requête de vérification qui recherche les couples de segments d'une même portion qui ont un même début ou une même fin
-- select sc1.IdSegmentCyclable, sc2.IdSegmentCyclable, pc1.Nom
-- from m.SegmentCyclable sc1, m.SegmentCyclable sc2, m.SegmentCyclable_PortionCyclable sp1, m.SegmentCyclable_PortionCyclable sp2, m.PortionCyclable pc1
-- where sc1.IdSegmentCyclable > sc2.IdSegmentCyclable
-- and sc1.IdSegmentCyclable = sp1.IdSegmentCyclable
-- and sp1.IdPortionCyclable = pc1.IdPortionCyclable
-- and sc2.IdSegmentCyclable = sp2.IdSegmentCyclable
-- and sp1.IdPortionCyclable = sp2.IdPortionCyclable
-- and (ST_Equals(ST_StartPoint(sc1.Geom), ST_StartPoint(sc2.Geom)) or ST_Equals(ST_EndPoint(sc1.Geom), ST_EndPoint(sc2.Geom)))
-- order by pc1.Nom