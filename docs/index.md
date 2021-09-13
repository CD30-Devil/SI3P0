Salut à toi,

Tu trouveras ci-après différentes ressources pour réutiliser le code que nous mettons à ta disposition ici.

## A propos de la MSI

La Mission des Systèmes d'Information (MSI) assure pour la Direction Générale adjointe Mobilité et Logistique (DGaML) du Département du Gard la collecte, le traitement et la restitution de (géo)données.

Le Système d'Information géographique (SIg) dont elle assure l'exploitation porte le nom de SI3P0 pour Système d'Information 3.0 ; en référence au logo du Département du Gard et à un certain robot protocolaire bien connu.

## A propos de SI3P0

SI3P0 est un SIg qui s'appuie fortement sur PostgreSQL/Postgis.
Le moteur ne sert pas seulement pour le stockage des données mais est également utilisé pour l'ensemble des (géo)traitements.

La base de données est scindée en 7 schémas :
* archive : schéma de stockage de tables archives
* d : schéma contenant des tables de données « à plat » sans relation entre elles
* f : schéma contenant les fonctions métiers
* m : schéma contenant le modèle de données relationnel géographique
* pc : schéma contenant des tables issues de pré-calculs afin d’optimiser certains traitements
* tmp : schéma de travail pour le stockage de tables, vues et fonctions temporaires
* v : schéma contenant des vues sur le modèle

Pour interagir avec PostgreSQL/Postgis et automatiser un certain nombre de tâches, la MSI a développé une bibliothèque de fonctions PowerShell disponible dans le dossier API du projet.
Cette bibliothèque, et les possibilités de manipulation des données offertes par PostgreSQL/Postigs, permettent à la MSI de se passer d’ETL.

## Les ressources
* [Tutoriel : Prendre en main l’API PowerShell SI3P0](./MD/API - Prise en main.html).
* [Tutoriel : Réaliser un (Géo)Bot Twitter](./MD/GéoBot Twitter.html).