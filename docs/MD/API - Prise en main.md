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

Table des matières
1. SI3Pquoi ?
2. Pourquoi une boîte à outils ?
	1. "Donnez-moi un T !"
	2. "Donnez- moi un E ! Donnez-moi un L !"
	3. ELT et TEL
	4. Quelques mots sur PowerShell
3. API SI3P0 et BAN
	1. Etape 1 - Préparer le contexte de travail
		1. Récupérer l’API SI3P0
		2. (Facultatif) Installer 7-Zip
		3. Créer une base de tests
		4. Ajouter les informations de connexion au PGPASS
		5. Modifier le fichier constantes.ps1
		6. Modifier le fichier sig_défaut.ps1
		7. (Facultatif) Nettoyer le code spécifique au Gard

## 1. SI3Pquoi ?

SI3P0 pour Systèmes d’Information 3.0 ; c’est le nom donné au SIg que nous développons à la Mission des Systèmes d’Information (MSI) pour la direction “routes et bâtiments” du Gard. Il fait référence au logo de la collectivité et au code INSEE de notre [chauvin=’on’]magnifique département[chauvin=’off’].

## 2. Pourquoi une boîte à outils ?

Classiquement, un SIg se construit autour de 3 briques :
* un Système de Gestion de Bases de Données géographiques (SGBDg),
* des outils de visualisation,
* un logiciel d’extraction, de transformation et de chargement des données (ETL).

![SIg avec ETL](../Ressources/API - Prise en main/SIg avec ETL.png)

Lorsque les moyens financiers manquent, difficile de faire l’impasse sur le SGBDg et les outils de visualisation. Mais PostgreSQL/Postgis et QGis font très bien le job.

L’ETL est quant à lui remplacé par une brique moins onéreuse ; classiquement appelée le “Shadok”.
Le “Shadok” c’est quoi ? Et bien le “Shadok” c’est toi ;
* Toi qui télécharges tous les mois la dernière mise à jour des données avec ton navigateur favori.
* Toi qui fais “clic-droit > extraire vers" pour décompresser une à une les 42 archives fraîchement téléchargées.
* Toi qui enfin importes les données dans la base avec des outils graphiques type “Postgis Shapefile Import/Export Manager”.

![SIg avec Shadok](../Ressources/API - Prise en main/SIg avec Shadok.png)

A la MSI nous n’avons pas de budget alloué et notre équipe se compte sur les doigts d’une demi-main. Mais, comme tout bon informaticien qui se respecte...on est feignant !

### 2.1. "Donnez-moi un T !"

L’ETL transforme. Tu peux grâce à lui croiser, filtrer, grouper, sélectionner, adapter (et plein d’autres verbes à l’infinitif) tes données. Mais ceux qui suivent auront noté que dans SGBGg il y a “Gestion” et “Données”. Aussi, il est tout à fait possible de faire faire les transformations au serveur de bases. Le SGBDg n’est plus seulement vu comme la brique de stockage mais aussi comme serveur de (géo)traitements.

