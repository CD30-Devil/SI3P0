. ("$PSScriptRoot\constantes.ps1")
. ("$PSScriptRoot\fonctions_outils.ps1")

# -----------------------------------------------------------------------------
# Exécution du navigateur Chromium.
#
# $parametres : Les paramètres d'appel à Chromium.
# $delaiMaxProcess : Le délai d'exécution max (secondes) laissé à Chromium.
# -----------------------------------------------------------------------------
function Executer-Chromium {
    param(
        [string[]] $parametres = $null,
        [int] $delaiMaxProcess = $null
    )

    Afficher-Message-Date -message "`"$chromium`" $parametres" -couleur gray

    $process = Start-Process -FilePath "`"$chromium`"" -WindowStyle Hidden -ArgumentList $parametres -PassThru
    
    $delaiMaxAtteint = $null

    if ($delaiMaxProcess) {
        $process | Wait-Process -Timeout $delaiMaxProcess -ErrorAction SilentlyContinue -ErrorVariable delaiMaxAtteint
    }
    else {
        $process | Wait-Process
    }

    if ($delaiMaxAtteint) {
        Afficher-Message-Date -message "Délai d'exécution max atteint, fermeture de $Chromium." -couleur red
        $process.Kill()
    }
}

# -----------------------------------------------------------------------------
# Capture d'une page Web.
#
# $url : L'URL (proprement encodée) de la page à capturer.
# $sortie : L'emplacement de sauvegarde de l'image.
# $delaiMaxProcess : Le délai d'exécution max (secondes) laissé à Chromium.
# $taille : La taille de la capture.
# $delaiChargement : Le délai d'attente (secondes) pour le chargement complet
#                    de la page.
# -----------------------------------------------------------------------------
function Chromium-Capturer-Page {
    param(
        [parameter(Mandatory=$true)] [string] $url,
        [parameter(Mandatory=$true)] [string] $sortie,
        [int] $delaiMaxProcess = $null,
        [string] $taille = '1280,720',
        [int] $delaiChargement = 10
    )
    
    New-Item -ItemType Directory -Force -Path (Split-Path -Path $sortie)

    $parametres = [Collections.ArrayList]::new()

    [void]$parametres.Add($url)
    [void]$parametres.Add("--screenshot=`"$([IO.Path]::GetFullPath($sortie))`"")
    [void]$parametres.Add("--window-size=$taille")
    [void]$parametres.Add("--headless")
    [void]$parametres.Add("--run-all-compositor-stages-before-draw")
    [void]$parametres.Add("--virtual-time-budget=$($delaiChargement * 1000)")

    Afficher-Message-Date -message "Capture de $url vers $sortie ($taille)."
    Executer-Chromium -parametres $parametres -delaiMaxProcess $delaiMaxProcess
}