-- schémas spécifiques SI3P0 (tmp = temporaire, m = modèle)
set search_path to tmp, m, public;

-- régions
create view Region_4Layer as
select
    COGRegion as "COGRegion",
    Nom as "Nom",
    Geom
from Region;

create view Region_4SHP as
select * from Region_4Layer;

-- départements
create view Departement_4Layer as
select
    d.COGDepartement as "COGDepartement",
    d.Nom as "Nom",
    d.COGRegion as "COGRegion",
    r.Nom as "NomRegion",
    d.Geom
from Departement d
left join Region r on r.COGRegion = d.COGRegion;

create view Departement_4SHP as
select
    "COGDepartement" as "COGDepart",
    "Nom",
    "COGRegion",
    "NomRegion",
    Geom
from Departement_4Layer;

-- EPCI
create view EPCI_4Layer as
select
    Siren as "SirenEPCI",
    Nom as "Nom",
    Nature as "Nature",
    Geom
from EPCIFederative;

create view EPCI_4SHP as
select * from EPCI_4Layer;

-- Communes
create view Commune_4Layer as
select
    c.COGCommune as "COGCommune",
    c.Nom as "Nom",
    c.Population as "Population",
    case when (c.ZoneMontagne) then 'Vrai' else 'Faux' end as "ZoneMontagne",
    c.SirenEPCI as "SirenEPCI",
    e.Nom as "NomEPCI",
    string_agg(ca.COGCanton, ', ' order by ca.COGCanton) as "ListeCOGCantons",
    string_agg(ca.Nom, ', ' order by ca.COGCanton) as "ListeNomCantons",
    case when bool_or(cc.ChefLieu) then 'Vrai' else 'Faux' end as "ChefLieuCanton",
    c.COGDepartement as "COGDepartement",
    d.Nom as "NomDepartement",
    c.Geom
from Commune c
left join EPCIFederative e on e.Siren = c.SirenEPCI
left join Commune_Canton cc on c.COGCommune = cc.COGCommune
left join Canton ca on cc.COGCanton = ca.COGCanton
left join Departement d on d.COGDepartement = c.COGDepartement
where c.COGDepartement = '30'
group by c.COGCommune, e.Siren, d.COGDepartement;

create view Commune_4SHP as
select
    "COGCommune",
    "Nom",
    "Population",
    "ZoneMontagne" as "Montagne",
    "SirenEPCI",
    "NomEPCI",
    "ListeCOGCantons" as "LstCOGCant",
    "ListeNomCantons" as "LstNomCant",
    "ChefLieuCanton" as "ChefCanton",
    "COGDepartement" as "COGDepart",
    "NomDepartement" as "NomDepart",
    Geom
from Commune_4Layer;

-- cantons
create view Canton_4Layer as
-- sous-requête de jointure des tables Canton, Commune_Canton et Commune
with JointureCantonCommune as (
    select ca.COGCanton, ca.Nom as NomCanton, cc.ChefLieu, co.COGCommune, co.Nom as NomCommune
    from Canton ca
    inner join Commune_Canton cc on cc.COGCanton = ca.COGCanton
    inner join Commune co on co.COGCommune = cc.COGCommune
    order by ca.COGCanton, co.COGCommune
),
-- sous-requête permettant de connaître le chef-lieu des cantons
ChefLieu as (
    select COGCanton, COGCommune, NomCommune
    from JointureCantonCommune
    where ChefLieu
),
-- sous-requête permettant de connaître la liste des communes des cantons
Composition as (
    select COGCanton, string_agg(COGCommune, ', ') as COGCommunes, string_agg(NomCommune, ', ') as NomCommunes
    from JointureCantonCommune
    group by COGCanton
)
select ca.COGCanton as "COGCanton", ca.Nom as "Nom", cl.COGCommune as "COGChefLieu", cl.NomCommune as "NomChefLieu", co.COGCommunes as "ListeCOGCommunes", co.NomCommunes as "ListeNomComumunes", Geom
from Canton ca
left join ChefLieu cl on cl.COGCanton = ca.COGCanton
left join Composition co on co.COGCanton = ca.COGCanton;

create view Canton_4SHP as
select
    "COGCanton",
    "Nom",
    "COGChefLieu" as "COGChef",
    "NomChefLieu" as "NomChef",
    "ListeCOGCommunes" as "LstCOGCom",
    "ListeNomComumunes" as "LstNomCom",
    Geom
from Canton_4Layer;