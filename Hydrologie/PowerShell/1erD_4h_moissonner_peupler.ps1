. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\1erD_4h_moissonner_peupler"

# liste des tronçons hydrographiques à surveiller
$codeTroncons = @(
    'GA22' # Ardèche aval
    'GA1'  # Cèze amont
    'GA2'  # Cèze aval
    'GA5'  # Gardon aval
    'GA4'  # Gardon d'Anduze
    'GA3'  # Gardons d'Alès
    'MO1'  # Hérault amont
    'GA10' # Rhône de Pont-Saint-Esprit à Avignon
    'GA9'  # Rhône d'Avignon à la mer
    'GA6'  # Vidourle
    'GA7'  # Vistre
)

# nettoyage préalable
Remove-Item "$dossierDonnees\hydrologie.sql"
Remove-Item "$dossierRapports\*"

# construction d'un fichier SQL à partir des données issues de Vigicrues et Hubeau
New-Item -ItemType Directory -Force -Path "$dossierDonnees\"

$fichierSQL = "$dossierDonnees\hydrologie.sql"
$ecriture = [System.IO.StreamWriter]::new($fichierSQL, [Text.UTF8Encoding]::new($true))

$ecriture.WriteLine("set search_path to m, f, public;");
$ecriture.WriteLine("start transaction;")
$ecriture.WriteLine("")
$ecriture.WriteLine("delete from ReleveHydro;")
$ecriture.WriteLine("delete from StationHydro;")
$ecriture.WriteLine("delete from TronconHydro;")
$ecriture.WriteLine("")

# pour chaque tronçon hydrographique
foreach ($codeTroncon in $codeTroncons) {

    $infosTroncon = Invoke-RestMethod -Uri "https://www.vigicrues.gouv.fr/services/1/TronEntVigiCru.jsonld/?CdEntVigiCru=$codeTroncon&TypEntVigiCru=8"
    
    $libelleTroncon = $infosTroncon.'vic:TronEntVigiCru'.'vic:LbEntVigiCru'.Replace("'", "''")

    # génération de l'ordre SQL d'insertion correspondant
    $ecriture.WriteLine("insert into TronconHydro (CodeTronconHydro, Libelle) values ('$codeTroncon', '$libelleTroncon');")
    
    # pour chaque station hydrométrique
    foreach ($station in $infosTroncon.'vic:TronEntVigiCru'.'vic:aNMoinsUn') {
        
        $infosStation = Invoke-RestMethod -Uri "https://hubeau.eaufrance.fr/api/v1/hydrometrie/referentiel/stations?&code_station=$($station.'vic:CdEntVigiCru')&format=json&fields=libelle_station,coordonnee_x_station,coordonnee_y_station"
        
        $codeStation = $station.'vic:CdEntVigiCru'
        $libelleStation = [Text.Encoding]::UTF8.GetString([Text.Encoding]::GetEncoding(28591).GetBytes($infosStation.data.libelle_station)).Replace("'", "''")
        $xStation = $infosStation.data.coordonnee_x_station.ToString([CultureInfo]::InvariantCulture)
        $yStation = $infosStation.data.coordonnee_y_station.ToString([CultureInfo]::InvariantCulture)

        # génération de l'ordre SQL d'insertion correspondant
        $ecriture.WriteLine("insert into StationHydro (CodeStationHydro, CodeTronconHydro, Libelle, Geom) values ('$codeStation', '$codeTroncon', '$libelleStation', FabriquerPointL93($xStation, $yStation));")
    }

    $ecriture.WriteLine("")
}

$ecriture.WriteLine("commit;")
$ecriture.WriteLine("")

$ecriture.Close() 
$ecriture = $null

# exécution du fichier SQL construit
SIg-Executer-Fichier -fichier $fichierSQL -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - exécution hydrologie.sql.txt"