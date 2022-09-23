. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"

# nettoyage préalable
Remove-Item "$dossierDonnees\*"

# paramétrage des jobs de téléchargement
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((Parametrer-Job-Telecharger -url 'https://www.insee.fr/fr/statistiques/fichier/6051727/canton_2022.csv' -enregistrerSous "$dossierDonnees\canton.csv"))
[void]$parametresJobs.Add((Parametrer-Job-Telecharger -url 'https://www.insee.fr/fr/statistiques/fichier/6215138/Filosofi2017_carreaux_200m_gpkg.zip' -enregistrerSous "$dossierDonnees\Filosofi2017_carreaux_200m_gpkg.zip"))
[void]$parametresJobs.Add((Parametrer-Job-Telecharger -url 'https://www.insee.fr/fr/statistiques/fichier/6215140/Filosofi2017_carreaux_1km_gpkg.zip' -enregistrerSous "$dossierDonnees\Filosofi2017_carreaux_1km_gpkg.zip"))

# exécution des jobs de téléchargement
Executer-Jobs -parametresJobs $parametresJobs

# décompression des archives
7Z-Decompresser-Ici -archive "$dossierDonnees\Filosofi*_carreaux_200m_gpkg.zip" -supprimer $true
7Z-Decompresser-Ici -archive "$dossierDonnees\Filosofi*_carreaux_200m_gpkg.7z" -supprimer $true
7Z-Decompresser-Ici -archive "$dossierDonnees\Filosofi*_carreaux_1km_gpkg.zip" -supprimer $true
7Z-Decompresser-Ici -archive "$dossierDonnees\Filosofi*_carreaux_1km_gpkg.7Z" -supprimer $true

# suppression des fichiers inutiles
Remove-Item "$dossierDonnees\*.gpkg" -Exclude '*met*'

# renommage des fichiers pour supprimer la mention de l'année
Rename-Item (Get-ChildItem "$dossierDonnees\Filosofi*_carreaux_200m_met.gpkg") 'filosofi_carreaux_200m_met.gpkg'
Rename-Item (Get-ChildItem "$dossierDonnees\Filosofi*_carreaux_1km_met.gpkg") 'filosofi_carreaux_1km_met.gpkg'