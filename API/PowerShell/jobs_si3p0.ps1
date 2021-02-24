# -----------------------------------------------------------------------------
# Jobs sp�cifiques � si3p0 (SIg du Gard)
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Job de g�n�ration d'une carte Leaflet sur la base de 1 � 5 vues/tables
# g�ographiques.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .sources : Les vues/tables (5 maxi) d�crivant les couches de la cartes.
#            Si un couche ligne existe, la mettre en premier pour que le zoom
#            fonctionne.
# .carte : Le chemin de sauvegarde de la carte.
# .titre : Le titre de la carte.
# .daterTitre : Pour demander l'ajout de la date de g�n�ration dans le titre.
# .descriptionCouches : La description des couches dans l'ordre de $sources.
# .fondDePlan : Le fond de plan � afficher par d�faut.
# .idInfo : L'identifiant du texte d'information � afficher sur le bouton
#           d'aide.
# .activerInfosBulles : Pour activer l'affichage des informations au survol.
# .replierBoiteControle : Pour replier la bo�te de contr�le en haut � droite.
# .activerZoomClic : Pour activer le zoom auto lors du clic sur un �l�ment
#                    d'une couche.
# .activerPermaliens : Pour activer la gestion des permaliens.
# .afficherNbEntites : Pour demander l'affichage du nombre d'entit�s de la
#                      couche � c�t� de sa description.
# .utilisateur : L'utilisateur pour la connexion � la base de donn�es.
# -----------------------------------------------------------------------------
$Job_SI3P0_Generer_Carte = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\fonctions_si3p0.ps1")

    SI3P0-Generer-Carte `
        -sources $parametres.sources `
        -carte $parametres.carte `
        -titre $parametres.titre `
        -daterTitre $parametres.daterTitre `
        -descriptionCouches $parametres.descriptionCouches `
        -fondDePlan $parametres.fondDePlan `
        -idInfo $parametres.idInfo `
        -activerInfosBulles $parametres.activerInfosBulles `
        -replierBoiteControle $parametres.replierBoiteControle `
        -activerZoomClic $parametres.activerZoomClic `
        -activerPermaliens $parametres.activerPermaliens `
        -afficherNbEntites $parametres.afficherNbEntites `
        -utilisateur $parametres.utilisateur
}

# -----------------------------------------------------------------------------
# Param�trage d'un job de g�n�ration d'une carte Leaflet sur la base de 1 � 5
# vues/tables g�ographiques.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# $sources : Les vues/tables (5 maxi) d�crivant les couches de la cartes.
#            Si un couche ligne existe, la mettre en premier pour que le zoom
#            fonctionne.
# $carte : Le chemin de sauvegarde de la carte.
# $titre : Le titre de la carte.
# $daterTitre : Pour demander l'ajout de la date de g�n�ration dans le titre.
# $descriptionCouches : La description des couches dans l'ordre de $sources.
# $fondDePlan : Le fond de plan � afficher par d�faut.
# $idInfo : L'identifiant du texte d'information � afficher sur le bouton
#           d'aide.
# $activerInfosBulles : Pour activer l'affichage des informations au survol.
# $replierBoiteControle : Pour replier la bo�te de contr�le en haut � droite.
# $activerZoomClic : Pour activer le zoom auto lors du clic sur un �l�ment
#                    d'une couche.
# $activerPermaliens : Pour activer la gestion des permaliens.
# $afficherNbEntites : Pour demander l'affichage du nombre d'entit�s de la
#                      couche � c�t� de sa description.
# $utilisateur : L'utilisateur pour la connexion � la base de donn�es.
# -----------------------------------------------------------------------------
function Parametrer-Job-SI3P0-Generer-Carte {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string[]] $sources,
        [parameter(Mandatory=$true)] [string] $carte,
        [string] $titre = 'Carte DGAML',
        [bool] $daterTitre = $false,
        [string[]] $descriptionCouches,
        [string] $fondDePlan = 'cartoDB',
        [string] $idInfo = 'vue_defaut',
        [bool] $activerInfosBulles = $true,
        [bool] $replierBoiteControle = $false,
        [bool] $activerZoomClic = $true,
        [bool] $activerPermaliens = $false,
        [bool] $afficherNbEntites = $true,
        [string] $utilisateur = $sigUtilisateur
    )

    @{
        script = $Job_SI3P0_Generer_Carte
        racineAPI = $racineAPI
        sources = $sources
        carte = $carte
        titre = $titre
        daterTitre = $daterTitre
        descriptionCouches = $descriptionCouches
        fondDePlan = $fondDePlan
        idInfo = $idInfo
        activerInfosBulles = $activerInfosBulles
        replierBoiteControle = $replierBoiteControle
        activerZoomClic = $activerZoomClic
        activerPermaliens = $activerPermaliens
        afficherNbEntites = $afficherNbEntites
        utilisateur = $utilisateur
    }
}