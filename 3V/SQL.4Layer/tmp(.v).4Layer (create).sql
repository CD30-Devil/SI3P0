-- véloroutes et voies vertes avec doublons lorsqu'un même segment participe à plusieurs itinéraires
create view tmp.VVVAvecDoublons_4Layer as
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
    sc.SourceGeometrie as "SourceGeometrieSegment",
    sc.IdGeometrie as "IdGeometrieSegment",
    to_char(sc.DateSource, 'DD-MM-YYYY') as "DateSourceSegment",
    sc.Fictif as "FictifSegment",
    string_agg(distinct gest.Denomination, ', ' order by gest.Denomination) as "GestionnairesSegment",
    string_agg(distinct prop.Denomination, ', ' order by prop.Denomination) as "ProprietairesSegment",
    sc.Geom
from m.SegmentCyclable sc
left join m.EtatAvancement3V ea on ea.CodeEtatAvancement3V = sc.CodeEtatAvancement3V
left join m.Revetement3V r on r.CodeRevetement3V = sc.CodeRevetement3V
left join m.Statut3V s on s.CodeStatut3V = sc.CodeStatut3V
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join m.TypePortionCyclable tpc on tpc.CodeTypePortionCyclable = pc.CodeTypePortionCyclable
left join m.PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
left join m.ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable
left join m.SegmentCyclable_Gestionnaire scg on scg.IdsegmentCyclable = sc.IdSegmentCyclable
left join d.Sirene_UniteLegale gest on gest.Siren = scg.Siren
left join m.SegmentCyclable_Proprietaire scp on scp.IdsegmentCyclable = sc.IdSegmentCyclable
left join d.Sirene_UniteLegale prop on prop.Siren = scp.Siren
group by
    ic.NumeroItineraireCyclable, ic.NomOfficiel, ic.NomUsage, ic.Depart, ic.Arrivee, ic.NiveauSchema, ic.SiteWeb, ic.AnneeOuverture,
    pc.Nom, pc.Description, tpc.Description,
    ea.Description, r.Description, s.Description, sc.AnneeOuverture, sc.SensUnique, sc.SourceGeometrie, sc.IdGeometrie, sc.DateSource, sc.Fictif, sc.Geom;

create view tmp.VVVAvecDoublons_4SHP as
select
    "NumeroItineraire" as "NumIti",
    "NomOfficielItineraire" as "NomOffIti",
    "NomUsageItineraire" as "NomIti",
    "DepartItineraire" as "DepartIti",
    "ArriveeItineraire" as "ArriveeIti",
    "NiveauItineraire" as "NiveauIti",
    "URLItineraire" as "URLIti",
    "AnneeOuvertureItineraire" as "AnOuvIti",
    "NomPortion",
    "DescriptionPortion" as "DesPortion",
    "TypePortion" as "TypPortion",
    "EtatAvancementSegment" as "AvancSeg",
    "RevetementSegment" as "RevetSeg",
    "StatutSegment" as "StatutSeg",
    "AnneeOuvertureSegment" as "AnOuvSeg",
    "SensUniqueSegment" as "SensUniSeg",
    "SourceGeometrieSegment" as "SrcGeomSeg",
    "IdGeometrieSegment" as "IdGeomSeg",
    "DateSourceSegment" as "DateSrcSeg",
    "FictifSegment" as "FictifSeg",
    "GestionnairesSegment" as "GestSeg",
    "ProprietairesSegment" as "PropSeg",
    Geom
from tmp.VVVAvecDoublons_4Layer;

-- véloroutes et voies vertes sans doublons
create view tmp.VVVSansDoublons_4Layer as
select
    ea.Description as "EtatAvancementSegment",
    r.Description as "RevetementSegment",
    s.Description as "StatutSegment",
    sc.AnneeOuverture as "AnneeOuvertureSegment",
    sc.SensUnique as "SensUniqueSegment",
    sc.SourceGeometrie as "SourceGeometrieSegment",
    sc.IdGeometrie as "IdGeometrieSegment",
    to_char(sc.DateSource, 'DD-MM-YYYY') as "DateSourceSegment",
    sc.Fictif as "FictifSegment",
    string_agg(distinct gest.Denomination, ', ' order by gest.Denomination) as "GestionnairesSegment",
    string_agg(distinct prop.Denomination, ', ' order by prop.Denomination) as "ProprietairesSegment",
    string_agg(distinct ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel, ', ') as "Itineraires",
    string_agg(distinct pc.Nom, ', ' order by pc.Nom) as "Portions",
    sc.Geom
