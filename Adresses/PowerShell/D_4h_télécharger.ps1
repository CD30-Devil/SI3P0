. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"

# liste des départements à télécharger
$departements = @(
    '07' # Ardèche
    #'09' # Ariège
    #'11' # Aude
    '12' # Aveyron
    '13' # Bouches-du-Rhône
    '26' # Drôme
    '30' # Gard
    #'31' # Haute-Garonne
    #'32' # Gers
    '34' # Hérault
    #'46' # Lot
    '48' # Lozère
    #'65' # Hautes-Pyrénées
    #'66' # Pyrénnées-Orientales
    #'81' # Tarn
    #'82' # Tarn-et-Garonne
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