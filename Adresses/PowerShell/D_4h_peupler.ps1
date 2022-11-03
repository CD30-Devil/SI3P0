. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\D_4h_peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

SIg-Effacer-Table -table 'tmp.source_adresse' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_adresse.txt"

# création des structures temporaires
SIg-Creer-Table-Temp -table 'tmp.source_adresse' -colonnes 'uid_adresse', 'cle_interop', 'commune_insee', 'commune_nom', 'commune_deleguee_insee', 'commune_deleguee_nom', 'voie_nom', 'lieudit_complement_nom', 'numero', 'suffixe', 'position', 'x', 'y', 'long', 'lat', 'cad_parcelles', 'source', 'date_der_maj', 'certification_commune' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.source_adresse.txt"

# paramétrage des jobs d'import des données dans les structures temporaires
$parametresJobs = [Collections.ArrayList]::new()

foreach ($csv in Get-ChildItem -Path "$dossierDonnees\*.csv") {
    [void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-CSV -csv $csv -table 'tmp.source_adresse' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import $([IO.Path]::GetFileName($csv)).txt"))
}

# exécution des jobs d'import des données dans les structures temporaires
Executer-Jobs -parametresJobs $parametresJobs

# transfert des données du schéma tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

# nettoyage final
SIg-Effacer-Table -table 'tmp.source_adresse' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_adresse.txt"