. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")
. ("$PSScriptRoot\..\..\API\PowerShell\constantes_privées.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\notifier"
$dossierSQL4Notif = "$PSScriptRoot\..\SQL.4Notif"

# nettoyage préalable
Remove-Item -Path "$dossierRapports\*.txt"
Remove-Item -Path "$dossierRapports\*.err"
Remove-Item -Path "$dossierRapports\*.csv"
Remove-Item -Path "$dossierTravailTemp\waze_notifier\*.png"

# création des vues pour la production des cartes
SIg-Executer-Fichier -fichier "$dossierSQL4Notif\tmp(.v).4Notif (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Notif (drop).txt"
SIg-Executer-Fichier -fichier "$dossierSQL4Notif\tmp(.v).4Notif (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Notif (create).txt"

# envoi de la notifiation
SIg-Exporter-CSV -requete 'select * from tmp.Waze_4Notif' -csv "$dossierRapports\notification.csv"

$alertes = Import-Csv -Delimiter ';' -Path "$dossierRapports\notification.csv"

if (($alertes | Measure-Object).Count -gt 0) {
    
    $idsTwitter = Twitter-Creer-Identifiants -cle $cleTwitterSI3P0Bot_Waze -cleSecrete $cleSecreteTwitterSI3P0Bot_Waze -jeton $jetonTwitterSI3P0Bot_Waze -jetonSecret $jetonSecretTwitterSI3P0Bot_Waze

    foreach ($alerte in $alertes) {
        Chromium-Capturer-Page -url $alerte.LienWazeEmbed -sortie "$dossierTravailTemp\waze_notifier\Aperçu Waze - $($alerte.NumeroRoute)_$($alerte.PRA).png"
        
        $statut = [Text.StringBuilder]::new()

        # ajout du type d'alerte
        switch ($alerte.TypeAlerte) {
            'ACCIDENT' {
                switch ($alerte.Gravite) {
                    2 { [void]$statut.Append("#Accident grave signalé ") }
                    1 { [void]$statut.Append("#Accident léger signalé ") }
                    default { [void]$statut.Append("#Accident signalé ") }
                }
            }
            'ROAD_CLOSED' {
                [void]$statut.Append("Fermeture de route signalée ")
            }
            'HAZARD_ON_ROAD_ICE' {
                [void]$statut.Append("#Verglas signalé ")
            }
            'HAZARD_ON_ROAD_OBJECT' {
                [void]$statut.Append("#Objet sur la route signalé ")
            }
            'HAZARD_ON_ROAD_OIL' {
                [void]$statut.Append("Traces d'#hydrocarbure signalées ")
            }
            'HAZARD_ON_ROAD_ROAD_KILL' {
                [void]$statut.Append("#Animal mort sur la route signalé ")
            }
            'HAZARD_WEATHER_FLOOD' {
                [void]$statut.Append("#Inondations signalées ")
            }
            'HAZARD_WEATHER_FOG' {
                [void]$statut.Append("#Brouillard signalé ")
            }
            'HAZARD_WEATHER_FREEZING_RAIN' {
                [void]$statut.Append("Pluies #verglaçantes signalées ")
            }
            'HAZARD_WEATHER_HAIL' {
                [void]$statut.Append("#Grêle signalée ")
            }
            'HAZARD_WEATHER_HEAVY_RAIN' {
                [void]$statut.Append("Fortes #pluies signalées ")
            }
            'HAZARD_WEATHER_HEAVY_SNOW' {
                [void]$statut.Append("Fortes chutes de #neige signalées ")
            }
        }
        
        # ajout de la localisation en RD, PR+Abs
        [void]$statut.AppendLine("proche de la #$($alerte.NumeroRoute), PR$($alerte.PRA).")

        # pour les accidents, indication, le cas échéant, de la présence de ralentissements
        if ($alerte.TypeAlerte -eq 'ACCIDENT' -and $alerte.LongueurRalentissements -gt 0) {
            [void]$statut.AppendLine("Présence de ralentissements.")
        }

        # ajout d'éléments permettant d'apprécier la fiabilité de l'alerte
        if ($alerte.NbSignalements -eq '1') {
            [void]$statut.AppendLine("(1 signalement à $($alerte.HeurePremierSignalement), fiabilité $($alerte.Fiabilite))")
        }
        else {
            [void]$statut.AppendLine("($($alerte.NbSignalements) signalements entre $($alerte.HeurePremierSignalement) et $($alerte.HeureDernierSignalement))")
        }
        
        # ajout des communes et PER concernés
        [void]$statut.AppendLine()
        [void]$statut.AppendLine("Commune(s) : $($alerte.Communes)")
        [void]$statut.AppendLine("PER : $($alerte.PER)")

        # si le taille du statut le permet, ajout du lien vers la LiveMap Waze
        if ($statut.Length -le 200) {
            [void]$statut.AppendLine()
            [void]$statut.AppendLine("Voir sur #Waze : $($alerte.LienWazeLiveMap)")
        }

        $idMedia = (Twitter-Televerser-Media -identifiants $idsTwitter -cheminMedia "$dossierTravailTemp\waze_notifier\Aperçu Waze - $($alerte.NumeroRoute)_$($alerte.PRA).png").media_id
        Twitter-Modifier-Statut -identifiants $idsTwitter -statut $statut.ToString() -lat $alerte.Y -long $alerte.X -idMedias $idMedia
    }
}

# nettoyage final
SIg-Executer-Fichier -fichier "$dossierSQL4Notif\tmp(.v).4Notif (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Notif (drop).txt"
Remove-Item -Path "$dossierTravailTemp\waze_notifier\*.png"