. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\D_4h_exporter"
$dossierSQL4Layer = "$PSScriptRoot\..\SQL.4Layer"
$dossierSQL4Sheet = "$PSScriptRoot\..\SQL.4Sheet"
$dossierSQLPart = "$PSScriptRoot\..\SQL.4Part"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

SIg-Executer-Fichier -fichier "$dossierSQL4Layer\tmp(.v).4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Layer (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\tmp(.v).4Sheet (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Sheet (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQLPart\tmp(.v).4Part (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Part (drop).txt"

# création des vues pour la production des exports
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\tmp(.v).4Layer (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Layer (create).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\tmp(.v).4Sheet (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Sheet (create).txt"
SIg-Executer-Fichier -fichier "$dossierSQLPart\tmp(.v).4Part (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Part (create).txt"

# recherche de la liste des itinéraires
SIg-Exporter-CSV -csv "$dossierRapports\itinéraires.csv" -requete @"
with ItineraireParEtatAvancement as (
    select ic.NumeroItineraireCyclable, NomOfficiel, sc.CodeEtatAvancement3V, sum(ST_3DLength(Geom)) as Longueur
    from m.ItineraireCyclable ic
    inner join m.PortionCyclable_ItineraireCyclable pi on pi.NumeroItineraireCyclable = ic.NumeroItineraireCyclable
    inner join m.PortionCyclable pc on pc.IdPortionCyclable = pi.IdPortionCyclable
    inner join m.SegmentCyclable_PortionCyclable sp on sp.IdPortionCyclable = pc.IdPortionCyclable
    inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = sp.IdSegmentCyclable
    group by ic.NumeroItineraireCyclable, sc.CodeEtatAvancement3V
)
select total.NumeroItineraireCyclable, total.NomOfficiel, round(coalesce(ouvert.Longueur * 100, 0) / sum(total.Longueur))::integer as TauxOuverture
from ItineraireParEtatAvancement total
left join ItineraireParEtatAvancement ouvert on ouvert.CodeEtatAvancement3V = 4 and ouvert.NumeroItineraireCyclable = total.NumeroItineraireCyclable
group by total.NumeroItineraireCyclable, total.NomOfficiel, ouvert.Longueur
order by NumeroItineraireCyclable
"@

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
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VVVInventaireGlobal_4Sheet' -csv "$si3p0ThematiquesPortailWeb\3V\Tableaux\csv\Inventaire global des portions.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VVVInventaireD30_4Sheet' -csv "$si3p0ThematiquesPortailWeb\3V\Tableaux\csv\Inventaire des portions dont le Gard est propriétaire (hors RD).csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VVVInventaireD30Ouvert_4Sheet' -csv "$si3p0ThematiquesPortailWeb\3V\Tableaux\csv\Inventaire des portions ouvertes dont le Gard est propriétaire (hors RD).csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VVVInventaireD30OuvertPourVote_4Sheet' -csv "$si3p0ThematiquesPortailWeb\3V\Tableaux\csv\Vote Assemblée - Inventaire des portions ouvertes au 12-2021 dont le Gard est propriétaire (hors RD).csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VVVItineraire_4Sheet' -csv "$si3p0ThematiquesPortailWeb\3V\Tableaux\csv\Itinéraires cyclables.csv"))

# partenaires : Vélo et Territoires
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VetT_Segment_4Layer' -geoJSON "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_Segment.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_V&T_Segment.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VetT_RTronconSegment_4Sheet' -csv "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_R_Troncon_Segment.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VetT_Portion_4Layer' -geoJSON "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_Portion.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_V&T_Portion.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VetT_RElementPortion_4Sheet' -csv "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_R_Element_Portion.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-CSV -requete 'select * from tmp.VetT_Itineraire_4Sheet' -csv "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_Itineraire.csv"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.VetT_BoucleCyclo_4Layer' -geoJSON "$si3p0DossierExportPartenaires\Vélo et Territoires\D30_V&T_BoucleCyclo.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_V&T_BoucleCyclo.geojson.txt"))

# partenaires : OpenData
foreach ($itineraire in Import-Csv -Delimiter (Get-Culture).TextInfo.ListSeparator -Path "$dossierRapports\itinéraires.csv") {

    # publication à partir de :
    if (($itineraire.NumeroItineraireCyclable.StartsWith('BD30') -and [int]::Parse($itineraire.TauxOuverture) -ge 95) -or # - 95% d'ouverture pour les boucles
        ($itineraire.NumeroItineraireCyclable.StartsWith('ID30') -and [int]::Parse($itineraire.TauxOuverture) -ge 50) -or # - 50% pour les itinéraires départementaux
        ($itineraire.NumeroItineraireCyclable.StartsWith('V') -and [int]::Parse($itineraire.TauxOuverture) -ge 10) -or    # - 10% pour les itinéraires nationaux
        ($itineraire.NumeroItineraireCyclable.StartsWith('EV') -and [int]::Parse($itineraire.TauxOuverture) -ge 5)) {     # - 5% pour les itinéraires européens
        
        [void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete "select * from tmp.OpenData_3V_4Part where `"`"NumeroItineraire`"`" = '$($itineraire.NumeroItineraireCyclable)'" -geoJSON "$si3p0DossierExportPartenaires\OpenData\3V\GeoJSON\$($itineraire.NumeroItineraireCyclable) - $($itineraire.NomOfficiel).geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export $($itineraire.NumeroItineraireCyclable) - $($itineraire.NomOfficiel).geojson.txt"))
        
        [void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GPX `            -gpx "$si3p0DossierExportPartenaires\OpenData\3V\GPX\$($itineraire.NumeroItineraireCyclable) - $($itineraire.NomOfficiel).gpx" `            -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export Géométrie - $($itineraire.NumeroItineraireCyclable) - $($itineraire.NomOfficiel).gpx.txt" `            -requete @"
                select ST_LineMerge(ST_Collect(Geom)) as Geom
                from tmp.OpenData_3V_4Part
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
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\tmp(.v).4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Layer (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\tmp(.v).4Sheet (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Sheet (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQLPart\tmp(.v).4Part (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Part (drop).txt"