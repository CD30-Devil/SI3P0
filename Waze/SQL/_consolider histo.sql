-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;

-- suppression des alertes de plus de 5 ans
delete from HistoAlerteWaze
where Age(Now(), DateCreation) > interval '5 years';

-- suppression des alertes à plus de 25 mètres du réseau routier départemental
delete from HistoAlerteWaze h
where not exists (
    select true
    from Troncon t
    where not(t.Fictif)
    and ST_DWithin(h.Geom, t.Geom, 25)
);

-- suppression des alertes similaires
delete from HistoAlerteWaze
where IdHistoAlerteWaze in (
    select asupprimer.IdHistoAlerteWaze
    from HistoAlerteWaze asupprimer
    inner join HistoAlerteWaze aconserver
    on aconserver.IdHistoAlerteWaze <> asupprimer.IdHistoAlerteWaze
    and aconserver.IdTypeAlerteWaze = asupprimer.IdTypeAlerteWaze -- même type
    and aconserver.IdSousTypeAlerteWaze = asupprimer.IdSousTypeAlerteWaze -- même sous-type
    and ST_DWithin(aconserver.Geom, asupprimer.Geom, 500) -- éloignées de maximum 500 mêtres
    and aconserver.DateCreation between asupprimer.DateCreation - '60 minutes'::interval and asupprimer.DateCreation + '60 minutes'::interval -- créées dans un intervalle de maximum 60 minutes
    and (
        aconserver.Fiabilite > asupprimer.Fiabilite -- pour ne conserver que la plus fiable...
        or (aconserver.Fiabilite = asupprimer.Fiabilite and aconserver.DateCreation < asupprimer.DateCreation) -- ...ou la plus ancienne...
        or (aconserver.Fiabilite = asupprimer.Fiabilite and aconserver.DateCreation = asupprimer.DateCreation and aconserver.IdHistoAlerteWaze < asupprimer.IdHistoAlerteWaze) -- ...ou celle avec l'Id le plus petit	
    )
);