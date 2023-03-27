# -----------------------------------------------------------------------------
# Job de téléchargement d'un fichier.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .url : L'adresse url du fichier à télécharger.
# .enregistrerSous : L'emplacement de sauvegarde.
# .entetes : Les entêtes à ajouter lors de l'appel.
# .identite : L'identité à utiliser pour une requête authentifiée.
# -----------------------------------------------------------------------------
$Job_Telecharger = {
    param (
        [object] $parametres
    )
    
    . ("$($parametres.racineAPI)\fonctions_web.ps1")

    Telecharger `        -url $parametres.url `        -enregistrerSous $parametres.enregistrerSous `        -entetes $parametres.entetes `        -identite $parametres.identite
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job de téléchargement d'un fichier.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# $url : L'adresse url du fichier à télécharger.
# $enregistrerSous : L'emplacement de sauvegarde.
# $entetes : Les entêtes à ajouter lors de l'appel.
# $identite : L'identité à utiliser pour une requête authentifiée.
# -----------------------------------------------------------------------------
function Parametrer-Job-Telecharger {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $url,
        [parameter(Mandatory=$true)] [string] $enregistrerSous,
        [hashtable] $entetes = $null,
        [Net.NetworkCredential] $identite = $null
    )

    @{
        script = $Job_Telecharger
        racineAPI = $racineAPI
        url = $url
        enregistrerSous = $enregistrerSous
        entetes = $entetes
        identite = $identite
    }
}