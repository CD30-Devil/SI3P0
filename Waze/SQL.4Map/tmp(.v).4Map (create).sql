-- carte de l'état du réseau routier
create view tmp.RalentissementWaze_4Map as
select
    to_char(DateCreation, 'DD/MM/YYYY HH24:mi') as "Date de création ",
    Niveau                                      as "Niveau            ",
    round(VitesseMS * 3.6, 1)                   as "Vitesse Km/H       ",
     'Ralentissements et fermetures' as NomCouche,
    case Niveau
        when 0 then '#F8FF19'::character varying
        when 1 then '#FEDA00'::character varying
        when 2 then '#FFB400'::character varying
        when 3 then '#FF6E09'::character varying
        when 4 then '#FD2100'::character varying
        when 5 then '#000000'::character varying
    end as Couleur,
    r.Geom
from m.RalentissementWaze r
inner join v.Gard g on ST_Intersects(g.Geom, r.Geom);

create view tmp.AlerteWaze_4Map as
with Alerte as (
    select
        *,
        (Age(Now(), DateCreation) < interval '60 minutes') as Recente,
        (p._NumeroRoute is not null) as ProcheRD
    from AlerteWaze a
    left join PointVersPRA(Geom, 25) p on true
    order by DateCreation desc
)
select
    a.Recente,
    a.ProcheRD,
    a.IdTypeAlerteWaze,
    to_char(a.DateCreation, 'DD/MM/YYYY HH24:mi')                           as "Date de création ",
    case when a._NumeroRoute is null then 'Hors RD' else a._NumeroRoute end as "RD                ",
    case when a._PRA is null then 'Hors RD' else PRAEnTexte(a._PRA) end     as "PR+Abs             ",
    t.Description                                                           as "Type                ",
    st.Description                                                          as "Sous-type            ",
    a.Fiabilite                                                             as "Fiabilité             ",
    case
        when a.Recente and a.ProcheRD and a.IdSousTypeAlerteWaze <> '' then 'http://si3p0/Ressources/Images/Waze/70x70/couleur/' || a.IdSousTypeAlerteWaze || '.png'::varchar
        when a.Recente and a.ProcheRD and a.IdSousTypeAlerteWaze = '' then 'http://si3p0/Ressources/Images/Waze/70x70/couleur/' || a.IdTypeAlerteWaze || '.png'::varchar
        when not(a.Recente and a.ProcheRD) and a.IdSousTypeAlerteWaze <> '' then 'http://si3p0/Ressources/Images/Waze/70x70/gris/' || a.IdSousTypeAlerteWaze || '.png'::varchar
        when not(a.Recente and a.ProcheRD) and a.IdSousTypeAlerteWaze = '' then 'http://si3p0/Ressources/Images/Waze/70x70/gris/' || a.IdTypeAlerteWaze || '.png'::varchar
        else 'http://si3p0/Ressources/Images/Waze/70x70/couleur/MISC.png'::varchar
    end as Icone,
    case
        when a.IdSousTypeAlerteWaze <> '' then st.Description
        else t.Description
    end as Legende,
    a.Geom
from Alerte a
inner join m.TypeAlerteWaze t on a.IdTypeAlerteWaze = t.IdTypeAlerteWaze
inner join m.TypeAlerteWaze st on a.IdSousTypeAlerteWaze = st.IdTypeAlerteWaze
where a.IdTypeAlerteWaze not in ('JAM', 'ROAD_CLOSED')
order by Legende;

create view tmp.AlerteWazeRecenteEtProcheRD_4Map as
select
    "Date de création ",
    "RD                ",
    "PR+Abs             ",
    "Type                ",
    "Sous-type            ",
    "Fiabilité             ",
    'Alertes récentes et proches RD' as NomCouche,
    Icone,
    Legende,
    Geom
from tmp.AlerteWaze_4Map
where Recente and ProcheRD;

