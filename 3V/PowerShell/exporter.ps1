. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\exporter"
$dossierSQL4Layer = "$PSScriptRoot\..\SQL.4Layer"
$dossierSQL4Sheet = "$PSScriptRoot\..\SQL.4Sheet"
$dossierSQLPart = "$PSScriptRoot\..\SQL.4Part"

# nettoyage préalable
Remove-Item -Path "$dossierRapports\*.txt"
Remove-Item -Path "$dossierRapports\*.err"

SIg-Executer-Fichier -fichier "$dossierSQL4Layer\tmp(.v).4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Layer (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\tmp(.v).4Sheet (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Sheet (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQLPart\tmp(.v).4Part (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Part (drop).txt"

# création des vues pour la production des exports
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\tmp(.v).4Layer (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Layer (create).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\tmp(.v).4Sheet (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Sheet (create).txt"
SIg-Executer-Fichier -fichier "$dossierSQLPart\tmp(.v).4Part (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Part (create).txt"

# paramétrage des jobs d'export
$parametresJobs = New-Object System.Collections.ArrayList

#geojson
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VVVAvecDoublons_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\3V\D30_3V avec doublons.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_3V avec doublons.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VVVSansDoublons_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\3V\D30_3V sans doublons.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_3V sans doublons.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VVVInventaireD30_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\3V\D30_Inventaire.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Inventaire.geojson.txt"))

# shp
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete 'select * from tmp.VVVAvecDoublons_4SHP' -shp "$si3p0DossierExportSHP\3V\D30_3V avec doublons.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_3V avec doublons.shp.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete 'select * from tmp.VVVSansDoublons_4SHP' -shp "$si3p0DossierExportSHP\3V\D30_3V sans doublons.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_3V sans doublons.shp.txt"))

# csv
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VVVInventaireD30ParStatut_4Sheet' -csv "$si3p0TableursPortailWeb\Thématique 3V\csv\Inventaire 3V Gard par statut.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VVVInventaireD30ParPortion_4Sheet' -csv "$si3p0TableursPortailWeb\Thématique 3V\csv\Inventaire 3V Gard par portion.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VVVInventaireD30ParItineraires_4Sheet' -csv "$si3p0TableursPortailWeb\Thématique 3V\csv\Inventaire 3V Gard par itinéraires.csv"))

# partenaires
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VetTSegment_4Layer' -geoJSON "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_Segment.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_V&T_Segment.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VetTRTronconSegment_4Sheet' -csv "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_R_Troncon_Segment.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VetTPortion_4Layer' -geoJSON "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_Portion.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_V&T_Portion.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VetTRElementPortion_4Sheet' -csv "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_R_Element_Portion.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VetTItineraire_4Sheet' -csv "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_Itineraire.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.vettbouclecyclo_4Layer' -geoJSON "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_BoucleCyclo.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_V&T_BoucleCyclo.geojson.txt"))

# exécution des jobs d'export
Executer-Jobs -parametresJobs $parametresJobs

# génération des fichiers HTML correspondants aux CSV
foreach ($csv in Get-ChildItem -Path "$si3p0TableursPortailWeb\Thématique 3V\csv\*.csv") {
    SI3P0-Convertir-CSV-Vers-HTML -csv $csv -urlCsv "./csv/$($csv.BaseName).csv" -html "$si3p0TableursPortailWeb\Thématique 3V\$($csv.BaseName).html"
}

# nettoyage final
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\tmp(.v).4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Layer (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\tmp(.v).4Sheet (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Sheet (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQLPart\tmp(.v).4Part (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Part (drop).txt"