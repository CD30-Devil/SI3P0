. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"

# nettoyage préalable
Remove-Item "$dossierDonnees\*"

# téléchargement des données
Telecharger -url 'https://sig.ville.gouv.fr/Atlas/qp-politiquedelaville-shp.zip' -enregistrerSous "$dossierDonnees\qp-politiquedelaville-shp.zip"

# décompression des archives
7Z-Decompresser-Ici "$dossierDonnees\qp-politiquedelaville-shp.zip" -supprimer $true

# conservation des fichiers de la métropole uniquement
Remove-Item "$dossierDonnees\*" -Exclude 'QP_METROPOLE_LB93.*'