﻿. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")
. ("$PSScriptRoot\..\..\API\PowerShell\constantes_privées.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\LàD_0hà0h_F10min_moissonner_peupler"

# nettoyage préalable
Remove-Item "$dossierDonnees\relevés.sql"
Remove-Item "$dossierRapports\*"

# recherche des stations à moissonner
SIg-Exporter-CSV -csv "$dossierRapports\Stations météo.csv" -requete 'select IdSource from m.StationMeteo'
$stationsInfoClimat = Import-Csv "$dossierRapports\Stations météo.csv"

# appel de l'API www.infoclimat.fr
$parametres = ($stationsInfoClimat | foreach { "stations[]=$($_.idsource)" }) -join '&'
$resultat = Invoke-RestMethod -Uri "https://www.infoclimat.fr/opendata/?method=get&format=json&$parametres&start=$([DateTime]::Now.AddDays(-1).ToString('yyyy-MM-dd'))&end=$([DateTime]::Now.ToString('yyyy-MM-dd'))&token=$cleInfoClimat"

# préparation des ordres SQL d'insertion des relevés
$releves = (
    $resultat.stations | foreach {

        foreach ($releve in $resultat.hourly."$($_.id)") {
            
            $sb = [Text.StringBuilder]::new()

            [void]$sb.Append('(')

            [void]$sb.Append("'https://www.infoclimat.fr', ")

            [void]$sb.Append("'$($releve.id_station)', ")

            [void]$sb.Append("to_timestamp('$($releve.dh_utc)', 'YYYY-MM-DD HH24:MI:SS')::timestamp at time zone 'UTC', ")

            if ([Regex]::Match($releve.temperature, '^-?\d+(\.\d+)?$').Success) {
                [void]$sb.Append("round($($releve.temperature), 1), ")
            }
            else {
                [void]$sb.Append("null, ")
            }

            if ([Regex]::Match($releve.pression, '^\d+(\.\d+)?$').Success) {
                [void]$sb.Append("round($($releve.pression), 1), ")
            }
            else {
                [void]$sb.Append("null, ")
            }

            if ([Regex]::Match($releve.humidite, '^\d+$').Success) {
                [void]$sb.Append("$($releve.humidite), ")
            }
            else {
                [void]$sb.Append("null, ")
            }

            if ([Regex]::Match($releve.point_de_rosee, '^-?\d+(\.\d+)?$').Success) {
                [void]$sb.Append("round($($releve.point_de_rosee), 1), ")
            }
            else {
                [void]$sb.Append("null, ")
            }

            if ([Regex]::Match($releve.vent_moyen, '^\d+(\.\d+)?$').Success) {
                [void]$sb.Append("round($($releve.vent_moyen), 1), ")
            }
            else {
                [void]$sb.Append("null, ")
            }

            if ([Regex]::Match($releve.vent_direction, '^\d+$').Success) {
                [void]$sb.Append("$($releve.vent_direction), ")
            }
            else {
                [void]$sb.Append("null, ")
            }

            if ([Regex]::Match($releve.pluie_1h, '^\d+$').Success) {
                [void]$sb.Append($releve.pluie_1h)
            }
            else {
                [void]$sb.Append("null")
            }
        
            [void]$sb.Append(")")

            $sb.ToString()

        }

    }
) -join ", `n"

# construction d'un fichier SQL
$fichierSQL = "$dossierDonnees\relevés.sql"
$ecriture = [System.IO.StreamWriter]::new($fichierSQL, [Text.UTF8Encoding]::new($true))

$ecriture.WriteLine("set search_path to m, f, public;");
$ecriture.WriteLine("start transaction;")
$ecriture.WriteLine("")

$ecriture.WriteLine("delete from ReleveMeteo;")
$ecriture.WriteLine("")

$ecriture.WriteLine("insert into ReleveMeteo (Source, IdSource, DateReleve, Temperature, Pression, Humidite, PointRosee, VentMoyen, DirectionVent, Pluie1h) values")
$ecriture.WriteLine("$releves;")
$ecriture.WriteLine("")

$ecriture.WriteLine("commit;")

$ecriture.Close() 
$ecriture = $null

# exécution du fichier SQL construit
SIg-Executer-Fichier -fichier $fichierSQL -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - exécution relevés.sql.txt"