. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\exporter"
$dossierSQL4Layer = "$PSScriptRoot\..\SQL.4Layer"

# nettoyage préalable
Remove-Item -Path "$dossierRapports\*.txt"
Remove-Item -Path "$dossierRapports\*.err"

SIg-Executer-Fichier -fichier "$dossierSQL4Layer\tmp(.v).4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Layer (drop).txt"

# création des vues pour la production des exports
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\tmp(.v).4Layer (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Layer (create).txt"

# paramétrage des jobs d'export
$parametresJobs = New-Object System.Collections.ArrayList

[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from tmp.Autoroute_4Layer" -geoJSON "$si3p0DossierExportGeoJSON\Autoroutes et RN\FR_Autoroute.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_Autoroute.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from tmp.D30Autoroute_4Layer" -geoJSON "$si3p0DossierExportGeoJSON\Autoroutes et RN\D30_Autoroute.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Autoroute.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from tmp.RN_4Layer" -geoJSON "$si3p0DossierExportGeoJSON\Autoroutes et RN\FR_RN.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_RN.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from tmp.D30RN_4Layer" -geoJSON "$si3p0DossierExportGeoJSON\Autoroutes et RN\D30_RN.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_RN.geojson.txt"))

# exécution des jobs d'export
Executer-Jobs -parametresJobs $parametresJobs

# nettoyage final
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\tmp(.v).4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Layer (drop).txt"