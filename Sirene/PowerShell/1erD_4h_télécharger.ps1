. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"

# nettoyage préalable
Remove-Item "$dossierDonnees\*"

# paramétrage des jobs de téléchargement
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((Parametrer-Job-Telecharger -url "http://files.data.gouv.fr/insee-sirene/StockUniteLegale_utf8.zip" -enregistrerSous "$dossierDonnees\StockUniteLegale_utf8.zip"))
[void]$parametresJobs.Add((Parametrer-Job-Telecharger -url "http://files.data.gouv.fr/insee-sirene/StockEtablissement_utf8.zip" -enregistrerSous "$dossierDonnees\StockEtablissement_utf8.zip"))

# exécution des jobs de téléchargement
Executer-Jobs -parametresJobs $parametresJobs

# décompression des archives
7Z-Decompresser-Ici "$dossierDonnees\StockUniteLegale_utf8.zip" -supprimer $true
7Z-Decompresser-Ici "$dossierDonnees\StockEtablissement_utf8.zip" -supprimer $true