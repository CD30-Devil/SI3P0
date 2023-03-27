. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\1erD_4h_peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

# nettoyage préalable
Remove-Item -Path "$dossierRapports\*"

SIg-Effacer-Table -table 'tmp.source_osm_route_departementale' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_osm_route_departementale.txt"

# import dans les structures temporaires
SIg-Importer-JSON -json "$dossierDonnees\Routes départementales du Gard.json" -table "tmp.source_osm_route_departementale" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import Routes départementales du Gard.json.txt"

# transfert des données du schéma tmp au schéma d
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

# nettoyage final
SIg-Effacer-Table -table 'tmp.source_osm_route_departementale' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_osm_route_departementale.txt"