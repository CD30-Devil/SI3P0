. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\D_4h_vérifier"
$dossierSQL = "$PSScriptRoot\..\SQL"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

# vérification
SIg-Executer-Fichier -fichier "$dossierSQL\_vérifier.sql" -autresParams '--tuples-only', '--no-align' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _vérifier.txt"