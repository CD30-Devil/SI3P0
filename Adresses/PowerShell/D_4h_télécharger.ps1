. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"

# liste des départements à télécharger
$departements = @(
    '07' # Ardèche
    '12' # Aveyron
    '13' # Bouches-du-Rhône
    '26' # Drôme
    '30' # Gard
    '34' # Hérault
    '48' # Lozère
    '84' # Vaucluse
)

# nettoyage préalable
Remove-Item "$dossierDonnees\*"

# paramétrage des jobs de téléchargement
$parametresJobs = [Collections.ArrayList]::new($departements.Count)

foreach ($departement in $departements) {
    [void]$parametresJobs.Add((Parametrer-Job-Telecharger -url "https://adresse.data.gouv.fr/data/ban/adresses/latest/csv-bal/adresses-$departement.csv.gz" -enregistrerSous "$dossierDonnees\adresses-$departement.csv.gz"))
}

# exécution des jobs de téléchargement
Executer-Jobs -parametresJobs $parametresJobs

# décompression des archives
foreach ($gz in Get-ChildItem "$dossierDonnees\*.gz") {
    7Z-Decompresser-Ici $gz -supprimer $true
}