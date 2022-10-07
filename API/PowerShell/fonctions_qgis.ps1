. ("$PSScriptRoot\constantes.ps1")
. ("$PSScriptRoot\fonctions_outils.ps1")

# -----------------------------------------------------------------------------
# Exécution de qgis_process.
#
# $parametres : Les paramètres d'appel.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# -----------------------------------------------------------------------------
function Executer-QGisProcess {
    param(
        [string[]] $parametres = $null,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Afficher-Message-Date -message "`"$qgisProcess`" $parametres" -couleur gray

    if ($sortie) {
        New-Item -ItemType Directory -Force -Path (Split-Path -Path $sortie)

        if ($erreur) {
            Start-Process -FilePath "`"$qgisProcess`"" -WindowStyle Hidden -Wait -ArgumentList $parametres -RedirectStandardOutput $sortie -RedirectStandardError "$sortie.err"
        }
        else {
            Start-Process -FilePath "`"$qgisProcess`"" -WindowStyle Hidden -Wait -ArgumentList $parametres -RedirectStandardOutput $sortie
        }

        Changer-Encodage -fichier $sortie -encodageAvant 'utf-8' -encodageApres 'utf-8' # permet de forcer l'ajout du BOM
    }
    else {
        Start-Process -FilePath "`"$qgisProcess`"" -WindowStyle Hidden -Wait -ArgumentList $parametres
    }
}

# -----------------------------------------------------------------------------
# Impression d'une mise en page en PDF.
#
# $projet : Le projet QGis à imprimer.
# $miseEnPage : La mise en page à imprimer.
# $pdf : Le chemin de sortie du PDF.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# -----------------------------------------------------------------------------
function QGisProcess-Imprimer-MiseEnPage {
    param(
        [parameter(Mandatory=$true)] [string] $projet,
        [parameter(Mandatory=$true)] [string] $miseEnPage,
        [parameter(Mandatory=$true)] [string] $pdf,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Executer-QGisProcess -parametres "run", "native:printlayouttopdf", "project_path=`"$projet`"", "LAYOUT=`"$miseEnPage`"", "OUTPUT=`"$pdf`"" -sortie $sortie -erreur $erreur
}