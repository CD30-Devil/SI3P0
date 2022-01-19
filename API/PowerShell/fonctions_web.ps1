. ("$PSScriptRoot\constantes.ps1")
. ("$PSScriptRoot\fonctions_outils.ps1")

# -----------------------------------------------------------------------------
# Téléchargement d'un fichier.
#
# $url : L'adresse url du fichier à télécharger.
# $enregistrerSous : L'emplacement de sauvegarde.
# $entetes : Les entêtes à ajouter lors de l'appel.
# -----------------------------------------------------------------------------
function Telecharger {
    param (
        [parameter(Mandatory=$true)] [string] $url,
        [parameter(Mandatory=$true)] [string] $enregistrerSous,
        [hashtable] $entetes = $null
    )
    
    Afficher-Message-Date -message "Téléchargement de $url vers $enregistrerSous."
    New-Item -ItemType Directory -Force -Path (Split-Path -Path $enregistrerSous)

    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls13 -bor [System.Net.SecurityProtocolType]::Ssl3
    $client = [Net.WebClient]::new()

    if ($entetes) {
        foreach ($cle in $entetes.Keys) {
            $client.Headers.Add($cle, $entetes[$cle])
        }
    }

    $client.DownloadFile($url, $enregistrerSous)
}

# -----------------------------------------------------------------------------
# Envoi d'un e-mail.
#
# $de : L'émetteur.
# $a : Les destinataires.
# $cc : Les destinataires en copie.
# $sujet : Le sujet du message.
# $corps : Le corps du message.
# $pjLes pièces jointes.
# -----------------------------------------------------------------------------
function Envoyer-Mail {
    param (
        [parameter(mandatory=$true)] [string] $de,
        [parameter(mandatory=$true)] [string[]] $a,
        [string[]] $cc = $null,
        [parameter(mandatory=$true)] [string] $sujet,
        [parameter(mandatory=$true)] [string] $corps,
        [string[]] $pj = $null
    )
    
    Afficher-Message-Date -message "Envoie d'un e-mail de $de à $([string]::Join(', ', $a))."

    # test préalable des paramètres car l'appel n'autorise pas les $null ou vide
    if ($cc -and $pj) {
        Send-MailMessage `
            -SmtpServer $serveurSMTP `
            -From $de `
            -to $a `
            -Cc $cc `
            -Attachments $pj `
            -Subject $sujet `
            -BodyAsHtml $corps `            -Priority Normal `            -Encoding ([System.Text.Encoding]::UTF8)
    }
    elseif ($cc) {
        Send-MailMessage `
            -SmtpServer $serveurSMTP `
            -From $de `
            -to $a `
            -Cc $cc `
            -Subject $sujet `
            -BodyAsHtml $corps `            -Priority Normal `            -Encoding ([System.Text.Encoding]::UTF8)
    }
    elseif ($pj) {
        Send-MailMessage `
            -SmtpServer $serveurSMTP `
            -From $de `
            -to $a `
            -Attachments $pj `
            -Subject $sujet `
            -BodyAsHtml $corps `            -Priority Normal `            -Encoding ([System.Text.Encoding]::UTF8)
    }
    else {
        Send-MailMessage `
            -SmtpServer $serveurSMTP `
            -From $de `
            -to $a `
            -Subject $sujet `
            -BodyAsHtml $corps `            -Priority Normal `            -Encoding ([System.Text.Encoding]::UTF8)
    }
}