-- inventaire pour le vote des élus
create view tmp.VVV_InventaireD30ParStatut_4Sheet as
-- extraction des segments à compter pour le vote des élus
with SegmentACompter as (
    select sc.*
    from m.SegmentCyclable sc
    inner join m.SegmentCyclable_Proprietaire sp on sp.Siren = '223000019' and sc.IdSegmentCyclable = sp.IdSegmentCyclable -- le segment doit appartenir au Département du Gard
    where sc.CodeEtatAvancement3V = 4 -- le segment doit être ouvert
    and (AnneeOuverture is null or AnneeOuverture < extract(year from current_date)) -- le date d'ouverture du segment doit être antérieure à l'année courante
    and (CodeStatut3V <> 'RTE') or (CodeStatut3V = 'RTE' and IdGeometrie not in (select IdIGN from m.Troncon)) -- le segment ne doit pas être une route ou, s'il l'est, ne doit pas être inclus dans le référentiel routier
),
-- recherche des informations détaillées concernant les segments
SegmentACompterDetails as (
    select
        sc.IdSegmentCyclable,
        sc.Geom,
        exists (select * from m.Commune where ZoneMontagne and ST_Intersects(Geom, sc.Geom)) as ZoneMontagne,
        s.Description as Statut
    from SegmentACompter sc
    left join m.Statut3V s on s.CodeStatut3V = sc.CodeStatut3V
)
select
    sc.Statut as "Statut",
    replace(round(sum(ST_Length(sc.Geom))::numeric / 1000, 3)::varchar, '.', ',') as "Km",
    coalesce(replace(round(sum(ST_Length(sczm.Geom))::numeric / 1000, 3)::varchar, '.', ','), '0') as "Km zone montagne"
from SegmentACompterDetails sc
left join SegmentACompterDetails sczm on sczm.ZoneMontagne and sc.IdSegmentCyclable = sczm.IdSegmentCyclable
group by sc.Statut
order by sc.Statut;

create view tmp.VVV_InventaireD30ParPortion_4Sheet as
-- extraction des segments à compter pour le vote des élus
with SegmentACompter as (
    select sc.*
    from m.SegmentCyclable sc
    inner join m.SegmentCyclable_Proprietaire sp on sp.Siren = '223000019' and sc.IdSegmentCyclable = sp.IdSegmentCyclable -- le segment doit appartenir au Département du Gard
    where sc.CodeEtatAvancement3V = 4 -- le segment doit être ouvert
    and (AnneeOuverture is null or AnneeOuverture < extract(year from current_date)) -- le date d'ouverture du segment doit être antérieure à l'année courante
    and (CodeStatut3V <> 'RTE') or (CodeStatut3V = 'RTE' and IdGeometrie not in (select IdIGN from m.Troncon)) -- le segment ne doit pas être une route ou, s'il l'est, ne doit pas être inclus dans le référentiel routier
),
-- recherche des informations détaillées concernant les segments
SegmentACompterDetails as (
    select
        sc.IdSegmentCyclable,
        sc.Geom,
        pc.Nom as Portion,
        exists (select * from m.Commune where ZoneMontagne and ST_Intersects(Geom, sc.Geom)) as ZoneMontagne,
        string_agg(ic.NumeroItineraireCyclable, '/' order by ic.NumeroItineraireCyclable) as Itineraires
    from SegmentACompter sc
    left join m.SegmentCyclable_PortionCyclable sp on sc.IdSegmentCyclable = sp.IdSegmentCyclable and sp.IdPortionCyclable = (
        select distinct IdPortionCyclable
        from m.SegmentCyclable_PortionCyclable
        where IdSegmentCyclable = sc.IdSegmentCyclable
        order by IdPortionCyclable
        limit 1) -- jointure uniquement sur la première portion pour ne pas compter en double les segments qui participent à plusieurs portions
    left join m.PortionCyclable pc on sp.IdPortionCyclable = pc.IdPortionCyclable
    left join m.PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
    left join m.ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable and ic.NiveauSchema in ('National', 'Européen')
    group by sc.IdSegmentCyclable, sc.Geom, pc.IdPortionCyclable
)
select
    concat_ws(' - ', sc.Itineraires, sc.Portion) as "Portion",
    replace(round(sum(ST_Length(sc.Geom))::numeric / 1000, 3)::varchar, '.', ',') as "Km",
    coalesce(replace(round(sum(ST_Length(sczm.Geom))::numeric / 1000, 3)::varchar, '.', ','), '0') as "Km zone montagne"
