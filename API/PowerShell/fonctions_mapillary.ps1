. ("$PSScriptRoot\constantes.ps1")
. ("$PSScriptRoot\fonctions_outils.ps1")

# -----------------------------------------------------------------------------
# Exécution des Mapillary Tools.
#
# $parametres : Les paramètres d'appel.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# -----------------------------------------------------------------------------
function Executer-MapillaryTools {
    param(
        [string[]] $parametres = $null,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Afficher-Message-Date -message "`"$mapillaryTools`" $parametres" -couleur gray

    New-Item -ItemType Directory -Force -Path "$dossierTravailTemp\MapillaryTools"

    if ($sortie) {
        New-Item -ItemType Directory -Force -Path (Split-Path -Path $sortie)

        if ($erreur) {
            Start-Process -FilePath "`"$mapillaryTools`"" -WorkingDirectory "$dossierTravailTemp\MapillaryTools" -WindowStyle Hidden -Wait -ArgumentList $parametres -RedirectStandardOutput $sortie -RedirectStandardError "$sortie.err"
        }
        else {
            Start-Process -FilePath "`"$mapillaryTools`"" -WorkingDirectory "$dossierTravailTemp\MapillaryTools" -WindowStyle Hidden -Wait -ArgumentList $parametres -RedirectStandardOutput $sortie
        }

        Changer-Encodage -fichier $sortie -encodageAvant 'utf-8' -encodageApres 'utf-8' # permet de forcer l'ajout du BOM
    }
    else {
        Start-Process -FilePath "`"$mapillaryTools`"" -WorkingDirectory "$dossierTravailTemp\MapillaryTools" -WindowStyle Hidden -Wait -ArgumentList $parametres
    }
}

# -----------------------------------------------------------------------------
# Connexion des Mapillary Tools.
#
# $utilisateur : Le nom d'utilisateur.
# $email : L'adresse email de l'utilisateur.
# $mdp : Le mot de passe utilisateur.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# -----------------------------------------------------------------------------
function MapillaryTools-Connecter {
    param(
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [parameter(Mandatory=$true)] [string] $email,
        [parameter(Mandatory=$true)] [string] $mdp,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Executer-MapillaryTools -parametres 'authenticate', '--user_name', $utilisateur, '--user_email', $email, '--user_password', $mdp -sortie $sortie -erreur $erreur
}

# -----------------------------------------------------------------------------
# Traitement d'un dossier d'images en vue de leur téléversement.
#
# $dossier : Le dossier contenant les images.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# -----------------------------------------------------------------------------
function MapillaryTools-Traiter-Images {
    param(
        [parameter(Mandatory=$true)] [string] $dossier,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Executer-MapillaryTools -parametres '--verbose', 'process', "`"$dossier`"" -sortie $sortie -erreur $erreur
}

# -----------------------------------------------------------------------------
# Téléversement d'un dossier d'images.
#
# $utilisateur : L'utilisateur devant téléverser les images.
# $dossier : Le dossier contenant les images.
# $organisation : L'organisation de rattachement.
# $modeTest : pour une exécution en mode test.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# -----------------------------------------------------------------------------
function MapillaryTools-Televerser-Images {
    param(
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [parameter(Mandatory=$true)] [string] $dossier,
        [string] $organisation = $null,
        [bool] $modeTest = $true,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    $parametres = [Collections.ArrayList]::new()
    
    [void]$parametres.Add('--verbose')
    [void]$parametres.Add('upload')

    [void]$parametres.Add('--user_name')
    [void]$parametres.Add($utilisateur)

    if ($organisation) {
        [void]$parametres.Add('--organization_key')
        [void]$parametres.Add($organisation)
    }

    if ($modeTest) {
        [void]$parametres.Add('--dry_run')
    }

    [void]$parametres.Add("`"$dossier`"")
    
    Executer-MapillaryTools -parametres $parametres -sortie $sortie -erreur $erreur
}