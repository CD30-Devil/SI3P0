-- inventaire global, c-a-d tous gestionnaires/propriétaires, tous états, tous statuts
create view tmp.VVVInventaireGlobal_4Sheet as
with SegmentRetenu as (
    select sc.IdSegmentCyclable
    from m.SegmentCyclable sc
),
DistancesPortionParEtat as (
    select pc.IdPortionCyclable, sc.CodeEtatAvancement3V, round(sum(ST_Length(geom))::numeric / 1000, 3) as Distance
    from m.PortionCyclable pc
    inner join m.SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    inner join SegmentRetenu sr on sr.IdSegmentCyclable = sc.IdSegmentCyclable
    group by pc.IdPortionCyclable, sc.CodeEtatAvancement3V
),
DistancesPortionParStatut as (
    select pc.IdPortionCyclable, sc.CodeStatut3V, round(sum(ST_Length(geom))::numeric / 1000, 3) as Distance
    from m.PortionCyclable pc
    inner join m.SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    inner join SegmentRetenu sr on sr.IdSegmentCyclable = sc.IdSegmentCyclable
    group by pc.IdPortionCyclable, sc.CodeStatut3V
)
select
    pc.Nom                                                                                                                                            as "Portion",
    string_agg(distinct ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel, ', ' order by ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel) as "Itinéraires",
    replace((coalesce(total.Distance, 0))::varchar, '.', ',')                                                                                         as "Longueur (km)",
    replace((coalesce(ouve.Distance, 0))::varchar, '.', ',')                                                                                          as "dont ouvert",
    replace((coalesce(trvx.Distance, 0))::varchar, '.', ',')                                                                                          as "dont travaux en cours",
    replace((coalesce(tarr.Distance, 0))::varchar, '.', ',')                                                                                          as "dont études en cours",
    replace((coalesce(proj.Distance, 0))::varchar, '.', ',')                                                                                          as "dont tracé d'intention",
    replace((coalesce(vv.Distance, 0))::varchar, '.', ',')                                                                                            as "dont voies vertes",
    replace((coalesce(pcy.Distance, 0))::varchar, '.', ',')                                                                                           as "dont pistes cyclables",
    replace((coalesce(asp.Distance, 0))::varchar, '.', ',')                                                                                           as "dont autres sites propres",
    replace((coalesce(bcy.Distance, 0))::varchar, '.', ',')                                                                                           as "dont bandes cyclables",
    replace((coalesce(ica.Distance, 0))::varchar, '.', ',')                                                                                           as "dont itinéraires à ciculation apaisée",
    replace((coalesce(rte.Distance, 0))::varchar, '.', ',')                                                                                           as "dont route"
from m.SegmentCyclable sc
inner join SegmentRetenu sr on sr.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
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
group by pc.Nom, total.Distance, ouve.Distance, trvx.Distance, tarr.Distance, proj.Distance, vv.Distance, pcy.Distance, asp.Distance, bcy.Distance, ica.Distance, rte.Distance
order by pc.Nom;

