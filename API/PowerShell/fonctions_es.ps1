. ("$PSScriptRoot\fonctions_outils.ps1")

# -----------------------------------------------------------------------------
# Changement de l'encodage d'un fichier.
#
# $fichier : Le fichier à changer.
# $encodageAvant : L'encodage du fichier avant changement.
# $encodageApres : L'encodage du fichier après changement.
# -----------------------------------------------------------------------------
function Changer-Encodage {
    param (
        [parameter(Mandatory=$true)] [string] $fichier,
        [parameter(Mandatory=$true)] [string] $encodageAvant,
        [parameter(Mandatory=$true)] [string] $encodageApres
    )
    
    Afficher-Message-Date -message "Changement de l'encodage de $fichier de $encodageAvant à $encodageApres."
    $contenu = [System.IO.File]::ReadAllText($fichier, [System.Text.Encoding]::GetEncoding($encodageAvant))
    [System.IO.File]::WriteAllText($fichier, $contenu, [System.Text.Encoding]::GetEncoding($encodageApres))
}