-------------------------------------------------------------------------------
-- Vue : BDT2RR_SourceTronconDeRoute
-------------------------------------------------------------------------------

-- Cette vue doit retourner une à une les colonnes de la source des tronçons issue de la BDTOPO.
-- Elle permet, si nécessaire, de renommer les colonnes de sorte à utiliser les dénominations longues de la BDTOPO.
-- Elle est notamment utilisée pour les fonctions de corrections présentes dans le fichier tmp(.f).correction bdtopo (create).sql.
-- Elle est également utilisée par la fonction LierTroncons présente dans le fichier tmp(.f).construction référentiel routier (create).sql pour la création de liens fictifs assurant la continuité des routes départementales.

-- Version pour une donnée source utilisant les noms longs.
create or replace view BDT2RR_SourceTronconDeRoute as
select
    geometrie,
    cleabs,
    nature,
    nom_1_gauche,
    nom_1_droite,
    nom_2_gauche,
    nom_2_droite,
    importance,
    fictif,
    position_par_rapport_au_sol,
    etat_de_l_objet,
    date_creation,
    date_modification,
    date_d_apparition,
    date_de_confirmation,
    sources,
    identifiants_sources,
    precision_planimetrique,
    precision_altimetrique,
    nombre_de_voies,
    largeur_de_chaussee,
    itineraire_vert,
    prive,
    sens_de_circulation,
    bande_cyclable,
    reserve_aux_bus,
    urbain,
    vitesse_moyenne_vl,
    acces_vehicule_leger,
    acces_pieton,
    periode_de_fermeture,
    nature_de_la_restriction,
    restriction_de_hauteur,
    restriction_de_poids_total,
    restriction_de_poids_par_essieu,
    restriction_de_largeur,
    restriction_de_longueur,
    matieres_dangereuses_interdites,
    borne_debut_gauche,
    borne_debut_droite,
    borne_fin_gauche,
    borne_fin_droite,
    insee_commune_gauche,
    insee_commune_droite,
    type_d_adressage_du_troncon,
    alias_gauche,
    alias_droit,
    code_postal_gauche,
    code_postal_droit,
    date_de_mise_en_service,
    identifiant_voie_1_gauche,
    identifiant_voie_1_droite,
    liens_vers_route_nommee,
    liens_vers_itineraire_autre,
    cpx_numero,
    cpx_numero_route_europeenne,
    cpx_classement_administratif,
    cpx_gestionnaire,
    cpx_toponyme_route_nommee,
    cpx_toponyme_itineraire_cyclable,
    cpx_toponyme_voie_verte,
    cpx_nature_itineraire_autre,
    cpx_toponyme_itineraire_autre
from source_troncon_de_route;

