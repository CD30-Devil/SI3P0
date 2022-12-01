. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\1erD_4h_exporter"
$dossierSQL4Layer = "$PSScriptRoot\..\SQL.4Layer"

# nettoyage préalable
Remove-Item -Path "$dossierRapports\*.txt"
Remove-Item -Path "$dossierRapports\*.err"

SIg-Executer-Fichier -fichier "$dossierSQL4Layer\4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Layer (drop).txt"

# création des vues pour la production des exports
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\4Layer (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Layer (create).txt"

# paramétrage des jobs d'export
$parametresJobs = [Collections.ArrayList]::new()

# geojson (WGS84)
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.LigneSNCF_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\SNCF\FR_Ligne SNCF.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_Ligne SNCF.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.PN_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\SNCF\FR_Passage à niveau.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_Passage à niveau.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.LigneSNCF_4Layer where ST_Intersects(Geom, (select Geom from v.Gard))' -geoJSON "$si3p0DossierExportGeoJSON\SNCF\D30_Ligne SNCF.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Ligne SNCF.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.PN_4Layer where ST_Intersects(Geom, (select Geom from v.Gard))' -geoJSON "$si3p0DossierExportGeoJSON\SNCF\D30_Passage à niveau.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Passage à niveau.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.PNSurRD_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\SNCF\D30_Passage à niveau sur RD.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Passage à niveau sur RD.geojson.txt"))#>

# shp
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete 'select * from tmp.LigneSNCF_4SHP' -shp "$si3p0DossierExportSHP\SNCF\FR_Ligne SNCF.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_Ligne SNCF.shp.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete 'select * from tmp.PN_4SHP' -shp "$si3p0DossierExportSHP\SNCF\FR_Passage à niveau.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_Passage à niveau.shp.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete 'select * from tmp.LigneSNCF_4SHP where ST_Intersects(Geom, (select Geom from v.Gard))' -shp "$si3p0DossierExportSHP\SNCF\D30_Ligne SNCF.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Ligne SNCF.shp.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete 'select * from tmp.PN_4SHP where ST_Intersects(Geom, (select Geom from v.Gard))' -shp "$si3p0DossierExportSHP\SNCF\D30_Passage à niveau.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Passage à niveau.shp.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete 'select * from tmp.PNSurRD_4SHP' -shp "$si3p0DossierExportSHP\SNCF\D30_Passage à niveau sur RD.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Passage à niveau sur RD.shp.txt"))

# exécution des jobs d'export
Executer-Jobs -parametresJobs $parametresJobs

# nettoyage final
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Layer (drop).txt"