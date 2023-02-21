-- TODO :
-- Adapter les requêtes de ce fichier de sorte à référencer les tables sources des données de construction et pour définir les bonnes emprises de construction.
-- Il convient d'avoir les données du département pour lequel il faut construire le référentiel routier ainsi que de ses départements limitophes.
-- Ceci est utile pour avoir le réseau sous convention de gestion d'entretien ou de VH qui se trouve au delà des limites départementales.

-- Copie des données sources pour les départements.
create table source_departement as
select
    code_insee,
    code_siren,
    nom_officiel,
    geometrie
from bdtopo_departement
where code_insee in ( -- le département pour lequel il faut construire le référentiel routier et ses départements limitrophes
    '07', -- Ardèche
    '12', -- Aveyron
    '13', -- Bouches-du-Rhône
    '26', -- Drôme
    '30', -- Gard
    '34', -- Hérault
    '48', -- Lozère
    '84'  -- Vaucluse
);

create unique index source_departement_code_insee on source_departement (code_insee);
create unique index source_departement_nom_officiel on source_departement (nom_officiel);

-- Copie des données sources pour les routes numerotées ou nommées.
create table source_route_numerotee_ou_nommee as
select
    cleabs,
    numero,
    type_de_route,
    gestionnaire
from bdtopo_route_numerotee_ou_nommee;

create unique index source_route_numerotee_ou_nommee_cleabs on source_route_numerotee_ou_nommee (cleabs);
create index source_route_numerotee_ou_nommee_type_de_route on source_route_numerotee_ou_nommee (type_de_route);

-- Copie des données sources pour les tronçons.
create table source_troncon_de_route as
select *
from d30limit_bdtopo_troncon_de_route t;

create unique index source_troncon_de_route_cleabs on source_troncon_de_route (cleabs);

-- Copie des données sources pour les points de repères.
create table source_point_de_repere as

-- NDLR :
-- Au département du Gard :
-- - les PR du réseau routier gardois sont repris de la version précédente du référentiel routier,
-- - les PR des autres réseaux sont pris depuis la BDTopo.
select
    NumeroRoute as route,
    PRA,
    'Gard' as gestionnaire,
    Geom as geometrie
from archive.pr_vmax
where NumeroRoute ~ '^D.*'
union
select 
    route,
    numero::integer * 10000 as PRA, -- NDLR : PRA équivaut à la valeur de PR * 10000 + Abs, exemple 3+250 -> 30250
    gestionnaire,
    geometrie
from bdtopo_point_de_repere pr
where gestionnaire <> 'Gard'
and numero ~ '^\d+$'
and code_insee_du_departement in (select code_insee from source_departement);

-- Analyse des tables de données sources.
analyze source_departement;
analyze source_route_numerotee_ou_nommee;
analyze source_troncon_de_route;
analyze source_point_de_repere;