. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnnes = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\manuel_peupler_histo"
$dossierSQL = "$PSScriptRoot\..\SQL"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

foreach ($csv in Get-ChildItem "$dossierDonnnes\histo_alertes*.csv") {

    # création des structures temporaires
    SIg-Effacer-Table -table 'tmp.source_histoalertewaze' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_histoalertewaze.txt"
    SIg-Creer-Table-Temp -table 'tmp.source_histoalertewaze' -colonnes 'uuid', 'ts', 'type', 'subtype', 'reliability', 'X', 'Y' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.source_histoalertewaze.txt"

    # import des données dans les structures temporaires
    SIg-Importer-CSV -csv $csv -table 'tmp.source_histoalertewaze' -delimiteur ',' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import $([IO.Path]::GetFileName($csv)).txt"

    # transfert des données du schéma tmp au schéma m
    SIg-Executer-Fichier -fichier "$dossierSQL\_peupler histo.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler histo.txt"
    SIg-Executer-Fichier -fichier "$dossierSQL\_consolider histo.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _consolider histo.txt"
}

# nettoyage final
SIg-Effacer-Table -table 'tmp.source_histoalertewaze' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_histoalertewaze.txt"