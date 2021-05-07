# Tutoriel : Prendre en main l’API PowerShell SI3P0.

Ce tutoriel montre comment l’API PowerShell SI3P0 peut permettre l’automatisation de traitements de données en lien avec un SIg construit sur PostgreSQL/Postgis.

Il est illustré par un cas pratique de téléchargement, d’import et d’exploitation des données de la Base Adresse Nationale.

_NDLR : Le terme API est peut-être mal choisi, le mot “toolkox” serait probablement plus adapté. Vu le nombre de références au dossier qui porte ce nom dans le code, j’avoue être faiblement motivé par l’idée de le renommer._

Pré-requis :
* Se dire que PowerShell, c’est comme tout, ça s’apprend.
* Avoir un SIg basé sur le couple PostgreSQL/Postgis.
* Avoir un client Windows qui :
    * permet la création et l’exécution de scripts PowerShell,
    * dispose des outils clients PostgreSQL/Postgis (dont principalement psql.exe),
    * dispose de ogr2ogr.exe.

## 1. SI3Pquoi ?
SI3P0 pour Systèmes d’Information 3.0 ; c’est le nom donné au SIg que nous développons à la Mission des Systèmes d’Information (MSI) pour la direction “routes et bâtiments” du Gard. Il fait référence au logo de la collectivité et au code INSEE de notre [chauvin=’on’]magnifique département[chauvin=’off’].

## 2. Pourquoi une boîte à outils ?

Classiquement, un SIg se construit autour de 3 briques :
* un Système de Gestion de Bases de Données géographiques (SGBDg),
* des outils de visualisation,
* un logiciel d’extraction, de transformation et de chargement des données (ETL).

![SIg avec ETL](./Ressources/API - Prise en main/SIg avec ETL.png)
(en construction)