from SegmentACompterDetails sc
left join SegmentACompterDetails sczm on sczm.ZoneMontagne and sc.IdSegmentCyclable = sczm.IdSegmentCyclable
group by sc.Itineraires, sc.Portion
order by sc.Itineraires nulls last, sc.Portion;

create view tmp.VVV_InventaireD30ParItineraire_4Sheet as
-- extraction des segments à compter pour le vote des élus
with SegmentACompter as (
    select sc.*
    from m.SegmentCyclable sc
    inner join m.SegmentCyclable_Proprietaire sp on sp.Siren = '223000019' and sc.IdSegmentCyclable = sp.IdSegmentCyclable -- le segment doit appartenir au Département du Gard
    where sc.CodeEtatAvancement3V = 4 -- le segment doit être ouvert
    and (AnneeOuverture is null or AnneeOuverture < extract(year from current_date)) -- le date d'ouverture du segment doit être antérieure à l'année courante
    and (CodeStatut3V <> 'RTE') or (CodeStatut3V = 'RTE' and IdGeometrie not in (select IdIGN from m.Troncon)) -- le segment ne doit pas être une route ou, s'il l'est, ne doit pas être inclus dans le référentiel routier
),
-- recherche des informations détaillées concernant les segments
SegmentACompterDetails as (
    select
        sc.IdSegmentCyclable,
        sc.Geom,
        exists (select * from m.Commune where ZoneMontagne and ST_Intersects(Geom, sc.Geom)) as ZoneMontagne,
        string_agg(ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel, ' / ' order by ic.NumeroItineraireCyclable) as Itineraires
    from SegmentACompter sc
    left join m.SegmentCyclable_PortionCyclable sp on sc.IdSegmentCyclable = sp.IdSegmentCyclable and sp.IdPortionCyclable = (
        select distinct IdPortionCyclable
        from m.SegmentCyclable_PortionCyclable
        where IdSegmentCyclable = sc.IdSegmentCyclable
        order by IdPortionCyclable
        limit 1) -- jointure uniquement sur la première portion pour ne pas compter en double les segments qui participent à plusieurs portions
    left join m.PortionCyclable pc on sp.IdPortionCyclable = pc.IdPortionCyclable
    left join m.PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
    left join m.ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable and (ic.NiveauSchema in ('National', 'Européen') or ic.NumeroItineraireCyclable like 'ID30%')
    group by sc.IdSegmentCyclable, sc.Geom, pc.IdPortionCyclable
)
select
    coalesce(sc.Itineraires, 'Autres') as "Itinéraires",
    replace(round(sum(ST_Length(sc.Geom))::numeric / 1000, 3)::varchar, '.', ',') as "Km",
    coalesce(replace(round(sum(ST_Length(sczm.Geom))::numeric / 1000, 3)::varchar, '.', ','), '0') as "Km zone montagne"
from SegmentACompterDetails sc
left join SegmentACompterDetails sczm on sczm.ZoneMontagne and sc.IdSegmentCyclable = sczm.IdSegmentCyclable
group by sc.Itineraires
order by sc.Itineraires nulls last;

