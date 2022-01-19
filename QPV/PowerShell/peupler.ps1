. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

# nettoyage préalable
Remove-Item "$dossierRapports\*.txt"
Remove-Item "$dossierRapports\*.err"

Remove-Item "$dossierTravailTemp\qpv_peupler\*"

SIg-Effacer-Table -table 'tmp.QPV' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.QPV.txt"

# import des données dans les structures temporaires
Executer-7Z -commande 'e' -archive "$dossierDonnees\qp-politiquedelaville-shp.zip" -autresParams "-o`"$dossierTravailTemp\qpv_peupler`"", "-i!QP_METROPOLE_LB93.*"
SIg-Importer-SHP -shp "$dossierTravailTemp\qpv_peupler\QP_METROPOLE_LB93.shp" -table 'tmp.QPV' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import QP_METROPOLE_LB93.shp.txt"

# transfert des données du schéma tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

# nettoyage final
Remove-Item "$dossierTravailTemp\qpv_peupler\*"

SIg-Effacer-Table -table 'tmp.QPV' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.QPV.txt"