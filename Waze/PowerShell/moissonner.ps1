. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnnes = "$PSScriptRoot\..\Données"

$fichierEmbouteillages = "$dossierDonnnes\embouteillages.json"
$fichierIrregularites = "$dossierDonnnes\irrégularités.json"
$fichierAlertes = "$dossierDonnnes\alertes $(Get-Date -Format 'yyyy-MM-dd HH-mm-ss').json" # seules les alertes sont historisées

Telecharger `
    -url "https://world-georss.waze.com/rtserver/web/TGeoRSS?tk=ccp_partner&ccp_partner_name=$wazeCCP&format=JSON&types=irregularities&polygon=3.135889,43.359627;3.135889,44.553825;4.989098,44.553825;4.989098,43.359627;3.135889,43.359627" `
    -enregistrerSous "$fichierIrregularites.tmp"

Telecharger `
    -url "https://world-georss.waze.com/rtserver/web/TGeoRSS?tk=ccp_partner&ccp_partner_name=$wazeCCP&format=JSON&types=traffic&polygon=3.135889,43.359627;3.135889,44.553825;4.989098,44.553825;4.989098,43.359627;3.135889,43.359627" `
    -enregistrerSous "$fichierEmbouteillages.tmp"

Telecharger `
    -url "https://world-georss.waze.com/rtserver/web/TGeoRSS?tk=ccp_partner&ccp_partner_name=$wazeCCP&format=JSON&types=alerts&polygon=3.135889,43.359627;3.135889,44.553825;4.989098,44.553825;4.989098,43.359627;3.135889,43.359627" `
    -enregistrerSous "$fichierAlertes.tmp"

Move-Item "$fichierEmbouteillages.tmp" $fichierEmbouteillages -Force
Move-Item "$fichierIrregularites.tmp" $fichierIrregularites -Force
Move-Item "$fichierAlertes.tmp" $fichierAlertes -Force