# -----------------------------------------------------------------------------
# Jobs spécifiques à si3p0 (SIg du Gard)
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Job de génération d'une carte Leaflet sur la base de vues/tables
# géographiques.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .sources : Les vues/tables (5 maxi) décrivant les couches de la cartes.
#            Si un couche ligne existe, la mettre en premier pour que le zoom
#            fonctionne.
# .carte : Le chemin de sauvegarde de la carte.
# .titre : Le titre de la carte.
# .daterTitre : Pour demander l'ajout de la date de génération dans le titre.
# .nbCouchesActives : Nombre de couches actives par défaut.
# .fondDePlan : Le fond de plan à afficher par défaut.
# .idInfo : L'identifiant du texte d'information à afficher sur le bouton
#           d'aide.
# .activerInfosBulles : Pour activer l'affichage des informations au survol.
# .replierBoiteControle : Pour replier la boîte de contrôle en haut à droite.
# .activerZoomClic : Pour activer le zoom auto lors du clic sur un élément
#                    d'une couche.
# .activerPermaliens : Pour activer la gestion des permaliens.
# .actualisationAuto : Délai pour l'actualisation automatique de la carte, 0
#                      pour désactiver.
# .utilisateur : L'utilisateur pour la connexion à la base de données.
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
        -fondDePlan $parametres.fondDePlan `
        -idInfo $parametres.idInfo `
        -nbCouchesActives $parametres.nbCouchesActives `
        -activerInfosBulles $parametres.activerInfosBulles `
        -replierBoiteControle $parametres.replierBoiteControle `
        -activerZoomClic $parametres.activerZoomClic `
        -activerPermaliens $parametres.activerPermaliens `
        -activerPegman $parametres.activerPegman `
        -actualisationAuto $parametres.actualisationAuto `
        -utilisateur $parametres.utilisateur
}

# -----------------------------------------------------------------------------
# Paramètrage d'un job de génération d'une carte Leaflet sur la base de
# vues/tables géographiques.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# $sources : Les vues/tables (5 maxi) décrivant les couches de la cartes.
#            Si un couche ligne ou polygone existe, la mettre en premier pour
#            que le zoom fonctionne.
# $carte : Le chemin de sauvegarde de la carte.
# $titre : Le titre de la carte.
# $daterTitre : Pour demander l'ajout de la date de génération dans le titre.
# $fondDePlan : Le fond de plan à afficher par défaut.
# $idInfo : L'identifiant du texte d'information à afficher sur le bouton
#           d'aide.
# $nbCouchesActives : Nombre de couches actives par défaut.
# $activerInfosBulles : Pour activer l'affichage des informations au survol.
# $replierBoiteControle : Pour replier la boîte de contrôle en haut à droite.
# $activerZoomClic : Pour activer le zoom auto lors du clic sur un élément
#                    d'une couche.
# $activerPermaliens : Pour activer la gestion des permaliens.
# $activerPegman : Pour activer "Pegman", le bonhomme d'accès aux sites
#                  externes dont StreetView.
# $actualisationAuto : Délai pour l'actualisation automatique de la carte, 0
#                      pour désactiver.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# -----------------------------------------------------------------------------
function Parametrer-Job-SI3P0-Generer-Carte {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string[]] $sources,
        [parameter(Mandatory=$true)] [string] $carte,
        [string] $titre = 'Carte DGAML',
        [bool] $daterTitre = $false,
        [string] $fondDePlan = 'cartoDB',
        [string] $idInfo = 'vue_defaut',
        [int] $nbCouchesActives = $null,
        [bool] $activerInfosBulles = $true,
        [bool] $replierBoiteControle = $false,
        [bool] $activerZoomClic = $true,
        [bool] $activerPermaliens = $false,
        [bool] $activerPegman = $true,
        [int] $actualisationAuto = 0,
        [string] $utilisateur = $sigUtilisateur,
        [bool] $afficherNbEntites = $true
    )

    @{
        script = $Job_SI3P0_Generer_Carte
        racineAPI = $racineAPI
        sources = $sources
        carte = $carte
        titre = $titre
        daterTitre = $daterTitre
        fondDePlan = $fondDePlan
        idInfo = $idInfo
        nbCouchesActives = $nbCouchesActives
        activerInfosBulles = $activerInfosBulles
        replierBoiteControle = $replierBoiteControle
        activerZoomClic = $activerZoomClic
        activerPermaliens = $activerPermaliens
        activerPegman = $activerPegman
        actualisationAuto = $actualisationAuto
        utilisateur = $utilisateur
    }
}