create view tmp.AlerteWazeAncienneEtProcheRD_4Map as
select
    "Date de création ",
    "RD                ",
    "PR+Abs             ",
    "Type                ",
    "Sous-type            ",
    "Fiabilité             ",
    'Alertes anciennes et proches RD' as NomCouche,
    Icone,
    Geom
from tmp.AlerteWaze_4Map
where not(Recente) and ProcheRD;

create view tmp.AlerteWazeEloigneeRD_4Map as
select
    "Date de création ",
    "RD                ",
    "PR+Abs             ",
    "Type                ",
    "Sous-type            ",
    "Fiabilité             ",
    'Alertes hors RD' as NomCouche,
    Icone,
    Geom
from tmp.AlerteWaze_4Map
where not(ProcheRD);

-- carte des zones accidentogènes
create view tmp.ZoneAccidentogene_4Map as
with ClusterAccidentsGraves as (
    select unnest(ST_ClusterWithin(Geom, 500)) as Geom
    from m.HistoAlerteWaze
    where IdTypeAlerteWaze = 'ACCIDENT'
    and IdSousTypeAlerteWaze = 'ACCIDENT_MAJOR'
    and Age(current_date, DateCreation::date) between interval '1 day' and interval '365 days'
)
select
    _NumeroRoute     as "RD ",
    PRAEnTexte(_PRA) as "PR+Abs ",
    'Zones accidentogènes' as NomCouche,
    ST_Envelope(Geom) as Geom
from ClusterAccidentsGraves, PointVersPRA(ST_Centroid(Geom))
where ST_NumGeometries(Geom) >= 5;

create view tmp.AccidentZoneAccidentogene_4Map as
select
    to_char(DateCreation, 'DD/MM/YYYY HH24:mi') as "Date de création ",
    _NumeroRoute                                as "RD                ",
    PRAEnTexte(_PRA)                            as "PR+Abs             ",
    'Accident sans classification'              as "Type                ",
    Fiabilite                                   as "Fiabilité            ",
    'http://si3p0/Ressources/Images/Waze/70x70/couleur/ACCIDENT.png'::varchar as Icone,
    'Accident sans classification' as NomCouche,
    'Accident sans classification' as Legende,
    h.Geom
from m.HistoAlerteWaze h
inner join PointVersPRA(h.Geom) on true
inner join tmp.ZoneAccidentogene_4Map z on ST_Intersects(z.Geom, h.Geom)
where h.IdSousTypeAlerteWaze = 'ACCIDENT' and h.IdSousTypeAlerteWaze = ''
and Age(current_date, h.DateCreation::date) between interval '1 day' and interval '365 days';

create view tmp.AccidentGraveZoneAccidentogene_4Map as
select
    to_char(DateCreation, 'DD/MM/YYYY HH24:mi')                                                     as "Date de création ",
    _NumeroRoute                                                                                    as "RD                ",
    PRAEnTexte(_PRA)                                                                                as "PR+Abs             ",
    'Accident grave'                                                                                as "Type                ",
    Fiabilite                                                                                       as "Fiabilité            ",
    'https://www.midilibre.fr/articles/' || to_char(DateCreation, 'YYYY/MM/DD/')                    as "Lien MidiLibre.fr Jour J ",
    'https://www.midilibre.fr/articles/' || to_char(DateCreation + interval '1 day', 'YYYY/MM/DD/') as "Lien MidiLibre.fr Jour J+1 ",
    'https://www.objectifgard.com/' || to_char(DateCreation, 'YYYY/MM/DD/')                         as "Lien ObjectifGard.fr Jour J ",
    'https://www.objectifgard.com/' || to_char(DateCreation + interval '1 day', 'YYYY/MM/DD/')      as "Lien ObjectifGard.fr Jour J+1 ",
    'http://si3p0/Ressources/Images/Waze/70x70/couleur/ACCIDENT_MAJOR.png'::varchar as Icone,
    'Accidents graves' as NomCouche,
    'Accidents graves' as Legende,
    h.Geom
