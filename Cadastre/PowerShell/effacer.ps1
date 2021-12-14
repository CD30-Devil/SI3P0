$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierCadastreDataGouv = "$dossierDonnees\cadastre.data.gouv.fr"

Remove-Item "$dossierCadastreDataGouv\cadastre-*.json.gz"