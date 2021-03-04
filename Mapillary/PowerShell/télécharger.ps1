# dossier d'enregistrement des données
$dossierDonnees = "$PSScriptRoot\..\Données"

# clé
$cleMapillary = '<votre_cle>'

# emprise de recherche
$emprise_xmin = <x_min wgs84>
$emprise_ymin = <y_min wgs84>
$emprise_xmax = <x_max wgs84>
$emprise_ymax = <y_max wgs84>

# nombre de résultats attendus par page (max selon la documentation de l'API : 1000)
$pagination = 1000

# filtres (couche et valeurs) permettant de déterminer les données à télécharger (utilisation du wildcard * possible)
$filtres = @(
    # https://www.mapillary.com/developer/api-documentation/#traffic-signs    
    @{ couche = 'trafficsigns'; valeurs = '*' }

    # https://www.mapillary.com/developer/api-documentation/#points
    @{ couche = 'points'; valeurs = '*' }

    # https://www.mapillary.com/developer/api-documentation/#lines
    @{ couche = 'lines'; valeurs = '*' }
)

# -----------------------------------------------------------------------------
# Extraction de l'URL de pagination suivante.
#
# $entete : L'entête de réponse HTTP du précédent appel.
# -----------------------------------------------------------------------------
function ExtraireUrlPageSuivante {
    param (
        [parameter(Mandatory=$true)] $entete
    )

    $match = [Regex]::match($entete['link'], '<([^<>]*)>\s*;\s*rel="next"') # l'url de pagination se trouve entre chevrons <> juste avant la mention rel="next"

    if ($match.Success) {
        $match.Groups[1].Value
    }
    else {
        ''
    }
}

# itération sur les filtres de téléchargement définis
foreach ($filtre in $filtres) {
    
    # url initiale (première page)
    $url = "https://a.mapillary.com/v3/map_features?client_id=$cleMapillary&bbox=$emprise_xmin,$emprise_ymin,$emprise_xmax,$emprise_ymax&layers=$($filtre.couche)&values=$($filtre.valeurs)&per_page=$pagination&sort_by=key"
    
    $numeroPage = 0

    # itération sur les URL de pagination
    while ($url -ne '') {
        $numeroPage++

        $reponse = Invoke-WebRequest $url
        $reponse.Content | Out-File -FilePath "$dossierDonnees\$($filtre.couche)_$($filtre.valeurs.replace('*', '(asterisk-wildcard)'))_$($numeroPage.ToString('0000')).json" -Encoding utf8
        $url = ExtraireUrlPageSuivante -entete $reponse.Headers

        Start-Sleep -Milliseconds 1337 # pause entre les appels pour éviter d'être black-listé
    }
}