. ("$PSScriptRoot\constantes.ps1")
. ("$PSScriptRoot\fonctions_outils.ps1")

# -----------------------------------------------------------------------------
# Téléchargement d'un fichier.
#
# $url : L'adresse url du fichier à télécharger.
# $enregistrerSous : L'emplacement de sauvegarde.
# -----------------------------------------------------------------------------
function Telecharger {
    param (
        [parameter(Mandatory=$true)] [string] $url,
        [parameter(Mandatory=$true)] [string] $enregistrerSous
    )
    
    Afficher-Message-Date -message "Téléchargement de $url vers $enregistrerSous."
    New-Item -ItemType Directory -Force -Path (Split-Path -Path $enregistrerSous)

    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls13 -bor [System.Net.SecurityProtocolType]::Ssl3
    $client = New-Object System.Net.WebClient
    $client.DownloadFile($url, $enregistrerSous)
}

# -----------------------------------------------------------------------------
# Envoi d'un e-mail.
#
# $de : Emetteur.
# $a : Destinataire(s).
# $sujet : Sujet.
# $corps : Corps du mail
# $cc : Copies carbones.
# -----------------------------------------------------------------------------
function Envoyer-Mail {
    param (
        [parameter(mandatory=$true)] [string] $de,
        [parameter(mandatory=$true)] [string] $a,
        [parameter(mandatory=$true)] [string] $sujet,
        [parameter(mandatory=$true)] [string] $corps,
        [string] $cc = $null
    )

    Afficher-Message-Date -message "Envoie d'un e-mail de $de à $a."

    # si inclus dans l'appel, pas de valeur vide par défaut pour cc sinon bug 
    if ($cc) {
          Send-MailMessage -From $de -to $a -Subject $sujet -SmtpServer $serveurSMTP -BodyAsHtml $corps -Priority Normal -Cc $cc -Encoding ([System.Text.Encoding]::UTF8)
    }
    else {
        Send-MailMessage -From $de -to $a -Subject $sujet -SmtpServer $serveurSMTP -BodyAsHtml $corps -Priority Normal -Encoding ([System.Text.Encoding]::UTF8)
    }
}