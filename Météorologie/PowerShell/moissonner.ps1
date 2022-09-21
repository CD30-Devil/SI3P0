. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")
. ("$PSScriptRoot\..\..\API\PowerShell\constantes_privées.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"

# liste des stations à moissonner
$stationsInfoClimat = @(
    '000UJ' # Chusclan
    'ME132' # Collège Paul Valéry - Roquemaure
    '000WD' # Concoules
    '000ZN' # Galargues
    '000OZ' # Gallargues-le-Montueux
    '000F1' # Le Grau-du-Roi - Salonique
    '00002' # Le Vigan
    '000UL' # Lussan - Audabiac
    '000ZW' # Lussan - La Lèque
    '000FK' # Malbosc
    '000OW' # Montaren-et-Saint-Médiers
    '000BZ' # Saint-Hilaire-de-Brethmas
    '000ZB' # Saint-Paul-les-Fonts
    '000OB' # Sauteyrargues
    '000GK' # Thoiras
    '000UB' # Valleraugue
    '000YB' # Vialas
    '000Q4' # Villefort - Mas de la Barque
)

# nettoyage préalable
Remove-Item "$dossierDonnees\www.infoclimat.fr.csv"

# appel de l'API www.infoclimat.fr
$parametres = [string]::Join('&', ($stationsInfoClimat | foreach -process { "stations[]=$_" }))
$donneesInfoClimat = Invoke-RestMethod -Uri "https://www.infoclimat.fr/opendata/?method=get&format=json&$parametres&start=$([DateTime]::Now.AddDays(-1).ToString('yyyy-MM-dd'))&end=$([DateTime]::Now.ToString('yyyy-MM-dd'))&token=$cleInfoClimat"

# transformation du retour en fichier CSV
$releves = [Collections.ArrayList]::new()

foreach ($station in $donneesInfoClimat.stations) {
    
    foreach ($releve in $donneesInfoClimat.hourly."$($station.id)") {

        [void]$releves.Add([pscustomobject]@{
            Source = 'https://www.infoclimat.fr'
            IdSource = $station.id
            Nom = $station.name
            Longitude = ($station.longitude -replace ',', '.')
            Latitude = ($station.latitude -replace ',', '.')
            DateReleve = $releve.dh_utc
            Temperature = ($releve.temperature -replace ',', '.')
            Pression = ($releve.pression -replace ',', '.')
            Humidite = ($releve.humidite -replace ',', '.')
            PointRosee = ($releve.point_de_rosee -replace ',', '.')
            VentMoyen = ($releve.vent_moyen -replace ',', '.')
            VentRafales = ($releve.vent_rafales -replace ',', '.')
            DirectionVent = $releve.vent_direction
            Pluie1h = $releve.pluie_1h
        })
    }
}

$releves | Export-Csv -Path "$dossierDonnees\www.infoclimat.fr.csv" -NoTypeInformation -Delimiter ';' -Encoding UTF8