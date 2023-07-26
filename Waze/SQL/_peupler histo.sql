-- schémas spécifiques SI3P0 (tmp = temporaire, m = modèle, f = fonctions)
set search_path to tmp, m, f, public;

start transaction;

-- insertion des alertes depuis le schéma tmp
with TypageAlerte as (
    select
        h.uuid,
        to_timestamp(h.ts, 'YYYY-MM-DD HH24:MI:SS')::timestamp at time zone 'UTC' as date,
        type,
        subtype,
        reliability::integer,
        TransformerEnL93(FabriquerPointWGS84(x::numeric, y::numeric))
    from source_histoalertewaze h
),
-- parfois, certains UUID sont en doublon
-- les CTE qui suivent visent à les illimer
NbAlertesParUUID as (
    select uuid, count(*) as NbAlertes
    from source_histoalertewaze
    group by uuid
),
AlerteUnique as (
    select a.*
    from NbAlertesParUUID nba
    inner join TypageAlerte a on a.uuid = nba.uuid
    where nba.NbAlertes = 1
    
    union
    
    select a.*
    from NbAlertesParUUID nba
    cross join lateral (
        select *
        from TypageAlerte a
        where a.uuid = nba.uuid
        order by date desc, reliability desc
        limit 1
    ) a
    where nba.NbAlertes > 1
)
insert into HistoAlerteWaze(IdHistoAlerteWaze, DateCreation, IdTypeAlerteWaze, IdSousTypeAlerteWaze, Fiabilite, Geom)
select * from AlerteUnique
on conflict (IdHistoAlerteWaze) do
update
set
    IdTypeAlerteWaze = EXCLUDED.IdTypeAlerteWaze,
    IdSousTypeAlerteWaze = EXCLUDED.IdSousTypeAlerteWaze,
    DateCreation = EXCLUDED.DateCreation,
    Fiabilite = EXCLUDED.Fiabilite,
    Geom = EXCLUDED.Geom;

commit;

analyze HistoAlerteWaze;