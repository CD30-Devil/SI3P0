\timing

-- schémas spécifiques SI3P0 (tmp = temporaire, m = modèle, d = données)
set search_path to tmp, m, d, public;

-- véloroutes et voies vertes avec doublons lorsqu'un même segment participe à plusieurs itinéraires
create materialized view D30_3VAvecDoublons_4Layer as
select
    ic.NumeroItineraireCyclable as "NumeroItineraire",
    ic.NomOfficiel as "NomOfficielItineraire",
    ic.NomUsage as "NomUsageItineraire",
    ic.Depart as "DepartItineraire",
    ic.Arrivee as "ArriveeItineraire",
    ic.NiveauSchema as "NiveauItineraire",
    ic.SiteWeb as "URLItineraire",
    ic.AnneeOuverture as "AnneeOuvertureItineraire",
    pc.Nom as "NomPortion",
    pc.Description as "DescriptionPortion",
    tpc.Description as "TypePortion",
    ea.Description as "EtatAvancementSegment",
    r.Description as "RevetementSegment",
    s.Description as "StatutSegment",
    sc.AnneeOuverture as "AnneeOuvertureSegment",
    sc.SensUnique  as "SensUniqueSegment",
    t.position_par_rapport_au_sol as "PositionParRapportAuSolSegment",
    sc.SourceGeometrie as "SourceGeometrieSegment",
    sc.IdGeometrie as "IdGeometrieSegment",
    to_char(sc.DateSource, 'DD-MM-YYYY') as "DateSourceSegment",
    sc.Fictif as "FictifSegment",
    string_agg(distinct gest.Denomination, ', ' order by gest.Denomination) as "GestionnairesSegment",
    string_agg(distinct prop.Denomination, ', ' order by prop.Denomination) as "ProprietairesSegment",
    sc.Geom
from SegmentCyclable sc
left join EtatAvancement3V ea on ea.CodeEtatAvancement3V = sc.CodeEtatAvancement3V
left join Revetement3V r on r.CodeRevetement3V = sc.CodeRevetement3V
left join Statut3V s on s.CodeStatut3V = sc.CodeStatut3V
left join SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join TypePortionCyclable tpc on tpc.CodeTypePortionCyclable = pc.CodeTypePortionCyclable
left join PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
left join ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable
left join SegmentCyclable_Gestionnaire scg on scg.IdSegmentCyclable = sc.IdSegmentCyclable
left join UniteLegale gest on gest.Siren = scg.Siren
left join SegmentCyclable_Proprietaire scp on scp.IdSegmentCyclable = sc.IdSegmentCyclable
left join UniteLegale prop on prop.Siren = scp.Siren
left join bdtopo_troncon_de_route t on sc.SourceGeometrie = 'bdtopo.troncon_de_route' and sc.IdGeometrie = t.cleabs
group by sc.IdSegmentCyclable, ea.CodeEtatAvancement3V, r.CodeRevetement3V, s.CodeStatut3V, pc.IdPortionCyclable, ic.NumeroItineraireCyclable, tpc.CodeTypePortionCyclable, t.position_par_rapport_au_sol;

create index D30_3VAvecDoublons_4Layer_NumeroItineraire_IDX on D30_3VAvecDoublons_4Layer ("NumeroItineraire");

-- véloroutes et voies vertes sans doublons lorsqu'un même segment participe à plusieurs itinéraires
create view D30_3VSansDoublons_4Layer as
select
    ea.Description as "EtatAvancementSegment",
    r.Description as "RevetementSegment",
    s.Description as "StatutSegment",
    sc.AnneeOuverture as "AnneeOuvertureSegment",
    sc.SensUnique as "SensUniqueSegment",
    t.position_par_rapport_au_sol as "PositionParRapportAuSolSegment",
    sc.SourceGeometrie as "SourceGeometrieSegment",
    sc.IdGeometrie as "IdGeometrieSegment",
    to_char(sc.DateSource, 'DD-MM-YYYY') as "DateSourceSegment",
    sc.Fictif as "FictifSegment",
    string_agg(distinct gest.Denomination, ', ' order by gest.Denomination) as "GestionnairesSegment",
    string_agg(distinct prop.Denomination, ', ' order by prop.Denomination) as "ProprietairesSegment",
    string_agg(distinct ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel, ', ' order by ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel) as "Itineraires",
    string_agg(distinct pc.Nom, ', ' order by pc.Nom) as "Portions",
    sc.Geom
