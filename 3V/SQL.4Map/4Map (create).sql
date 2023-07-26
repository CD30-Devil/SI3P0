﻿-- schémas spécifiques SI3P0 (tmp = temporaire, m = modèle)
set search_path to tmp, m, public;

create view D30_3VSegmentEtatAvancement_4Map as
select
    case sc.CodeEtatAvancement3V
        when 4 then 'Ouvert'
        when 3 then 'Travaux en cours'
        when 2 then 'Etudes en cours'
        when 1 then 'Tracé d''intention'
    end                                                                               as "Etat d'avancement segment ",
    r.Description                                                                     as "Rev&ecirc;tement segment   ",
    s.Description                                                                     as "Statut segment              ",
    sc.AnneeOuverture                                                                 as "Ann&eacute;e d'ouverture segment ",
    case when sc.SensUnique then 'Faux' else 'Vrai' end                               as "Sens unique                       ",
    sc.SourceGeometrie                                                                as "Source de la g&eacute;om&eacute;trie ",
    sc.IdGeometrie                                                                    as "Identifiant de la g&eacute;om&eacute;trie ",
    case when sc.Fictif then 'Faux' else 'Vrai' end                                   as "Fictif                                     ",
    string_agg(distinct ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel, ', ') as "Itin&eacute;raire(s)                        ",
    string_agg(distinct pc.Nom, ', ')                                                 as "Portion(s)                                   ",
    string_agg(distinct gest.Denomination, ', ')                                      as "Gestionnaire(s)                               ",
    string_agg(distinct prop.Denomination, ', ')                                      as "Propri&eacute;taire(s)                         ",
    sc.Geom,
    'Segments cyclables par état d''avancement' as NomCouche,
    case sc.CodeEtatAvancement3V
        when 4 then 'Ouvert'
        when 3 then 'Travaux en cours'
        when 2 then 'Etudes en cours'
        when 1 then 'Tracé d''intention'
    end as Legende,
    case sc.CodeEtatAvancement3V
        when 4 then '#60D701'
        when 3 then '#FFDB01'
        when 2 then '#FF6E0B'
        when 1 then '#FD2100'
        else '#FF0000'
    end as Couleur
from SegmentCyclable sc
left join Revetement3V r on r.CodeRevetement3V = sc.CodeRevetement3V
left join Statut3V s on s.CodeStatut3V = sc.CodeStatut3V
left join SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join TypePortionCyclable tpc on tpc.CodeTypePortionCyclable = pc.CodeTypePortionCyclable
left join PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
left join ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable
left join SegmentCyclable_Gestionnaire scg on scg.IdsegmentCyclable = sc.IdSegmentCyclable
left join UniteLegale gest on gest.Siren = scg.Siren
left join SegmentCyclable_Proprietaire scp on scp.IdsegmentCyclable = sc.IdSegmentCyclable
left join UniteLegale prop on prop.Siren = scp.Siren
group by
    sc.CodeEtatAvancement3V, r.CodeRevetement3V, r.Description, s.CodeStatut3V, s.Description, sc.AnneeOuverture, sc.SensUnique, sc.SourceGeometrie, sc.IdGeometrie, sc.DateSource, sc.Fictif, sc.Geom
order by sc.CodeEtatAvancement3V;

create view D30_3VPortion_4Map as
with DistancesPortionParEtat as (
    select pc.IdPortionCyclable, sc.CodeEtatAvancement3V, round(sum(ST_Length(geom))::numeric / 1000, 2) as Distance
    from PortionCyclable pc
    inner join SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    group by pc.IdPortionCyclable, sc.CodeEtatAvancement3V
),
DistancesPortionParStatut as (
    select pc.IdPortionCyclable, sc.CodeStatut3V, round(sum(ST_Length(geom))::numeric / 1000, 2) as Distance
    from PortionCyclable pc
    inner join SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    group by pc.IdPortionCyclable, sc.CodeStatut3V
)
select
    pc.Nom                                                                                                                                            as "Portion ",
    string_agg(distinct ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel, ', ' order by ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel) as "Itin&eacute;raires ",
    coalesce(total.Distance, 0)                                                                                                                       as "Longueur (km)       ",
    coalesce(ouve.Distance, 0)                                                                                                                        as "- dont ouvert        ",
    coalesce(trvx.Distance, 0)                                                                                                                        as "- dont travaux en cours ",
    coalesce(tarr.Distance, 0)                                                                                                                        as "- dont &eacute;tudes en cours ",
    coalesce(proj.Distance, 0)                                                                                                                        as "- dont trac&eacute; d'intention ",
    coalesce(vv.Distance, 0)                                                                                                                          as "- dont voies vertes              ",
    coalesce(pcy.Distance, 0)                                                                                                                         as "- dont pistes cyclables           ",
    coalesce(asp.Distance, 0)                                                                                                                         as "- dont autres sites propres        ",
    coalesce(bcy.Distance, 0)                                                                                                                         as "- dont bandes cyclables             ",
    coalesce(ica.Distance, 0)                                                                                                                         as "- dont itinéraires à ciculation apaisée ",
    coalesce(rte.Distance, 0)                                                                                                                         as "- dont route                             ",
    case
        when total.Distance = ouve.Distance then '#60D701'
        when ouve.Distance > 0 then '#FFDB01'
        else '#FD2100'
    end as Couleur,
    case
        when total.Distance = ouve.Distance then '1 - En service'
        when ouve.Distance > 0 then '2 - Partiellement en service'
        else '3 - Hors service'
    end as Legende,
    'Portions cyclables' as NomCouche,
    ST_LineMerge(ST_Collect(sc.Geom)) as Geom
from SegmentCyclable sc
left join SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
left join ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable
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
group by pc.IdPortionCyclable, total.Distance, ouve.Distance, trvx.Distance, tarr.Distance, proj.Distance, vv.Distance, pcy.Distance, asp.Distance, bcy.Distance, ica.Distance, rte.Distance
order by Legende;