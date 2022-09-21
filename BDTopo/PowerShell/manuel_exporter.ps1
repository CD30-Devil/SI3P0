. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\manuel_exporter"
$dossierSQL4Layer = "$PSScriptRoot\..\SQL.4Layer"

# nettoyage préalable
Remove-Item -Path "$dossierRapports\*"

SIg-Executer-Fichier -fichier "$dossierSQL4Layer\4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Layer (drop).txt"

# création des vues pour la production des exports
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\4Layer (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Layer (create).txt"

# paramétrage des jobs d'export
$parametresJobs = [Collections.ArrayList]::new()

# geojson
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from Autoroute_4Layer" -geoJSON "$si3p0DossierExportGeoJSON\Autres réseaux\FR_Autoroute.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_Autoroute.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from D30Autoroute_4Layer" -geoJSON "$si3p0DossierExportGeoJSON\Autres réseaux\D30_Autoroute.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Autoroute.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from RN_4Layer" -geoJSON "$si3p0DossierExportGeoJSON\Autres réseaux\FR_RN.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_RN.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from D30RN_4Layer" -geoJSON "$si3p0DossierExportGeoJSON\Autres réseaux\D30_RN.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_RN.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from D30VoieFerreeAgregee_4Layer" -geoJSON "$si3p0DossierExportGeoJSON\Autres réseaux\D30_Voie ferrée agrégée.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Voie ferrée agrégée.geojson.txt"))

# exécution des jobs d'export
Executer-Jobs -parametresJobs $parametresJobs

# nettoyage final
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Layer (drop).txt"