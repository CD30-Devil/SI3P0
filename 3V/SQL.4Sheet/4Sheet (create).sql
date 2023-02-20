-- schémas spécifiques SI3P0 (tmp = temporaire, m = modèle, f = fonctions, archive = archive, v = vues)
set search_path to tmp, m, public;

create view D30_InfosItineraires as
with ItineraireParEtatAvancement as (
    select ic.NumeroItineraireCyclable, NomOfficiel, sc.CodeEtatAvancement3V, sum(ST_3DLength(Geom)) as Longueur
    from ItineraireCyclable ic
    inner join PortionCyclable_ItineraireCyclable pi on pi.NumeroItineraireCyclable = ic.NumeroItineraireCyclable
    inner join PortionCyclable pc on pc.IdPortionCyclable = pi.IdPortionCyclable
    inner join SegmentCyclable_PortionCyclable sp on sp.IdPortionCyclable = pc.IdPortionCyclable
    inner join SegmentCyclable sc on sc.IdSegmentCyclable = sp.IdSegmentCyclable
    group by ic.NumeroItineraireCyclable, sc.CodeEtatAvancement3V
)
select
    total.NumeroItineraireCyclable,
    total.NomOfficiel,
    Unaccent(total.NomOfficiel) as NomOfficielSansAccent,
    round(coalesce(ouvert.Longueur * 100, 0) / sum(total.Longueur))::integer as TauxOuverture
from ItineraireParEtatAvancement total
left join ItineraireParEtatAvancement ouvert on ouvert.CodeEtatAvancement3V = 4 and ouvert.NumeroItineraireCyclable = total.NumeroItineraireCyclable
group by total.NumeroItineraireCyclable, total.NomOfficiel, ouvert.Longueur
order by NumeroItineraireCyclable;

-- inventaire D30 ouvert pour le vote en assemblée, c-a-d dont le Gard est propriétaire, état = 4 à l'année N-1, tous statuts sauf RD
create view D30_VoteAssemblee_3VLineaireParItineraire_4Sheet as
with SegmentRetenu as (
    select sc.*, string_agg(ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel, ', ' order by ic.NumeroItineraireCyclable) as Itineraires
    from SegmentCyclable sc
    inner join SegmentCyclable_Proprietaire prop on prop.IdSegmentCyclable = sc.IdSegmentCyclable
    left join SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
    left join PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = sp.IdPortionCyclable
    left join ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable and ic.NiveauSchema in ('Européen', 'National', 'Départemental')
    where prop.Siren = '223000019' -- le segment doit appartenir au Département du Gard
    and sc.CodeEtatAvancement3V = 4 -- le segment doit être ouvert
    and (sc.AnneeOuverture is null or sc.AnneeOuverture < extract(year from current_date)) -- la date d'ouverture du segment doit être antérieure à l'année courante
    and ((sc.CodeStatut3V <> 'RTE') or (sc.CodeStatut3V = 'RTE' and IdGeometrie not in (select IdIGN from Troncon))) -- le segment ne doit pas être une route ou, s'il l'est, ne doit pas être inclus dans le référentiel routier
    group by sc.IdSegmentCyclable
),
LineaireParItineraires as (
    select
        Itineraires, 
        sum(ST_Length(geom)) as Longueur,
        sum(ST_Length(geom)) filter (where exists(select true from Commune c where c.ZoneMontagne and ST_Intersects(sr.Geom, c.Geom))) as LongueurZoneMontagne
    from SegmentRetenu sr
    group by Itineraires
)
select
    coalesce(Itineraires, 'Autres') as "Itinéraires",
    coalesce(replace(round(Longueur::numeric / 1000, 2)::varchar, '.', ','), '0')  as "Km",
    coalesce(replace(round(LongueurZoneMontagne::numeric / 1000, 2)::varchar, '.', ','), '0')  as "Km zone montagne"
from LineaireParItineraires ic
order by Itineraires nulls last;

-- itinéraires cyclables et portions contituantes
create view D30_3VItineraire_4Sheet as
with LongueursPortions as (
    select
        pc.IdPortionCyclable,
        pc.Nom,
        sum(ST_Length(geom)) as Longueur,
        sum(ST_Length(geom)) filter (where CodeEtatAvancement3V = 4) as LongueurOuvert,
        sum(ST_Length(geom)) filter (where CodeEtatAvancement3V = 3) as LongueurTravauxEnCours,
        sum(ST_Length(geom)) filter (where CodeEtatAvancement3V = 2) as LongueurTraceArrete,
        sum(ST_Length(geom)) filter (where CodeEtatAvancement3V = 1) as LongueurProjet,
        sum(ST_Length(geom)) filter (where CodeStatut3V = 'VV') as LongueurVV,
        sum(ST_Length(geom)) filter (where CodeStatut3V = 'PCY') as LongueurPCY,
        sum(ST_Length(geom)) filter (where CodeStatut3V = 'ASP') as LongueurASP,
        sum(ST_Length(geom)) filter (where CodeStatut3V = 'BCY') as LongueurBCY,
        sum(ST_Length(geom)) filter (where CodeStatut3V = 'ICA') as LongueurICA,
        sum(ST_Length(geom)) filter (where CodeStatut3V = 'RTE') as LongueurRTE
    from PortionCyclable pc
    inner join SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    group by pc.IdPortionCyclable
)
select
    ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel as "Itinéraire",
    lp.Nom as "Portion",
    tpc.Description as "Type portion",
    coalesce(replace(round(Longueur::numeric / 1000, 2)::varchar, '.', ','), '0') as "Longueur (km)",
    coalesce(replace(round(LongueurOuvert::numeric / 1000, 2)::varchar, '.', ','), '0') as "dont ouvert",
    coalesce(replace(round(LongueurTravauxEnCours::numeric / 1000, 2)::varchar, '.', ','), '0') as "dont travaux en cours",
    coalesce(replace(round(LongueurTraceArrete::numeric / 1000, 2)::varchar, '.', ','), '0') as "dont études en cours",
    coalesce(replace(round(LongueurProjet::numeric / 1000, 2)::varchar, '.', ','), '0') as "dont tracé d'intention",
    coalesce(replace(round(LongueurVV::numeric / 1000, 2)::varchar, '.', ','), '0') as "dont voies vertes",
    coalesce(replace(round(LongueurPCY::numeric / 1000, 2)::varchar, '.', ','), '0') as "dont pistes cyclables",
    coalesce(replace(round(LongueurASP::numeric / 1000, 2)::varchar, '.', ','), '0') as "dont autres sites propres",
    coalesce(replace(round(LongueurBCY::numeric / 1000, 2)::varchar, '.', ','), '0') as "dont bandes cyclables",
    coalesce(replace(round(LongueurICA::numeric / 1000, 2)::varchar, '.', ','), '0') as "dont itinéraires à ciculation apaisée",
    coalesce(replace(round(LongueurRTE::numeric / 1000, 2)::varchar, '.', ','), '0') as "dont route"
from ItineraireCyclable ic
left join PortionCyclable_ItineraireCyclable pi on pi.NumeroItineraireCyclable = ic.NumeroItineraireCyclable
left join PortionCyclable pc on pc.IdPortionCyclable = pi.IdPortionCyclable
left join TypePortionCyclable tpc on tpc.CodeTypePortionCyclable = pc.CodeTypePortionCyclable
left join LongueursPortions lp on lp.IdPortionCyclable = pc.IdPortionCyclable
order by "Itinéraire", pi.Ordre;