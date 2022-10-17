. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\1erD_4h_exporter"
$dossierSQL4Layer = "$PSScriptRoot\..\SQL.4Layer"

# nettoyage préalable
Remove-Item -Path "$dossierRapports\*"

SIg-Executer-Fichier -fichier "$dossierSQL4Layer\tmp(.v).4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Layer (drop).txt"

# création des vues pour la production des exports
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\tmp(.v).4Layer (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Layer (create).txt"

# paramétrage des jobs d'export
$parametresJobs = [Collections.ArrayList]::new()

# geojson (WGS84)
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from Region_4Layer" -geoJSON "$si3p0DossierExportGeoJSON\Administratif\FR_Région.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_Région.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from Departement_4Layer" -geoJSON "$si3p0DossierExportGeoJSON\Administratif\FR_Département.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_Département.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from EPCI_4Layer" -geoJSON "$si3p0DossierExportGeoJSON\Administratif\FR_EPCI.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_EPCI.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from Commune_4Layer" -geoJSON "$si3p0DossierExportGeoJSON\Administratif\FR_Commune.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_Commune.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from Canton_4Layer" -geoJSON "$si3p0DossierExportGeoJSON\Administratif\FR_Canton.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_Canton.geojson.txt"))

[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from Region_4Layer where \`"COGRegion\`" = '76'" -geoJSON "$si3p0DossierExportGeoJSON\Administratif\D30_Région.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Région.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from Departement_4Layer where \`"COGDepartement\`" = '30'" -geoJSON "$si3p0DossierExportGeoJSON\Administratif\D30_Département.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Département.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from EPCI_4Layer where exists (select true from m.Commune where COGDepartement = '30' and SirenEPCI = \`"SirenEPCI\`")" -geoJSON "$si3p0DossierExportGeoJSON\Administratif\D30_EPCI.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_EPCI.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from Commune_4Layer where \`"COGDepartement\`" = '30'" -geoJSON "$si3p0DossierExportGeoJSON\Administratif\D30_Commune.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Commune.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from Canton_4Layer where \`"COGCanton\`" like '30%'" -geoJSON "$si3p0DossierExportGeoJSON\Administratif\D30_Canton.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Canton.geojson.txt"))

# shp
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete "select * from Region_4SHP" -shp "$si3p0DossierExportSHP\Administratif\FR_Région.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_Région.shp.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete "select * from Departement_4SHP" -shp "$si3p0DossierExportSHP\Administratif\FR_Département.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_Département.shp.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete "select * from EPCI_4SHP" -shp "$si3p0DossierExportSHP\Administratif\FR_EPCI.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_EPCI.shp.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete "select * from Commune_4SHP" -shp "$si3p0DossierExportSHP\Administratif\FR_Commune.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_Commune.shp.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete "select * from Canton_4SHP" -shp "$si3p0DossierExportSHP\Administratif\FR_Canton.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export FR_Canton.shp.txt"))

[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete "select * from Region_4SHP where \`"COGRegion\`" = '76'" -shp "$si3p0DossierExportSHP\Administratif\D30_Région.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Région.shp.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete "select * from Departement_4SHP where \`"COGDepart\`" = '30'" -shp "$si3p0DossierExportSHP\Administratif\D30_Département.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Département.shp.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete "select * from EPCI_4SHP where exists (select true from m.Commune where COGDepartement = '30' and SirenEPCI = \`"SirenEPCI\`")" -shp "$si3p0DossierExportSHP\Administratif\D30_EPCI.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_EPCI.shp.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete "select * from Commune_4SHP where \`"COGDepart\`" = '30'" -shp "$si3p0DossierExportSHP\Administratif\D30_Commune.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Commune.shp.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete "select * from Canton_4SHP where \`"COGCanton\`" like '30%'" -shp "$si3p0DossierExportSHP\Administratif\D30_Canton.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Canton.shp.txt"))

# exécution des jobs d'export
Executer-Jobs -parametresJobs $parametresJobs

# nettoyage final
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\tmp(.v).4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Layer (drop).txt"