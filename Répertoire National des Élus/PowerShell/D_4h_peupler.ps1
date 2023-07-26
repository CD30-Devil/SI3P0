. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\D_4h_peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

SIg-Effacer-Table -table 'tmp.source_conseillermunicipal' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_conseillermunicipal.txt"

# création des structures temporaires
SIg-Creer-Table-Temp `    -table 'tmp.source_conseillermunicipal' `    -colonnes `        'CodeDepartement', `        'LibelleDepartement', `        'CodeCollectiviteStatutParticulier', `        'LibelleCollectiviteStatutParticulier', `        'CodeCommune', `        'LibelleCommune', `        'NomElu', `        'PrenomElu', `        'Sexe', `        'DateNaissance', `        'CodeCategorieSocioPro', `        'LibelleCategorieSocioPro', `        'DateDebutMandat', `        'LibelleFonction', `        'DateDebutFonction', `        'Nationalite', `        'LieuNaissance', `        'CodeNuanceMandat', `        'LibelleNuanceMandat' `    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.source_conseillermunicipal.txt"

# import des données dans les structures temporaires
SIg-Importer-CSV `    -csv "$dossierDonnees\Conseillers municipaux.csv" `    -delimiteur '`t' `    -table 'tmp.source_conseillermunicipal' `    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import Conseillers municipaux.csv.txt"

# transfert des données du schéma tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

# nettoyage final
SIg-Effacer-Table -table 'tmp.source_conseillermunicipal' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_conseillermunicipal.txt"