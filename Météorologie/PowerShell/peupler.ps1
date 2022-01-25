. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

# nettoyage préalable
Remove-Item "$dossierRapports\*.txt"
Remove-Item "$dossierRapports\*.err"

SIg-Effacer-Table -table 'tmp.ReleveMeteo' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.ReleveMeteo.txt"

# création des structures temporaires
SIg-Creer-Table-Temp -table 'tmp.ReleveMeteo' -colonnes 'Source', 'IdSource', 'Nom', 'Longitude', 'Latitude', 'DateReleve', 'Temperature', 'Pression', 'Humidite', 'PointRosee', 'VentMoyen', 'VentRafales', 'DirectionVent', 'Pluie1h' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.ReleveMeteo.txt"

# paramètrage des jobs d'import des données dans les structures temporaires
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-CSV -csv "$dossierDonnees\www.infoclimat.fr.csv" -table 'tmp.ReleveMeteo' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import www.infoclimat.fr.csv.txt"))

# exécution des jobs d'import des données dans les structures temporaires
Executer-Jobs -parametresJobs $parametresJobs

# transfert des données du schéma tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

# nettoyage final
SIg-Effacer-Table -table 'tmp.ReleveMeteo' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.ReleveMeteo.txt"