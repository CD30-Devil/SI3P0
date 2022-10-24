. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\1erD_4h_peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

SIg-Effacer-Table -table 'tmp.source_qpv' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_qpv.txt"

# extraction des données et import dans les structures temporaires
SIg-Importer-SHP -shp "$dossierDonnees\QP_METROPOLE_LB93.shp" -table 'tmp.source_qpv' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import QP_METROPOLE_LB93.shp.txt"

# transfert des données du schéma tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

# nettoyage final
SIg-Effacer-Table -table 'tmp.source_qpv' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_qpv.txt"