-- inventaire D30, c-a-d dont le Gard est propriétaire, tous états, tous statuts sauf RD
create view tmp.VVVInventaireD30_4Sheet as
with SegmentRetenu as (
    select sc.IdSegmentCyclable, CodeEtatAvancement3V
    from m.SegmentCyclable sc
    inner join m.SegmentCyclable_Proprietaire sp on sp.Siren = '223000019' and sc.IdSegmentCyclable = sp.IdSegmentCyclable -- le segment doit appartenir au Département du Gard
    and ((CodeStatut3V <> 'RTE') or (CodeStatut3V = 'RTE' and IdGeometrie not in (select IdIGN from m.Troncon))) -- le segment ne doit pas être une route ou, s'il l'est, ne doit pas être inclus dans le référentiel routier
),
DistancesPortionParEtat as (
    select pc.IdPortionCyclable, sc.CodeEtatAvancement3V, round(sum(ST_Length(geom))::numeric / 1000, 3) as Distance
    from m.PortionCyclable pc
    inner join m.SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    inner join SegmentRetenu sr on sr.IdSegmentCyclable = sc.IdSegmentCyclable
    group by pc.IdPortionCyclable, sc.CodeEtatAvancement3V
),
DistancesPortionParStatut as (
    select pc.IdPortionCyclable, sc.CodeStatut3V, round(sum(ST_Length(geom))::numeric / 1000, 3) as Distance
    from m.PortionCyclable pc
    inner join m.SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    inner join SegmentRetenu sr on sr.IdSegmentCyclable = sc.IdSegmentCyclable
    group by pc.IdPortionCyclable, sc.CodeStatut3V
)
select
    pc.Nom                                                                                                                                            as "Portion",
    string_agg(distinct ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel, ', ' order by ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel) as "Itinéraires",
    replace((coalesce(total.Distance, 0))::varchar, '.', ',')                                                                                         as "Longueur (km)",
    replace((coalesce(ouve.Distance, 0))::varchar, '.', ',')                                                                                          as "dont ouvert",
    replace((coalesce(trvx.Distance, 0))::varchar, '.', ',')                                                                                          as "dont travaux en cours",
    replace((coalesce(tarr.Distance, 0))::varchar, '.', ',')                                                                                          as "dont études en cours",
    replace((coalesce(proj.Distance, 0))::varchar, '.', ',')                                                                                          as "dont tracé d'intention",
    replace((coalesce(vv.Distance, 0))::varchar, '.', ',')                                                                                            as "dont voies vertes",
    replace((coalesce(pcy.Distance, 0))::varchar, '.', ',')                                                                                           as "dont pistes cyclables",
    replace((coalesce(asp.Distance, 0))::varchar, '.', ',')                                                                                           as "dont autres sites propres",
    replace((coalesce(bcy.Distance, 0))::varchar, '.', ',')                                                                                           as "dont bandes cyclables",
    replace((coalesce(ica.Distance, 0))::varchar, '.', ',')                                                                                           as "dont itinéraires à ciculation apaisée",
    replace((coalesce(rte.Distance, 0))::varchar, '.', ',')                                                                                           as "dont route"
from m.SegmentCyclable sc
inner join SegmentRetenu sr on sr.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
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
group by pc.Nom, total.Distance, ouve.Distance, trvx.Distance, tarr.Distance, proj.Distance, vv.Distance, pcy.Distance, asp.Distance, bcy.Distance, ica.Distance, rte.Distance
order by pc.Nom;

-- inventaire D30 ouvert, c-a-d dont le Gard est propriétaire, état = 4, tous statuts sauf RD
create view tmp.VVVInventaireD30Ouvert_4Sheet as
with SegmentRetenu as (
    select sc.IdSegmentCyclable, CodeEtatAvancement3V
    from m.SegmentCyclable sc
    inner join m.SegmentCyclable_Proprietaire sp on sp.Siren = '223000019' and sc.IdSegmentCyclable = sp.IdSegmentCyclable -- le segment doit appartenir au Département du Gard
    where CodeEtatAvancement3V = 4 -- le segment doit être ouvert
    and ((CodeStatut3V <> 'RTE') or (CodeStatut3V = 'RTE' and IdGeometrie not in (select IdIGN from m.Troncon))) -- le segment ne doit pas être une route ou, s'il l'est, ne doit pas être inclus dans le référentiel routier
),
DistancesPortionParEtat as (
    select pc.IdPortionCyclable, sc.CodeEtatAvancement3V, round(sum(ST_Length(geom))::numeric / 1000, 3) as Distance
    from m.PortionCyclable pc
    inner join m.SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    inner join SegmentRetenu sr on sr.IdSegmentCyclable = sc.IdSegmentCyclable
    group by pc.IdPortionCyclable, sc.CodeEtatAvancement3V
),
DistancesPortionParStatut as (
    select pc.IdPortionCyclable, sc.CodeStatut3V, round(sum(ST_Length(geom))::numeric / 1000, 3) as Distance
    from m.PortionCyclable pc
    inner join m.SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    inner join SegmentRetenu sr on sr.IdSegmentCyclable = sc.IdSegmentCyclable
    group by pc.IdPortionCyclable, sc.CodeStatut3V
)
select
    pc.Nom                                                                                                                                            as "Portion",
    string_agg(distinct ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel, ', ' order by ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel) as "Itinéraires",
    replace((coalesce(total.Distance, 0))::varchar, '.', ',')                                                                                         as "Longueur (km)",
    replace((coalesce(vv.Distance, 0))::varchar, '.', ',')                                                                                            as "dont voies vertes",
    replace((coalesce(pcy.Distance, 0))::varchar, '.', ',')                                                                                           as "dont pistes cyclables",
    replace((coalesce(asp.Distance, 0))::varchar, '.', ',')                                                                                           as "dont autres sites propres",
    replace((coalesce(bcy.Distance, 0))::varchar, '.', ',')                                                                                           as "dont bandes cyclables",
    replace((coalesce(ica.Distance, 0))::varchar, '.', ',')                                                                                           as "dont itinéraires à ciculation apaisée",
    replace((coalesce(rte.Distance, 0))::varchar, '.', ',')                                                                                           as "dont route"
