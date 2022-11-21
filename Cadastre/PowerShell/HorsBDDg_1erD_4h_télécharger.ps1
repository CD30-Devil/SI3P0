. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierCadastreDataGouv = "$dossierDonnees\cadastre.data.gouv.fr"

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

# liste des natures de données à télécharger
$natures = @(
    'lieux_dits'
    'sections'
    'parcelles'
)

# nettoyage préalable
Remove-Item "$dossierCadastreDataGouv\*"

# paramétrage des jobs de téléchargement
$parametresJobs = [Collections.ArrayList]::new()

foreach ($departement in $departements) {
    foreach ($nature in $natures) {
        [void]$parametresJobs.Add((Parametrer-Job-Telecharger -url "https://cadastre.data.gouv.fr/data/etalab-cadastre/latest/geojson/departements/$departement/cadastre-$departement-$nature.json.gz" -enregistrerSous "$dossierCadastreDataGouv\cadastre-$departement-$nature.json.gz"))
    }
}

# exécution des jobs de téléchargement
Executer-Jobs -parametresJobs $parametresJobs

# paramétrage des jobs de décompression des archives
$parametresJobs = [Collections.ArrayList]::new()

foreach ($gz in Get-ChildItem "$dossierCadastreDataGouv\*.gz") {
    [void]$parametresJobs.Add((Parametrer-Job-7Z-Decompresser-Ici -archive $gz -supprimer $true))
}

# exécution des jobs de décompression des archives
Executer-Jobs -parametresJobs $parametresJobs