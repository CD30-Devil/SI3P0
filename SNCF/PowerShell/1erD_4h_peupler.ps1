. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\1erD_4h_peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

# nettoyage préalable
Remove-Item -Path "$dossierRapports\*"

SIg-Effacer-Table -table 'tmp.source_lignesncf' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_lignesncf.txt"
SIg-Effacer-Table -table 'tmp.source_pn' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_pn.txt"

# paramétrage des jobs d'import dans les structures temporaires
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-GeoJSON -geojson "$dossierDonnees\lignes-par-statut.geojson" -table "tmp.source_lignesncf" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import lignes-par-statut.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-GeoJSON -geojson "$dossierDonnees\liste-des-passages-a-niveau.geojson" -table "tmp.source_pn" -multiGeom $false -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import liste-des-passages-a-niveau.geojson.txt"))

# exécution des jobs d'import dans les structures temporaires
Executer-Jobs -parametresJobs $parametresJobs

# transfert des données du schéma tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

# nettoyage final
SIg-Effacer-Table -table 'tmp.source_lignesncf' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_lignesncf.txt"
SIg-Effacer-Table -table 'tmp.source_pn' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_pn.txt"