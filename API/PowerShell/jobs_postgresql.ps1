. ("$PSScriptRoot\fonctions_jobs.ps1")

# -----------------------------------------------------------------------------
# Job d'exécution d'un script SQL via l'outil psql.exe.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .serveur : Le serveur de base de données.
# .port : Le port du serveur de base de données.
# .bdd : Le nom de la base de données.
# .utilisateur : L'utilisateur pour la connexion à la base de données.
# .fichier : Le chemin vers le fichier à exécuter.
# .autresParams : Les paramètres d'appel supplémentaires à psql.exe.
# .sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# .erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# -----------------------------------------------------------------------------
$Job_Executer_PSQL_Fichier = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\fonctions_postgresql.ps1")

    Executer-PSQL-Fichier `
        -serveur $parametres.serveur `
        -port $parametres.port `
        -bdd $parametres.bdd `
        -utilisateur $parametres.utilisateur `
        -fichier $parametres.fichier `
        -autresParams $parametres.autresParams `
        -sortie $parametres.sortie `
        -erreur $parametres.erreur
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'exécution d'un script SQL via l'outil psql.exe.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
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
function Parametrer-Job-Executer-PSQL-Fichier {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $serveur,
        [parameter(Mandatory=$true)] [string] $port,
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [parameter(Mandatory=$true)] [string] $fichier,
        [string[]] $autresParams = $null,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    @{
        script = $Job_Executer_PSQL_Fichier
        racineAPI = $racineAPI
        serveur = $serveur
        port = $port
        bdd = $bdd
        utilisateur = $utilisateur
        fichier = $fichier
        autresParams = $autresParams
        sortie = $sortie
        erreur = $erreur
    }
}

# -----------------------------------------------------------------------------
# Job d'exécution d'une commande SQL via l'outil psql.exe.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .serveur : Le serveur de base de données.
# .port : Le port du serveur de base de données.
# .bdd : Le nom de la base de données.
# .utilisateur : L'utilisateur pour la connexion à la base de données.
# .commande : La commande à exécuter.
# .autresParams : Les paramètres d'appel supplémentaires à psql.exe.
# .sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# .erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# -----------------------------------------------------------------------------
$Job_Executer_PSQL_Commande = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\fonctions_postgresql.ps1")

    Executer-PSQL-Commande `
        -serveur $parametres.serveur `
        -port $parametres.port `
        -bdd $parametres.bdd `
        -utilisateur $parametres.utilisateur `
        -commande $parametres.commande `
        -autresParams $parametres.autresParams `
        -sortie $parametres.sortie `
        -erreur $parametres.erreur
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'exécution d'une commande SQL via l'outil psql.exe.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
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
function Parametrer-Job-Executer-PSQL-Commande {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $serveur,
        [parameter(Mandatory=$true)] [string] $port,
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [parameter(Mandatory=$true)] [string] $commande,
        [string[]] $autresParams = $null,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    @{
        script = $Job_Executer_PSQL_Commande
        racineAPI = $racineAPI
        serveur = $serveur
        port = $port
        bdd = $bdd
        utilisateur = $utilisateur
        commande = $commande
        autresParams = $autresParams
        sortie = $sortie
        erreur = $erreur
    }
}

# -----------------------------------------------------------------------------
# Parallélisation par jobs des transactions d'un script SQL.
#
# Un script doit respecter la forme suivante :
# begin;
# <commande 1.1>;
# <commande 1.2>;
# ...
# commit;
# begin;
# <commande 2.1>;
# <commande 2.2>;
# ...
# commit;
# ...
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $fichierTransactions : La fichier SQL de transactions.
# $autresParams : Les paramètres d'appel supplémentaires à psql.exe.
# $dossierSortie : Chemin de redirection de la sortie standard, $null pour ne
#                  pas activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $nombreJobs : Le nombre maximum de jobs en parrallèle, par défaut égal au
#               nombre de coeurs - 1.
# $afficherSortieJobs : Pour demander l'affichage des sorties des jobs.
# -----------------------------------------------------------------------------
function Paralleliser-Fichier-PSQL-Transactions {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $serveur,
        [parameter(Mandatory=$true)] [string] $port,
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [parameter(Mandatory=$true)] [string] $fichierTransactions,
        [string[]] $autresParams = $null,
        [string] $dossierSortie = $null,
        [bool] $erreur = $true,
        [int] $nombreJobs = $env:NUMBER_OF_PROCESSORS - 1,
        [bool] $afficherSortieJobs = $true
    )
    
    $parametresJobs = New-Object System.Collections.ArrayList

    $commande = New-Object System.Text.StringBuilder
    $numeroCommande = 0;

    # itération sur les lignes du fichier pour identifier les transactions
    foreach ($ligne in Get-Content $fichierTransactions) {
    
        $ligne = $ligne.Trim()

        if ($ligne -ne '' -and !$ligne.Contains('--') -and $ligne -ne 'begin;' -and $ligne -ne 'commit;') {
            [void]$commande.Append(" $ligne")
        }

        if ($ligne -eq 'commit;') {
            $numeroCommande++

            # paramètrage d'un job par transaction
            $parametreJob = Parametrer-Job-Executer-PSQL-Commande `
                -racineAPI $racineAPI `
                -serveur $serveur `
                -port $port `
                -bdd $bdd `
                -utilisateur $utilisateur `
                -commande "begin; $commande commit;" `
                -erreur $erreur `
                -autresParams $autresParams

            if ($dossierSortie) {
                $parametreJob.sortie = "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Transaction $numeroCommande - $([System.IO.Path]::GetFileNameWithoutExtension($fichierTransactions)).txt"
            }

            [void]$parametresJobs.Add($parametreJob)

            $commande = New-Object System.Text.StringBuilder
        }
    }

    # exécution des jobs
    Executer-Jobs -parametresJobs $parametresJobs -nombreJobs $nombreJobs -afficherSortieJobs $afficherSortieJobs
}

