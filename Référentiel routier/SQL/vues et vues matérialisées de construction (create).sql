-------------------------------------------------------------------------------
-- Vue matérialisée : BDT2RR_Departement
--
-- Cette vue matérialisée permet d'isoler de source_departement le département
-- pour lequel on souhaite construire le référentiel routier.
-------------------------------------------------------------------------------
create materialized view BDT2RR_Departement as
select
    code_insee as COGDepartement,
    code_siren as Siren,
    geometrie as Geom
from source_departement
where code_insee = '30'; -- TODO : Saisir ici le code du département.

create index BDT2RR_Departement_Geom on BDT2RR_Departement using gist (Geom);

-------------------------------------------------------------------------------
-- Vue : BDT2RR_Troncon
--
-- Cette vue matérialisée permet de récupérer les données des tronçons qui sont
-- nécessaires à la construction du référentiel routier départemental.
-------------------------------------------------------------------------------
create materialized view BDT2RR_Troncon as
select
    -- NDLR :
    -- Au département du Gard, la règle de nommage retenu pour les routes est :
    -- - nom court pour les autoroutes et nationale, exemples : A9, N106
    -- - nom court pour les routes départementales en gestion, exemples : D1, D135, D6086
    -- - nom court préfixé par le COG du département pour les autrres routes départementales, exemples : 34D107E4, 48D118
    case
        when r.type_de_route in ('Nationale', 'Autoroute') then r.numero
        when d.code_insee in (select COGDepartement from BDT2RR_Departement) then r.numero
        else concat(coalesce(d.code_insee, 'NC'), r.numero)
    end as NumeroRoute,
    
    -- références
    t.cleabs as IdIGN,
    r.cleabs as IdIGNRoute,
    t.insee_commune_gauche as COGCommuneGauche,
    t.insee_commune_droite as COGCommuneDroite,
    
    -- caractéristiques techniques du tronçon
    t.fictif as Fictif,
    t.importance as Importance,
    t.nature as Nature,
    t.nombre_de_voies as NbVoies,
    t.largeur_de_chaussee as Largeur,
    case
        when t.position_par_rapport_au_sol ~ '^-{0,1}[0-9]+$' then position_par_rapport_au_sol::integer
        else 0
    end as PositionSol,
    (t.position_par_rapport_au_sol = 'Gué ou radier') as GueOuRadier,
    
    -- caractéristiques administratives du tronçon
    r.type_de_route as ClasseAdmin,
    r.gestionnaire as NomGestionnaireRoute,
    d.code_insee as COGGestionnaireRoute,
    d.code_siren as SirenGestionnaireRoute,
    t.urbain as Urbain,
    t.prive as Prive,
    
    -- caractéristiques de circulation du tronçon
    t.sens_de_circulation as SensCirculation,
    t.itineraire_vert as ItineraireVert,
    t.delestage as Delestage,
    t.matieres_dangereuses_interdites as MatDangereusesInterdites,
    t.restriction_de_longueur as RestrictionLongueur,
    t.restriction_de_largeur as RestrictionLargeur,
    t.restriction_de_poids_par_essieu as RestrictionPoidsParEssieu,
    t.restriction_de_poids_total as RestrictionPoidsTotal,
    t.restriction_de_hauteur as RestrictionHauteur,
    t.nature_de_la_restriction as NatureRestriction,
    t.periode_de_fermeture as PeriodeFermeture,
    t.acces_pieton as AccesPieton,
    t.acces_vehicule_leger as AccesVL,
    t.vitesse_moyenne_vl as VitesseMoyenneVL,
    t.reserve_aux_bus as ReserveBus,
    
    -- caractéristiques de circulation cyclable du tronçon
    t.sens_amenagement_cyclable_gauche as SensAmngtCyclableGauche,
    t.sens_amenagement_cyclable_droit as SensAmngtCyclableDroit,
    t.amenagement_cyclable_gauche as AmngtCyclableGauche,
    t.amenagement_cyclable_droit as AmngtCyclableDroit,
    
    -- caractéristiques de la géométrie
    t.precision_planimetrique as PrecisionPlani,
    t.precision_altimetrique as PrecisionAlti,
    t.geometrie as Geom
    
from source_troncon_de_route t
inner join source_route_numerotee_ou_nommee r on r.cleabs = any (regexp_split_to_array(t.liens_vers_route_nommee, '/'))
left join source_departement d on r.gestionnaire = d.nom_officiel
where r.type_de_route in ('Départementale', 'Nationale', 'Autoroute');

create index BDT2RR_Troncon_NumeroRoute on BDT2RR_Troncon (NumeroRoute);
create index BDT2RR_Troncon_IdIGN on BDT2RR_Troncon (IdIGN);
create index BDT2RR_Troncon_sens_de_circulation on BDT2RR_Troncon (SensCirculation);
create index BDT2RR_Troncon_Geom on BDT2RR_Troncon using gist (Geom);

-------------------------------------------------------------------------------
-- Vue : BDT2RR_PR
-- 
-- Cette vue matérialisée permet de récupérer les données des points de repères
-- qui sont nécessaires à la construction du référentiel routier départemental.
-------------------------------------------------------------------------------
create materialized view BDT2RR_PR as
select
    case
        when d.code_insee in (select COGDepartement from BDT2RR_Departement) then pr.route
        else concat(coalesce(d.code_insee, ''), pr.route)
    end as NumeroRoute,
    pr.PRA,
    pr.geometrie as Geom
from source_point_de_repere pr
left join source_departement d on pr.gestionnaire = d.nom_officiel;