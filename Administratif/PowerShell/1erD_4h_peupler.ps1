. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\1erD_4h_peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

SIg-Effacer-Table -table 'tmp.source_canton' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_canton.txt"
SIg-Effacer-Table -table 'tmp.source_zonemontagne' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_zonemontagne.txt"

# création des structures temporaires
SIg-Creer-Table-Temp -table 'tmp.source_zonemontagne' -colonnes 'objectid_1', 'objectid', 'id_rte500', 'Commune', 'InseeCommune', 'Superficie', 'Statut', 'Departement', 'Region', 'CodeZoneMontagne', 'ZoneMontagne', 'st_area', 'st_perimeter', 'st_area_shape', 'st_perimeter_shape', 'geo_shape', 'geo_point_2d' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.source_zonemontagne.txt"

# import des données dans les structures temporaires
SIg-Importer-SHP -shp "$dossierDonnees\Cantons*.shp" -table 'tmp.source_canton' -sridSource 4326 -sridCible 4326 -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import Cantons.shp.txt"
SIg-Importer-CSV -csv "$dossierDonnees\zone-montagne-occitanie.csv" -table 'tmp.source_zonemontagne' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import zone-montagne-occitanie.csv.txt"

# transfert des données du schéma d et tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

# paramétrage des jobs de recalage des cantons sur les limites de communes (/!\ le recalage est approximatif pour les cantons avec fraction de commune)
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((Parametrer-Job-SIg-Executer-Fichier -fichier "$dossierSQL\_recaler cantons sans fraction.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _recaler cantons sans fraction.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Executer-Fichier -fichier "$dossierSQL\_recaler cantons avec fraction.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _recaler cantons avec fraction.txt"))

# exécution des jobs de de recalage des cantons sur les limites de communes
Executer-Jobs -parametresJobs $parametresJobs

# rafraîchissement des vues matérialisées
SIg-Executer-Fichier -fichier "$dossierSQL\_rafraîchir vues matérialisées.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _rafraîchir vues matérialisées.txt"

# nettoyage final
SIg-Effacer-Table -table 'tmp.source_canton' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_canton.txt"
SIg-Effacer-Table -table 'tmp.source_zonemontagne' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_zonemontagne.txt"