# -----------------------------------------------------------------------------
# Job d'import d'un fichier CSV.
# Le CSV doit être encodé en UTF8.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .csv : Le chemin vers le fichier CSV à importer.
# .serveur : Le serveur de base de données.
# .port : Le port du serveur de base de données.
# .bdd : Le nom de la base de données.
# .utilisateur : L'utilisateur pour la connexion à la base de données.
# .table : Le nom de la table, éventuellement préfixe d'un schéma, à remplir.
# .delimiteur : Le delimiteur utilisé dans le fichier CSV.
# .sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# .erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# -----------------------------------------------------------------------------
$Job_Importer_CSV_PostgreSQL = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\fonctions_postgresql.ps1")

    Importer-CSV-PostgreSQL `
        -csv $parametres.csv `
        -serveur $parametres.serveur `
        -port $parametres.port `
        -bdd $parametres.bdd `
        -utilisateur $parametres.utilisateur `
        -table $parametres.table `
        -delimiteur $parametres.delimiteur `
        -sortie $parametres.sortie `        -erreur $parametres.erreur
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'import d'un fichier CSV.
# Le CSV doit être encodé en UTF8.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
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
function Parametrer-Job-Importer-CSV-PostgreSQL {
    param (
        [string] $racineAPI = $PSScriptRoot,
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

    @{
        script = $Job_Importer_CSV_PostgreSQL
        racineAPI = $racineAPI
        csv = $csv
        serveur = $serveur
        port = $port
        bdd = $bdd
        utilisateur = $utilisateur
        table = $table
        delimiteur = $delimiteur
        sortie = $sortie
        erreur = $erreur
    }
}

# -----------------------------------------------------------------------------
# Job d'export d'un CSV.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .serveur : Le serveur de base de données.
# .port : Le port du serveur de base de données.
# .bdd : Le nom de la base de données.
# .utilisateur : L'utilisateur pour la connexion à la base de données.
# .requete : La requête SQL source de l'export.
# .csv : Le CSV d'export.
# .delimiteur : Le delimiteur utilisé dans le fichier CSV.
# -----------------------------------------------------------------------------
$Job_Exporter_CSV_PostgreSQL = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\fonctions_postgresql.ps1")

    Exporter-CSV-PostgreSQL `
        -serveur $parametres.serveur `
        -port $parametres.port `
        -bdd $parametres.bdd `
        -utilisateur $parametres.utilisateur `
        -requete $parametres.requete `
        -csv $parametres.csv `
        -delimiteur $parametres.delimiteur
}

# -----------------------------------------------------------------------------
# Paramètrage d'un job d'export d'un CSV.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $requete : La requête SQL source de l'export.
# $csv : Le CSV d'export.
# $delimiteur : Le delimiteur utilisé dans le fichier CSV.
# -----------------------------------------------------------------------------
function Parametrer-Job-Exporter-CSV-PostgreSQL {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $serveur,
        [parameter(Mandatory=$true)] [string] $port,
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $csv,
        [string] $delimiteur = (Get-Culture).TextInfo.ListSeparator
    )

    @{
        script = $Job_Exporter_CSV_PostgreSQL
        racineAPI = $racineAPI
        serveur = $serveur
        port = $port
        bdd = $bdd
        utilisateur = $utilisateur
        requete = $requete
        csv = $csv
        delimiteur = $delimiteur
    }
}

# -----------------------------------------------------------------------------
# Job d'export d'un dump.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .serveur : Le serveur de base de données.
# .port : Le port du serveur de base de données.
# .bdd : Le nom de la base de données.
# .utilisateur : L'utilisateur pour la connexion à la base de données.
# .tables : Les tables à exporter.
# .dump : Le dump d'export.
# .autresParams : Les paramètres d'appel supplémentaires à pg_dump.exe.
# -----------------------------------------------------------------------------
$Job_Exporter_Dump_PostgreSQL ` = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\fonctions_postgresql.ps1")

    Exporter-Dump-PostgreSQL `
        -serveur $parametres.serveur `
        -port $parametres.port `
        -bdd $parametres.bdd `
        -utilisateur $parametres.utilisateur `
        -tables $parametres.tables `
        -dump $parametres.dump `
        -autresParams $parametres.autresParams
}

# -----------------------------------------------------------------------------
# Paramètrage d'un job d'export d'un dump.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $tables : Les tables à exporter.
# $dump : Le dump d'export.
# $autresParams : Les paramètres d'appel supplémentaires à pg_dump.exe.
# -----------------------------------------------------------------------------
function Parametrer-Job-Exporter-Dump-PostgreSQL {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $serveur,
        [parameter(Mandatory=$true)] [string] $port,
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [string[]] $tables = $null,
        [parameter(Mandatory=$true)] [string] $dump,
        [string[]] $autresParams = @('--inserts', '--no-owner', '--no-privileges')
    )

    @{
        script = $Job_Exporter_Dump_PostgreSQL
        racineAPI = $racineAPI
        serveur = $serveur
        port = $port
        bdd = $bdd
        utilisateur = $utilisateur
        tables = $tables
        dump = $dump
        autresParams = $autresParams
    }
}