from SegmentCyclable sc
left join EtatAvancement3V ea on ea.CodeEtatAvancement3V = sc.CodeEtatAvancement3V
left join Revetement3V r on r.CodeRevetement3V = sc.CodeRevetement3V
left join Statut3V s on s.CodeStatut3V = sc.CodeStatut3V
left join SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join TypePortionCyclable tpc on tpc.CodeTypePortionCyclable = pc.CodeTypePortionCyclable
left join PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
left join ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable
left join SegmentCyclable_Gestionnaire scg on scg.IdSegmentCyclable = sc.IdSegmentCyclable
left join UniteLegale gest on gest.Siren = scg.Siren
left join SegmentCyclable_Proprietaire scp on scp.IdSegmentCyclable = sc.IdSegmentCyclable
left join UniteLegale prop on prop.Siren = scp.Siren
left join bdtopo_troncon_de_route t on sc.SourceGeometrie = 'bdtopo.troncon_de_route' and sc.IdGeometrie = t.cleabs
group by ea.CodeEtatAvancement3V, r.CodeRevetement3V, s.CodeStatut3V, sc.AnneeOuverture, sc.SensUnique, sc.SourceGeometrie, sc.IdGeometrie, sc.DateSource, sc.Fictif, sc.Geom, t.position_par_rapport_au_sol;

-- segments cyclables dont le Gard est propriétaire
create view D30_3VSegmentCyclableGard_4Layer as
with SegmentCyclableGard as (
    select distinct sc.IdSegmentCyclable
    from SegmentCyclable sc
    inner join SegmentCyclable_Proprietaire sp on sp.Siren = '223000019' and sc.IdSegmentCyclable = sp.IdSegmentCyclable
    where sc.CodeEtatAvancement3V = 4
    and (
        CodeStatut3V <> 'RTE' or
        (CodeStatut3V = 'RTE' and IdGeometrie not in (select IdIGN from Troncon))
    )
)
select
    r.Description as "RevetementSegment",
    s.Description as "StatutSegment",
    sc.AnneeOuverture as "AnneeOuvertureSegment",
    sc.SensUnique as "SensUniqueSegment",
    sc.SourceGeometrie as "SourceGeometrieSegment",
    sc.IdGeometrie as "IdGeometrieSegment",
    to_char(sc.DateSource, 'DD-MM-YYYY') as "DateSourceSegment",
    string_agg(distinct gest.Denomination, ', ' order by gest.Denomination) as "GestionnairesSegment",
    string_agg(distinct prop.Denomination, ', ' order by prop.Denomination) as "ProprietairesSegment",
    string_agg(distinct ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel, ', ' order by ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel) as "Itineraires",
    string_agg(distinct pc.Nom, ', ' order by pc.Nom) as "Portions",
    sc.Geom
from SegmentCyclableGard scgard
inner join SegmentCyclable sc on sc.IdSegmentCyclable = scgard.IdSegmentCyclable
left join Revetement3V r on r.CodeRevetement3V = sc.CodeRevetement3V
left join Statut3V s on s.CodeStatut3V = sc.CodeStatut3V
left join SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
left join ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable
left join SegmentCyclable_Gestionnaire scg on scg.IdSegmentCyclable = sc.IdSegmentCyclable
left join UniteLegale gest on gest.Siren = scg.Siren
left join SegmentCyclable_Proprietaire scp on scp.IdSegmentCyclable = sc.IdSegmentCyclable
left join UniteLegale prop on prop.Siren = scp.Siren
group by r.CodeRevetement3V, s.CodeStatut3V, sc.AnneeOuverture, sc.SensUnique, sc.SourceGeometrie, sc.IdGeometrie, sc.DateSource, sc.Geom;

