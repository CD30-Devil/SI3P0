. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\manuel_exporter"
$dossierSQL4Layer = "$PSScriptRoot\..\SQL.4Layer"
$dossierSQL4Sheet = "$PSScriptRoot\..\SQL.4Sheet"
$dossierSQLPart = "$PSScriptRoot\..\SQL.4Part"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

SIg-Executer-Fichier -fichier "$dossierSQL4Layer\4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Layer (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\4Sheet (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Sheet (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQLPart\4Part (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Part (drop).txt"

# création des vues pour la production des exports
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\4Layer (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Layer (create).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\4Sheet (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Sheet (create).txt"
SIg-Executer-Fichier -fichier "$dossierSQLPart\4Part (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Part (create).txt"

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

# partenaires : Vélo et Territoires
[void]$parametresJobs.Add((
    Parametrer-Job-SIg-Exporter-GPKG `
        -requetes `            'select * from tmp.D30_VetT_3VSegment_4Layer', `            'select * from tmp.D30_VetT_3VRTronconSegment_4Sheet', `            'select * from tmp.D30_VetT_3VPortion_4Layer', `            'select * from tmp.D30_VetT_3VRElementPortion_4Sheet', `            'select * from tmp.D30_VetT_3VItineraire_4Sheet', `            'select * from tmp.D30_VetT_3VBoucleCyclo_4Layer' `        -gpkg "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_3V.gpkg" `        -couches `            'Segment', `            'RTronconSegment', `            'Portion', `            'RElementPortion', `            'Itineraire', `            'BoucleCyclo' `        -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_V&T_3V.gpkg.txt"))            
# partenaires : OpenData
foreach ($itineraire in Import-Csv -Delimiter (Get-Culture).TextInfo.ListSeparator -Path "$dossierRapports\itinéraires.csv") {

    # publication à partir de :
    if (($itineraire.NumeroItineraireCyclable.StartsWith('BD30') -and [int]::Parse($itineraire.TauxOuverture) -ge 95) -or # - 95% d'ouverture pour les boucles
        ($itineraire.NumeroItineraireCyclable.StartsWith('ID30') -and [int]::Parse($itineraire.TauxOuverture) -ge 50) -or # - 50% pour les itinéraires départementaux
        ($itineraire.NumeroItineraireCyclable.StartsWith('V') -and [int]::Parse($itineraire.TauxOuverture) -ge 10) -or    # - 10% pour les itinéraires nationaux
        ($itineraire.NumeroItineraireCyclable.StartsWith('EV') -and [int]::Parse($itineraire.TauxOuverture) -ge 5)) {     # - 5% pour les itinéraires européens

        [void]$parametresJobs.Add((
            Parametrer-Job-SIg-Exporter-GeoJSON `                -requete "select * from tmp.D30_OpenData_3V_4Part where `"`"NumeroItineraire`"`" = '$($itineraire.NumeroItineraireCyclable)'" `                -geoJSON "$si3p0DossierExportPartenaires\OpenData\3V\GeoJSON\$($itineraire.NumeroItineraireCyclable) - $($itineraire.NomOfficielSansAccent).geojson" `                -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export $($itineraire.NumeroItineraireCyclable) - $($itineraire.NomOfficielSansAccent).geojson.txt"))
        
        [void]$parametresJobs.Add((            Parametrer-Job-SIg-Exporter-GPX `                -gpx "$si3p0DossierExportPartenaires\OpenData\3V\GPX\$($itineraire.NumeroItineraireCyclable) - $($itineraire.NomOfficielSansAccent).gpx" `                -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export Géométrie - $($itineraire.NumeroItineraireCyclable) - $($itineraire.NomOfficielSansAccent).gpx.txt" `                -requete @"
                    select ST_LineMerge(ST_Collect(Geom)) as Geom
                    from tmp.D30_OpenData_3V_4Part
                    where ""NumeroItineraire"" = '$($itineraire.NumeroItineraireCyclable)'
                    group by ""NumeroItineraire"", ""NomItineraire""
"@))
    
    }
    
}

# exécution des jobs d'export
Executer-Jobs -parametresJobs $parametresJobs

# génération des fichiers HTML correspondants aux CSV
SI3P0-Generer-Tableaux-Portail -dossier "$si3p0ThematiquesPortailWeb\3V\Tableaux\csv" -urlDossier "./csv" -sortie "$si3p0ThematiquesPortailWeb\3V\Tableaux"

# nettoyage final
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Layer (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\4Sheet (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Sheet (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQLPart\4Part (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Part (drop).txt"