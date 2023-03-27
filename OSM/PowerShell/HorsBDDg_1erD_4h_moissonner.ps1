. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"

# appel à Overpass
$reponse = Overpass-Appeler -requete @"
    [out:json];
    area[admin_level=6][name="Gard"];
    way[highway][ref~"^D [0-9]+"](area);
    out geom;
"@

# enregistrement du résultat
if ($reponse.StatusCode -eq 200) {
    $contenuReponse = [Text.Encoding]::UTF8.GetString([Text.Encoding]::GetEncoding(28591).GetBytes($reponse.Content))
    $contenuReponse | Out-File "$dossierDonnees\Routes départementales du Gard.json" -Encoding Utf8
}