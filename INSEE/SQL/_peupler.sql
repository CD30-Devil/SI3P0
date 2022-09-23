-- schémas spécifiques SI3P0 (d = données, tmp = temporaire)
set search_path to d, tmp, public;

start transaction;

set constraints all deferred;

-- nettoyage préalable
drop table if exists insee_cog_canton;

-- création de la table INSEE des cantons
create table insee_cog_canton as
select
    id_canton::varchar,
    id_departement::varchar,
    id_region::varchar,
    case when compct ~ '^\d+$' then compct::integer end as compct,
    burcentral::varchar,
    case when tncc ~ '^\d+$' then tncc::integer end as tncc,
    ncc::varchar,
    nccenr::varchar,
    libelle::varchar,
    typect::varchar
from source_insee_cog_canton;

commit;