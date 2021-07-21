start transaction;

-- suppression des alertes de plus de 5 ans
delete from m.HistoAlerteWaze
where Age(Now(), DateCreation) > interval '5 years';

-- suppression des alertes à plus de 25 mètres du réseau routier départemental
delete from m.HistoAlerteWaze h
where not exists (select IdTroncon from m.Troncon t where not(t.Fictif) and ST_DWithin(h.Geom, t.Geom, 25) limit 1);

-- suppression des alertes similaires
delete from m.HistoAlerteWaze
where IdHistoAlerteWaze in (
    select h1.IdHistoAlerteWaze
    from m.HistoAlerteWaze h1, m.HistoAlerteWaze h2
    where h1.IdHistoAlerteWaze <> h2.IdHistoAlerteWaze
    and h1.IdTypeAlerteWaze = h2.IdTypeAlerteWaze -- même type
    and h1.IdSousTypeAlerteWaze = h2.IdSousTypeAlerteWaze -- même sous-type
    and ST_DWithin(h1.Geom, h2.Geom, 500) -- éloignées de maximum 500 mêtres
    and age(h1.DateCreation, h2.DateCreation) between interval '-60 minutes' and interval '60 minutes' -- créées dans un intervalle de maximum 60 minutes
    and (
        h1.Fiabilite < h2.Fiabilite -- pour ne conserver que la plus fiable...
        or (h1.Fiabilite = h2.Fiabilite and h1.DateCreation < h2.DateCreation) -- ...ou la plus récente...
        or (h1.Fiabilite = h2.Fiabilite and h1.DateCreation < h2.DateCreation and h1.IdHistoAlerteWaze < h2.IdHistoAlerteWaze) -- ...ou celle avec l'Id le plus grand
    )
);

commit;