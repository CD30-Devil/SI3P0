. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"

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
Remove-Item "$dossierDonnees\*.csv"

$infosTroncons = @()
$infosStations = @()

# pour chaque tronçon hydrographique
foreach ($codeTroncon in $codeTroncons) {

    # récupération de ses informations
    $infosTroncon = Invoke-RestMethod -Uri "https://www.vigicrues.gouv.fr/services/1/TronEntVigiCru.jsonld/?CdEntVigiCru=$codeTroncon&TypEntVigiCru=8"
        $infosTroncons += [pscustomobject]@{
        CodeTroncon = $codeTroncon
        Libelle = $infosTroncon.'vic:TronEntVigiCru'.'vic:LbEntVigiCru'.Replace("'", "''")
    }

    # et récupération des informations des stations associées
    foreach ($station in $infosTroncon.'vic:TronEntVigiCru'.'vic:aNMoinsUn') {
        
        $infosStation = Invoke-RestMethod -Uri "https://hubeau.eaufrance.fr/api/v1/hydrometrie/referentiel/stations?&code_station=$($station.'vic:CdEntVigiCru')&format=json&fields=libelle_station,coordonnee_x_station,coordonnee_y_station"
        
        $infosStations += [pscustomobject]@{
            CodeStation = $station.'vic:CdEntVigiCru'
            CodeTroncon = $codeTroncon
            Libelle = [Text.Encoding]::UTF8.GetString([Text.Encoding]::GetEncoding(28591).GetBytes($infosStation.data.libelle_station)).Replace("'", "''")
            X = $infosStation.data.coordonnee_x_station.ToString([CultureInfo]::InvariantCulture)
            Y = $infosStation.data.coordonnee_y_station.ToString([CultureInfo]::InvariantCulture)
        }
    }
}

$infosTroncons | Export-Csv -Path "$dossierDonnees\tronçons.csv" -NoTypeInformation -Delimiter ';' -Encoding UTF8
$infosStations | Export-Csv -Path "$dossierDonnees\stations.csv" -NoTypeInformation -Delimiter ';' -Encoding UTF8