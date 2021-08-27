. ("$PSScriptRoot\constantes.ps1")

# -----------------------------------------------------------------------------
# Exécution du navigateur Chromium.
#
# $parametres : Les paramètres d'appel à Chromium.
# -----------------------------------------------------------------------------
Function Executer-Chromium {
    param(
        [string[]] $parametres = $null
    )

    Start-Process -FilePath "`"$Chromium`"" -Wait -ArgumentList $parametres
}

# -----------------------------------------------------------------------------
# Capture d'une page Web.
#
# $url : L'URL (proprement encodée) de la page à capturer.
# $sortie : L'emplacement de sauvegarde de l'image.
# $taille : La taille de la capture.
# $delai : Le délai d'attente pour le chargement complet de la page.
# -----------------------------------------------------------------------------
function Chromium-Capturer-Page {
    param(
        [parameter(Mandatory=$true)] [string] $url,
        [parameter(Mandatory=$true)] [string] $sortie,
        [string] $taille = '1280,720',
        [int] $delai = 10000
    )
    
    New-Item -ItemType Directory -Force -Path (Split-Path -Path $sortie)

    $parametres = [Collections.ArrayList]::new()

    [void]$parametres.Add($url)
    [void]$parametres.Add("--screenshot=`"$([IO.Path]::GetFullPath($sortie))`"")
    [void]$parametres.Add("--window-size=$taille")
    [void]$parametres.Add("--headless")
    [void]$parametres.Add("--run-all-compositor-stages-before-draw")
    [void]$parametres.Add("--virtual-time-budget=$delai")

    Afficher-Message-Date -message "Capture de $url vers $sortie ($taille)."
    Executer-Chromium -parametres $parametres
}