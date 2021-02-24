. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$si3p0DossierExportDXF\Cadastre\Parcelle"

# -----------------------------------------------------------------------------
# Job de décompression d'archives .tar.bz2.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .listeArchiveTarBz2 : La liste des .tar.bz2 à décompresser.
# -----------------------------------------------------------------------------
$Job_Extraire_TarBz2 = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\api_complète.ps1")

    foreach ($archiveTarBz2 in $parametres.listeArchiveTarBz2) {

        $dossierTarBz2 = [System.IO.Path]::GetDirectoryName($archiveTarBz2)
        $nomTarBz2 = [System.IO.Path]::GetFileName($archiveTarBz2)
        $nomTar = [System.IO.Path]::GetFileNameWithoutExtension($archiveTarBz2)

        7Z-Decompresser-Ici -archive "$dossierTarBz2\$nomTarBz2" -supprimer $true
        7Z-Decompresser-Ici -archive "$dossierTarBz2\$nomTar" -supprimer $true
    }
}

# nettoyage préalable
Remove-Item -Path "$dossierDonnees\*" -Recurse -Force

# téléchargement des DXF projection CC du département du Gard
Telecharger -url 'https://cadastre.data.gouv.fr/data/dgfip-pci-vecteur/latest/dxf-cc/departements/dep30.zip' -enregistrerSous "$dossierDonnees\dep30.zip"

# extraction du zip global
7Z-Decompresser -archive "$dossierDonnees\dep30.zip" -extraireVers $dossierDonnees
Remove-Item "$dossierDonnees\dep30.zip"

# paramétrage de 32 jobs d'extraction des .tar.bz2
$listeArchiveTarBz2 = Get-ChildItem $dossierDonnees -Include "*.tar.bz2" -Recurse
$fragmentsListeArchiveTarBz2 = Fragmenter-Liste -liste $listeArchiveTarBz2 -nombreFragments 32
$parametresJobs = New-Object System.Collections.ArrayList

foreach ($fragmentListeArchiveTarBz2 in $fragmentsListeArchiveTarBz2) {
    [void]$parametresJobs.Add(@{
        script = $Job_Extraire_TarBz2
        racineAPI = "$PSScriptRoot\..\..\API\PowerShell"
        listeArchiveTarBz2 = $fragmentListeArchiveTarBz2
    })
}

# exécution des jobs d'extraction des .tar.bz2
Executer-Jobs -parametresJobs $parametresJobs -afficherSortieJobs $false