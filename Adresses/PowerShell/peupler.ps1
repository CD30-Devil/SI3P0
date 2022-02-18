. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

# -----------------------------------------------------------------------------
# Job d'import d'un fichier d'adresses dans les structures temporaires.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .archive : L'archive contenant les adresses à importer.
# .table : La table destination de l'import.
# .dossierRapports : Le chemin vers le dossier de sortie des rapports.
# -----------------------------------------------------------------------------
$Job_Importer_Adresses = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\api_complète.ps1")

    $nomArchive = [System.IO.Path]::GetFileNameWithoutExtension($parametres.archive)

    # décompression et import des données dans les structures temporaires
    7Z-Decompresser -archive $parametres.archive -extraireVers "$dossierTravailTemp\adresses_peupler\$nomArchive"
    $csv = Get-ChildItem "$dossierTravailTemp\adresses_peupler\$nomArchive\*.csv"

    SIg-Importer-CSV -csv $csv -table ($parametres.table) -sortie "$($parametres.dossierRapports)\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import $nomArchive.txt"

    # supression des fichiers décompréssés après import
    Remove-Item "$dossierTravailTemp\adresses_peupler\$nomArchive" -Recurse -Force
}

# nettoyage préalable
Remove-Item "$dossierRapports\*.txt"
Remove-Item "$dossierRapports\*.err"

Remove-Item "$dossierTravailTemp\adresses_peupler\*.csv"

SIg-Effacer-Table -table 'tmp.Adresse_Etalab' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.Adresse_Etalab.txt"
SIg-Effacer-Table -table 'tmp.Adresse_DGFIP' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.Adresse_DGFIP.txt"

# création des structures temporaires
SIg-Creer-Table-Temp -table 'tmp.Adresse_Etalab' -colonnes 'id', 'id_fantoir', 'numero', 'rep', 'nom_voie', 'code_postal', 'code_insee', 'nom_commune', 'code_insee_ancienne_commune', 'nom_ancienne_commune', 'x', 'y', 'lon', 'lat', 'type_position', 'alias', 'nom_ld', 'libelle_acheminement', 'nom_afnor', 'source_position', 'source_nom_voie', 'certification_commune', 'cad_parcelles' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.Adresse_Etalab.txt"
SIg-Creer-Table-Temp -table 'tmp.Adresse_DGFIP' -colonnes 'cle_interop', 'uid_adresse', 'numero', 'suffixe', 'pseudo_numero', 'voie_nom', 'voie_code', 'code_postal', 'libelle_acheminement', 'destination_principale', 'commune_code', 'commune_nom', 'source', 'long', 'lat', 'x', 'y', 'position', 'date_der_maj' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.Adresse_DGFIP.txt"

# paramétrage des jobs d'import des données dans les structures temporaires
$parametresJobs = [Collections.ArrayList]::new()

foreach ($archive in Get-ChildItem -Path "$dossierDonnees\*-etalab.csv.gz") {
    [void]$parametresJobs.Add(@{
            script = $Job_Importer_Adresses
            racineAPI = "$PSScriptRoot\..\..\API\PowerShell"
            archive = $archive
            table = 'tmp.Adresse_Etalab'
            dossierRapports = $dossierRapports
    })
}

foreach ($archive in Get-ChildItem -Path "$dossierDonnees\*-dgfip.csv.gz") {
    [void]$parametresJobs.Add(@{
            script = $Job_Importer_Adresses
            racineAPI = "$PSScriptRoot\..\..\API\PowerShell"
            archive = $archive
            table = 'tmp.Adresse_DGFIP'
            dossierRapports = $dossierRapports
    })
}

# exécution des jobs d'import des données dans les structures temporaires
Executer-Jobs -parametresJobs $parametresJobs

# transfert des données du schéma tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

# nettoyage final
SIg-Effacer-Table -table 'tmp.Adresse_Etalab' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.Adresse_Etalab.txt"
SIg-Effacer-Table -table 'tmp.Adresse_DGFIP' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.Adresse_DGFIP.txt"