from m.HistoAlerteWaze h
inner join PointVersPRA(h.Geom) on true
inner join tmp.ZoneAccidentogene_4Map z on ST_Intersects(z.Geom, h.Geom)
where h.IdSousTypeAlerteWaze = 'ACCIDENT_MAJOR'
and Age(current_date, h.DateCreation::date) between interval '1 day' and interval '365 days';

create view tmp.AutreAccidentZoneAccidentogene_4Map as
select
    to_char(DateCreation, 'DD/MM/YYYY HH24:mi') as "Date de création ",
    _NumeroRoute                                as "RD                ",
    PRAEnTexte(_PRA)                            as "PR+Abs             ",
    case
        when IdSousTypeAlerteWaze = 'ACCIDENT_MINOR' then 'Accident léger'::varchar
        else 'Accident (gravitée non définie)'::varchar
    end                                         as "Type                ",
    Fiabilite                                   as "Fiabilité            ",
    case
        when IdSousTypeAlerteWaze = 'ACCIDENT_MINOR' then 'http://si3p0/Ressources/Images/Waze/70x70/couleur/ACCIDENT_MINOR.png'::varchar
        else 'http://si3p0/Ressources/Images/Waze/70x70/couleur/ACCIDENT.png'::varchar
    end as Icone,
    'Autres accidents' as NomCouche,
    case
        when IdSousTypeAlerteWaze = 'ACCIDENT_MINOR' then 'Accidents légers'::varchar
        else 'Accidents (gravitée non définie)'::varchar
    end as Legende,
    h.Geom
from m.HistoAlerteWaze h
inner join PointVersPRA(h.Geom) on true
inner join tmp.ZoneAccidentogene_4Map z on ST_Intersects(z.Geom, h.Geom)
where h.IdTypeAlerteWaze = 'ACCIDENT' and h.IdSousTypeAlerteWaze <> 'ACCIDENT_MAJOR'
and Age(current_date, h.DateCreation::date) between interval '1 day' and interval '365 days'
order by Legende desc;

-- carte des nids-de-poule
create view tmp.NidDePoule_4Map as
select
    to_char(DateCreation, 'DD/MM/YYYY HH24:mi') as "Date de création ",
    _NumeroRoute                                as "RD                ",
    PRAEnTexte(_PRA)                            as "PR+Abs             ",
    Fiabilite                                   as "Fiabilité           ",
    'http://si3p0/Ressources/Images/Waze/70x70/couleur/HAZARD_ON_ROAD_POT_HOLE.png'::varchar as Icone,
    Age(current_date, h.DateCreation::date) as Age,
    h.Geom
from m.HistoAlerteWaze h
inner join PointVersPRA(h.Geom) p on true
where h.IdSousTypeAlerteWaze = 'HAZARD_ON_ROAD_POT_HOLE';

create view tmp.NidDePouleJ1J7_4Map as
select
    "Date de création ",
    "RD                ",
    "PR+Abs             ",
    "Fiabilité           ",
    'Nids-de-poule signalés entre jour J-1 et jour J-7' as NomCouche,
    Icone,
    Geom
from tmp.NidDePoule_4Map
where Age between interval '1 day' and interval '7 days';

create view tmp.NidDePouleJ8J15_4Map as
select
    "Date de création ",
    "RD                ",
    "PR+Abs             ",
    "Fiabilité           ",
    'Nids-de-poule signalés entre jour J-8 et jour J-15' as NomCouche,
    Icone,
    Geom
from tmp.NidDePoule_4Map
where Age between interval '8 days' and interval '15 days';

create view tmp.NidDePouleJ16J30_4Map as
select
    "Date de création ",
    "RD                ",
    "PR+Abs             ",
    "Fiabilité           ",
    'Nids-de-poule signalés entre jour J-16 et jour J-30' as NomCouche,
    Icone,
    Geom
from tmp.NidDePoule_4Map
where Age between interval '16 days' and interval '30 days';