from m.SegmentCyclable sc
inner join SegmentRetenu sr on sr.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
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
group by pc.Nom, total.Distance, ouve.Distance, trvx.Distance, tarr.Distance, proj.Distance, vv.Distance, pcy.Distance, asp.Distance, bcy.Distance, ica.Distance, rte.Distance
order by pc.Nom;

-- inventaire D30 ouvert pour le vote en assemblée, c-a-d dont le Gard est propriétaire, état = 4 à l'année N-1, tous statuts sauf RD
create view tmp.VVVInventaireD30OuvertPourVote_4Sheet as
with SegmentRetenu as (
    select sc.IdSegmentCyclable
    from m.SegmentCyclable sc
    inner join m.SegmentCyclable_Proprietaire sp on sp.Siren = '223000019' and sc.IdSegmentCyclable = sp.IdSegmentCyclable -- le segment doit appartenir au Département du Gard
    where CodeEtatAvancement3V = 4 -- le segment doit être ouvert
    and (AnneeOuverture is null or AnneeOuverture < extract(year from current_date)) -- le date d'ouverture du segment doit être antérieure à l'année courante
    and ((CodeStatut3V <> 'RTE') or (CodeStatut3V = 'RTE' and IdGeometrie not in (select IdIGN from m.Troncon))) -- le segment ne doit pas être une route ou, s'il l'est, ne doit pas être inclus dans le référentiel routier
),
DistancesPortionParEtat as (
    select pc.IdPortionCyclable, sc.CodeEtatAvancement3V, round(sum(ST_Length(geom))::numeric / 1000, 3) as Distance
    from m.PortionCyclable pc
    inner join m.SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    inner join SegmentRetenu sr on sr.IdSegmentCyclable = sc.IdSegmentCyclable
    group by pc.IdPortionCyclable, sc.CodeEtatAvancement3V
),
DistancesPortionParStatut as (
    select pc.IdPortionCyclable, sc.CodeStatut3V, round(sum(ST_Length(geom))::numeric / 1000, 3) as Distance
    from m.PortionCyclable pc
    inner join m.SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    inner join SegmentRetenu sr on sr.IdSegmentCyclable = sc.IdSegmentCyclable
    group by pc.IdPortionCyclable, sc.CodeStatut3V
)
select
    pc.Nom                                                                                                                                            as "Portion",
    string_agg(distinct ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel, ', ' order by ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel) as "Itinéraires",
    replace((coalesce(total.Distance, 0))::varchar, '.', ',')                                                                                         as "Longueur (km)",
    replace((coalesce(vv.Distance, 0))::varchar, '.', ',')                                                                                            as "dont voies vertes",
    replace((coalesce(pcy.Distance, 0))::varchar, '.', ',')                                                                                           as "dont pistes cyclables",
    replace((coalesce(asp.Distance, 0))::varchar, '.', ',')                                                                                           as "dont autres sites propres",
    replace((coalesce(bcy.Distance, 0))::varchar, '.', ',')                                                                                           as "dont bandes cyclables",
    replace((coalesce(ica.Distance, 0))::varchar, '.', ',')                                                                                           as "dont itinéraires à ciculation apaisée",
    replace((coalesce(rte.Distance, 0))::varchar, '.', ',')                                                                                           as "dont route"
from m.SegmentCyclable sc
inner join SegmentRetenu sr on sr.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
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
group by pc.Nom, total.Distance, ouve.Distance, trvx.Distance, tarr.Distance, proj.Distance, vv.Distance, pcy.Distance, asp.Distance, bcy.Distance, ica.Distance, rte.Distance
order by pc.Nom;

-- itinéraires cyclables et portions contituantes
create view tmp.VVVItineraire_4Sheet as
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