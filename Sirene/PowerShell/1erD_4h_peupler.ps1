﻿. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierSQL = "$PSScriptRoot\..\SQL"
$dossierRapports = "$PSScriptRoot\..\Rapports\1erD_4h_peupler"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

SIg-Effacer-Table -table 'tmp.source_unitelegale' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_unitelegale.txt"
SIg-Effacer-Table -table 'tmp.source_etablissementsirene' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_etablissementsirene.txt"

# création des structures temporaires
SIg-Creer-Table-Temp `
    -table 'tmp.source_unitelegale' `
    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.source_unitelegale.txt" `
    -colonnes `
        'sigleunitelegale', `
        'identifiantassociationunitelegale', `
        'denominationunitelegale', `
        'categoriejuridiqueunitelegale', `

SIg-Creer-Table-Temp `
    -table 'tmp.source_etablissementsirene' `
    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.source_etablissementsirene.txt" `
    -colonnes `
        'activiteprincipaleregistremetiersetablissement', `
        'complementadresseetablissement', `
        'libellecommuneetrangeretablissement', `
        'complementadresse2etablissement', `
        'libellecommuneetranger2etablissement', `
        'datedebut', `
        'activiteprincipaleetablissement', `

# paramétrage des jobs d'import
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-CSV -csv "$dossierDonnees\StockUniteLegale_utf8.csv" -table 'tmp.source_unitelegale' -delimiteur ',' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import StockUniteLegale_utf8.csv.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-CSV -csv "$dossierDonnees\StockEtablissement_utf8.csv" -table 'tmp.source_etablissementsirene' -delimiteur ',' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import StockEtablissement_utf8.csv.txt"))

# exécution des jobs d'import
Executer-Jobs -parametresJobs $parametresJobs

# transfert des données du schéma tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

# nettoyage final
SIg-Effacer-Table -table 'tmp.source_unitelegale' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_unitelegale.txt"
SIg-Effacer-Table -table 'tmp.source_etablissementsirene' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_etablissementsirene.txt"