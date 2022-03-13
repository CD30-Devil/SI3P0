﻿CREATE TABLE "troncon_de_route"();
SELECT AddGeometryColumn('troncon_de_route','geometrie',2154,'GEOMETRY',3);
CREATE INDEX "troncon_de_route_geometrie_geom_idx" ON "troncon_de_route" USING GIST ("geometrie");
ALTER TABLE "troncon_de_route" ADD COLUMN "cleabs" VARCHAR(24);
ALTER TABLE "troncon_de_route" ADD COLUMN "nature" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "nom_1_gauche" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "nom_1_droite" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "nom_2_gauche" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "nom_2_droite" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "importance" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "fictif" BOOLEAN;
ALTER TABLE "troncon_de_route" ADD COLUMN "position_par_rapport_au_sol" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "etat_de_l_objet" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "date_creation" timestamp with time zone;
ALTER TABLE "troncon_de_route" ADD COLUMN "date_modification" timestamp with time zone;
ALTER TABLE "troncon_de_route" ADD COLUMN "date_d_apparition" date;
ALTER TABLE "troncon_de_route" ADD COLUMN "date_de_confirmation" date;
ALTER TABLE "troncon_de_route" ADD COLUMN "sources" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "identifiants_sources" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "precision_planimetrique" NUMERIC(5,1);
ALTER TABLE "troncon_de_route" ADD COLUMN "precision_altimetrique" NUMERIC(5,1);
ALTER TABLE "troncon_de_route" ADD COLUMN "nombre_de_voies" INTEGER;
ALTER TABLE "troncon_de_route" ADD COLUMN "largeur_de_chaussee" NUMERIC(5,1);
ALTER TABLE "troncon_de_route" ADD COLUMN "itineraire_vert" BOOLEAN;
ALTER TABLE "troncon_de_route" ADD COLUMN "prive" BOOLEAN;
ALTER TABLE "troncon_de_route" ADD COLUMN "sens_de_circulation" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "bande_cyclable" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "reserve_aux_bus" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "urbain" BOOLEAN;
ALTER TABLE "troncon_de_route" ADD COLUMN "vitesse_moyenne_vl" INTEGER;
ALTER TABLE "troncon_de_route" ADD COLUMN "acces_vehicule_leger" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "acces_pieton" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "periode_de_fermeture" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "nature_de_la_restriction" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "restriction_de_hauteur" NUMERIC(5,2);
ALTER TABLE "troncon_de_route" ADD COLUMN "restriction_de_poids_total" NUMERIC(5,2);
ALTER TABLE "troncon_de_route" ADD COLUMN "restriction_de_poids_par_essieu" NUMERIC(5,2);
ALTER TABLE "troncon_de_route" ADD COLUMN "restriction_de_largeur" NUMERIC(5,2);
ALTER TABLE "troncon_de_route" ADD COLUMN "restriction_de_longueur" NUMERIC(5,2);
ALTER TABLE "troncon_de_route" ADD COLUMN "matieres_dangereuses_interdites" BOOLEAN;
ALTER TABLE "troncon_de_route" ADD COLUMN "borne_debut_gauche" VARCHAR(15);
ALTER TABLE "troncon_de_route" ADD COLUMN "borne_debut_droite" VARCHAR(15);
ALTER TABLE "troncon_de_route" ADD COLUMN "borne_fin_gauche" VARCHAR(15);
ALTER TABLE "troncon_de_route" ADD COLUMN "borne_fin_droite" VARCHAR(15);
ALTER TABLE "troncon_de_route" ADD COLUMN "insee_commune_gauche" VARCHAR(5);
ALTER TABLE "troncon_de_route" ADD COLUMN "insee_commune_droite" VARCHAR(5);
ALTER TABLE "troncon_de_route" ADD COLUMN "type_d_adressage_du_troncon" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "alias_gauche" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "alias_droit" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "code_postal_gauche" VARCHAR(5);
ALTER TABLE "troncon_de_route" ADD COLUMN "code_postal_droit" VARCHAR(5);
ALTER TABLE "troncon_de_route" ADD COLUMN "date_de_mise_en_service" date;
ALTER TABLE "troncon_de_route" ADD COLUMN "identifiant_voie_1_gauche" VARCHAR(9);
ALTER TABLE "troncon_de_route" ADD COLUMN "identifiant_voie_1_droite" VARCHAR(9);
ALTER TABLE "troncon_de_route" ADD COLUMN "liens_vers_route_nommee" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "liens_vers_itineraire_autre" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "cpx_numero" VARCHAR(32);
ALTER TABLE "troncon_de_route" ADD COLUMN "cpx_numero_route_europeenne" VARCHAR(32);
ALTER TABLE "troncon_de_route" ADD COLUMN "cpx_classement_administratif" VARCHAR(30);
ALTER TABLE "troncon_de_route" ADD COLUMN "cpx_gestionnaire" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "cpx_toponyme_route_nommee" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "cpx_toponyme_itineraire_cyclable" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "cpx_toponyme_voie_verte" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "cpx_nature_itineraire_autre" VARCHAR;
ALTER TABLE "troncon_de_route" ADD COLUMN "cpx_toponyme_itineraire_autre" VARCHAR;

