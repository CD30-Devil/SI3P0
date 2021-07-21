. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnnes = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\peupler_histo"
$dossierSQL = "$PSScriptRoot\..\SQL"

# nettoyage préalable
Remove-Item "$dossierRapports\*.txt"
Remove-Item "$dossierRapports\*.err"

SIg-Effacer-Table -table 'tmp.HistoAlerteWaze' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.HistoAlerteWaze.txt"

# création des structures temporaires
SIg-Creer-Table-Temp -table 'tmp.HistoAlerteWaze' -colonnes 'uuid', 'ts', 'type', 'subtype', 'reliability', 'X', 'Y' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.HistoAlerteWaze.txt"

# import des données dans les structures temporaires
SIg-Importer-CSV -csv "$dossierDonnnes\histo_alertes.csv" -table 'tmp.HistoAlerteWaze' -delimiteur ',' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import histo_alertes.csv.txt"

# transfert des données du schéma tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler histo.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler histo.txt"
SIg-Executer-Fichier -fichier "$dossierSQL\_consolider histo.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _consolider histo.txt"

# nettoyage final
SIg-Effacer-Table -table 'tmp.HistoAlerteWaze' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.HistoAlerteWaze.txt"