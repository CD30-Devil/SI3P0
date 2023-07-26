. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"

$fichierEmbouteillages = "$dossierDonnees\embouteillages.json"
$fichierIrregularites = "$dossierDonnees\irrégularités.json"
$fichierAlertes = "$dossierDonnees\alertes $(Get-Date -Format 'yyyy-MM-dd HH-mm-ss').json" # seules les alertes sont historisées

Telecharger `
    -url "https://www.waze.com/row-partnerhub-api/partners/19922757588/waze-feeds/3a9c7f95-81cd-40cf-beeb-2c9adcd47c40?format=1&types=irregularities" `
    -enregistrerSous "$fichierIrregularites.tmp"

Telecharger `
    -url "https://www.waze.com/row-partnerhub-api/partners/19922757588/waze-feeds/3a9c7f95-81cd-40cf-beeb-2c9adcd47c40?format=1&types=traffic" `
    -enregistrerSous "$fichierEmbouteillages.tmp"

Telecharger `
    -url "https://www.waze.com/row-partnerhub-api/partners/19922757588/waze-feeds/3a9c7f95-81cd-40cf-beeb-2c9adcd47c40?format=1&types=alerts" `
    -enregistrerSous "$fichierAlertes.tmp"

Move-Item "$fichierEmbouteillages.tmp" $fichierEmbouteillages -Force
Move-Item "$fichierIrregularites.tmp" $fichierIrregularites -Force
Move-Item "$fichierAlertes.tmp" $fichierAlertes -Force