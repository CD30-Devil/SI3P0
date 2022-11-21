. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"

# nettoyage préalable
Remove-Item "$dossierDonnees\*"

# paramétrage des jobs de téléchargement
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((Parametrer-Job-Telecharger -url 'https://www.data.gouv.fr/fr/datasets/r/2e3dd501-cec7-4f5e-a1a5-6d99bb4e5f25' -enregistrerSous "$dossierDonnees\Cantons.zip"))
[void]$parametresJobs.Add((Parametrer-Job-Telecharger -url 'https://data.laregion.fr/explore/dataset/zone-montagne-occitanie/download/?format=csv&timezone=Europe/Berlin&use_labels_for_header=true&csv_separator=%3B' -enregistrerSous "$dossierDonnees\zone-montagne-occitanie.csv"))

# exécution des jobs de téléchargement
Executer-Jobs -parametresJobs $parametresJobs

# décompression des archives
7Z-Decompresser-Ici -archive "$dossierDonnees\Cantons.zip" -supprimer $true