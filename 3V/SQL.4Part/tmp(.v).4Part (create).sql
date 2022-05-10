create view tmp.VetT_Segment_4Layer as
select
    distinct
    sc.IdSegmentCyclable as "ID_LOCAL",
    null::varchar as "ID_ON3V",
    sc.CodeStatut3V as "STATUT",
    sc.CodeEtatAvancement3V as "AVANCEMENT",
    sc.AnneeOuverture as "AN_OUVERT",
    sc.SensUnique as "SENSUNIQUE",
    sc.CodeRevetement3V as "REVETEMENT",
    string_agg(distinct gest.Denomination, ', ' order by gest.Denomination) as "GESTION",
    string_agg(distinct prop.Denomination, ', ' order by prop.Denomination) as "PROPRIETE",
    sc.DateSaisie as "DATESAISIE",
    sc.Fictif as "FICTIF",
    sc.PrecisionEstimee as "PRECISION",
    sc.SourceGeometrie as "SRC_GEOM",
    sc.DateSource as "SRC_DATE",
    (extract(year from sc.DateSource))::integer as "SRC_ANNEE",
    string_agg(distinct com.COGCommune, ', ' order by com.COGCommune) as "COG_COMMUNES",
    string_agg(distinct epci.Siren, ', ' order by epci.Siren) as "SIREN_EPCI",
    string_agg(distinct dep.COGDepartement, ', ' order by dep.COGDepartement) as "COG_DEPARTEMENTS",
    string_agg(distinct dep.COGRegion, ', ' order by dep.COGRegion) as "COG_REGIONS",
    sc.Geom
from m.SegmentCyclable sc
left join m.SegmentCyclable_Gestionnaire scg on scg.IdsegmentCyclable = sc.IdSegmentCyclable
left join d.Sirene_UniteLegale gest on gest.Siren = scg.Siren
left join m.SegmentCyclable_Proprietaire scp on scp.IdsegmentCyclable = sc.IdSegmentCyclable
left join d.Sirene_UniteLegale prop on prop.Siren = scp.Siren
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join m.PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
inner join m.Commune com on ST_Intersects(sc.Geom, com.Geom)
inner join m.EPCIFederative epci on com.SirenEPCI = epci.Siren
inner join m.Departement dep on com.COGDepartement = dep.COGDepartement
inner join m.Region reg on dep.COGRegion = reg.COGRegion
where pi.NumeroItineraireCyclable not like 'B%'
group by sc.IdSegmentCyclable
order by "ID_LOCAL";

create view tmp.VetT_RTronconSegment_4Sheet as
select
    distinct
    sc.IdSegmentCyclable as "ID_LOCAL",
    sc.IdGeometrie as "ID_SI_EXT",
    sc.SourceGeometrie as "NOM_SI_EXT"
from m.SegmentCyclable sc
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join m.PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
where pi.NumeroItineraireCyclable not like 'B%'
order by "ID_LOCAL";

create view tmp.VetT_Portion_4Layer as
select
    pc.IdPortionCyclable as "ID_LOCAL",
    null::varchar as "ID_ON3V",
    pc.Nom as "NOM",
    pc.CodeTypePortionCyclable as "TYPE",
    pc.Description as "DESCRIPT",
    case pi.NumeroItineraireCyclable
        when 'EV17a' then 'EV17'
        when 'EV17b' then 'EV17'
        else pi.NumeroItineraireCyclable
    end as "ID_ITI",
    case pi.NumeroItineraireCyclable
        when 'EV17a' then pi.Ordre + 10000
        when 'EV17b' then pi.Ordre + 20000
        else pi.Ordre
    end as "ORDRE_ETAP",
    ST_LineMerge(ST_Collect(sc.Geom)) as Geom
from m.SegmentCyclable sc
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join m.PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
where pi.NumeroItineraireCyclable not like 'B%'
group by pc.IdPortionCyclable, pi.NumeroItineraireCyclable, pi.Ordre
order by "ID_ITI", "ORDRE_ETAP";

create view tmp.VetT_RElementPortion_4Sheet as
select sp.IdPortionCyclable as "ID_PORTION", sp.IdSegmentCyclable as "ID_ELEMENT"
from m.SegmentCyclable_PortionCyclable sp
left join m.PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = sp.IdPortionCyclable
where pi.NumeroItineraireCyclable not like 'B%'
order by "ID_PORTION", "ID_ELEMENT";

