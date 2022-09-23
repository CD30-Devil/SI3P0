. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierSQL = "$PSScriptRoot\..\SQL"
$dossierRapports = "$PSScriptRoot\..\Rapports\manuel_peupler"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

SIg-Executer-Fichier -fichier "$dossierSQL\tables de précalcul (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tables de précalcul (drop).txt"

SIg-Effacer-Table -table 'tmp.source_insee_cog_canton' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_insee_cog_canton.txt"
SIg-Effacer-Table -table 'd.insee_filosofi_carroyage_200m' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement insee_filosofi_carroyage_200m.txt"
SIg-Effacer-Table -table 'd.insee_filosofi_carroyage_1000m' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement insee_filosofi_carroyage_1000m.txt"

# création des structures temporaires
SIg-Creer-Table-Temp -table 'tmp.source_insee_cog_canton' -colonnes 'id_canton', 'id_departement', 'id_region', 'compct', 'burcentral', 'tncc', 'ncc', 'nccenr', 'libelle', 'typect' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.source_insee_cog_canton.txt"

# paramétrage des jobs d'import
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-CSV -csv "$dossierDonnees\canton.csv" -table 'tmp.source_insee_cog_canton' -delimiteur ',' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import canton.csv.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-GPKG -gpkg "$dossierDonnees\filosofi_carreaux_200m_met.gpkg" -couche 'Filosofi2017_carreaux_200m_met' -table 'd.insee_filosofi_carroyage_200m' -multiGeom $false -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import filosofi_carreaux_200m_met.gpkg.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-GPKG -gpkg "$dossierDonnees\filosofi_carreaux_1km_met.gpkg" -couche 'Filosofi2017_carreaux_1km_met' -table 'd.insee_filosofi_carroyage_1000m' -multiGeom $false -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import filosofi_carreaux_1km_met.gpkg.txt"))

# exécution des jobs d'import
Executer-Jobs -parametresJobs $parametresJobs

# transfert des données du schéma tmp au schéma d
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

# création des tables de précalcul
SIg-Paralleliser-Fichier-Transactions -fichier "$dossierSQL\tables de précalcul (create).sql" -dossierSortie $dossierRapports

# nettoyage final
SIg-Effacer-Table -table 'tmp.source_insee_cog_canton' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_insee_cog_canton.txt"