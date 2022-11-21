# -----------------------------------------------------------------------------
# Job de décompression sur place d'une archive en utilisant 7z.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .archive : L'archive à extraire sur place.
# .supprimer : Pour demander la suppression de l'archive après décompression.
# -----------------------------------------------------------------------------
$Job_7Z_Decompresser_Ici = {
    param (
        [object] $parametres
    )
    
    . ("$($parametres.racineAPI)\fonctions_archives.ps1")

    7Z-Decompresser-Ici -archive $parametres.archive -supprimer $parametres.supprimer
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job de décompression sur place d'une archive en utilisant
# 7z.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# $archive : L'archive à extraire sur place.
# $supprimer : Pour demander la suppression de l'archive après décompression.
# -----------------------------------------------------------------------------
function Parametrer-Job-7Z-Decompresser-Ici {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $archive,
        [bool] $supprimer = $false
    )

    @{
        script = $Job_7Z_Decompresser_Ici
        racineAPI = $racineAPI
        archive = $archive
        supprimer = $supprimer
    }
}