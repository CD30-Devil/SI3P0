. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"

# liste des départements à télécharger
$departements = @(
    #'07' # Ardèche
    #'09' # Ariège
    #'11' # Aude
    #'12' # Aveyron
    #'13' # Bouches-du-Rhône
    #'26' # Drôme
    '30' # Gard
    #'31' # Haute-Garonne
    #'32' # Gers
    #'34' # Hérault
    #'46' # Lot
    #'48' # Lozère
    #'65' # Hautes-Pyrénées
    #'66' # Pyrénnées-Orientales
    #'81' # Tarn
    #'82' # Tarn-et-Garonne
    #'84' # Vaucluse
)

# liste des natures de données à télécharger
$natures = @(
    'lieux_dits'
    'prefixes_sections'
    'sections'
    'feuilles'
    'parcelles'
    'batiments'
    'subdivisions_fiscales'
)

# paramétrage des jobs de téléchargement
$parametresJobs = New-Object System.Collections.ArrayList($departements.Count * $natures.Count)

foreach ($departement in $departements) {
    foreach ($nature in $natures) {
        [void]$parametresJobs.Add((Parametrer-Job-Telecharger -url "https://cadastre.data.gouv.fr/data/etalab-cadastre/latest/geojson/departements/$departement/cadastre-$departement-$nature.json.gz" -enregistrerSous "$dossierDonnees\cadastre-$departement-$nature.json.gz"))
    }
}

# exécution des jobs de téléchargement
Executer-Jobs -parametresJobs $parametresJobs