create view tmp.VetT_Itineraire_4Sheet as
select
    NumeroItineraireCyclable as "ID_ITI",
    NumeroItineraireCyclable as "NUMERO",
    NomOfficiel as "NOM_OFF",
    NomUsage as "NOM_USAGE",
    Depart as "DEPART",
    case NumeroItineraireCyclable
        when 'EV17' then (select string_agg(Arrivee, ', ' order by Arrivee) from m.ItineraireCyclable where NumeroItineraireCyclable in ('EV17a', 'EV17b'))
        else Arrivee
    end as "ARRIVEE",
    EstInscrit as "EST_INSCRI",
    NiveauSchema as "NIV_INSCRI",
    AnneeInscription as "AN_INSCRI",
    SiteWeb as "SITE_WEB",
    AnneeOuverture as "AN_OUVERT"
from m.ItineraireCyclable
where NumeroItineraireCyclable not like 'B%'
and NumeroItineraireCyclable not in ('EV17a', 'EV17b')
order by "ID_ITI";

create view tmp.VetT_BoucleCyclo_4Layer as
with ItineraireCyclableCommune as (
    select distinct ic.NumeroItineraireCyclable, c.Nom
    from m.ItineraireCyclable ic
    inner join m.PortionCyclable_ItineraireCyclable pi on pi.NumeroItineraireCyclable = ic.NumeroItineraireCyclable
    inner join m.PortionCyclable pc on pc.IdPortionCyclable = pi.IdPortionCyclable
    inner join m.SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    inner join m.Commune c on ST_Intersects(sc.Geom, c.Geom)
),
DistancesItineraireParEtat as (
    select ic.NumeroItineraireCyclable, sc.CodeEtatAvancement3V, round(sum(ST_Length(geom))::numeric / 1000, 2) as Distance
    from m.ItineraireCyclable ic
    inner join m.PortionCyclable_ItineraireCyclable pi on pi.NumeroItineraireCyclable = ic.NumeroItineraireCyclable
    inner join m.PortionCyclable pc on pc.IdPortionCyclable = pi.IdPortionCyclable
    inner join m.SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    group by ic.NumeroItineraireCyclable, sc.CodeEtatAvancement3V
)
select
    ic.NumeroItineraireCyclable as "ID_ITI",
    ic.NumeroItineraireCyclable as "NUMERO",
    ic.NomOfficiel as "NOM_OFF",
    ic.NomUsage as "NOM_USAGE",
    ic.Depart as "DEPART",
    ic.Arrivee as "ARRIVEE",
    ic.NiveauSchema as "NIV_INSCRI",
    ic.SiteWeb as "SITE_WEB",
    ic.AnneeOuverture as "AN_OUVERT",
    string_agg(distinct icc.Nom, ', ' order by icc.Nom) as "COMMUNES",
    coalesce(total.Distance, 0) as "KM",
    coalesce(ouve.Distance, 0) as "KM_OUVE",
    coalesce(trvx.Distance, 0) as "KM_TRVX",
    coalesce(tarr.Distance, 0) as "KM_TR_ARR",
    coalesce(proj.Distance, 0) as "KM_PROJ",
    ST_LineMerge(ST_Collect(sc.Geom)) as Geom
from m.SegmentCyclable sc
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join m.PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
left join m.ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable
inner join ItineraireCyclableCommune icc on icc.NumeroItineraireCyclable = ic.NumeroItineraireCyclable
left join (select NumeroItineraireCyclable, sum(Distance) as Distance from DistancesItineraireParEtat group by NumeroItineraireCyclable) total on total.NumeroItineraireCyclable = ic.NumeroItineraireCyclable
left join DistancesItineraireParEtat ouve on ouve.NumeroItineraireCyclable = ic.NumeroItineraireCyclable and ouve.CodeEtatAvancement3V = 4
left join DistancesItineraireParEtat trvx on trvx.NumeroItineraireCyclable = ic.NumeroItineraireCyclable and trvx.CodeEtatAvancement3V = 3
left join DistancesItineraireParEtat tarr on tarr.NumeroItineraireCyclable = ic.NumeroItineraireCyclable and tarr.CodeEtatAvancement3V = 2
left join DistancesItineraireParEtat proj on proj.NumeroItineraireCyclable = ic.NumeroItineraireCyclable and proj.CodeEtatAvancement3V = 1
where ic.NumeroItineraireCyclable like 'B%'
group by ic.NumeroItineraireCyclable, total.Distance, ouve.Distance, trvx.Distance, tarr.Distance, proj.Distance
order by "ID_ITI";