. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapportsVaisala = "$dossierDonnees\Rapports Vaisala"

# paramétrage des jobs de téléchargement
$parametresJobs = [Collections.ArrayList]::new()

foreach ($rapport in (Import-Csv -Path "$dossierDonnees\Liste des rapports Vaisala.csv" -Delimiter ';' -Encoding UTF8)) {
    [void]$parametresJobs.Add((Parametrer-Job-Telecharger -url $rapport.URL -enregistrerSous "$dossierRapportsVaisala\$($rapport.Nom).zip"))
}

# exécution des jobs de téléchargement
Executer-Jobs -parametresJobs $parametresJobs