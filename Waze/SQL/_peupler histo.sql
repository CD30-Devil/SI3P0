start transaction;

-- insertion des alertes depuis le schéma tmp
insert into m.HistoAlerteWaze(IdHistoAlerteWaze, DateCreation, IdTypeAlerteWaze, IdSousTypeAlerteWaze, Fiabilite, Geom)
select
    distinct
    h.uuid,
    to_timestamp(h.ts, 'YYYY-MM-DD HH24:MI:SS')::timestamp at time zone 'UTC' as date,
    type,
    subtype,
    reliability::integer,
    TransformerEnL93(FabriquerPointWGS84(x::numeric, y::numeric))
from tmp.HistoAlerteWaze h
inner join (select uuid,  max(ts) as ts from tmp.histoalertewaze group by uuid) hmax -- présence de doublons d'uuid, on ne conserve que le plus récent
on h.uuid = hmax.uuid and h.ts = hmax.ts
order by date
on conflict (IdHistoAlerteWaze) do
update
set
    IdTypeAlerteWaze = EXCLUDED.IdTypeAlerteWaze,
    IdSousTypeAlerteWaze = EXCLUDED.IdSousTypeAlerteWaze,
    DateCreation = EXCLUDED.DateCreation,
    Fiabilite = EXCLUDED.Fiabilite,
    Geom = EXCLUDED.Geom;

commit;