-- inventaire pour le vote des élus
create view tmp.VVVInventaireD30ParStatut_4Sheet as
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

create view tmp.VVVInventaireD30ParPortion_4Sheet as
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

create view tmp.VVVInventaireD30ParItineraires_4Sheet as
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