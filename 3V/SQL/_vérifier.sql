-- schémas spécifiques SI3P0 (m = modèle, d = données)
set search_path to m, d, public;

select '***************************************************************************************************';
select 'Métriques';
select '***************************************************************************************************';
select '';

select 'Nombre d''itinéraires : ' || count(*)
from ItineraireCyclable;

select 'Nombre de portions : ' || count(*)
from PortionCyclable;

select 'Nombre de segments : ' || count(*)
from SegmentCyclable;

select '';

select 'Nombre de segments par source : ';
select SourceGeometrie, count(*)
from SegmentCyclable
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
from ItineraireCyclable
where NumeroItineraireCyclable not in (
    select NumeroItineraireCyclable from PortionCyclable_ItineraireCyclable
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
from PortionCyclable
where IdPortionCyclable not in (
    select IdPortionCyclable from SegmentCyclable_PortionCyclable
);
select 'Remarque : cette liste devrait être vide.';
select '';

select 'Liste des portions (Nom | Nombre de morceaux) présentant des discontinuités :';
select pc.Nom, array_length((st_ClusterWithin(sc.Geom, 1)), 1) as NbClusters
from SegmentCyclable sc
left join SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
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
from SegmentCyclable
where CodeEtatAvancement3V = 4
and SourceGeometrie <> 'bdtopo.troncon_de_route'
order by SourceGeometrie, IdGeometrie;
select 'Remarque : les segments ouverts doivent en mojorité être présents dans la BDTOPO.';
select '';

select 'Liste des segments (IdSegmentCyclable | SourceGeometrie | IdGeometrie) non rattachés à une portion :';
select IdSegmentCyclable, SourceGeometrie, IdGeometrie
from SegmentCyclable
where IdSegmentCyclable not in (
    select IdSegmentCyclable from SegmentCyclable_PortionCyclable
);
select 'Remarque : cette liste devrait être vide.';
select '';

select 'Liste des segments (IdSegmentCyclable | SourceGeometrie | IdGeometrie) ayant une géographie nulle :';
select IdSegmentCyclable, SourceGeometrie, IdGeometrie
from SegmentCyclable
where Geom is null;
select 'Remarque : cette liste devrait être vide.';
select '';

select 'Liste des segments (IdSegmentCyclable | SourceGeometrie | IdGeometrie) non-ouverts mais avec une date d''ouverture non nulle :';
select IdSegmentCyclable, SourceGeometrie, IdGeometrie
from SegmentCyclable
where CodeEtatAvancement3V < 4 and AnneeOuverture is not null
and SourceGeometrie <> 'bdtopo.troncon_de_route'
order by SourceGeometrie, IdGeometrie;
select 'Remarque : cette liste devrait être vide.';
select '';

select 'Liste des segments (IdSegmentCyclable | SourceGeometrie | IdGeometrie) ouverts et fictifs :';
select IdSegmentCyclable, SourceGeometrie, IdGeometrie
from SegmentCyclable
where CodeEtatAvancement3V = 4 and Fictif;
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
from SegmentCyclable sc1
inner join Statut3V st1 on st1.CodeStatut3V = sc1.CodeStatut3V
inner join EtatAvancement3V ea1 on ea1.CodeEtatAvancement3V = sc1.CodeEtatAvancement3V
inner join SegmentCyclable sc2 on ST_Equals(sc1.Geom, sc2.Geom)
inner join Statut3V st2 on st2.CodeStatut3V = sc2.CodeStatut3V
inner join EtatAvancement3V ea2 on ea2.CodeEtatAvancement3V = sc2.CodeEtatAvancement3V
where sc1.IdSegmentCyclable > sc2.IdSegmentCyclable;
select 'Remarque : vérifier attentivement que ces différences sont souhaitées.';
select '';

select 'Liste des segments cyclables (IdSegmentCyclable | IdGeometrie) RTE et non fictifs dont le Gard est (co-)propriétaire mais qui ne sont pas dans le référentiel routier :';
select sc.IdSegmentCyclable, sc.IdGeometrie
from SegmentCyclable sc
where not sc.Fictif
and sc.CodeStatut3V = 'RTE'
and exists (select * from SegmentCyclable_Proprietaire sp where sp.IdSegmentCyclable = sc.IdSegmentCyclable and sp.Siren = '223000019' limit 1)
and not exists (select * from Troncon where IdIGN = sc.IdGeometrie limit 1);
select 'Remarque : cette liste devrait être vide.';
select '';

select 'Liste des segments cyclables (IdSegmentCyclable | IdGeometrie) RTE et non fictifs dont le Gard n''est pas (co-)propriétaire mais qui sont dans le référentiel routier :';
select sc.IdSegmentCyclable, sc.IdGeometrie
from SegmentCyclable sc
where not sc.Fictif
and sc.CodeStatut3V = 'RTE'
and not exists (select * from SegmentCyclable_Proprietaire sp where sp.IdSegmentCyclable = sc.IdSegmentCyclable and sp.Siren = '223000019' limit 1)
and exists (select * from Troncon where IdIGN = sc.IdGeometrie and SirenProprietaire = '223000019' limit 1);
select 'Remarque : cette liste devrait être vide.';
select '';

select 'Liste des segments cyclables (IdSegmentCyclable | IdGeometrie | CodeInsee) dont le propriétaire défini ne correspond pas à la BDTOPO :';
with CodeInseeSegmentViaProprio as (
    select sc.IdSegmentCyclable, sc.IdGeometrie, es.COGCommune
    from SegmentCyclable sc
    inner join SegmentCyclable_Proprietaire scp on sc.IdSegmentCyclable = scp.IdSegmentCyclable
    inner join EtablissementSirene es on scp.Siren = es.siren
    where sc.SourceGeometrie = 'bdtopo.troncon_de_route'
    and es.siege
    and scp.Siren <> '223000019' -- Département du Gard
    and scp.Siren <> '223400011' -- Département de l'Hérault
    and scp.Siren <> '221300015' -- Département des Bouches-du-Rhône
    and scp.Siren <> '130017791' -- Voies Navigables de France
    and scp.Siren <> '550200661' -- BRL
    and scp.Siren <> '957520901' -- Compagnie Nationale du Rhône
),
CodeInseeSegmentViaTroncon as (
    select sc.IdSegmentCyclable, sc.IdGeometrie, tr.insee_commune_gauche
    from SegmentCyclable sc
    inner join bdtopo_troncon_de_route tr on sc.IdGeometrie = tr.cleabs
    union
    select sc.IdSegmentCyclable, sc.IdGeometrie, tr.insee_commune_droite
    from SegmentCyclable sc
    inner join bdtopo_troncon_de_route tr on sc.IdGeometrie = tr.cleabs
)
select *
from CodeInseeSegmentViaProprio
except
select *
from CodeInseeSegmentViaTroncon
order by COGCommune;
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
from SegmentCyclable sc
inner join bdtopo_troncon_de_route t on sc.SourceGeometrie = 'bdtopo.troncon_de_route' and sc.IdGeometrie = t.cleabs
where (sc.SensUnique and t.sens_de_circulation = 'Double sens')
or (not sc.SensUnique and t.sens_de_circulation in ('Sens direct', 'Sens inverse'))
or (sc.SensUnique and t.sens_de_circulation = 'Sens direct' and not ST_OrderingEquals(sc.Geom, t.Geometrie))
or (sc.SensUnique and t.sens_de_circulation = 'Sens inverse' and not ST_OrderingEquals(sc.Geom, ST_Reverse(t.Geometrie)))
order by Description, sc.IdGeometrie;
select 'Remarque : vérifier cette liste pour être sûr que les cyclistes ne sont pas invités à prendre des sens interdits.';
select '';

select 'Comparaison des natures de segments/tronçons (IdGeometrie | Statut | Revêtement | nature | nature_de_la_restriction | bande_cyclable) :';
select
    sc.IdGeometrie,
    pc.Nom,
    s3v.Description,
    r3v.Description,
    tr.nature,
    tr.nature_de_la_restriction,
    tr.amenagement_cyclable_gauche,
    tr.amenagement_cyclable_droit
from SegmentCyclable sc
inner join Statut3V s3v on s3v.CodeStatut3V = sc.CodeStatut3V
inner join Revetement3V r3v on r3v.CodeRevetement3V = sc.CodeRevetement3V
inner join SegmentCyclable_PortionCyclable sp ON sp.IdSegmentCyclable = sc.IdSegmentCyclable
inner join PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
inner join bdtopo_troncon_de_route tr on sc.IdGeometrie = tr.cleabs
and sc.CodeEtatAvancement3v = 4
and (
    (
        s3v.Description not in ('Voie verte', 'Piste cyclable', 'Bande cyclable', 'Route')
    )
    or
    (
        s3v.Description = 'Voie verte' and
        tr.nature_de_la_restriction <> 'Voie verte'
    )
    or
    (
        s3v.Description = 'Piste cyclable' and
        tr.nature_de_la_restriction <> 'Piste cyclable'
    )
    or
    (
        s3v.Description = 'Bande cyclable' and
        tr.amenagement_cyclable_gauche <> 'Bande cyclable' and
        tr.amenagement_cyclable_droit <> 'Bande cyclable'
    )
    or
    (
        s3v.Description = 'Route' and
        r3v.Description in ('Rugueux', 'Meuble') and
        tr.nature not in ('Route empierrée', 'Chemin', 'Sentier')
    )
    or
    (
        s3v.Description = 'Route' and
        r3v.Description = 'Lisse' and
        tr.nature not in ('Route à 2 chaussées', 'Route à 1 chaussée', 'Rond-point')
    )
)
order by 2, 3, 4, 1;