A propos de la MSI
------------------

La Mission des Systèmes d'Information (MSI) assure pour la Direction Générale adjointe Mobilité et Logistique (DGaML) du Département du Gard la collecte, le traitement et la restitution de (géo)données.
Le Système d'Information géographique (SIg) dont elle assure l'exploitation porte le nom de SI3P0 pour Système d'Information 3.0 ; en référence au logo du Département du Gard et à un certain robot protocolaire bien connu.

A propos de SI3P0
-----------------

SI3P0 s'appuie fortement sur PostgreSQL/Postgis. En effet, le moteur ne sert pas seulement pour le stockage des données mais est également utilisé pour l'ensemble des (géo)traitements.

La base de données est scindée en 7 schémas :
- archive : schéma de stockage de tables archives
- d : schéma contenant des tables de données « à plat » sans relation entre elles
- f : schéma contenant les fonctions métiers
- m : schéma contenant le modèle de données relationnel géographique
- pc : schéma contenant des tables issues de pré-calculs afin d’optimiser certains traitements
- tmp : schéma de travail pour le stockage de tables, vues et fonctions temporaires
- v : schéma contenant des vues sur le modèle

A propos de la bibliothèque PowerShell
--------------------------------------

Pour interagir avec PostgreSQL/Postgis et automatiser un certain nombre de tâches, la MSI a développé une bibliothèque de fonctions PowerShell disponible dans le dossier API.
Cette bibliothèque, et les possibilités de manipulation des données offertes par PostgreSQL/Postigs, permettent à la MSI de se passer d’ETL.

La bibliothèque se veut être générique et réutilisable puisque seules quelques fonctions sont propres à SI3P0.
Pour pouvoir l'exploiter, il est d’abord nécessaire de définir plusieurs constantes dans les fichiers :
.\API\PowerShell\constantes.ps1
.\API\PowerShell\sig_défaut.ps1

Il est ensuite possible de vérifier le bon fonctionnement de la bibliothèque dans le contexte courant de travail en exécutant le fichier :
.\API\TU\PowerShell\exécuter.ps1

Liste non exhaustive des fonctions proposées :
- Telecharger
- Zipper
- Dezipper
- Exporter-CSV-Excel
- Exporter-CSV-Oracle
- Executer-Ogr2Ogr
- Executer-Shp2Pgsql
- Executer-Raster2Pgsql
- Rechercher-MDP-PGPass
- Executer-PSQL-Fichier
- Executer-PSQL-Commande
- Importer-CSV-PostgreSQL
- Exporter-CSV-PostgreSQL
- Importer-GeoJSON-Postgis
- Importer-SHP-Postgis
- Exporter-GeoJSON-Postgis
- Exporter-SHP-Postgis
- Exporter-DXF-Postgis

La bibliothèque propose en plus un ensemble de fonctions "jobs" pour paralléliser les traitements.

Cas d’usages de la bibliothèque
-------------------------------

Les autres dossiers publiés ici sont les traitements mis en place par la MSI pour les besoins de la DGaML.
Ils sont partiellement spécifiques aux besoins du Département du Gard mais servent d’exemple d’utilisation de la bibliothèque et peuvent pour une partie d’entre eux être adaptés et réutilisés.

- Adresses : Agrégation dans une unique table des adresses BAN et fictives Cadastre (DGFiP) avec mise à disposition de fonctions PL/pgSQL de géocodage
- BDTopo : Import des données de la version SQL L93 de la BDTopo IGN
- Cadastre : Téléchargement et import des données de cadastre.data.gouv.fr
- QPV : Téléchargement et import des limites des Quartiers Prioritaires de la politique de la Ville


Aucune contribution n’est attendue pour ce projet.
