. ("$PSScriptRoot\constantes.ps1")
. ("$PSScriptRoot\fonctions_outils.ps1")
. ("$PSScriptRoot\fonctions_es.ps1")

# -----------------------------------------------------------------------------
# Recherche d'un mot de passe dans le fichier pgpass.conf local correspondant
# aux informations de connexion données.
#
# Le fonctionnement est identique à celui de PostgreSQL ; le mot de passe de la
# première ligne qui valide les informations de connexion est renvoyé.
#
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# -----------------------------------------------------------------------------
function Rechercher-MDP-PGPass {
    param (
        [string] $serveur = '.*',
        [string] $port = '.*',
        [string] $bdd = '.*',
        [string] $utilisateur = '.*'
    )

    $mdp = $null

    foreach ($ligne in Get-Content "$env:APPDATA\postgresql\pgpass.conf") {
        if ($ligne -match "($($serveur)|\*):($($port)|\*):($($bdd)|\*):($($utilisateur)|\*)") {
            $mdp = $ligne.Substring($ligne.LastIndexOf(':') + 1)
        }
    }

    $mdp
}

# -----------------------------------------------------------------------------
# Exécution d'un script SQL via l'outil psql.exe.
#
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $fichier : Le chemin vers le fichier à exécuter.
# $autresParams : Les paramètres d'appel supplémentaires à psql.exe.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# -----------------------------------------------------------------------------
function Executer-PSQL-Fichier {
    param (
        [parameter(Mandatory=$true)] [string] $serveur,
        [parameter(Mandatory=$true)] [string] $port,
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [parameter(Mandatory=$true)] [string] $fichier,
        [string[]] $autresParams = $null,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )
    
    Afficher-Message-Date -message "Exécution de $fichier sur $serveur\$bdd."
    
    $parametres = New-Object System.Collections.ArrayList
    [void]$parametres.Add("--host=$serveur")
    [void]$parametres.Add("--port=$port")
    [void]$parametres.Add("--dbname=$bdd")
    [void]$parametres.Add("--username=$utilisateur")
    [void]$parametres.Add("--file=`"$fichier`"")

    if ($autresParams) {
        [void]$parametres.AddRange($autresParams)
    }

    Afficher-Message-Date -message "`"$psql`" $parametres" -couleur gray

    if ($sortie) {
        New-Item -ItemType Directory -Force -Path (Split-Path -Path $sortie)

        if ($erreur) {
            Start-Process -FilePath "`"$psql`"" -WindowStyle Hidden -Wait -ArgumentList $parametres -RedirectStandardOutput $sortie -RedirectStandardError "$sortie.err"
        }
        else {
            Start-Process -FilePath "`"$psql`"" -WindowStyle Hidden -Wait -ArgumentList $parametres -RedirectStandardOutput $sortie
        }

        Changer-Encodage -fichier $sortie -encodageAvant 'utf-8' -encodageApres 'utf-8' # permet de forcer l'ajout du BOM
    }
    else {
        Start-Process -FilePath "`"$psql`"" -WindowStyle Hidden -Wait -ArgumentList $parametres
    }
}

# -----------------------------------------------------------------------------
# Exécution d'une commande SQL via l'outil psql.exe.
#
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $commande : La commande à exécuter.
# $autresParams : Les paramètres d'appel supplémentaires à psql.exe.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# -----------------------------------------------------------------------------
function Executer-PSQL-Commande {
    param (
        [parameter(Mandatory=$true)] [string] $serveur,
        [parameter(Mandatory=$true)] [string] $port,
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [parameter(Mandatory=$true)] [string] $commande,
        [string[]] $autresParams = $null,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )
    
    Afficher-Message-Date -message "Exécution de $commande sur $serveur\$bdd."
    
    # passe par un fichier SQL temporaire pour éviter les problèmes d'encodage lors des appels
    New-Item -ItemType Directory -Force -Path "$dossierTravailTemp\Executer-PSQL-Commande\"
    $fichierTemp = "$dossierTravailTemp\Executer-PSQL-Commande\$(New-Guid).sql"

    [System.IO.File]::WriteAllText($fichierTemp, $commande, (New-Object System.Text.UTF8Encoding $false))
    Executer-PSQL-Fichier -serveur $serveur -port $port -bdd $bdd -utilisateur $utilisateur -fichier $fichierTemp -autresParams $autresParams -sortie $sortie -erreur $erreur

    Remove-Item $fichierTemp
}

# -----------------------------------------------------------------------------
# Création d'une table temporaire avec des colonnes de type text.
#
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $table : Le nom de la table, éventuellement préfixé d'un schéma, à créer.
# $colonnes : Le nom des colonnes de la table.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# -----------------------------------------------------------------------------
function Creer-Table-Temp-PostgreSQL {
    param (
        [parameter(Mandatory=$true)] [string] $serveur,
        [parameter(Mandatory=$true)] [string] $port,
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [parameter(Mandatory=$true)] [string] $table,
        [parameter(Mandatory=$true)] [string[]] $colonnes,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Afficher-Message-Date -message "Création de la table $table dans $serveur\$bdd."

    $commande = "create unlogged table if not exists $table ($([string]::Join(', ', ($colonnes | foreach { "$_ text" }))));"
    Executer-PSQL-Commande -serveur $serveur -port $port -bdd $bdd -utilisateur $utilisateur -commande $commande -sortie $sortie -erreur $erreur
}

# -----------------------------------------------------------------------------
# Effacement d'une table.
#
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $table : Le nom de la table, éventuellement préfixé d'un schéma, à effacer.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# -----------------------------------------------------------------------------
function Effacer-Table-PostgreSQL {
    param (
        [parameter(Mandatory=$true)] [string] $serveur,
        [parameter(Mandatory=$true)] [string] $port,
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [parameter(Mandatory=$true)] [string] $table,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Afficher-Message-Date -message "Effacement de la table $table dans $serveur\$bdd."

    Executer-PSQL-Commande -serveur $serveur -port $port -bdd $bdd -utilisateur $utilisateur -commande "drop table if exists $table" -sortie $sortie -erreur $erreur
}

# -----------------------------------------------------------------------------
# Effacement d'une vue.
#
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $vue : Le nom de la vue, éventuellement préfixé d'un schéma, à effacer.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# -----------------------------------------------------------------------------
function Effacer-Vue-PostgreSQL {
    param (
        [parameter(Mandatory=$true)] [string] $serveur,
        [parameter(Mandatory=$true)] [string] $port,
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [parameter(Mandatory=$true)] [string] $vue,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Afficher-Message-Date -message "Effacement de la vue $vue dans $serveur\$bdd."

    Executer-PSQL-Commande -serveur $serveur -port $port -bdd $bdd -utilisateur $utilisateur -commande "drop view if exists $vue" -sortie $sortie -erreur $erreur
}

# -----------------------------------------------------------------------------
# Import d'un fichier CSV.
# Le CSV doit être encodé en UTF8.
#
# $csv : Le chemin vers le fichier CSV à importer.
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $table : Le nom de la table, éventuellement préfixé d'un schéma, à remplir.
# $delimiteur : Le delimiteur utilisé dans le fichier CSV.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# -----------------------------------------------------------------------------
function Importer-CSV-PostgreSQL {
    param (
        [parameter(Mandatory=$true)] [string] $csv,
        [parameter(Mandatory=$true)] [string] $serveur,
        [parameter(Mandatory=$true)] [string] $port,
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [parameter(Mandatory=$true)] [string] $table,
        [string] $delimiteur = (Get-Culture).TextInfo.ListSeparator,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Afficher-Message-Date -message "Import de $csv vers $serveur\$bdd."

    # passe par une copie temporaire du csv pour éviter les problèmes de caractères accentués dans les chemins
    New-Item -ItemType Directory -Force -Path "$dossierTravailTemp\Importer-CSV-PostgreSQL\"
    $fichierTemp = "$dossierTravailTemp\Importer-CSV-PostgreSQL\$(New-Guid).csv"
    Copy-Item -LiteralPath $csv -Destination $fichierTemp -Force

    $commande = "\copy $table from '$fichierTemp' with (format csv, delimiter '$delimiteur', header true, encoding 'utf8')"
    Executer-PSQL-Commande -serveur $serveur -port $port -bdd $bdd -utilisateur $utilisateur -commande $commande -sortie $sortie -erreur $erreur

    Remove-Item $fichierTemp
}

# -----------------------------------------------------------------------------
# Export d'un CSV.
#
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $requete : La requête SQL source de l'export.
# $csv : Le CSV d'export.
# $delimiteur : Le delimiteur utilisé dans le fichier CSV.
# -----------------------------------------------------------------------------
function Exporter-CSV-PostgreSQL {
    param (
        [parameter(Mandatory=$true)] [string] $serveur,
        [parameter(Mandatory=$true)] [string] $port,
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $csv,
        [string] $delimiteur = (Get-Culture).TextInfo.ListSeparator
    )

    Afficher-Message-Date -message "Export de $requete depuis $serveur\$bdd vers $csv."

    Executer-PSQL-Commande `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -commande $requete `
        -autresParams @('--no-align', '--pset footer', "-F $delimiteur") `
        -sortie $csv `
        -erreur $false
}

# -----------------------------------------------------------------------------
# Export d'un dump.
#
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $tables : Les tables à exporter.
# $dump : Le dump d'export.
# $autresParams : Les paramètres d'appel supplémentaires à pg_dump.exe.
# -----------------------------------------------------------------------------
function Exporter-Dump-PostgreSQL {
    param (
        [parameter(Mandatory=$true)] [string] $serveur,
        [parameter(Mandatory=$true)] [string] $port,
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [string[]] $tables = $null,
        [parameter(Mandatory=$true)] [string] $dump,
        [string[]] $autresParams = @('--inserts', '--no-owner', '--no-privileges')
    )

    Afficher-Message-Date "Export dump de $tables depuis $serveur\$bdd vers $dump."
    
    $parametres = New-Object System.Collections.ArrayList
    [void]$parametres.Add("-h $serveur")
    [void]$parametres.Add("-p $port")
    [void]$parametres.Add("-U $utilisateur")

    if ($autresParams) {
        [void]$parametres.AddRange($autresParams)
    }
    
    foreach ($table in $tables) {
       [void]$parametres.Add("-t $table")
    }
    
    [void]$parametres.Add("-f `"$dump`"")
    [void]$parametres.Add("$bdd")
    
    New-Item -ItemType Directory -Force -Path (Split-Path -Path $dump)

    Afficher-Message-Date -message "`"$pgdump`" $parametres" -couleur gray
    Start-Process -FilePath "`"$pgdump`"" -WindowStyle Hidden -Wait -ArgumentList $parametres
}