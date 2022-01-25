start transaction;

set constraints all deferred;

delete from m.ReleveMeteo;
delete from m.StationMeteo;

-- insertion des stations météo
insert into m.StationMeteo (Source, IdSource, Nom, Geom)
select
    distinct
    Source,
    IdSource,
    Nom,
    TransformerEnL93(FabriquerPointWGS84(Longitude::numeric, Latitude::numeric))
from tmp.ReleveMeteo
where Longitude ~ '^\d+(.\d+)?$'
and Latitude ~ '^\d+(.\d+)?$';

-- insertion des relevés météo
insert into m.ReleveMeteo (Source, IdSource, DateReleve, Temperature, Pression, Humidite, PointRosee, VentMoyen, DirectionVent, Pluie1h)
select
    Source,
    IdSource,
    to_timestamp(DateReleve, 'YYYY-MM-DD HH24:MI:SS')::timestamp at time zone 'UTC' as DateReleve,
    case when Temperature  ~ '^-?\d+(.\d+)?$' then round(Temperature::decimal, 1) end as Temperature,
    case when Pression  ~ '^\d+(.\d+)?$' then round(Pression::decimal, 1) end as Pression,
    case when Humidite  ~ '^\d+$' then Humidite::integer end as Humidite,
    case when PointRosee  ~ '^-?\d+(.\d+)?$' then round(PointRosee::decimal, 1) end as PointRosee,
    case when VentMoyen  ~ '^\d+(.\d+)?$' then round(VentMoyen::decimal, 1) end as VentMoyen,
    case when DirectionVent  ~ '^\d+$' then DirectionVent::integer end as DirectionVent,
    case when Pluie1h  ~ '^\d+$' then Pluie1h::integer end as Pluie1h
from tmp.ReleveMeteo
where Longitude ~ '^\d+(.\d+)?$'
and Latitude ~ '^\d+(.\d+)?$';

commit;