# -----------------------------------------------------------------------------
# Affichage d'un message avec indication de la date et de l'heure.
#
# $message : Le message à afficher.
# $couleur : La couleur d'affichage.
# -----------------------------------------------------------------------------
function Afficher-Message-Date {
    param (
        [parameter(Mandatory=$true)] [string] $message,
        [string] $couleur = 'green'
    )
    
    Write-Host (Get-Date -Format 'yyyy/MM/dd H:mm:ss - ') $message -foregroundcolor $couleur
}

# -----------------------------------------------------------------------------
# Demande de choix d'une option à l'utilisateur.
#
# $message : La question posées à l'utilisateur.
# $options : Les options possibles.
# $couleur : La couleur d'affichage du message.
# -----------------------------------------------------------------------------
function Choisir-Option {
    param (
        [parameter(Mandatory=$true)] [string] $message,
        [parameter(Mandatory=$true)] [string[]] $options,
        [string] $couleur = 'green'
    )

    $saisieUtilisateur = ''
    $choixUtilisateur = 0
    
    do {

        $i = 0
        Write-Host "$message : " -foregroundcolor $couleur

        foreach ($option in $options) {
            $i++
            Write-Host "$i - $option" -foregroundcolor $couleur
        }

        $saisieUtilisateur = Read-Host

    } until ([int]::TryParse($saisieUtilisateur, [ref]$choixUtilisateur) -and $choixUtilisateur -ge 1 -and $choixUtilisateur -le $options.length)

    $options[$choixUtilisateur - 1]
}

# -----------------------------------------------------------------------------
# Exécution d'un fichier PowerShell.
#
# $chemin : Le chemin vers le fichier à exécuter.
# $process : Indique si le fichier doit être exécuté dans un processus séparé.
# $process32 : En mode processus séparé, execute le sous-processus en 32 bits.
# -----------------------------------------------------------------------------
function Executer-FichierPS {
    param (
        [parameter(Mandatory=$true)] [string] $chemin,
        [bool] $process = $false,
        [bool] $process32 = $false
    )

    Afficher-Message-Date -message "Exécution de $chemin." -couleur 'Magenta'

    $debut = Get-Date

    # lancement du fichier PowerShell en mode process
    if ($process) {
        $job = if ($process32) {
            Start-Job -RunAs32 { param ($chemin) Invoke-Expression -Command "& '$chemin'" } -ArgumentList $chemin
        }
        else {
            Start-Job { param ($chemin) Invoke-Expression -Command "& '$chemin'" } -ArgumentList $chemin
        }
        $job | Receive-Job -Wait
        $job.Dispose()
        $job = $null
    }
    # ou par appel direct dans le processus actif
    else {
        Invoke-Expression "& '$chemin'"
    }

    $fin = Get-Date

    Afficher-Message-Date -message ("Durée d'exécution de $chemin : {0:hh' h 'mm' m 'ss' s'}" -f (New-TimeSpan -Start $debut -End $fin)) -couleur 'magenta'
}