/*
-- Version pour une donnée source utilisant les noms courts (c-a-d le nommage des livrables SHP de la BDTopo).
-- La règle PostgreSQL qui suit est associée à cette version de la vue pour gérer le transtypage (gestion des booléens).
create or replace view BDT2RR_SourceTronconDeRoute as
select
    geom as geometrie,
    id as cleabs,
    nature as nature,
    nom_1_g as nom_1_gauche,
    nom_1_d as nom_1_droite,
    nom_2_g as nom_2_gauche,
    nom_2_d as nom_2_droite,
    importance as importance,
    (fictif = 'Oui') as fictif,
    pos_sol as position_par_rapport_au_sol,
    etat as etat_de_l_objet,
    date_creat as date_creation,
    date_maj as date_modification,
    date_app as date_d_apparition,
    date_conf as date_de_confirmation,
    source as sources,
    id_source as identifiants_sources,
    prec_plani as precision_planimetrique,
    prec_alti as precision_altimetrique,
    nb_voies as nombre_de_voies,
    largeur as largeur_de_chaussee,
    it_vert as itineraire_vert,
    prive as prive,
    sens as sens_de_circulation,
    cyclable as bande_cyclable,
    bus as reserve_aux_bus,
    urbain as urbain,
    vit_moy_vl as vitesse_moyenne_vl,
    acces_vl as acces_vehicule_leger,
    acces_ped as acces_pieton,
    fermeture as periode_de_fermeture,
    nat_restr as nature_de_la_restriction,
    restr_h as restriction_de_hauteur,
    restr_p as restriction_de_poids_total,
    restr_ppe as restriction_de_poids_par_essieu,
    restr_lar as restriction_de_largeur,
    restr_lon as restriction_de_longueur,
    restr_mat as matieres_dangereuses_interdites,
    bornedeb_g as borne_debut_gauche,
    bornedeb_d as borne_debut_droite,
    bornefin_g as borne_fin_gauche,
    bornefin_d as borne_fin_droite,
    inseecom_g as insee_commune_gauche,
    inseecom_d as insee_commune_droite,
    typ_adres as type_d_adressage_du_troncon,
    alias_g as alias_gauche,
    alias_d as alias_droit,
    c_postal_g as code_postal_gauche,
    c_postal_d as code_postal_droit,
    date_serv as date_de_mise_en_service,
    id_voie_g as identifiant_voie_1_gauche,
    id_voie_d as identifiant_voie_1_droite,
    id_rn as liens_vers_route_nommee,
    id_iti as liens_vers_itineraire_autre,
    numero as cpx_numero,
    num_europ as cpx_numero_route_europeenne,
    cl_admin as cpx_classement_administratif,
    gestion as cpx_gestionnaire,
    toponyme as cpx_toponyme_route_nommee,
    iti_cycl as cpx_toponyme_itineraire_cyclable,
    voie_verte as cpx_toponyme_voie_verte,
    nature_iti as cpx_nature_itineraire_autre,
    nom_iti as cpx_toponyme_itineraire_autre
from source_troncon_de_route;

create rule insert_BDT2RR_SourceTronconDeRoute as on insert to BDT2RR_SourceTronconDeRoute do instead
insert into source_troncon_de_route (
    geom,
    id,
    nature,
    nom_1_g,
    nom_1_d,
    nom_2_g,
    nom_2_d,
    importance,
    fictif,
    pos_sol,
    etat,
    date_creat,
    date_maj,
    date_app,
    date_conf,
    source,
    id_source,
    prec_plani,
    prec_alti,
    nb_voies,
    largeur,
    it_vert,
    prive,
    sens,
    cyclable,
    bus,
    urbain,
    vit_moy_vl,
    acces_vl,
    acces_ped,
    fermeture,
    nat_restr,
    restr_h,
    restr_p,
    restr_ppe,
    restr_lar,
    restr_lon,
    restr_mat,
    bornedeb_g,
    bornedeb_d,
    bornefin_g,
    bornefin_d,
    inseecom_g,
    inseecom_d,
    typ_adres,
    alias_g,
    alias_d,
    c_postal_g,
    c_postal_d,
    date_serv,
    id_voie_g,
    id_voie_d,
    id_rn,
    id_iti,
    numero,
    num_europ,
    cl_admin,
    gestion,
    toponyme,
    iti_cycl,
    voie_verte,
    nature_iti,
    nom_iti
) values (
    new.geometrie,
    new.cleabs,
    new.nature,
    new.nom_1_gauche,
    new.nom_1_droite,
    new.nom_2_gauche,
    new.nom_2_droite,
    new.importance,
    case new.fictif when true then 'Oui' else 'Non' end,
    new.position_par_rapport_au_sol,
    new.etat_de_l_objet,
    new.date_creation,
    new.date_modification,
    new.date_d_apparition,
    new.date_de_confirmation,
    new.sources,
    new.identifiants_sources,
    new.precision_planimetrique,
    new.precision_altimetrique,
    new.nombre_de_voies,
    new.largeur_de_chaussee,
    new.itineraire_vert,
    new.prive,
    new.sens_de_circulation,
    new.bande_cyclable,
    new.reserve_aux_bus,
    new.urbain,
    new.vitesse_moyenne_vl,
    new.acces_vehicule_leger,
    new.acces_pieton,
    new.periode_de_fermeture,
    new.nature_de_la_restriction,
    new.restriction_de_hauteur,
    new.restriction_de_poids_total,
    new.restriction_de_poids_par_essieu,
    new.restriction_de_largeur,
    new.restriction_de_longueur,
    new.matieres_dangereuses_interdites,
    new.borne_debut_gauche,
    new.borne_debut_droite,
    new.borne_fin_gauche,
    new.borne_fin_droite,
    new.insee_commune_gauche,
    new.insee_commune_droite,
    new.type_d_adressage_du_troncon,
    new.alias_gauche,
    new.alias_droit,
    new.code_postal_gauche,
    new.code_postal_droit,
    new.date_de_mise_en_service,
    new.identifiant_voie_1_gauche,
    new.identifiant_voie_1_droite,
    new.liens_vers_route_nommee,
    new.liens_vers_itineraire_autre,
    new.cpx_numero,
    new.cpx_numero_route_europeenne,
    new.cpx_classement_administratif,
    new.cpx_gestionnaire,
    new.cpx_toponyme_route_nommee,
    new.cpx_toponyme_itineraire_cyclable,
    new.cpx_toponyme_voie_verte,
    new.cpx_nature_itineraire_autre,
    new.cpx_toponyme_itineraire_autre
);
*/

