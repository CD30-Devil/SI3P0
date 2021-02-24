. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

$natures = @(
    @{ nom = 'batiments'; table = 'Cadastre_Batiment' }
    @{ nom = 'feuilles'; table = 'Cadastre_Feuille' }
    @{ nom = 'lieux_dits'; table = 'Cadastre_LieuDit' }
    @{ nom = 'parcelles'; table = 'Cadastre_Parcelle' }
    @{ nom = 'prefixes_sections'; table = 'Cadastre_PrefixeSection' }
    @{ nom = 'sections'; table = 'Cadastre_Section' }
    @{ nom = 'subdivisions_fiscales'; table = 'Cadastre_SubdivisionFiscale' }
)

$Job_Importer_Cadastre = {
    param (
        $parametres
    )

    . ("$($parametres.racineAPI)\api_complète.ps1")

    $dossierRapports = "$($parametres.dossierRapports)\$($parametres.nature)"

    # nettoyage préalable
    Remove-Item "$dossierRapports\*.txt"
    Remove-Item "$dossierRapports\*.err"

    SIg-Effacer-Table -table "d.$($parametres.table)" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement d.$($parametres.table).txt"

    # parcours des archives de la nature à traiter
    foreach ($archive in Get-ChildItem "$($parametres.dossierDonnees)\cadastre-*-$($parametres.nature).json.gz") {

        # isolation du code de département
        $match = [Regex]::Match($archive.FullName, "-(.{2,3})-")
        $departement = $match.Groups[1].Value

        # extraction du GeoJSON
        7Z-Decompresser -archive $archive -extraireVers "$dossierTravailTemp\cadastre_peupler\"

        # import du GeoJSON dans le schéma tmp
        $nomGeoJSON = [System.IO.Path]::GetFileNameWithoutExtension($archive)
        SIg-Importer-GeoJSON -geoJSON "$dossierTravailTemp\cadastre_peupler\$nomGeoJSON" -table "tmp.$($parametres.table)_$departement" -sridSource '4326' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import $nomGeoJSON.txt"

        # transfert des données du schéma tmp vers le schéma d
        SIg-Executer-Commande -commande "create table if not exists d.$($parametres.table) as select * from tmp.$($parametres.table)_$departement where false"
        SIg-Executer-Commande -commande "insert into d.$($parametres.table) select * from tmp.$($parametres.table)_$departement" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - transfert tmp.$($parametres.table)_$departement vers d.$($parametres.table).txt"

        # nettoyage
        SIg-Effacer-Table -table "tmp.$($parametres.table)_$departement" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.$($parametres.table)_$departement.txt"
        Remove-Item "$dossierTravailTemp\cadastre_peupler\$nomGeoJSON"
    }
}

# nettoyage préalable
Remove-Item -Path "$dossierTravailTemp\cadastre_peupler\*"
Remove-Item "$dossierRapports\*.txt"
Remove-Item "$dossierRapports\*.err"

# paramétrage d'un job d'import par nature de données cadastrales
$parametresJobs = New-Object System.Collections.ArrayList

foreach ($nature in $natures) {
    [void]$parametresJobs.Add(@{
        script = $Job_Importer_Cadastre
        racineAPI = "$PSScriptRoot\..\..\API\PowerShell"
        nature = $nature.nom
        table = $nature.table
        dossierDonnees = $dossierDonnees
        dossierRapports = $dossierRapports
    })
}

# exécution des jobs d'import
Executer-Jobs -parametresJobs $parametresJobs

# création des index
SIg-Executer-Fichier -fichier "$dossierSQL\_créer index.sql" -sortie "$dossierRapports\peupler\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _créer index.txt"