Ce principe selon lequel le “code” est placé au niveau du SGBD porte le nom de base épaisse. Ce n’est pas l’objet du tutoriel aussi je t’invite à [lire le “Plaidoyer de Frédéric Brouard” pour en savoir plus](https://www.yumpu.com/fr/document/read/51018012/plaidoyer-de-frederic-brouard-sur-le-concept-de-bases-de-donnees-epaisses). 

### 2.2. "Donnez- moi un E ! Donnez-moi un L !"

En revanche, le SGBD n’est pas l’outil le plus adapté pour interagir avec le système de fichiers même si certaines choses sont possibles ; foreign data, copy from file. Et surtout le SGBD n’ira pas récupérer la matière sur le net pour toi.

C’est là qu’intervient l’API. Celle-ci propose notamment des fonctions :
* de téléchargement,
* de manipulation d’archives dont certaines avec l’appui de 7-Zip,
* d’import-export de (géo)données via psql et ogr2ogr.

Elle donne également la possibilité de paralléliser les traitements grâce à ce que nous appelons des “jobs” qui lancent simultanément plusieurs processus. Il est ainsi possible d’exploiter au mieux les ressources machines et par conséquent de réduire les temps de traitement.

### 2.3. ELT et TEL

Puisqu’il est question de transformer les données grâce aux SGBDg, l’approche sera légèrement différente du classique schéma ETL.

En entrée, il faudra charger les données “au plus tôt” dans la base pour pouvoir les adapter au modèle cible ; ELT pour Extract Load Transform.

En sortie, il faudra extraire les données “au plus tard” après qu’elles aient été rendues compatibles avec le format attendu ; TEL pour Transform Extract Load.

![SIg sans ETL](../Ressources/API - Prise en main/ELT - TEL.png)

### 2.4. Quelques mots sur PowerShell

PowerShell est à Windows ce que Bash est à Linux. Au placard donc les .BAT, c’est l’heure de faire des .PS1.

Ce langage de script propose de nombreuses cmdlet (prononcer commandlette) pour réaliser différentes opérations allant du simple Write-Host, pour écrire sur la sortie standard, au Invoke-WebRequest et ses multiples paramètres pour envoyer une requête HTTP/HTTPS.

Si malgré tout, tu ne trouves pas la cmdlet qu’il te faut, tu pourras créer tes propres fonctions et profiter de la richesse du Framework .NET sur lequel PowerShell s’appuie.

Comme PowerShell est inclus à Windows, même si tu n’as pas de droits administrateurs dans ton contexte professionnel, il est probable que tu ais accès à :
Windows PowerShell (powershell.exe) : l’interface ligne de commande,
Windows PowerShell ISE (powershell_ise.exe) : un éditeur de scripts simple mais complet puisqu’il permet l’exécution pas à pas et le debug.

![SIg sans ETL](../Ressources/API - Prise en main/Debug PowerShell ISE.png)

## 3. API SI3P0 et BAN

L’API Adresse disponible sur Etalab propose la point d’entrée /search/ pour le géocodage. Lorsque le numéro est introuvable, un point au centre de la rue (type street) est retourné.

Dans notre cas, si le numéro est absent, nous souhaitons que le numéro le plus proche soit retourné. Nous avons pour cela automatisé le téléchargement et l’import des données de la BAN dans le SIg et avons développé une fonction PL/pgSQL de géocodage. Celle-ci est moins souple/puissante que la version Etalab et ne se base que sur les adresses présentent dans le SIg, mais elle est suffisante pour nos besoins.

Le tutoriel qui suit s’appuie sur ce cas d’usage.

### 3.1. Etape 1 - Préparer le contexte de travail

_"Nombreuses les étapes préparatoires sont, de patience t’armer tu dois"_. Je plaisante même s’il est vrai qu’il y a plusieurs choses à faire préalablement à l’utilisation de l’API. J’ai essayé de détailler ici les différents “level” à passer pour que tu sois ensuite opérationnel pour la rédaction de scripts PowerShell, c’est donc un peu verbeux mais pas forcément très long.

#### 3.1.1. Récupérer l’API SI3P0

L’API SI3P0, ainsi que le code propre à certains de nos cas d’usages, sont disponibles sous licence BSD-3 à l’emplacement suivant : [https://github.com/CD30-Devil/SI3P0](https://github.com/CD30-Devil/SI3P0)

Le sous-dossier API est suffisant mais les autres répertoires peuvent à minima servir d’exemple voire être réutilisables moyennant quelques adaptations (notamment pour les collègues territoriaux qui travaillent sur des thématiques équivalentes aux nôtres).

Commence donc par récupérer ce “repo” par téléchargement et extraction du Zip ou en créant un fork du projet.

#### 3.1.2. (Facultatif) Installer 7-Zip

7-Zip est un logiciel libre et gratuit de gestion des fichiers archives. Après installation, tu auras accès à deux versions de l’outil :
* une version graphique ; pratique au quotidien,
* une version ligne de commandes ; que tu pourras appeler via l’API SI3P0.

Si tu n’es pas en mesure d’installer 7-Zip, l’API propose des fonctions natives pour les fichiers Zip et GZip...ce qui reste malgré tout assez limité.

#### 3.1.3. Créer une base de tests

Pour les premiers tests, je t’encourage à créer une base dédiée histoire de te familiariser avec les différentes fonctions avant de travailler sur ta base de production.

Je recommande également de créer dans cette base (et ensuite dans la base de production) un schéma de travail pour la création des tables, vues et fonctions temporaires nécessaires aux transformations.

Comme il faut ajouter des extensions à cette base, il te faudra être connecté en tant que superuser.

```markdown
-- création d'un utilisateur geotribu
create role geotribu with password 'geotribu' login nosuperuser createdb;

-- création de la base de données de tests
create database tutosi3p0 owner geotribu;

-- connexion à la base tutosi3p0
\c tutosi3p0

-- installation des extensions PostGis
create extension if not exists postgis;
create extension if not exists postgis_topology;

-- installation de l'extension unaccent (pour disposer de la fonction du même nom)
-- cf. https://www.postgresql.org/docs/13/unaccent.html
create extension if not exists unaccent;

-- installation de l'extension pg_trgm (pour disposer de la fonction similarity)
-- https://www.postgresql.org/docs/13/pgtrgm.html
create extension if not exists pg_trgm;

-- création du schéma temporaire
create schema tmp authorization geotribu;
```

![Création BDD](../Ressources/API - Prise en main/Création BDD.png)

#### 3.1.4. Ajouter les informations de connexion au PGPASS

L’API SI3P0 utilise le fichier PGPASS (notamment via psql.exe) pour se connecter au serveur PostgreSQL. Il te faut donc y ajouter les paramètres de connexion à la base nouvellement créée. Tu trouveras plus d’information sur ce fichier ici : https://docs.postgresql.fr/13/libpq-pgpass.html

![Fichier PGPASS](../Ressources/API - Prise en main/Fichier PGPASS.png)

#### 3.1.5. Modifier le fichier constantes.ps1

Le fichier API\PowerShell\constantes.ps1 fixe plusieurs paramètres utiles à l’API. Il est notamment question de définir les chemins vers les outils PostgreSQL et OSGeo4W.

Après ouverture de ce fichier dans Windows PowerShell ISE, tu dois modifier les éléments placés entre chevrons :

* &racinePostgreSQL et &racineOSGeo4W : Ces racines sont utilisées dans les constantes qui suivent, aussi, si ton contexte de travail le nécessite, tu peux également modifier les chemins dans la suite du fichier pour pointer vers les bons emplacements des différents outils.

* $racineOracle : Tu n’as pas de client Oracle sur ton poste ? Pas de panique. En fait, ce chemin sert seulement si tu dois extraire des données depuis une base Oracle. Tu peux donc le laisser tel quel si ce n’est pas ton cas.

* $email_contact et $serveurSMTP : Ces variables sont utiles si tu veux envoyer des mails depuis tes scripts. Dans le cas contraire, tu peux passer ton chemin. A noter qu’en l’état, l’API ne gère que le SMTP sans authentification.

Tu peux en profiter pour modifier le chemin vers le dossier de travail temporaire ($dossierTravailTemp) qu’utilisent plusieurs fonctions. Tu pourras aussi changer le SRID par défaut ($sridDefaut) mais pour les besoins du tuto il te faut rester pour le moment en 2154.

![Fichier constantes](../Ressources/API - Prise en main/Fichier constantes.png)

#### 3.1.6. Modifier le fichier sig_défaut.ps1

Le fichier API\PowerShell\sig_défaut.ps1 est un élément central de l’API SI3P0. Il contient les fonctions d’interaction avec le SGBDg.

Les paramètres de connexion à la base SIg sont à définir en haut de ce fichier. Ceux-ci sont ensuite passés comme valeur par défaut aux arguments des fonctions. Il reste possible d’outrepasser ces paramètres lors des appels ce qui peut par exemple être utile ;
* lorsque plusieurs bases sont exploitées (test et production),
* quand des utilisateurs avec des droits distincts sont nécessaires pour la connexion à la base.

Tu trouveras également dans ce fichier la variable $sigNbCoeurs qui détermine le nombre de cœurs du SGBDg. Celle-ci peut permettre de limiter le nombre de processus en parallèle lors de l’utilisation des jobs.

![Fichier sig_défaut](../Ressources/API - Prise en main/Fichier sig_défaut.png)

#### 3.1.7. (Facultatif) Nettoyer le code spécifique au Gard

Certains fichiers sont spécifiques aux besoins et à l’infrastructure du Département du Gard. Tu peux supprimer ce code qui est là pour garder la cohérence avec le source des autres dossiers du “repo”.

Pour cela :
* supprime le fichier API\PowerShell\constantes_si3p0.ps1,
* supprime le fichier API\PowerShell\fonctions_si3p0.ps1,
* supprime le fichier API\PowerShell\jobs_si3p0.ps1,
* dans le fichier API\PowerShell\api_complète.ps1, retire l’appel aux 3 fichiers spécifiques.

#### 3.1.8. Fixer l’ExecutionPolicy

Si tu veux tout savoir sur l’ExecutionPolicy c’est par là :
[https://docs.microsoft.com/fr-fr/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.1](https://docs.microsoft.com/fr-fr/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.1)

Mais si tu n’es pas motivé pour lire tout ça et bien, en résumé, tu dois savoir que l’ExecutionPolicy est un niveau de sécurité appliqué à l’exécution des scripts PowerShell. Par défaut, cela empêche le lancement de scripts non signés numériquement. Pour cette raison, le niveau de sécurité doit être abaissé pour permettre l’utilisation de l’API SI3P0.

L’ExecutionPolicy peut se fixer au niveau machine mais cela nécessite des droits administrateur. Pour ce faire, exécute Windows PowerShell en tant qu’administrateur et lance la commande suivante :
`Set-ExecutionPolicy -scope LocalMachine Unrestricted`

Si tu n’es pas administrateur, tu peux également modifier ce paramètre au niveau utilisateur. Dans ce cas il te faut lancer la commande suivante :
`Set-ExecutionPolicy -scope CurrentUser Unrestricted`

Si tu penses lancer des scripts dans des contextes 64 bits et 32 bits alors tu dois également exécuter ces commandes avec la version x86 de Windows PowerShell.

Si tu n'es pas en mesure de faire l’un ou l’autre, il reste deux options qui ne sont pas très pratiques puisqu’il est question de fixer le niveau à la session. Il faudra donc refaire l’action à chaque exécution.

* Option 1 - Passer le paramètre au lancement de Windows Powershell grâce à la commande suivante : powershell.exe -executionpolicy Unrestricted

* Option 2 - Fixer la variable d’environnement PSExecutionPolicyPreference pour la session, il suffit pour cela de lancer dans l’invite PowerShell la commande suivante : $Env:PSExecutionPolicyPreference = 'Unrestricted'

(en construction)