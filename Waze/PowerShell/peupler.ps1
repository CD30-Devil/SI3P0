. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnnes = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\peupler"

if (!(Test-Path "$dossierDonnnes\alertes*.json")) {
    # s'il n'y a aucun fichier d'alertes, sortie
    exit
}

# nettoyage préalable
Remove-Item "$dossierRapports\*.txt"
Remove-Item "$dossierRapports\*.err"

# construction d'un fichier SQL à partir des données des fichiers JSON Waze
New-Item -ItemType Directory -Force -Path "$dossierTravailTemp\waze_peupler\"

$fichierSQL = "$dossierTravailTemp\waze_peupler\$(New-Guid).sql"
$ecriture = [System.IO.StreamWriter] $fichierSQL

$ecriture.WriteLine("start transaction;")
$ecriture.WriteLine("")

# historisation des alertes
$ecriture.WriteLine("insert into HistoAlerteWaze (IdHistoAlerteWaze, IdTypeAlerteWaze, IdSousTypeAlerteWaze, DateCreation, Fiabilite, Geom)")
$ecriture.WriteLine("select IdAlerteWaze, IdTypeAlerteWaze, IdSousTypeAlerteWaze, DateCreation, Fiabilite, Geom")
$ecriture.WriteLine("from m.AlerteWaze")
$ecriture.WriteLine("on conflict (IdHistoAlerteWaze) do")
$ecriture.WriteLine("update")
$ecriture.WriteLine("set")
$ecriture.WriteLine("    IdTypeAlerteWaze = EXCLUDED.IdTypeAlerteWaze,")
$ecriture.WriteLine("    IdSousTypeAlerteWaze = EXCLUDED.IdSousTypeAlerteWaze,")
$ecriture.WriteLine("    DateCreation = EXCLUDED.DateCreation,")
$ecriture.WriteLine("    Fiabilite = EXCLUDED.Fiabilite,")
$ecriture.WriteLine("    Geom = EXCLUDED.Geom;")
$ecriture.WriteLine("")

$ecriture.WriteLine("delete from m.AlerteWaze;")
$ecriture.WriteLine("")

# traitement des alertes

# itération sur les fichiers JSON Waze d'alertes
# utilisation d'un while plutôt que foreach pour prendre en compte les téléchargements qui pourraient se terminer durant la boucle de traitement
while (Test-Path "$dossierDonnnes\alertes*.json") {
    
    $FichierAlertes = Get-ChildItem "$dossierDonnnes\alertes*.json" | Sort-Object -Property BaseName | select -First 1

    Afficher-Message-Date -message "Traitement du fichier $FichierAlertes."
    
    $json = ConvertFrom-Json (Get-Content $FichierAlertes)
    $alertes = $json.alerts | foreach {
        [pscustomobject] @{
            id = $_.uuid
            date = ([dateTime]'1970-01-01 00:00:00').AddMilliseconds($_.pubMillis)
            x = $_.location.x
            y = $_.location.y
            type = $_.type
            sousType = $_.subtype
            fiabilite = $_.reliability
        }
    }

    foreach ($alerte in $alertes) {

        # insère ou met à jour l'alerte avec les informations les plus récentes (du fait du parcours des fichiers JSON Waze dans l'ordre de moissonnage)
        $ecriture.WriteLine("insert into m.AlerteWaze (IdAlerteWaze, IdTypeAlerteWaze, IdSousTypeAlerteWaze, DateCreation, Fiabilite, Geom)")
        $ecriture.WriteLine("values ('$($alerte.id)', '$($alerte.type)', '$($alerte.sousType)', to_timestamp('$($alerte.date.ToString("yyyy-MM-dd HH:mm:ss"))', 'YYYY-MM-DD HH24:MI:SS')::timestamp at time zone 'UTC', $($alerte.fiabilite), f.TransformerEnL93(f.FabriquerPointWGS84($($alerte.x), $($alerte.y))))")
        $ecriture.WriteLine("on conflict (IdAlerteWaze) do")
        $ecriture.WriteLine("update")
        $ecriture.WriteLine("set")
        $ecriture.WriteLine("    IdTypeAlerteWaze = '$($alerte.type)',")
        $ecriture.WriteLine("    IdSousTypeAlerteWaze = '$($alerte.sousType)',")
        $ecriture.WriteLine("    DateCreation = to_timestamp('$($alerte.date.ToString("yyyy-MM-dd HH:mm:ss"))', 'YYYY-MM-DD HH24:MI:SS'),")
        $ecriture.WriteLine("    Fiabilite = $($alerte.fiabilite),")
        $ecriture.WriteLine("    Geom = f.TransformerEnL93(f.FabriquerPointWGS84($($alerte.x),  $($alerte.y)));")
        $ecriture.WriteLine("")
    }

    Remove-Item $FichierAlertes
}

