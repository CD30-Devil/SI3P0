-- Création d'une copie des données sources pour les tronçons.
create table source_troncon_de_route as
select *
from pc.d30limit_bdtopo_troncon_de_route; -- Saisir ici la source pour les tronçons.

-- Création d'une copie des données sources pour les points de repères.
create table source_pr as
select *
from archive.pr_vmax; -- Saisir ici la source pour les points de repères.

-- Création des index.
create unique index source_troncon_de_route_cleabs on source_troncon_de_route (cleabs);
create index source_troncon_de_route_sens_de_circulation on source_troncon_de_route (sens_de_circulation);
create index source_troncon_de_route_insee_commune_gauche on source_troncon_de_route (insee_commune_gauche varchar_pattern_ops);
create index source_troncon_de_route_insee_commune_droite on source_troncon_de_route (insee_commune_droite varchar_pattern_ops);
create index source_troncon_de_route_cpx_classement_administratif on source_troncon_de_route (cpx_classement_administratif);
create index source_troncon_de_route_cpx_gestionnaire on source_troncon_de_route (cpx_gestionnaire);
create index source_troncon_de_route_geometrie on source_troncon_de_route using gist (geometrie);