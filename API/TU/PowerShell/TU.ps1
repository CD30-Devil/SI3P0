# chemin vers le bas à sable
$bas = "$PSScriptRoot\..\Bac à sable"

# -----------------------------------------------------------------------------
# Vidage du bas à sable.
# -----------------------------------------------------------------------------
function Vider-BacASable {
    Remove-Item -Path "$bas\*" -Exclude '.gitignore' -Recurse -Force
}

# -----------------------------------------------------------------------------
# Fonction de vérification de l'appel à un script de test.
#
# $message : Le message de contextualisation du test.
# $test : Le script de test.
# $avant : Le script de préparation du test.
# $apres : Le script de finalisation du test.
# -----------------------------------------------------------------------------
function Assert-Script {
    param (
        [parameter(Mandatory=$true)] [string] $message,
        [parameter(Mandatory=$true)] [scriptblock] $test,
        [scriptblock] $avant = $null,
        [scriptblock] $apres = $null
    )
    
    if ($avant) { & $avant *> $null }

    $resultat = & $test

    if ($resultat) {
        Write-Host "OK | $message" -foregroundcolor green
    }
    else {
        Write-Host "KO | $message" -foregroundcolor red
    }

    if ($apres) { & $apres *> $null }
}

# -----------------------------------------------------------------------------
# Fonction de vérification de l'existence d'un fichier/dossier.
#
# $message : Le message de contextualisation du test.
# $chemin : Le chemin dont il faut vérifier l'existence.
# $avant : Le script de préparation du test.
# $apres : Le script de finalisation du test.
# -----------------------------------------------------------------------------
function Assert-CheminExiste {
    param (
        [string] $message = '',
        [parameter(Mandatory=$true)] [string] $chemin,
        [scriptblock] $avant = $null,
        [scriptblock] $apres = $null
    )

    Assert-Script -message "$message | Assert-CheminExiste $chemin" -test { Test-Path $chemin } -avant $avant -apres $apres
}