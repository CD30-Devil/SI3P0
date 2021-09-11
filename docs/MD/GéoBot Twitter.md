# Tutoriel : Réaliser un (Géo)Bot Twitter.

On trouve sur Twitter de nombreux comptes Bot qui diffusent de façon régulière des informations.

Par exemple, et pour ne citer que les plus utiles, il y a :
* [@whataweekhuh](https://twitter.com/whataweekhuh){:target="_blank"} - où Tintin nous rappelle chaque mercredi que c'est mercredi,
* [@year_progress](https://twitter.com/year_progress){:target="_blank"} - qui nous aide à patienter jusqu'au réveillon du nouvel an grâce à une barre de progression de l'année en cours façon code ASCII.

Ce tutoriel te propose de créer un Bot Twitter avec l'aide des sources qui nous mettons à ta disposition.
Pour cela, tu vas utiliser les fonctions d'appel à l'API standard v1.1 de Twitter présentent dans le fichier [fonctions_twitter.ps1](https://github.com/CD30-Devil/SI3P0/blob/main/API/PowerShell/fonctions_twitter.ps1){:target="_blank"}.

Ce fichier est indépendant des autres sources, MAIS, comme on aime bien la Géo ici, on va créer un GéoBot et donc utiliser un peu plus largement les fonctions de la boîte à outils SI3P0 notamment pour l'accès au SIg. On va également exploiter les données de notre base géographique si bien que, si tu souhaites réaliser ton propre GéoBot, il te faudra adapter la partie extraction de données.

**Pré-requis :**

* Avoir un poste Windows pouvant exécuter du PowerShell (testé en 5.1)
* Pour faire un Bot simple : télécharger et référencer ([en Dot-Sourcing](https://mcpmag.com/articles/2017/02/02/exploring-dot-sourcing-in-powershell.aspx){:target="_blank"}) le fichier [fonctions_twitter.ps1](https://github.com/CD30-Devil/SI3P0/blob/main/API/PowerShell/fonctions_twitter.ps1){:target="_blank"}.
* Pour faire un GéoBot avec la boîte à outils SI3P0 : [avoir suivi le tuto de prise en main de l'API SI3P0](/SI3P0/MD/API - Prise en main.html){:target="_blank"}.

**Table des matières**

[1. @MonBotTwitter](#_1)

[2. Le fichier fonctions_twitter.ps1](#_2)

&nbsp;&nbsp;&nbsp;&nbsp;[2.1. Appel à une fonction "mappée" de l'API Twitter](#_21)

&nbsp;&nbsp;&nbsp;&nbsp;[2.2. Appel à une autre fonction de l'API Twitter](#_22)

[3. Donnons vie au bot !](#_3)

&nbsp;&nbsp;&nbsp;&nbsp;[3.1. Création de l'objet d'identification](#_31)

&nbsp;&nbsp;&nbsp;&nbsp;[3.2. Préparation des données et médias](#_32)

&nbsp;&nbsp;&nbsp;&nbsp;[3.3. Téléversement des médias](#_33)

&nbsp;&nbsp;&nbsp;&nbsp;[3.4. Publication des tweets](#_34)

[4. Conclusion](#_4)

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

Le fichier [fonctions_twitter.ps1](https://github.com/CD30-Devil/SI3P0/blob/main/API/PowerShell/fonctions_twitter.ps1){:target="_blank"} est découpé en régions avec :
* une première région dans laquelle on trouve la machinerie d'appel,
* suivie de régions correspondantes aux sections de la documentation de l'API disponible à l'adresse [https://developer.twitter.com/en/docs/twitter-api/v1](https://developer.twitter.com/en/docs/twitter-api/v1){:target="_blank"}.

Au moment où je rédige ces lignes, seules quelques fonctions nécessaires à nos besoins internes ont été "mappées".
Cependant, la tuyauterie est là est l'appel aux autres fonctions ne devrait pas trop poser de problèmes.

### <a name="_21"></a>2.1. Appel à une fonction "mappée" de l'API Twitter

Pour l'heure, les fonctions "mappées" de l'API sont :
* `Twitter-Modifier-Statut`, cf. [https://developer.twitter.com/en/docs/twitter-api/v1/tweets/post-and-engage/api-reference/post-statuses-update](https://developer.twitter.com/en/docs/twitter-api/v1/tweets/post-and-engage/api-reference/post-statuses-update){:target="_blank"}.

* `Twitter-Effacer-Statut`, cf. [https://developer.twitter.com/en/docs/twitter-api/v1/tweets/post-and-engage/api-reference/post-statuses-destroy-id](https://developer.twitter.com/en/docs/twitter-api/v1/tweets/post-and-engage/api-reference/post-statuses-destroy-id){:target="_blank"}.

* `Twitter-Obtenir-Statuts`, cf. [https://developer.twitter.com/en/docs/twitter-api/v1/tweets/timelines/api-reference/get-statuses-home_timeline](https://developer.twitter.com/en/docs/twitter-api/v1/tweets/timelines/api-reference/get-statuses-home_timeline){:target="_blank"}.

* `Twitter-Televerser-Media`, cette fonction étant en fait une succession de plusieurs appels :
    * `INIT`, cf. [https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload-init](https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload-init){:target="_blank"},
    * `APPEND`, cf. [https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload-append](https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload-append){:target="_blank"},
    * `FINALIZE`, cf. [https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload-finalize](https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload-finalize){:target="_blank"}.
    
* `Twitter-Televerser-Media-Simple`, cf. [https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload](https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload){:target="_blank"}.

Toutes ces fonctions prennent un paramètre obligatoire qui permet l'identification auprès de Twitter.
Celui-ci est obtenu par appel à la fonction `Twitter-Creer-Identifiants`.

### <a name="_22"></a>2.2. Appel à une autre fonction de l'API Twitter

Si tu regardes le code des fonctions "mappées", tu pourras voir que chaque appel est une succession de 3 fonctions.

1. `Twitter-Preparer-Appel`

Cette fonction construit un `pscustomobject` contenant l'ensemble des informations utiles à l'appel en préparation. On y trouve :
* l'URL
* la méthode (_GET_ / _POST_)
* pour les appels en _POST_, le type MIME du corps de la requête (_application/x-www-form-urlencoded_, _multipart/form-data_)
* les paramètres

D'une part, l'objet retourné sert à calculer la signature d'appel grâce à la fonction `Twitter-Calculer-Signature`.

Si t'as du temps à perdre, les détails sont ici : [https://developer.twitter.com/en/docs/authentication/oauth-1-0a/creating-a-signature](https://developer.twitter.com/en/docs/authentication/oauth-1-0a/creating-a-signature){:target="_blank"} mais en gros cette signature permet le calcul de l'entête _OAuth_ qui sert à authentifier l'appelant.

Si tu n'as pas assez perdu de temps avec le lien précédent, tu peux aussi regarder celui là : [https://developer.twitter.com/en/docs/authentication/oauth-1-0a/authorizing-a-request](https://developer.twitter.com/en/docs/authentication/oauth-1-0a/authorizing-a-request){:target="_blank"}.

Ensuite, ce même objet est passé à la fonction `Twitter-Appeler` pour invoquer l'API.

2. `Twitter-Calculer-Signature`

Et bien tu sais déjà tout ou presque, la fonction calcule la signature et l'ajoute au `pscustomobject` reçu en entrée, histoire de refiler l'info à la fonction `Twitter-Appeler`.

3. `Twitter-Appeler`

La fonction `Twitter-Appeler` appelle Twitter. Surpris ?

Le résultat de l'appel est désérialisé (merci [Invoke-RestMethod](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7.1){:target="_blank"}) et retourné.


Du coup, il devrait être assez simple d'appeler une fonction non "mappée"...enfin j'sais pas, enfin peut-être.

[![enfin j'sais pas, enfin peut-être](https://img.youtube.com/vi/UhjWQKr0b0g/0.jpg)](https://www.youtube.com/watch?v=UhjWQKr0b0g){:target="_blank"}

## <a name="_3"></a>3. Donnons vie au bot !

Le compte Twitter est actif et nous avons rapidement passé en revue les fonctions ; il est désormais temps de donner vie au bot.

### <a name="_31"></a>3.1. Création de l'objet d'identification

TODO

### <a name="_32"></a>3.2. Préparation des données et médias

TODO

### <a name="_33"></a>3.3. Téléversement des médias

TODO

### <a name="_34"></a>3.4. Publication des tweets

TODO

## <a name="_4"></a>4. Conclusion

TODO

Pour la MSI,

Michaël Galien - [@Tetranos](https://twitter.com/tetranos){:target="_blank"}