. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"

# nettoyage préalable
Remove-Item "$dossierDonnees\*"

# paramétrage des jobs de téléchargement
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((Parametrer-Job-Telecharger -url 'https://www.data.gouv.fr/fr/datasets/r/d5f400de-ae3f-4966-8cb6-a85c70c6c24a' -enregistrerSous "$dossierDonnees\Conseillers municipaux.csv"))
[void]$parametresJobs.Add((Parametrer-Job-Telecharger -url 'https://www.data.gouv.fr/fr/datasets/r/41d95d7d-b172-4636-ac44-32656367cdc7' -enregistrerSous "$dossierDonnees\Conseillers communautaires.csv"))
[void]$parametresJobs.Add((Parametrer-Job-Telecharger -url 'https://www.data.gouv.fr/fr/datasets/r/601ef073-d986-4582-8e1a-ed14dc857fba' -enregistrerSous "$dossierDonnees\Conseillers départementaux.csv"))
[void]$parametresJobs.Add((Parametrer-Job-Telecharger -url 'https://www.data.gouv.fr/fr/datasets/r/430e13f9-834b-4411-a1a8-da0b4b6e715c' -enregistrerSous "$dossierDonnees\Conseillers régionaux.csv"))
[void]$parametresJobs.Add((Parametrer-Job-Telecharger -url 'https://www.data.gouv.fr/fr/datasets/r/b78f8945-509f-4609-a4a7-3048b8370479' -enregistrerSous "$dossierDonnees\Sénateurs.csv"))
[void]$parametresJobs.Add((Parametrer-Job-Telecharger -url 'https://www.data.gouv.fr/fr/datasets/r/1ac42ff4-1336-44f8-a221-832039dbc142' -enregistrerSous "$dossierDonnees\Députés.csv"))

# exécution des jobs de téléchargement
Executer-Jobs -parametresJobs $parametresJobs

foreach ($csv in Get-ChildItem "$dossierDonnees\*.csv") {
    # forcage de l'UTF-8 pour ajout du BOM
    Changer-Encodage -fichier $csv -encodageAvant 'utf-8' -encodageApres 'utf-8'
}