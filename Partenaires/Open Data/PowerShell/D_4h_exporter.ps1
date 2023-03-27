. ("$PSScriptRoot\..\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\D_4h_exporter"
$dossierSQL4Sheet = "$PSScriptRoot\..\SQL.4Sheet"
$dossierSQLPart = "$PSScriptRoot\..\SQL.4Part"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\4Sheet (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Sheet (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQLPart\4Part (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Part (drop).txt"

# création des vues pour la production des exports
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\4Sheet (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Sheet (create).txt"
SIg-Executer-Fichier -fichier "$dossierSQLPart\4Part (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Part (create).txt"

# paramétrage des jobs d'export
$parametresJobs = [Collections.ArrayList]::new()

# >> 3V -----------------------------------------------------------------------

# extraction des informations concernant les itinéraires
SIg-Exporter-CSV -csv "$dossierRapports\itinéraires.csv" -requete 'select * from tmp.D30_InfosItineraires'
$itineraires = Import-Csv -Delimiter (Get-Culture).TextInfo.ListSeparator -Path "$dossierRapports\itinéraires.csv"

foreach ($itineraire in Import-Csv -Delimiter (Get-Culture).TextInfo.ListSeparator -Path "$dossierRapports\itinéraires.csv") {

    # publication à partir de :
    if (($itineraire.NumeroItineraireCyclable.StartsWith('BD30') -and [int]::Parse($itineraire.TauxOuverture) -ge 95) -or # - 95% d'ouverture pour les boucles
        ($itineraire.NumeroItineraireCyclable.StartsWith('ID30') -and [int]::Parse($itineraire.TauxOuverture) -ge 50) -or # - 50% pour les itinéraires départementaux
        ($itineraire.NumeroItineraireCyclable.StartsWith('V') -and [int]::Parse($itineraire.TauxOuverture) -ge 10) -or    # - 10% pour les itinéraires nationaux
        ($itineraire.NumeroItineraireCyclable.StartsWith('EV') -and [int]::Parse($itineraire.TauxOuverture) -ge 5)) {     # - 5% pour les itinéraires européens

        [void]$parametresJobs.Add((
            Parametrer-Job-SIg-Exporter-GeoJSON `                -requete "select * from tmp.D30_OpenData_3V_4Part where `"`"NumeroItineraire`"`" = '$($itineraire.NumeroItineraireCyclable)'" `                -geoJSON "$si3p0DossierExportPartenaires\Open Data\3V\GeoJSON\$($itineraire.NumeroItineraireCyclable) - $($itineraire.NomOfficielSansAccent).geojson" `                -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export $($itineraire.NumeroItineraireCyclable) - $($itineraire.NomOfficielSansAccent).geojson.txt"))
        
        [void]$parametresJobs.Add((            Parametrer-Job-SIg-Exporter-GPX `                -gpx "$si3p0DossierExportPartenaires\Open Data\3V\GPX\$($itineraire.NumeroItineraireCyclable) - $($itineraire.NomOfficielSansAccent).gpx" `                -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export Géométrie - $($itineraire.NumeroItineraireCyclable) - $($itineraire.NomOfficielSansAccent).gpx.txt" `                -requete @"
                    select ST_LineMerge(ST_Collect(Geom)) as Geom
                    from tmp.D30_OpenData_3V_4Part
                    where ""NumeroItineraire"" = '$($itineraire.NumeroItineraireCyclable)'
                    group by ""NumeroItineraire"", ""NomItineraire""
"@))
    
    }
}

# << 3V -----------------------------------------------------------------------

# >> Référentiel routier ------------------------------------------------------

[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.D30_OpenData_Troncon_4Part' -geoJSON "$si3p0DossierExportPartenaires\Open Data\Référentiel routier\D30_Troncon.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Troncon.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.D30_OpenData_PR_4Part' -geoJSON "$si3p0DossierExportPartenaires\Open Data\Référentiel routier\D30_PR.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_PR.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.D30_OpenData_Giratoire_4Part' -geoJSON "$si3p0DossierExportPartenaires\Open Data\Référentiel routier\D30_Giratoire.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Giratoire.geojson.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.D30_OpenData_RDAgregeeParNiveau_4Part' -geoJSON "$si3p0DossierExportPartenaires\Open Data\Référentiel routier\D30_RD agregee par niveau.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_RD agregee par niveau.geojson.txt"))

# << Référentiel routier ------------------------------------------------------

# >> comparatif référentiel routier / OSM -------------------------------------

[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GeoJSON -requete 'select * from tmp.D30_OpenData_ComparatifRefRoutierOSM_4Part' -geoJSON "$si3p0DossierExportPartenaires\Open Data\Référentiel routier\D30_Comparatif referentiel routier - OSM.geojson" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export D30_Comparatif referentiel routier - OSM.geojson.txt"))

# << comparatif référentiel routier / OSM -------------------------------------


# exécution des jobs d'export
Executer-Jobs -parametresJobs $parametresJobs

# nettoyage final
SIg-Executer-Fichier -fichier "$dossierSQL4Sheet\4Sheet (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Sheet (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQLPart\4Part (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Part (drop).txt"