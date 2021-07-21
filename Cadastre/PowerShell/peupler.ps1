. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

$natures = @(
    @{ nom = 'subdivisions_fiscales'; table = 'd.Cadastre_SubdivisionFiscale' }
    @{ nom = 'batiments'; table = 'd.Cadastre_Batiment' }
    @{ nom = 'parcelles'; table = 'd.Cadastre_Parcelle' }
    @{ nom = 'feuilles'; table = 'd.Cadastre_Feuille' }
    @{ nom = 'sections'; table = 'd.Cadastre_Section' }
    @{ nom = 'prefixes_sections'; table = 'd.Cadastre_PrefixeSection' }
    @{ nom = 'lieux_dits'; table = 'd.Cadastre_LieuDit' }
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

    $dossierRapports = $parametres.dossierRapports

    # parcours des archives de la nature à traiter
    $archives = Get-ChildItem "$($parametres.dossierDonnees)\cadastre-*-$($parametres.nature).json.gz"

    for ($i = 0; $i -lt $archives.Count; $i++) {

        # extraction du GeoJSON
        7Z-Decompresser -archive $archives[$i] -extraireVers "$dossierTravailTemp\cadastre_peupler\"

        # import du GeoJSON dans le schéma tmp
        $nomGeoJSON = [System.IO.Path]::GetFileNameWithoutExtension($archives[$i])

        if ($i -eq 0) {
            SIg-Importer-GeoJSON `                -geoJSON "$dossierTravailTemp\cadastre_peupler\$nomGeoJSON" `                -table "$($parametres.table)" `                -sridSource '4326' `                -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import $nomGeoJSON.txt"
        }
        else {
            SIg-Importer-GeoJSON `                -geoJSON "$dossierTravailTemp\cadastre_peupler\$nomGeoJSON" `                -table "$($parametres.table)" `                -sridSource '4326' `                -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import $nomGeoJSON.txt" `
                -autresParams @('-append')
        }

        # suppression du geojson extrait
        Remove-Item "$dossierTravailTemp\cadastre_peupler\$nomGeoJSON"#>
    }
}

# nettoyage préalable
Remove-Item -Path "$dossierTravailTemp\cadastre_peupler\*"
Remove-Item "$dossierRapports\*.txt"
Remove-Item "$dossierRapports\*.err"

foreach ($nature in $natures) {
    SIg-Effacer-Table -table "$($nature.table)" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement $($nature.table).txt"
}

# paramétrage d'un job d'import par nature de données cadastrales dans les structures temporaires
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

# exécution des jobs d'import dans les structures temporaires
Executer-Jobs -parametresJobs $parametresJobs

# transfert d'une partie des données du schéma tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"