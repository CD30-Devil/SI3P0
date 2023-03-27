-- schémas spécifiques SI3P0 (tmp = temporaire, m = modèle)
set search_path to tmp, m, public;

-- >> 3V ----------------------------------------------------------------------

-- informations concernant les itinéraires
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

-- << 3V ----------------------------------------------------------------------