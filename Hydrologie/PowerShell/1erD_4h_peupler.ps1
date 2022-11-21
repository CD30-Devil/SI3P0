. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierSQL = "$PSScriptRoot\..\SQL"
$dossierRapports = "$PSScriptRoot\..\Rapports\1erD_4h_peupler"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

SIg-Effacer-Table -table 'tmp.source_tronconhydro' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_tronconhydro.txt"
SIg-Effacer-Table -table 'tmp.source_stationhydro' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_stationhydro.txt"

# création des structures temporaires
SIg-Creer-Table-Temp `
    -table 'tmp.source_tronconhydro' `
    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.source_tronconhydro.txt" `
    -colonnes `        'codetroncon', `        'libelle'

SIg-Creer-Table-Temp `
    -table 'tmp.source_stationhydro' `
    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.source_stationhydro.txt" `
    -colonnes `        'codestation', `        'codetroncon', `        'libelle', `        'x', `        'y'

# paramétrage des jobs d'import
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-CSV -csv "$dossierDonnees\tronçons.csv" -table 'tmp.source_tronconhydro' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import tronçons.csv.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-CSV -csv "$dossierDonnees\stations.csv" -table 'tmp.source_stationhydro' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import stations.csv.txt"))

# exécution des jobs d'import
Executer-Jobs -parametresJobs $parametresJobs

# transfert des données du schéma tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

# nettoyage final
SIg-Effacer-Table -table 'tmp.source_tronconhydro' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_tronconhydro.txt"
SIg-Effacer-Table -table 'tmp.source_stationhydro' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_stationhydro.txt"