-------------------------------------------------------------------------------
-- Vue : BDT2RR_Troncon
-------------------------------------------------------------------------------

-- L'objectif de cette vue est de donner les troncons :
--   - des routes départementales du gestionnaire,
--   - des routes nationales sur le périmètre du gestionnaire,
--   - des autoroutes sur le périmètre du gestionnaire.
-- Cette vue réutilise BDT2RR_SourceTronconDeRoute. Elle rend plus générique le code source de construction en factorisant notamment le filtre sur l'attribut 'cpx_gestionnaire'.
-- Ell gère également le cas des tronçons avec de multiples gestionnaires.
create or replace view BDT2RR_Troncon as
select
    s.NumeroRoute as NumeroRoute,
    t.insee_commune_gauche as CodeInseeGauche,
    t.insee_commune_droite as CodeInseeDroite,
    t.cleabs as IdIGN,
    t.cpx_classement_administratif as ClasseAdmin,
    t.etat_de_l_objet as Etat,
    case -- transformation du type chaîne en entier pour l'attribut importance
        when t.importance ~ '^[0-9]+$' then importance::integer
        else 0
    end as Niveau,
    t.itineraire_vert as ItineraireVert,
    t.fictif as Fictif,
    t.nature as Nature,
    t.sens_de_circulation as SensCirculation,
    t.nombre_de_voies as NbVoies,
    t.largeur_de_chaussee as Largeur,
    case -- transformation du type chaîne en entier pour l'attribut position_par_rapport_au_sol
        when t.position_par_rapport_au_sol ~ '^-{0,1}[0-9]+$' then position_par_rapport_au_sol::integer
        else 0
    end as PositionSol,
    t.acces_vehicule_leger as AccesVL,
    t.reserve_aux_bus as ReserveBus,
    t.bande_cyclable as BandeCyclable,
    t.acces_pieton as AccesPieton,
    t.prive as Prive,
    t.urbain as Urbain,
    t.vitesse_moyenne_vl as VitesseMoyenneVL,
    t.precision_planimetrique as PrecisionPlani,
    t.precision_altimetrique as PrecisionAlti,
    t.geometrie as Geom
from BDT2RR_SourceTronconDeRoute t
cross join lateral (select distinct regexp_split_to_table(t.cpx_numero, '/') as NumeroRoute) s
where (
    cpx_classement_administratif = 'Départementale'
    and 'Gard' = any (regexp_split_to_array(cpx_gestionnaire, '/')) -- Saisir ici le nom du département en respectant l'orthographe de la BDTopo.
)
or (
    cpx_classement_administratif in ('Nationale', 'Autoroute')
    and (
        insee_commune_gauche ~ '^30' -- Saisir ici le Code Officiel Géographique du département précédé de ^.
        or insee_commune_droite ~ '^30' -- Saisir ici le Code Officiel Géographique du département précédé de ^.
    )
);

-------------------------------------------------------------------------------
-- Vue : BDT2RR_PR
-------------------------------------------------------------------------------

-- L'objectif de cette vue est de donner les PR du département gestionnaire.
-- Elle peut être basée sur les données présentes dans la BDTopo IGN (cf. classe point_de_repere) ou sur un base PR que le département a à disposition.
-- Elle retourne 3 colonnes :
--    - NumeroRoute : le numéro de la route dans le respect de la syntaxe de la BDTopo (ex: D979, D6100, D2E).
--    - PRA : la valeur de PR+Abs du repère sous la forme 10000 * PR + Abs (ex : 5+0 -> 50000, 11+138 -> 110139, 2+1125 -> 21125).
--    - Geom : la localisation ponctuelle du PR.
create or replace view BDT2RR_PR as
select
    NumeroRoute,
    PRA,
    Geom
from source_pr;

-- Version basée sur la classe point_de_repere du thème transport de la BDTopo IGN.
/*
create or replace view BDT2RR_PR as
with PR as (
    select route, numero, cote, geometrie
    from source_pr
    where route ~ 'D.*'
    and numero ~ '^\d+$'
    and code_insee_du_departement = '30'
)
select
    route as NumeroRoute,
    numero::integer * 10000 as PRA,
    ST_Centroid(ST_Collect(geometrie)) as Geom
from PR
where cote <> 'G'
group by route, numero
union all
select
    route || '_G' as NumeroRoute,
    numero::integer * 10000 as PRA,
    ST_Centroid(ST_Collect(geometrie)) as Geom
from PR
where cote = 'G'
group by route, numero;
*/