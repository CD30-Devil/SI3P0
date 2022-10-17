-- schémas spécifiques SI3P0 (m = modèle, f = fonctions, d = données, tmp = temporaire)
set search_path to m, f, d, tmp, public;

start transaction;

set constraints all deferred;

-- nettoyage préalable
delete from Commune_Canton;
delete from Canton;
delete from Commune;
delete from EPCIFederative;
delete from Departement;
delete from Region;

-- insertion des régions depuis les données de la BDTOPO
insert into Region (COGRegion, Nom, Geom)
select code_insee, nom_officiel, geometrie from bdtopo_region;

-- insertion des départements depuis les données de la BDTOPO
insert into Departement (COGDepartement, COGRegion, Nom, Geom)
select code_insee, code_insee_de_la_region, nom_officiel, geometrie from bdtopo_departement;

-- insertion des EPCI fédératives depuis les données de la BDTOPO
insert into EPCIFederative (Siren, Nom, Nature, Geom)
select code_siren, nom_officiel, nature, geometrie from bdtopo_epci;

-- insertion des communes depuis les données de la BDTOPO
insert into Commune (COGCommune, COGDepartement, Nom, CodePostal, Population, Geom)
select code_insee, code_insee_du_departement, nom_officiel, code_postal, population, geometrie from bdtopo_commune;

-- ajout de l'attribut ZoneMontagne aux communes depuis les données de l'Occitanie
update Commune c
set ZoneMontagne = (zm.CodeZoneMontagne = '1.0')
from source_zonemontagne zm
where c.COGCommune = zm.InseeCommune;

-- ajout du lien commune <-> EPCI par analyse géographique ; la commune doit être recouverte par l'EPCI
with Commune_EPCI as (
    select c.COGCommune, e.Siren
    from Commune c
    inner join EPCIFederative e on ST_CoveredBy(c.Geom, e.Geom)
)
update Commune c
set SirenEPCI = ce.Siren
from Commune_EPCI ce
where c.COGCommune = ce.COGCommune;

-- insertion des cantons depuis les données de l'IGN
insert into Canton (COGCanton, Nom, Geom)
select id_can, nom_can, TransformerEnL93(Geom)
from source_canton
where Length(code_dep) = 2; -- on ne conserve que les cantons de France métropolitaine

-- ajout du lien commune <-> canton par analyse géographique ; le canton doit recouvrir au moins 1,5% de la commune
with IntersectionCommuneCanton as (
    select co.COGCommune, ca.COGCanton, ST_Area((ST_Dump(ST_CollectionExtract(ST_Intersection(co.Geom, ca.Geom), 3))).Geom)::numeric / ST_Area(co.Geom)::numeric as RatioSurface
    from Commune co
    inner join Canton ca
    on ST_Intersects(co.Geom, ca.Geom)
)
insert into Commune_Canton(COGCommune, COGCanton, ChefLieu)
select distinct COGCommune, COGCanton, false
from IntersectionCommuneCanton
where RatioSurface >= 0.015;

-- ajout de l'attribut ChefLieu à la relation commune <-> canton depuis les données de l'INSEE
with ChefLieuCanton as (
    select burcentral as COGCommune, id_canton as COGCanton
    from insee_cog_canton
)
update Commune_Canton cc
set ChefLieu = true
from ChefLieuCanton clc
where cc.COGCommune = clc.COGCommune
and cc.COGCanton = clc.COGCanton;

commit;

-- TODO affecter les numéros SIREN aux entités
-- SELECT * from sirene_unitelegale where categoriejuridique = '7220' AND etatadministratif = 'A' Département
-- 7210	Commune et commune nouvelle 
-- 7220	Département 
-- 7225	Collectivité et territoire d'Outre Mer
-- 7229	(Autre) Collectivité territoriale 
-- 7230	Région 
-- 7312	Commune associée et commune déléguée 
-- 7313	Section de commune 