$ecriture.WriteLine("commit;")
$ecriture.WriteLine("")

$ecriture.WriteLine("start transaction;")
$ecriture.WriteLine("")

$ecriture.WriteLine("delete from m.RalentissementWaze;")
$ecriture.WriteLine("select pg_catalog.setval('m.ralentissementwaze_idralentissementwaze_seq', 1, false);")
$ecriture.WriteLine("")

# traitement des ralentissements (embouteillages et irrégularités)

if (Test-Path "$dossierDonnnes\embouteillages.json") {

    Afficher-Message-Date -message "Traitement du fichier $dossierDonnnes\embouteillages.json."

    $json = ConvertFrom-Json (Get-Content "$dossierDonnnes\embouteillages.json")

    $embouteillages = $json.jams | where line -ne $null | foreach {
        [pscustomobject] @{
            date = ([dateTime]'1970-01-01 00:00:00').AddMilliseconds($_.pubMillis)
            niveau = $_.level
            vitessems = $_.speed
            ewkt = 'SRID=4326;LINESTRING(' + [string]::Join(', ', ($_.line | foreach { "$($_.x) $($_.y)" })) + ')'
        }
    }

    foreach ($embouteillage in $embouteillages) {
        $ecriture.WriteLine("insert into m.RalentissementWaze (DateCreation, Niveau, VitesseMS, Nature, Geom)")
        $ecriture.WriteLine("values (to_timestamp('$($embouteillage.date.ToString("yyyy-MM-dd HH:mm:ss"))', 'YYYY-MM-DD HH24:MI:SS')::timestamp at time zone 'UTC', $($embouteillage.niveau), $($embouteillage.vitessems), 'Embouteillage', f.TransformerEnL93(ST_GeomFromEWKT('$($embouteillage.ewkt)')));");
    }
}

if (Test-Path "$dossierDonnnes\irrégularités.json") {

    Afficher-Message-Date -message "Traitement du fichier $dossierDonnnes\irrégularités.json."

    $json = ConvertFrom-Json (Get-Content "$dossierDonnnes\irrégularités.json")

    $irregularites = $json.irregularities | where line -ne $null | foreach {
        [pscustomobject] @{
            date = ([dateTime]'1970-01-01 00:00:00').AddMilliseconds($_.detectionDateMillis)
            niveau = $_.jamLevel
            vitessems = $_.speed
            ewkt = 'SRID=4326;LINESTRING(' + [string]::Join(', ', ($_.line | foreach { "$($_.x) $($_.y)" })) + ')'
        }
    }

    foreach ($irregularite in $irregularites) {
        $ecriture.WriteLine("insert into m.RalentissementWaze (DateCreation, Niveau, VitesseMS, Nature, Geom)")
        $ecriture.WriteLine("values (to_timestamp('$($irregularite.date.ToString("yyyy-MM-dd HH:mm:ss"))', 'YYYY-MM-DD HH24:MI:SS')::timestamp at time zone 'UTC', $($irregularite.niveau), $($irregularite.vitessems), 'Irrégularité', f.TransformerEnL93(ST_GeomFromEWKT('$($irregularite.ewkt)')));")
    }
}

$ecriture.WriteLine("commit;")
$ecriture.WriteLine("")

$ecriture.Close() 
$ecriture = $null

SIg-Executer-Fichier -fichier $fichierSQL -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import des données Waze.txt"
Remove-Item $fichierSQL