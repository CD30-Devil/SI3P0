-- suppression des points trop éloignés de la RD de rattachement (> 50 mètres)
delete
from tmp.RapportVideoVaisala rvv
where not exists (
    select true
    from v.TronconReel t
    where t.NumeroRoute = rvv.NumeroRoute
    and ST_DWithin(t.Geom, TransformerEnL93(FabriquerPointWGS84(rvv.Longitude::numeric, rvv.Latitude::numeric)), 50)
);

-- typage et mise en ordre des rapports vidéos
create table tmp.RapportVideoVaisalaOrdonne as
with RapportVideoVaisala as (
select
        to_timestamp(HeureUTC, 'YYYY-MM-DD HH24:MI') as DateHeure,
        NumeroRoute::varchar,
        Abs::numeric as CumulDist,
        Direction::varchar,
        URLImage::varchar,
		FabriquerPointWGS84(Longitude::numeric, Latitude::numeric) as Geom
    from tmp.RapportVideoVaisala
)
select
    row_number() over(order by DateHeure, NumeroRoute, Direction, case when Direction = 'Croissant' then CumulDist else -CumulDist end) as Id,
    DateHeure::date as Date,
    *,
    string_to_array(ST_AsLatLonText(Geom, 'D M S.SSSS C'), ' ') as LatLong
from RapportVideoVaisala;

-- création des index en vu de la constitution des séquences
create index RapportVideoVaisalaOrdonne_NumeroRoute_IDX on tmp.RapportVideoVaisalaOrdonne(NumeroRoute);
create index RapportVideoVaisalaOrdonne_Direction_IDX on tmp.RapportVideoVaisalaOrdonne(Direction);
create index RapportVideoVaisalaOrdonne_Date_IDX on tmp.RapportVideoVaisalaOrdonne(Date);

-- constitution des séquences par RD et direction
create table tmp.SequencesVaisala as
with recursive SequencesVaisala as (
    (
        -- recherche de la première image de chaque séquence
        -- la première image n'a pas d'autre image qui la précède sur la même RD, dans la même direction dans les 5 minutes qui précèdent
        select row_number() over() as IdSequence, 1 as IdImage, DateHeure as DebutSequence, rvvo1.*
        from tmp.RapportVideoVaisalaOrdonne rvvo1
        where not exists (
            select true
            from tmp.RapportVideoVaisalaOrdonne rvvo2
            where rvvo1.NumeroRoute = rvvo2.NumeroRoute
            and rvvo1.Direction = rvvo2.Direction
            and rvvo1.Date = rvvo2.Date
            and Age(rvvo1.DateHeure, rvvo2.DateHeure) between '0 minute'::interval and '5 minutes'::interval
            and rvvo1.Id > rvvo2.Id
        )
    )
    
    union all
    
    -- recherche des images suivantes
    select sv.IdSequence, sv.IdImage + 1 as IdImage, sv.DebutSequence, rvvo.*
    from SequencesVaisala sv
    cross join lateral (
        select *
        from tmp.RapportVideoVaisalaOrdonne rvvo
        where sv.NumeroRoute = rvvo.NumeroRoute
        and sv.Direction = rvvo.Direction
        and sv.Date = rvvo.Date
        and Age(rvvo.DateHeure, sv.DateHeure) between '0 minute'::interval and '5 minutes'::interval
        and rvvo.Id > sv.Id
        order by rvvo.Id
        limit 1
    ) rvvo
)
select
    IdSequence as "IdSequence",
    IdImage as "IdImage",
    to_char(DebutSequence at time zone 'utc', 'YYYY-MM-DD HH24-MI-SS') as "DebutSequence",
    NumeroRoute as "NumeroRoute",
    Direction as "Direction",
    to_char(DateHeure at time zone 'utc', 'YYYY/MM/DD HH24:MI:SS') as "DateHeure",
    URLImage as "URLImage",
    LatLong[1] as "LatitudeDeg",
    LatLong[2] as "LatitudeMin",
    LatLong[3] as "LatitudeSec",
    LatLong[4] as "LatitudeCard",
    LatLong[5] as "LongitudeDeg",
    LatLong[6] as "LongitudeMin",
    LatLong[7] as "LongitudeSec",
    LatLong[8] as "LongitudeCard",
    case
        when IdImage = 1 then degrees(ST_Azimuth(Geom, lead(Geom, 1) over(partition by IdSequence order by IdImage)))
        else degrees(ST_Azimuth(lag(Geom, 1) over(partition by IdSequence order by IdImage), Geom))
    end as "Angle"
from SequencesVaisala;

create index SequencesVaisala_IdSequence_IDX on tmp.SequencesVaisala("IdSequence");