-- Portions cyclables
create view tmp.VVV_Itineraire_4Sheet as
with DistancesPortionParEtat as (
    select pc.IdPortionCyclable, sc.CodeEtatAvancement3V, round(sum(ST_Length(geom))::numeric / 1000, 2) as Distance
    from m.PortionCyclable pc
    inner join m.SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    group by pc.IdPortionCyclable, sc.CodeEtatAvancement3V
),
DistancesPortionParStatut as (
    select pc.IdPortionCyclable, sc.CodeStatut3V, round(sum(ST_Length(geom))::numeric / 1000, 2) as Distance
    from m.PortionCyclable pc
    inner join m.SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    group by pc.IdPortionCyclable, sc.CodeStatut3V
)
select
	ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel as "Itinéraire",
    pc.Nom as "Portion",
	tpc.Description as "Type portion",
    replace((coalesce(total.Distance, 0))::varchar, '.', ',') as "Longueur (km)",
    replace((coalesce(ouve.Distance, 0))::varchar, '.', ',') as "dont ouvert",
    replace((coalesce(trvx.Distance, 0))::varchar, '.', ',') as "dont travaux en cours",
    replace((coalesce(tarr.Distance, 0))::varchar, '.', ',') as "dont études en cours",
    replace((coalesce(proj.Distance, 0))::varchar, '.', ',') as "dont tracé d'intention",
    replace((coalesce(vv.Distance, 0))::varchar, '.', ',') as "dont voies vertes",
    replace((coalesce(pcy.Distance, 0))::varchar, '.', ',') as "dont pistes cyclables",
    replace((coalesce(asp.Distance, 0))::varchar, '.', ',') as "dont autres sites propres",
    replace((coalesce(bcy.Distance, 0))::varchar, '.', ',') as "dont bandes cyclables",
    replace((coalesce(ica.Distance, 0))::varchar, '.', ',') as "dont itinéraires à ciculation apaisée",
    replace((coalesce(rte.Distance, 0))::varchar, '.', ',') as "dont route"
from m.SegmentCyclable sc
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join m.TypePortionCyclable tpc on tpc.CodeTypePortionCyclable = pc.CodeTypePortionCyclable
left join m.PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
left join m.ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable
left join (select IdPortionCyclable, sum(Distance) as Distance from DistancesPortionParEtat group by IdPortionCyclable) total on total.IdPortionCyclable = pc.IdPortionCyclable
left join DistancesPortionParEtat ouve on ouve.IdPortionCyclable = pc.IdPortionCyclable and ouve.CodeEtatAvancement3V = 4
left join DistancesPortionParEtat trvx on trvx.IdPortionCyclable = pc.IdPortionCyclable and trvx.CodeEtatAvancement3V = 3
left join DistancesPortionParEtat tarr on tarr.IdPortionCyclable = pc.IdPortionCyclable and tarr.CodeEtatAvancement3V = 2
left join DistancesPortionParEtat proj on proj.IdPortionCyclable = pc.IdPortionCyclable and proj.CodeEtatAvancement3V = 1
left join DistancesPortionParStatut vv on vv.IdPortionCyclable = pc.IdPortionCyclable and vv.CodeStatut3V = 'VV'
left join DistancesPortionParStatut pcy on pcy.IdPortionCyclable = pc.IdPortionCyclable and pcy.CodeStatut3V = 'PCY'
left join DistancesPortionParStatut asp on asp.IdPortionCyclable = pc.IdPortionCyclable and asp.CodeStatut3V = 'ASP'
left join DistancesPortionParStatut bcy on bcy.IdPortionCyclable = pc.IdPortionCyclable and bcy.CodeStatut3V = 'BCY'
left join DistancesPortionParStatut ica on ica.IdPortionCyclable = pc.IdPortionCyclable and ica.CodeStatut3V = 'ICA'
left join DistancesPortionParStatut rte on rte.IdPortionCyclable = pc.IdPortionCyclable and rte.CodeStatut3V = 'RTE'
group by ic.NumeroItineraireCyclable, pc.IdPortionCyclable, tpc.Description, pi.Ordre, total.Distance, ouve.Distance, trvx.Distance, tarr.Distance, proj.Distance, vv.Distance, pcy.Distance, asp.Distance, bcy.Distance, ica.Distance, rte.Distance
order by "Itinéraire", pi.Ordre;