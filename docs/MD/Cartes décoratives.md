# Tutoriel : Décorer son intérieur avec une carte.

Tu as peut-être déjà vu, sur Internet ou en magasin, ces cartes décoratives de communes et tu penses qu'elles trouveraient bonne place dans ton bureau.

Mais bon, à 30€ le morçeau de papier tu hésites un peu et en plus c'est TA ville que tu voudrais avoir.

![Aperçu Aigues-Mortes](../Ressources/Cartes décoratives/Aperçu.png)

Dans ce tutoriel on te montre comment, avec les données de l'[IGN](https://geoservices.ign.fr/bdtopo), une base [PostgreSQL](https://www.postgresql.org/)/[PostGIS](https://postgis.net/) et [QGis](https://qgis.org/fr/site/), tu peux faire ta propre carte.
Tu utiliseras pour cela les styles et modèles d'impression que nous mettons à ta disposition.

Charge à toi, si le coeur t'en dit, de faire tes propres présentations et pourquoi pas de nous les proposer.
On pourra alors stocker et re-partager sur ce projet ta réalisation.

**Pré-requis :**

* Une base PostgreSQL/PostGIS.
* QGis.
* Les données de la BDTopo IGN sur l'emprise souhaitée.

**Table des matières**

[1. Importer les données IGN](#_1)

[2. Produire la couche des bâtiments notables et celle pour l'atlas QGis](#_2)

&nbsp;&nbsp;&nbsp;&nbsp;[2.1. Couche des bâtiments notables](#_21)

&nbsp;&nbsp;&nbsp;&nbsp;[2.2. Couche d'atlas](#_22)

[3. Créer le projet QGis](#_3)

&nbsp;&nbsp;&nbsp;&nbsp;[3.1. Ajouter les couches](#_31)

&nbsp;&nbsp;&nbsp;&nbsp;[3.2. Appliquer les styles](#_32)

&nbsp;&nbsp;&nbsp;&nbsp;[3.3. Importer les modèles d'impression](#_33)

&nbsp;&nbsp;&nbsp;&nbsp;[3.4. Exporter une ou plusieurs cartes](#_34)

[4. Conclusion](#_4)

## <a name="_1"></a>1. Importer les données IGN

La première étape consiste à intégrer les données IGN dans la base PostgreSQL/PostGIS.

Tu as besoin des cinq données suivantes :
* la classe `batiment` du thème **Bâti**,
* la classe `commune` du thème **Administratif**,
* la classe `surface_hydrographique` du thème **Hydrographie**,
* la classe `troncon_de_route` du thème **Transport**,
* la classe `zone_d_activite_ou_d_interet` du thème **Services et activités**.

Plusieurs méthodes sont possibles pour intégrer les données mais, ici, nous avons pour habitude de travailler avec la version SQL de la France métropolitaine.
Certains fichiers y sont trés volumineux dont notamment les classes `batiment` et `troncon_de_route` qui pèsent chacune plusieurs Go une fois décompréssées.

Pas de panique, tu peux à la place utiliser les versions découpées par EPCI, Département et Région que nous mettons à ta disposition sur [cet espace OneDrive](https://gardfr-my.sharepoint.com/:f:/g/personal/michael_galien_gard_fr/Eqoe4M0WjcZCpUUmNq7HXGwBSA6QeTjDlRKE4O7mAeMYXA)

Ces découpages proposent une zone tampon de 5 km autour de l'emprise ce qui devrait permettre de produire une carte sans trou même si la commune souhaitée est en limite.

L'exécution d'un fichier SQL, et donc la création des structures et l'import des données, se fait à l'aide de l'outil **psql**.

Une commande d'appel a le format suivant :
```
psql
    --host=<serveur>
    --port=<port>
    --dbname=<bdd>
    --username=<utilisateur>
    --file="<chemin vers le fichier SQL>"
```

Il est aussi possible de jouer un ordre SQL simple avec une ligne de commande ainsi construite :
```
psql
    --host=<serveur>
    --port=<port>
    --dbname=<bdd>
    --username=<utilisateur>
    --command="<ordre SQL à exécuter>"
```

L'outil psql ne prend pas en paramètre le mot de passe utilisateur.

PostgreSQL propose différents modes d'authentification et il existe plusieurs techniques pour renseigner le mot de passe que ce soit par la [variable d'environnement `PGPASSWORD`](https://www.postgresql.org/docs/current/libpq-envars.html) ou en utilisant un [fichier de mots de passe](https://www.postgresql.org/docs/current/libpq-pgpass.html).
A défaut, psql affichera un prompt de saisie du mot de passe immédiatement après son lancement.

Pense également à bien définir l'encodage utilisé par le client (éventuellement via la variable d'environnement `PGCLIENTENCODING` ) sachant que les fichiers de découpage sont en mis à disposition en UTF8.

Dans le projet, nous avons mis pour exemple les fichiers SQL correspondants à la [communauté de communes Terre de Camargue](http://www.terredecamargue.fr/).
Nous mettons également à ta disposition un [modèle PowerShell de séquencement des appels dans le dossier PSQL](https://github.com/CD30-Devil/SI3P0/blob/main/Cartes%20d%C3%A9coratives/PSQL/lancement%20psql.ps1).

## <a name="_2"></a>2. Produire la couche des bâtiments notables et celle pour l'atlas QGis

Deux couches, déduites des données IGN, sont nécessaires pour la construction des cartes.

### <a name="_21"></a>2.1. Couche des bâtiments notables

Le nombre de bâtiments dans les données de l'IGN peut-être réellement conséquent.

Plutôt que d'utiliser un critère de filtre sous QGis, qui pourrait ralentir le travail de cartographie, on précalcule les bâtiments notables à afficher.
On utilise pour cela une [vue materialisée](https://www.postgresql.org/docs/current/rules-materializedviews.html) qui va extraire des bâtiments ceux à représenter.

L'ordre de création de cette vue est le suivant :
```sql
create materialized view cartodeco_batimentnotable as
select
    row_number() over () as id,
    geometrie
from batiment
where nature in (
    'Arc de triomphe',
    'Arène ou théâtre antique',
    'Chapelle',
    'Château',
    'Eglise',
    'Fort, blockhaus, casemate',
    'Monument',
    'Tour, donjon'
);
```

Il est disponible dans le fichier [Bâtiments notables.sql](https://github.com/CD30-Devil/SI3P0/blob/main/Cartes%20d%C3%A9coratives/Vues/B%C3%A2timents%20notables.sql).

### <a name="_22"></a>2.2. Couche d'atlas



## <a name="_3"></a>3. Créer le projet QGis



### <a name="_31"></a>3.1. Ajouter les couches



### <a name="_32"></a>3.2. Appliquer les styles



### <a name="_33"></a>3.3. Importer les modèles de conception



### <a name="_34"></a>3.4. Exporter une ou plusieurs cartes



## <a name="_4"></a>4. Conclusion

Pour la MSI,

Michaël Galien - [@Tetranos](https://twitter.com/tetranos){:target="_blank"}