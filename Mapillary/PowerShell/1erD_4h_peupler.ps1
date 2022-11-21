. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\1erD_4h_peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

SIg-Effacer-Table -table 'tmp.source_mapillary' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_mapillary.txt"

# création des structures temporaires
SIg-Creer-Table-Temp -table 'tmp.source_mapillary' -colonnes 'id', 'aligned_direction', 'first_seen_at', 'last_seen_at', 'object_value', 'object_type', 'x', 'y' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.source_mapillary.txt"

# paramétrage des jobs d'import des données dans les structures temporaires
$parametresJobs = [Collections.ArrayList]::new()

foreach ($csv in Get-ChildItem -Path "$dossierDonnees\*.csv") {
    [void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-CSV -csv $csv -table 'tmp.source_mapillary' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import $([IO.Path]::GetFileName($csv)).txt"))
}

# exécution des jobs d'import des données dans les structures temporaires
Executer-Jobs -parametresJobs $parametresJobs

# transfert des données du schéma tmp au schéma d
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

# nettoyage final
SIg-Effacer-Table -table 'tmp.source_mapillary' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_mapillary.txt"