from m.SegmentCyclable sc
left join m.EtatAvancement3V ea on ea.CodeEtatAvancement3V = sc.CodeEtatAvancement3V
left join m.Revetement3V r on r.CodeRevetement3V = sc.CodeRevetement3V
left join m.Statut3V s on s.CodeStatut3V = sc.CodeStatut3V
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join m.TypePortionCyclable tpc on tpc.CodeTypePortionCyclable = pc.CodeTypePortionCyclable
left join m.PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
left join m.ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable
left join m.SegmentCyclable_Gestionnaire scg on scg.IdsegmentCyclable = sc.IdSegmentCyclable
left join d.Sirene_UniteLegale gest on gest.Siren = scg.Siren
left join m.SegmentCyclable_Proprietaire scp on scp.IdsegmentCyclable = sc.IdSegmentCyclable
left join d.Sirene_UniteLegale prop on prop.Siren = scp.Siren
group by
    ea.CodeEtatAvancement3V, ea.Description, r.CodeRevetement3V, r.Description, s.CodeStatut3V, s.Description, sc.AnneeOuverture, sc.SensUnique, sc.SourceGeometrie, sc.IdGeometrie, sc.DateSource, sc.Fictif, sc.Geom;

create view tmp.VVVSansDoublons_4SHP as
select
    "EtatAvancementSegment" as "AvancSeg",
    "RevetementSegment" as "RevetSeg",
    "StatutSegment" as "StatutSeg",
    "AnneeOuvertureSegment" as "AnOuvSeg",
    "SensUniqueSegment"as "SensUniSeg",
    "SourceGeometrieSegment" as "SrcGeomSeg",
    "IdGeometrieSegment" as "IdGeomSeg",
    "DateSourceSegment" as "DateSrcSeg",
    "FictifSegment" as "FictifSeg",
    "GestionnairesSegment" as "GestSeg",
    "ProprietairesSegment" as "PropSeg",
    "Itineraires" as "Iti",
    "Portions",
    Geom
from tmp.VVVSansDoublons_4Layer;

-- véloroutes et voies vertes départementales
create view tmp.VVVInventaireD30_4Layer as
with SegmentOuvertD30 as (
    select distinct sc.*
    from m.SegmentCyclable sc
    inner join m.SegmentCyclable_Proprietaire sp on sp.Siren = '223000019' and sc.IdSegmentCyclable = sp.IdSegmentCyclable
    where sc.CodeEtatAvancement3V = 4
),
SegmentACompter as (
    select *
    from SegmentOuvertD30
    where CodeStatut3V <> 'RTE'
    and (AnneeOuverture is null or AnneeOuverture < extract(year from current_date))
    union
    select *
    from SegmentOuvertD30
    where CodeStatut3V = 'RTE'
    and (AnneeOuverture is null or AnneeOuverture < extract(year from current_date))
    and IdGeometrie not in (select IdIGN from m.Troncon)
)
select
    r.Description                                as "RevetementSegment",
    s.Description                                as "StatutSegment",
    ST_CollectionExtract(unnest(ST_ClusterWithin(sc.Geom, 1)), 2) as Geom
from SegmentACompter sc
left join m.Revetement3V r on r.CodeRevetement3V = sc.CodeRevetement3V
left join m.Statut3V s on s.CodeStatut3V = sc.CodeStatut3V
group by r.Description, s.Description;

-- portions uniformes
create view tmp.VVVPortionUniforme_4Layer as
select
	pc.Nom as "Nom",
	s.Description as "Statut",
	e.Description as "EtatAvancement",
    ST_Multi(ST_LineMerge(ST_CollectionExtract(unnest(ST_ClusterIntersecting(sc.geom)), 2))) as Geom
from m.SegmentCyclable sc
left join m.Statut3V s on sc.CodeStatut3V = s.CodeStatut3V
left join m.EtatAvancement3V e on sc.CodeEtatAvancement3V = e.CodeEtatAvancement3V
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
group by pc.Nom, s.Description, e.Description;