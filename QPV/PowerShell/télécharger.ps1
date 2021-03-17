. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"

# téléchargement des données
Telecharger -url 'https://sig.ville.gouv.fr/Atlas/qp-politiquedelaville-shp.zip' -enregistrerSous "$dossierDonnees\qp-politiquedelaville-shp.zip"