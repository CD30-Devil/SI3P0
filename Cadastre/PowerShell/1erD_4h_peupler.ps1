. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierCadastreDataGouv = "$dossierDonnees\cadastre.data.gouv.fr"
$dossierDataEconomieGouv = "$dossierDonnees\data.economie.gouv.fr"
$dossierRapports = "$PSScriptRoot\..\Rapports\1erD_4h_peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

# nettoyage préalable
Remove-Item "$dossierTravailTemp\cadastre_peupler\*"
Remove-Item "$dossierRapports\*"

# -----------------------------------------------------------------------------
# traitements des données issues de cadastre.data.gouv.fr
# -----------------------------------------------------------------------------

$natures = @(
    @{ nom = 'lieux_dits'; table = 'tmp.source_cadastre_lieudit' }
    @{ nom = 'sections'; table = 'tmp.source_cadastre_section' }
    @{ nom = 'parcelles'; table = 'tmp.source_cadastre_parcelle' }
)

# -----------------------------------------------------------------------------
# Job d'import de données cadastrales dans les structures temporaires.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .nature : La nature des données à importer (parcelles, sections, ...).
# .table : La table destination de l'import.
# .dossierDonnees : Le chemin vers le dossier contenant les données à importer.
# .dossierRapports : Le chemin vers le dossier de sortie des rapports.
# -----------------------------------------------------------------------------
$Job_Importer_Cadastre = {
    param (
        $parametres
    )

    . ("$($parametres.racineAPI)\api_complète.ps1")

    # parcours des fichiers JSON de la nature à traiter
    $fichiersGeoJSON = Get-ChildItem "$($parametres.dossierDonnees)\cadastre-*-$($parametres.nature).json"

    # import du premier en mode "create"
    SIg-Importer-GeoJSON `
        -geoJSON ($fichiersGeoJSON[0]) `
        -table "$($parametres.table)" `
        -sortie "$($parametres.dossierRapports)\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import $([System.IO.Path]::GetFileName($fichiersGeoJSON[0])).txt"

    # import des suivants en mode "append"
    foreach ($fichierGeoJSON in $fichiersGeoJSON | select -Skip 1) {

        SIg-Importer-GeoJSON `
            -geoJSON $fichierGeoJSON `
            -table "$($parametres.table)" `
            -sortie "$($parametres.dossierRapports)\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import $([System.IO.Path]::GetFileName($fichierGeoJSON)).txt" `
            -autresParams @('-append')

    }
}

# nettoyage préalable
foreach ($nature in $natures) {
    SIg-Effacer-Table -table "$($nature.table)" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement $($nature.table).txt"
}

# paramétrage d'un job d'import par nature de données cadastrales dans les structures temporaires
$parametresJobs = [Collections.ArrayList]::new()

foreach ($nature in $natures) {
    [void]$parametresJobs.Add(@{
        script = $Job_Importer_Cadastre
        racineAPI = "$PSScriptRoot\..\..\API\PowerShell"
        nature = $nature.nom
        table = $nature.table
        dossierDonnees = $dossierCadastreDataGouv
        dossierRapports = $dossierRapports
    })
}

# exécution des jobs d'import dans les structures temporaires
Executer-Jobs -parametresJobs $parametresJobs

# -----------------------------------------------------------------------------
# traitements des données issues de data.economie.gouv.fr
# -----------------------------------------------------------------------------

SIg-Effacer-Table -table 'tmp.source_parcelle_personnemorale' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_parcelle_personnemorale.txt"

# création des structures temporaires
SIg-Creer-Table-Temp `
    -table 'tmp.source_parcelle_personnemorale' `
    -colonnes `
        'code_departement', `
        'code_direction', `
        'code_commune', `
        'nom_commune', `
        'prefixe', `
        'section', `
        'num_plan', `
        'num_voirie', `
        'repetition', `
        'code_majic', `
        'code_rivoli', `
        'nature_voie', `
        'nom_voie', `
        'contenance', `
        'suf', `
        'nature_culture', `
        'contenance_suf', `
        'code_droit', `
        'num_majic', `
        'siren', `
        'groupe_personne', `
        'forme_juridique', `
        'forme_juridique_abregee', `
        'denomination' `
    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_parcelle_personnemorale.txt"

# import des données dans les structures temporaires
[System.IO.Directory]::CreateDirectory("$dossierTravailTemp\cadastre_peupler")
foreach ($fichier in (Get-ChildItem -Path "$dossierDataEconomieGouv\PM_*_NB_*.txt")) {

    $nomFichier = [IO.Path]::GetFileName($fichier)
    Copy-Item $fichier "$dossierTravailTemp\cadastre_peupler\$nomFichier"
    Changer-Encodage "$dossierTravailTemp\cadastre_peupler\$nomFichier" -encodageAvant 'iso-8859-1' -encodageApres 'utf-8'
    SIg-Importer-CSV -csv "$dossierTravailTemp\cadastre_peupler\$nomFichier" -table 'tmp.source_parcelle_personnemorale' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import $nomFichier.txt"

}

# transfert des données du schéma tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

# nettoyage final
Remove-Item "$dossierTravailTemp\cadastre_peupler\*"

foreach ($nature in $natures) {
    SIg-Effacer-Table -table "$($nature.table)" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement $($nature.table).txt"
}

SIg-Effacer-Table -table 'tmp.source_parcelle_personnemorale' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.source_parcelle_personnemorale.txt"