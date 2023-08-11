. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"

# nettoyage préalable
Remove-Item "$dossierDonnees\Stations météo.geojson"

# téléchargement de la liste des stations au format GeoJSON
Telecharger -url "https://www.infoclimat.fr/opendata/stations_xhr.php?format=geojson" -enregistrerSous "$dossierDonnees\Stations météo.geojson"