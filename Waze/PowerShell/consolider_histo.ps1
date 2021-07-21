. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\consolider_histo"
$dossierSQL = "$PSScriptRoot\..\SQL"

# nettoyage préalable
Remove-Item "$dossierRapports\*.txt"
Remove-Item "$dossierRapports\*.err"

# exécution de la purge
SIg-Executer-Fichier -fichier "$dossierSQL\_consolider histo.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _consolider histo.txt"