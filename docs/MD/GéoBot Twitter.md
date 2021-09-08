# Tutoriel : Réaliser un (Géo)Bot Twitter.

On trouve sur Twitter de nombreux comptes Bot qui diffusent de façon régulière des informations.

Par exemple, et pour ne citer que les plus utiles, il y a :
* [@whataweekhuh](https://twitter.com/whataweekhuh){:target="_blank"} - où Tintin nous rappelle chaque mercredi que c'est mercredi,
* [@year_progress](https://twitter.com/year_progress){:target="_blank"} - qui nous aide à patienter jusqu'au réveillon du nouvel an grâce à une barre de progression de l'année en cours façon code ASCII.

Ce tutoriel te propose de créer un Bot Twitter avec la boîte à outils PowerShell SI3P0.
Pour cela, tu vas utiliser les fonctions d'appel à l'API standard v1.1 de Twitter présentent dans le fichier [fonctions_twitter.ps1](https://github.com/CD30-Devil/SI3P0/blob/main/API/PowerShell/fonctions_twitter.ps1){:target="_blank"}.

Ce fichier est indépendant des autres sources de la boîte à outils SI3P0, MAIS, comme on aime bien la Géo ici, on va créer un GéoBot et donc utiliser d'autres fonctions en lien avec le SIg. On va également exploiter les données de notre base géographique si bien que, si tu souhaites réaliser ton propre GéoBot, il te faudra adapter la partie extraction de données.

**Pré-requis :**

* Avoir un poste Windows pouvant exécuter du PowerShell (testé en 5.1)
* Pour faire un Bot simple : télécharger et référencer ([en Dot-Sourcing](https://mcpmag.com/articles/2017/02/02/exploring-dot-sourcing-in-powershell.aspx){:target="_blank"}) les fichiers [fonctions_twitter.ps1](https://github.com/CD30-Devil/SI3P0/blob/main/API/PowerShell/fonctions_twitter.ps1){:target="_blank"} et [fonctions_chromium.ps1](https://github.com/CD30-Devil/SI3P0/blob/main/API/PowerShell/fonctions_chromium.ps1){:target="_blank"}.
* Pour faire un GéoBot avec la boîte à outils SI3P0 : [avoir suivi le tuto de prise en main de l'API SI3P0](/MD/API - Prise en main.html]){:target="_blank"}.

**Table des matières**

[1. @MonBotTwitter](#_1)

[2. Le fichier fonctions_twitter.ps1](#_2)

&nbsp;&nbsp;&nbsp;&nbsp;[2.1. Appel à une fonction "mappée" de l'API Twitter](#_21)

&nbsp;&nbsp;&nbsp;&nbsp;[2.2. Appel à une autre fonction de l'API Twitter](#_22)

[3. Création de l'objet d'identification](#_3)

[4. Préparation des données et médias](#_4)

[5. Téléversement des médias](#_5)

[6. Publication des tweets](#_6)

[7. Conclusion](#_7)

## <a name="_1"></a>1. @MonBotTwitter

Avant de t'attaquer à la partie développement, tu dois :
1. Créer le compte Twitter du Bot.
2. Demander un accès développeur à l'API standard (gratuite) v1.1 via un formulaire où tu devras préciser à _"la firme"_ tes intentions.
3. Créer un projet.
4. Ajouter une application au projet et noter ses identifiants (_API Key_, _API Key Secret_, _Bearer Token_ ; ce dernier est proposé automatiquement à la création de l'app mais n'est pas utile pour ce tuto).
5. Modifier les permissions de l'application en _Read and Write_.
6. Générer et conserver les _Access Token_ et _Access Secret Token_ pour l'application.

Toute la documentation nécessaire est disponible en ligne que ce soit dans l'aide Twitter ou via différents tutos.

Ci-dessous quelques liens qui devraient t'aider :
* [S'inscrire sur Twitter (FR)](https://help.twitter.com/fr/using-twitter/create-twitter-account){:target="_blank"}.
* [Demander un accès développeur (EN)](https://developer.twitter.com/en/apply-for-access){:target="_blank"}.
* [Vu d'ensemble des projets et apps (EN - accessible après création du compte développeur)](https://developer.twitter.com/en/portal/projects-and-apps){:target="_blank"}.
* [A propos des API Twitter (FR)](https://help.twitter.com/fr/rules-and-policies/twitter-api){:target="_blank"}.
* [Documentation de la plateforme développeur (EN)](https://developer.twitter.com/en/docs){:target="_blank"}.

## <a name="_2"></a>2. Le fichier fonctions_twitter.ps1

TODO

### <a name="_21"></a>2.1. Appel à une fonction "mappée" de l'API Twitter

TODO

### <a name="_22"></a>2.2. Appel à une autre fonction de l'API Twitter

TODO

## <a name="_3"></a>3. Création de l'objet d'identification

TODO

## <a name="_4"></a>4. Préparation des données et médias

TODO

## <a name="_5"></a>5. Téléversement des médias

TODO

## <a name="_6"></a>6. Publication des tweets

TODO

## <a name="_7"></a>7. Conclusion

TODO

Pour la MSI,

Michaël Galien - [@Tetranos](https://twitter.com/tetranos){:target="_blank"}