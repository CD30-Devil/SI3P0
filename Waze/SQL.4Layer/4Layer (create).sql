-- schémas spécifiques SI3P0 (tmp = temporaire, m = modèle, f = fonctions)
set search_path to tmp, m, f, public;

create view AccidentProcheRD_4Layer as
with AccidentAIgnorer as (
    select aignorer.IdHistoAlerteWaze
    from HistoAlerteWaze aignorer
    inner join HistoAlerteWaze aconserver
    on aconserver.IdHistoAlerteWaze <> aignorer.IdHistoAlerteWaze
    and aconserver.IdTypeAlerteWaze = aignorer.IdTypeAlerteWaze -- même type
    and ST_DWithin(aconserver.Geom, aignorer.Geom, 500) -- éloignées de maximum 500 mêtres
    and aconserver.DateCreation between aignorer.DateCreation - '60 minutes'::interval and aignorer.DateCreation + '60 minutes'::interval -- créées dans un intervalle de maximum 60 minutes
    and (
        (aconserver.IdSousTypeAlerteWaze = 'ACCIDENT_MAJOR' and aignorer.IdSousTypeAlerteWaze in ('ACCIDENT_MINOR', ''))
        or (aconserver.IdSousTypeAlerteWaze = 'ACCIDENT_MINOR' and aignorer.IdSousTypeAlerteWaze in ('')) -- pour ne concserver que le plus grave...
        or (aconserver.IdSousTypeAlerteWaze = aignorer.IdSousTypeAlerteWaze and aconserver.Fiabilite > aignorer.Fiabilite) -- ...ou le plus fiable...
        or (aconserver.IdSousTypeAlerteWaze = aignorer.IdSousTypeAlerteWaze and aconserver.Fiabilite = aignorer.Fiabilite and aconserver.DateCreation < aignorer.DateCreation) -- ...ou le plus ancien...
        or (aconserver.IdSousTypeAlerteWaze = aignorer.IdSousTypeAlerteWaze and aconserver.Fiabilite = aignorer.Fiabilite and aconserver.DateCreation = aignorer.DateCreation and aconserver.IdHistoAlerteWaze < aignorer.IdHistoAlerteWaze) -- ...ou celui avec l'Id le plus petit
    )
    where aignorer.IdTypeAlerteWaze = 'ACCIDENT'
)
select p._NumeroRoute as NumeroRoute, PRAEnTexte(p._PRA) as PRA, IdSousTypeAlerteWaze, DateCreation, Fiabilite, h.Geom
from HistoAlerteWaze h
cross join PointVersPRA(h.Geom, 1) p
where IdTypeAlerteWaze = 'ACCIDENT'
and IdHistoAlerteWaze not in (
    select IdHistoAlerteWaze
    from AccidentAIgnorer
);

create view DegradationProcheRD_4Layer as
with DegradationAIgnorer as (
    select aignorer.IdHistoAlerteWaze
    from HistoAlerteWaze aignorer
    inner join HistoAlerteWaze aconserver
    on aconserver.IdHistoAlerteWaze <> aignorer.IdHistoAlerteWaze
    and aconserver.IdSousTypeAlerteWaze = aignorer.IdSousTypeAlerteWaze -- même sous-type
    and ST_DWithin(aconserver.Geom, aignorer.Geom, 500) -- éloignées de maximum 500 mêtres
    and aconserver.DateCreation between aignorer.DateCreation - '12 hours'::interval and aignorer.DateCreation + '12 hours'::interval -- créées dans un intervalle de maximum 12 heures
    and (
        (aconserver.Fiabilite > aignorer.Fiabilite) -- pour ne conserver que le plus fiable...
        or (aconserver.Fiabilite = aignorer.Fiabilite and aconserver.DateCreation < aignorer.DateCreation) -- ...ou le plus ancien...
        or (aconserver.Fiabilite = aignorer.Fiabilite and aconserver.DateCreation = aignorer.DateCreation and aconserver.IdHistoAlerteWaze < aignorer.IdHistoAlerteWaze) -- ...ou celui avec l'Id le plus petit
    )
    where aignorer.IdSousTypeAlerteWaze = 'HAZARD_ON_ROAD_POT_HOLE'
)
select p._NumeroRoute as NumeroRoute, PRAEnTexte(p._PRA) as PRA, DateCreation, Fiabilite, h.Geom
from HistoAlerteWaze h
cross join PointVersPRA(h.Geom, 1) p
where IdSousTypeAlerteWaze = 'HAZARD_ON_ROAD_POT_HOLE'
and IdHistoAlerteWaze not in (
    select IdHistoAlerteWaze
    from DegradationAIgnorer
);