-- couche spécifique pour la carte des itinéraires modes doux
create view D30_3VModesDoux_4Layer as
with CategorieSegment as (
    select
        case
            when CodeStatut3V = 'VV' and CodeEtatAvancement3V = 4 then 'VV ouverte'
            when CodeStatut3V = 'VV' and CodeEtatAvancement3V = 3 then 'VV en travaux'
            when CodeStatut3V = 'VV' and CodeEtatAvancement3V = 2 then 'VV avec tracé arrêté'
            when CodeStatut3V = 'VV' and CodeEtatAvancement3V = 1 then 'VV en projet'
            when CodeStatut3V = 'PCY' and CodeEtatAvancement3V = 4 then 'Piste cyclable ouverte'
            when CodeStatut3V = 'PCY' and CodeEtatAvancement3V = 3 then 'Piste cyclable en travaux'
            when CodeStatut3V = 'PCY' and CodeEtatAvancement3V = 2 then 'Piste cyclable avec tracé arrêté'
            when CodeStatut3V = 'PCY' and CodeEtatAvancement3V = 1 then 'Piste cyclable en projet'
            when CodeStatut3V = 'RTE' and CodeEtatAvancement3V = 4 then 'Route partagée ouverte'
            when CodeStatut3V = 'RTE' and CodeEtatAvancement3V = 3 then 'Route partagée en travaux'
            when CodeStatut3V = 'RTE' and CodeEtatAvancement3V = 2 then 'Route partagée avec tracé arrêté'
            when CodeStatut3V = 'RTE' and CodeEtatAvancement3V = 1 then 'Route partagée en projet'
            when CodeStatut3V not in ('VV', 'PCY', 'RTE') and CodeEtatAvancement3V = 4 then 'Autre voie ouverte'
            when CodeStatut3V not in ('VV', 'PCY', 'RTE') and CodeEtatAvancement3V = 3 then 'Autre voie en travaux'
            when CodeStatut3V not in ('VV', 'PCY', 'RTE') and CodeEtatAvancement3V = 2 then 'Autre voie avec tracé arrêté'
            when CodeStatut3V not in ('VV', 'PCY', 'RTE') and CodeEtatAvancement3V = 1 then 'Autre voie en projet'
            else 'Indéterminée'
        end as Categorie,
        Geom
    from SegmentCyclable sc
),
SectionUniforme as (
    select
        Categorie,
        ST_Multi(ST_LineMerge(ST_CollectionExtract(unnest(ST_ClusterIntersecting(geom)), 2))) as Geom
    from CategorieSegment
    group by Categorie
)
select
    row_number() over() as Id,
    Categorie,
    Geom
from SectionUniforme;

-- portions uniformes - couche utile à la production de la carte "Véloroutes, voies vertes et boucles cyclo-découvertes du Gard"
create view D30_3VPortionUniforme_4Layer as
with SegmentDistinct as (
    select
        distinct
        pc.Nom as NomPortion,
        s.Description as StatutSegment,
        e.Description as EtatAvancementSegment,
        sc.Geom
    from SegmentCyclable sc
    left join Statut3V s on sc.CodeStatut3V = s.CodeStatut3V
    left join EtatAvancement3V e on sc.CodeEtatAvancement3V = e.CodeEtatAvancement3V
    left join SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
    left join PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
)
select
    NomPortion as "Nom",
    StatutSegment as "Statut",
    EtatAvancementSegment as "EtatAvancement",
    (ST_Dump(ST_LineMerge(ST_CollectionExtract(unnest(ST_ClusterIntersecting(geom)), 2)))).Geom
from SegmentDistinct
group by NomPortion, StatutSegment, EtatAvancementSegment;

-- étiquetage itinéraires - couche utile à la production de la carte "Véloroutes, voies vertes et boucles cyclo-découvertes du Gard"
create view D30_3VEtiquetageItineraire_4Layer as
select
    ic.NumeroItineraireCyclable as "NumeroItineraire",
    ic.NomOfficiel as "NomOfficielItineraire",
    ic.NiveauSchema as "NiveauSchema",
    ST_Force2D(ST_PointOnSurface(ST_Collect(geom))) as Geom
from SegmentCyclable sc
left join SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join PortionCyclable_ItineraireCyclable pi ON pi.IdPortionCyclable = pc.IdPortionCyclable
left join ItineraireCyclable ic ON ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable
where pc.CodeTypePortionCyclable = 'ETP'
group by ic.NumeroItineraireCyclable;
