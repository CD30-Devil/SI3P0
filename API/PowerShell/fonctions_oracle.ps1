. ("$PSScriptRoot\constantes.ps1")
. ("$PSScriptRoot\fonctions_outils.ps1")
. ("$PSScriptRoot\fonctions_es.ps1")

# -----------------------------------------------------------------------------
# Exécution d'un script SQL via l'outil sqlplus.exe.
#
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe.
# $tnsname : Le nom tns pour la connexion.
# $fichier : Le chemin vers le fichier à exécuter.
# $autresParams : Les paramètres d'appel supplémentaires à sqlplus.exe.
# -----------------------------------------------------------------------------
function Executer-SQLPLUS-Fichier {
    param (
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [parameter(Mandatory=$true)] [string] $mdp,
        [parameter(Mandatory=$true)] [string] $tnsname,
        [parameter(Mandatory=$true)] [string] $fichier,
        [string[]] $autresParams = $null
    )

    Afficher-Message-Date -message "Exécution de $fichier sur $tnsname."

    $parametres = New-Object System.Collections.ArrayList
    [void]$parametres.Add("-L $utilisateur/$mdp@$tnsname")
    [void]$parametres.Add("`"@$fichier`"")
    
    
    if ($autresParams) {
        [void]$parametres.AddRange($autresParams)
    }

    Afficher-Message-Date -message "`"$sqlplus`" $parametres" -couleur gray
    Start-Process -FilePath "`"$sqlplus`"" -WindowStyle Hidden -Wait -ArgumentList $parametres
}

# -----------------------------------------------------------------------------
# Export d'un CSV.
#
# /!\ En fonction de la nature de l'assembly $OracleDataAccessLib
# (variable définie dans constantes.ps1) il peut être nécessaire d'appeler
# cette fonction dans un process 32 bits.
#
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe.
# $tnsname : Le nom tns pour la connexion.
# $requete : La requête SQL source de l'export.
# $csv : Le CSV d'export.
# $delimiteur : Le delimiteur utilisé dans le fichier CSV.
# -----------------------------------------------------------------------------
function Exporter-CSV-Oracle {
    param (
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [parameter(Mandatory=$true)] [string] $mdp,
        [parameter(Mandatory=$true)] [string] $tnsname,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $csv,
        [string] $delimiteur = (Get-Culture).TextInfo.ListSeparator
    )

    Afficher-Message-Date -message "Exécution de $requete sur $tnsname."

    $ecriture = New-Object System.IO.StreamWriter($csv)

    [Reflection.Assembly]::LoadFile($OracleDataAccessLib)

    $connexion = New-Object Oracle.DataAccess.Client.OracleConnection("User Id=$utilisateur;Password=$mdp;Data Source=$tnsname")
    $connexion.Open()

    $commande = New-Object Oracle.DataAccess.Client.OracleCommand($requete, $connexion)

    $lecteur = $commande.ExecuteReader()

    # ligne d'entête du CSV de sortie
    $champs = @()

    for ($n = 0; $n -lt $lecteur.FieldCount; $n++) {
        $champs += '"' + $lecteur.GetName($n) + '"'
    }

    $ecriture.WriteLine([string]::Join($delimiteur, $champs))

    # lignes résultats du CSV de sortie
    while ($lecteur.Read()) {
        $champs = @()

        for ($n = 0; $n -lt $lecteur.FieldCount; $n++) {
            if ($lecteur.IsDBNull($n)) {
                $champs += ''
            }
            else {
                $champs += '"' + $lecteur.GetValue($n).ToString() + '"'
            }
        }

        $ecriture.WriteLine([string]::Join($delimiteur, $champs))
    }

    $lecteur.Close()
    $lecteur = $null

    $commande.Dispose()
    $commande = $null

    $connexion.Close()
    $connexion = $null

    $ecriture.Close()
    $ecriture = $null
}