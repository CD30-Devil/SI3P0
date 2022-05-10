. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\exporter"
$dossierSQL4Layer = "$PSScriptRoot\..\SQL.4Layer"
$dossierSQL4Sheet = "$PSScriptRoot\..\SQL.4Sheet"
$dossierSQLPart = "$PSScriptRoot\..\SQL.4Part"

# nettoyage préalable
Remove-Item "$dossierRapports\*.txt"
Remove-Item "$dossierRapports\*.err"

SIg-Executer-Fichier -fichier "$dossierSQL4Layer\tmp(.v).4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Layer (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\tmp(.v).4Sheet (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Sheet (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQLPart\tmp(.v).4Part (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Part (drop).txt"

# création des vues pour la production des exports
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\tmp(.v).4Layer (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Layer (create).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\tmp(.v).4Sheet (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Sheet (create).txt"
SIg-Executer-Fichier -fichier "$dossierSQLPart\tmp(.v).4Part (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Part (create).txt"

# recherche de la liste des itinéraires
SIg-Exporter-CSV -requete "select NumeroItineraireCyclable, NomOfficiel from m.itinerairecyclable" -csv "$dossierRapports\itinéraires.csv"

# paramétrage des jobs d'export
$parametresJobs = [Collections.ArrayList]::new()

# geojson (WGS84)
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VVV_AvecDoublons_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\3V\D30_3V avec doublons.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_3V avec doublons.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VVV_SansDoublons_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\3V\D30_3V sans doublons.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_3V sans doublons.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VVV_InventaireD30_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\3V\D30_Inventaire.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Inventaire.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VVV_ModesDoux_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\3V\D30_Modes doux.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Modes doux.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VVV_PortionUniforme_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\3V\D30_Portion uniforme.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Portion uniforme.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VVV_EtiquetageItineraire_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\3V\D30_Etiquetage itinéraire.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Etiquetage itinéraire.geojson.txt"))

foreach ($itineraire in Import-Csv -Delimiter (Get-Culture).TextInfo.ListSeparator -Path "$dossierRapports\itinéraires.csv") {
    [void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from tmp.VVV_AvecDoublons_4Layer where `"`"NumeroItineraire`"`" = '$($itineraire.NumeroItineraireCyclable)'" -geoJSON "$si3p0DossierExportGeoJSON\3V\Itinéraires\$($itineraire.NumeroItineraireCyclable) - $($itineraire.NomOfficiel).geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export $($itineraire.NumeroItineraireCyclable) - $($itineraire.NomOfficiel).geojson.txt"))
}
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from tmp.VVV_AvecDoublons_4Layer where `"`"NumeroItineraire`"`" is null" -geoJSON "$si3p0DossierExportGeoJSON\3V\Itinéraires\Hors itinéraires.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export Hors itinéraires.geojson.txt"))

# shp
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete 'select * from tmp.VVV_AvecDoublons_4SHP' -shp "$si3p0DossierExportSHP\3V\D30_3V avec doublons.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_3V avec doublons.shp.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-SHP -requete 'select * from tmp.VVV_SansDoublons_4SHP' -shp "$si3p0DossierExportSHP\3V\D30_3V sans doublons.shp" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_3V sans doublons.shp.txt"))

# csv
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VVV_InventaireD30ParStatut_4Sheet' -csv "$si3p0ThematiquesPortailWeb\3V\Tableaux\csv\Linéaire du Gard par statut.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VVV_InventaireD30ParPortion_4Sheet' -csv "$si3p0ThematiquesPortailWeb\3V\Tableaux\csv\Linéaire du Gard par portion.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VVV_InventaireD30ParItineraire_4Sheet' -csv "$si3p0ThematiquesPortailWeb\3V\Tableaux\csv\Linéaire du Gard par itinéraire.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VVV_Itineraire_4Sheet' -csv "$si3p0ThematiquesPortailWeb\3V\Tableaux\csv\Itinéraires cyclables.csv"))

# partenaires
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VetT_Segment_4Layer' -geoJSON "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_Segment.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_V&T_Segment.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VetT_RTronconSegment_4Sheet' -csv "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_R_Troncon_Segment.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VetT_Portion_4Layer' -geoJSON "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_Portion.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_V&T_Portion.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VetT_RElementPortion_4Sheet' -csv "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_R_Element_Portion.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VetT_Itineraire_4Sheet' -csv "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_Itineraire.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VetT_BoucleCyclo_4Layer' -geoJSON "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_BoucleCyclo.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_V&T_BoucleCyclo.geojson.txt"))

# exécution des jobs d'export
Executer-Jobs -parametresJobs $parametresJobs

# génération des fichiers HTML correspondants aux CSV
SI3P0-Generer-Tableaux-Portail -dossier "$si3p0ThematiquesPortailWeb\3V\Tableaux\csv" -urlDossier "./csv" -sortie "$si3p0ThematiquesPortailWeb\3V\Tableaux"

# nettoyage final
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\tmp(.v).4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Layer (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\tmp(.v).4Sheet (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Sheet (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQLPart\tmp(.v).4Part (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Part (drop).txt"