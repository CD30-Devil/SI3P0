﻿. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierSQL = "$PSScriptRoot\..\SQL"
$dossierRapports = "$PSScriptRoot\..\Rapports\peupler"

$Job_PeuplerSirene = {
    param (
        $parametres
    )

    . ("$($parametres.racineAPI)\api_complète.ps1")

    # décompression du fichier à importer
    7Z-Decompresser -archive "$($parametres.dossierDonnees)\$($parametres.archive).zip" -extraireVers "$($parametres.dossierDonnees)\"

    # import des données dans les structures temporaires
    SIg-Importer-CSV `

    Remove-Item -Path "$($parametres.dossierDonnees)\$($parametres.archive).csv"
}

# nettoyage préalable
Remove-Item "$dossierDonnees\*.csv"
Remove-Item "$dossierRapports\*"

SIg-Effacer-Table -table 'tmp.Sirene_Etablissement' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.Sirene_Etablissement.txt"
SIg-Effacer-Table -table 'tmp.Sirene_UniteLegale' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.Sirene_UniteLegale.txt"

# création des structures temporaires
SIg-Creer-Table-Temp `
    -table 'tmp.Sirene_UniteLegale' `
    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.Sirene_UniteLegale.txt" `
    -colonnes `
        'sigleunitelegale', `
        'identifiantassociationunitelegale', `
        'denominationunitelegale', `
        'categoriejuridiqueunitelegale', `

SIg-Creer-Table-Temp `
    -table 'tmp.Sirene_Etablissement' `
    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.Sirene_Etablissement.txt" `
    -colonnes `
        'activiteprincipaleregistremetiersetablissement', `
        'complementadresseetablissement', `
        'libellecommuneetrangeretablissement', `
        'complementadresse2etablissement', `
        'libellecommuneetranger2etablissement', `
        'datedebut', `
        'activiteprincipaleetablissement', `

# paramétrage des jobs d'import dans les structures temporaires
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((@{
        script = $Job_PeuplerSirene
        racineAPI = "$PSScriptRoot\..\..\API\PowerShell"
        dossierDonnees = $dossierDonnees
        dossierRapports = $dossierRapports
        archive = 'StockUniteLegale_utf8'
        table = 'Sirene_UniteLegale'
    }))

[void]$parametresJobs.Add((@{
        script = $Job_PeuplerSirene
        racineAPI = "$PSScriptRoot\..\..\API\PowerShell"
        dossierDonnees = $dossierDonnees
        dossierRapports = $dossierRapports
        archive = 'StockEtablissement_utf8'
        table = 'Sirene_Etablissement'
    }))

# exécution des jobs d'import des données dans les structures temporaires
Executer-Jobs -parametresJobs $parametresJobs

# transfert des données du schéma tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

# nettoyage final
SIg-Effacer-Table -table 'tmp.Sirene_Etablissement' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.Sirene_Etablissement.txt"
SIg-Effacer-Table -table 'tmp.Sirene_UniteLegale' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.Sirene_UniteLegale.txt"