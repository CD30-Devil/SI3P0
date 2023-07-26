. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\manuel_exporter"
$dossierSQL4Layer = "$PSScriptRoot\..\SQL.4Layer"
$dossierSQL4Sheet = "$PSScriptRoot\..\SQL.4Sheet"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

SIg-Executer-Fichier -fichier "$dossierSQL4Layer\4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Layer (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\4Sheet (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Sheet (drop).txt"

# création des vues pour la production des exports
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\4Layer (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Layer (create).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\4Sheet (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Sheet (create).txt"

# extraction des informations concernant les itinéraires
SIg-Exporter-CSV -csv "$dossierRapports\itinéraires.csv" -requete 'select * from tmp.D30_InfosItineraires'
$itineraires = Import-Csv -Delimiter (Get-Culture).TextInfo.ListSeparator -Path "$dossierRapports\itinéraires.csv"

# paramétrage des jobs d'export
$parametresJobs = [Collections.ArrayList]::new()

# gpkg
[void]$parametresJobs.Add((
    Parametrer-Job-SIg-Exporter-GPKG `
        -requetes `            'select * from tmp.D30_3VAvecDoublons_4Layer', `            'select * from tmp.D30_3VSansDoublons_4Layer', `            'select * from tmp.D30_3VSegmentCyclableGard_4Layer' `        -gpkg "$si3p0DossierExportGPKG\3V\3V.gpkg" `        -couches `            'D30_3VAvecDoublons', `            'D30_3VSansDoublons', `            'D30_3VSegmentCyclableGard' `        -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export 3V.gpkg.txt"))

$requetesItineraires = $itineraires |  ForEach { "select * from tmp.D30_3VAvecDoublons_4Layer where `"`"NumeroItineraire`"`" = '$($_.NumeroItineraireCyclable)'" }
$requetesItineraires += "select * from tmp.D30_3VAvecDoublons_4Layer where `"`"NumeroItineraire`"`" is null"
$couchesItineraires = $itineraires | ForEach { """$($_.NumeroItineraireCyclable) - $($_.NomOfficiel)""" }
$couchesItineraires += '"Hors itinéraire"'

[void]$parametresJobs.Add((
    Parametrer-Job-SIg-Exporter-GPKG `
        -requetes $requetesItineraires `        -gpkg "$si3p0DossierExportGPKG\3V\Itinéraires.gpkg" `        -couches $couchesItineraires `        -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export Itinéraires.gpkg.txt"))

[void]$parametresJobs.Add((
    Parametrer-Job-SIg-Exporter-GPKG `
        -requetes `            'select * from tmp.D30_3VPortionUniforme_4Layer', `            'select * from tmp.D30_3VEtiquetageItineraire_4Layer' `        -gpkg "$PSScriptRoot\..\QGis\Couches\3V.gpkg" `        -couches `            'D30_3VPortionUniforme', `            'D30_3VEtiquetageItineraire' `        -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export 3V.gpkg (couches QGis).txt"))

# geojson
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.D30_3VAvecDoublons_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\3V\D30_3V avec doublons.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_3V avec doublons.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.D30_3VSansDoublons_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\3V\D30_3V sans doublons.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_3V sans doublons.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.D30_3VSegmentCyclableGard_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\3V\D30_Segments cyclables propriété du Gard.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Segments cyclables propriété du Gard.txt"))

[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.D30_3VModesDoux_4Layer' -geoJSON "$si3p0DossierExportGeoJSON\3V\D30_Modes doux.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Modes doux.geojson.txt"))

# csv
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.D30_VoteAssemblee_3VLineaireParItineraire_4Sheet' -csv "$si3p0ThematiquesPortailWeb\3V\Tableaux\csv\Vote Assemblée - Linéaire par itinéraire au 12-2022.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.D30_3VItineraire_4Sheet' -csv "$si3p0ThematiquesPortailWeb\3V\Tableaux\csv\Itinéraires cyclables et portions constituantes.csv"))

# exécution des jobs d'export
Executer-Jobs -parametresJobs $parametresJobs

# génération des fichiers HTML correspondants aux CSV
SI3P0-Generer-Tableaux-Portail -dossier "$si3p0ThematiquesPortailWeb\3V\Tableaux\csv" -urlDossier "./csv" -sortie "$si3p0ThematiquesPortailWeb\3V\Tableaux"

# nettoyage final
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Layer (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\4Sheet (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Sheet (drop).txt"