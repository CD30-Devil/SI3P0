. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\précalculer"
$dossierSQL = "$PSScriptRoot\..\SQL"

# nettoyage préalable
Remove-Item -Path "$dossierRapports\*.txt"
Remove-Item -Path "$dossierRapports\*.err"

# exécution du fichier de precalcul
SIg-Paralleliser-Fichier-Transactions -fichier "$dossierSQL\_précalculer.sql" -dossierSortie $dossierRapports