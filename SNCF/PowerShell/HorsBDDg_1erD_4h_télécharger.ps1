. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"

# nettoyage préalable
Remove-Item "$dossierDonnees\*.geojson"

# paramétrage des jobs de téléchargement
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((Parametrer-Job-Telecharger -url 'https://ressources.data.sncf.com/explore/dataset/lignes-par-statut/download/?format=geojson&timezone=Europe/Berlin&lang=fr' -enregistrerSous "$dossierDonnees\lignes-par-statut.geojson"))
[void]$parametresJobs.Add((Parametrer-Job-Telecharger -url 'https://ressources.data.sncf.com/explore/dataset/liste-des-passages-a-niveau/download/?format=geojson&timezone=Europe/Berlin&lang=fr' -enregistrerSous "$dossierDonnees\liste-des-passages-a-niveau.geojson"))

# exécution des jobs de téléchargement
Executer-Jobs -parametresJobs $parametresJobs