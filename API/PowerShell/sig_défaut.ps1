. ("$PSScriptRoot\constantes.ps1")
. ("$PSScriptRoot\fonctions_postgresql.ps1")
. ("$PSScriptRoot\fonctions_postgis.ps1")
. ("$PSScriptRoot\jobs_postgresql.ps1")
. ("$PSScriptRoot\jobs_postgis.ps1")

# paramètres de connexion au serveur SIg par défaut
$sigServeur = '<mon-serveur-postgis>'
$sigPort = '<5432>'
$sigBDD = '<ma-base-postgis>'
$sigUtilisateur = '<mon-utilisateur-postgis>'
$sigMDP = Rechercher-MDP-PGPass -serveur $sigServeur -port $sigPort -bdd $sigBDD -utilisateur $sigUtilisateur

# nombre de coeurs disponibles sur le serveur SIg
$sigNbCoeurs = 8

# -----------------------------------------------------------------------------
# Exécution d'un script SQL via l'outil psql.exe.
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
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
function SIg-Executer-Fichier {
    param (
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [parameter(Mandatory=$true)] [string] $fichier,
        [string[]] $autresParams = $null,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )
    
    Executer-PSQL-Fichier `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -fichier $fichier `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur
}

# -----------------------------------------------------------------------------
# Exécution d'une commande SQL via l'outil psql.exe.
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
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
function SIg-Executer-Commande {
    param (
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [parameter(Mandatory=$true)] [string] $commande,
        [string[]] $autresParams = $null,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )
    
    Executer-PSQL-Commande `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -commande $commande `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur
}

# -----------------------------------------------------------------------------
# Création d'une table temporaire avec des colonnes de type text.
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
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
function SIg-Creer-Table-Temp {
    param (
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [parameter(Mandatory=$true)] [string] $table,
        [parameter(Mandatory=$true)] [string[]] $colonnes,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Creer-Table-Temp-PostgreSQL `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -table $table `
        -colonnes $colonnes `
        -sortie $sortie `
        -erreur $erreur
}

# -----------------------------------------------------------------------------
# Effacement d'une table.
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
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
function SIg-Effacer-Table {
    param (
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [parameter(Mandatory=$true)] [string] $table,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Effacer-Table-PostgreSQL `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -table $table `
        -sortie $sortie `
        -erreur $erreur
}

# -----------------------------------------------------------------------------
# Effacement d'une vue.
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
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
function SIg-Effacer-Vue {
    param (
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [parameter(Mandatory=$true)] [string] $vue,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Effacer-Vue-PostgreSQL `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -vue $vue `
        -sortie $sortie `
        -erreur $erreur
}

# -----------------------------------------------------------------------------
# Import d'un fichier CSV.
# Le CSV doit être encodé en UTF8.
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
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
function SIg-Importer-CSV {
    param (
        [parameter(Mandatory=$true)] [string] $csv,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [parameter(Mandatory=$true)] [string] $table,
        [string] $delimiteur = (Get-Culture).TextInfo.ListSeparator,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Importer-CSV-PostgreSQL `
        -csv $csv `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -table $table `
        -delimiteur $delimiteur `
        -sortie $sortie `
        -erreur $erreur
}

# -----------------------------------------------------------------------------
# Import d'un GeoJSON (par appel à Ogr2Ogr).
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
#
# $geoJSON : Le GeoJSON à importer.
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf
# $table : La table destination.
# $sridSource : Le SRID source.
# $sridCible : Le SRID cible.
# $multiGeom : Pour demander la création d'une géométrie multi*.
# $autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function SIg-Importer-GeoJSON {
    param (
        [parameter(Mandatory=$true)] [string] $geoJSON,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string] $mdp = $sigMDP,
        [parameter(Mandatory=$true)] [string] $table,
        [string] $sridSource = '4326',
        [string] $sridCible = $sridDefaut,
        [bool] $multiGeom = $true,
        [string[]] $autresParams = @('-lco SPATIAL_INDEX=GIST', '-lco GEOMETRY_NAME=geom'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Importer-GeoJSON-Postgis `
        -geoJSON $geoJSON `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -mdp $mdp `
        -table $table `
        -sridSource $sridSource `
        -sridCible $sridCible `
        -multiGeom $multiGeom `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Import d'un SHP (par appel à Ogr2Ogr).
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
#
# $shp : Le SHP à importer.
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf
# $table : La table destination.
# $sridSource : Le SRID source.
# $sridCible : Le SRID cible.
# $multiGeom : Pour demander la création d'une géométrie multi*.
# $autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function SIg-Importer-SHP {
    param (
        [parameter(Mandatory=$true)] [string] $shp,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string] $mdp = $sigMDP,
        [parameter(Mandatory=$true)] [string] $table,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = $sridDefaut,
        [bool] $multiGeom = $true,
        [string[]] $autresParams = @('-lco SPATIAL_INDEX=GIST', '-lco GEOMETRY_NAME=geom'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Importer-SHP-Postgis `
        -shp $shp `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -mdp $mdp `
        -table $table `
        -sridSource $sridSource `
        -sridCible $sridCible `
        -multiGeom $multiGeom `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Import d'un MIF/MIF (par appel à Ogr2Ogr).
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
#
# $midmid : Le MIF/MID à importer.
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf
# $table : La table destination.
# $sridSource : Le SRID source.
# $sridCible : Le SRID cible.
# $multiGeom : Pour demander la création d'une géométrie multi*.
# $autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function SIg-Importer-MIFMID {
    param (
        [parameter(Mandatory=$true)] [string] $mifmid,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string] $mdp = $sigMDP,
        [parameter(Mandatory=$true)] [string] $table,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = $sridDefaut,
        [bool] $multiGeom = $true,
        [string[]] $autresParams = @('-lco SPATIAL_INDEX=GIST', '-lco GEOMETRY_NAME=geom'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Importer-MIFMID-Postgis `
        -mifmid $mifmid `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -mdp $mdp `
        -table $table `
        -sridSource $sridSource `
        -sridCible $sridCible `
        -multiGeom $multiGeom `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Export d'un CSV.
# Les valeurs pré-établies des paramètres font que le SIg par défaut est
# utilisé comme source.
#
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $requete : La requête SQL source de l'export.
# $csv : Le CSV d'export.
# $delimiteur : Le delimiteur utilisé dans le fichier CSV.
# -----------------------------------------------------------------------------
function SIg-Exporter-CSV {
    param (
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $csv,
        [string] $delimiteur = (Get-Culture).TextInfo.ListSeparator
    )

    Exporter-CSV-PostgreSQL `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -requete $requete `
        -csv $csv `
        -delimiteur $delimiteur
}

# -----------------------------------------------------------------------------
# Export d'un GeoJSON (par appel à Ogr2Ogr).
# Les valeurs pré-établies des paramètres font que le SIg par défaut est
# utilisé comme source.
#
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# $requete : La requête SQL source de l'export.
# $geoJSON : Le GeoJSON d'export.
# $sridSource : Le SRID source.
# $sridCible : Le SRID cible.
# $autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function SIg-Exporter-GeoJSON {
    param (
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string] $mdp = $sigMDP,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $geoJSON,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = '4326',
        [string[]] $autresParams = @('-lco WRITE_NAME=NO'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Exporter-GeoJSON-Postgis `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -mdp $mdp `
        -requete $requete `
        -geoJSON $geoJSON `
        -sridSource $sridSource `
        -sridCible $sridCible `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Export d'un SHP (par appel à Ogr2Ogr).
# Les valeurs pré-établies des paramètres font que le SIg par défaut est
# utilisé comme source.
#
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# $requete : La requête SQL source de l'export.
# $shp : Le SHP d'export.
# $compresser : Pour demander la génération d'un zip contenant le SHP et ses
#               dépendances.
# $sridSource : Le SRID source.
# $sridCible : Le SRID cible.
# $autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function SIg-Exporter-SHP {
    param (
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string] $mdp = $sigMDP,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $shp,
        [bool] $compresser = $false,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = $sridDefaut,
        [string[]] $autresParams = @('-lco ENCODING=UTF-8'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Exporter-SHP-Postgis `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -mdp $mdp `
        -requete $requete `
        -shp $shp `
        -compresser $compresser `
        -sridSource $sridSource `
        -sridCible $sridCible `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Export d'un GPX (par appel à Ogr2Ogr).
# Les valeurs pré-établies des paramètres font que le SIg par défaut est
# utilisé comme source.
#
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# $requete : La requête SQL source de l'export.
# $gpx : Le GPX d'export.
# $sridSource : Le SRID source.
# $autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function SIg-Exporter-GPX {
    param (
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string] $mdp = $sigMDP,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $gpx,
        [string] $sridSource = $sridDefaut,
        [string[]] $autresParams = @('-nlt MULTILINESTRING', '-dsco GPX_USE_EXTENSIONS=YES'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Exporter-GPX-Postgis `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -mdp $mdp `
        -requete $requete `
        -gpx $gpx `
        -sridSource $sridSource `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Export d'un DXF (par appel à Ogr2Ogr).
# Les valeurs pré-établies des paramètres font que le SIg par défaut est
# utilisé comme source.
#
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# $requete : La requête SQL source de l'export.
# $dxf : Le DXF d'export.
# $sridSource : Le SRID source.
# $sridCible : Le SRID cible.
# $autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function SIg-Exporter-DXF {
    param (
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string] $mdp = $sigMDP,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $dxf,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = $sridDefaut,
        [string[]] $autresParams = $null,
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Exporter-DXF-Postgis `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -mdp $mdp `
        -requete $requete `
        -dxf $dxf `
        -sridSource $sridSource `
        -sridCible $sridCible `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Export d'un dump.
# Les valeurs pré-établies des paramètres font que le SIg par défaut est
# utilisé comme source.
#
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $tables : Les tables à exporter.
# $dump : Le dump d'export.
# $autresParams : Les paramètres d'appel supplémentaires à pg_dump.exe.
# -----------------------------------------------------------------------------
function SIg-Exporter-Dump {
    param (
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string[]] $tables = $null,
        [parameter(Mandatory=$true)] [string] $dump,
        [string[]] $autresParams = @('--inserts', '--no-owner', '--no-privileges')
    )

    Exporter-Dump-PostgreSQL `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -tables $tables `
        -dump $dump `
        -autresParams $autresParams
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'exécution d'un script SQL via l'outil psql.exe.
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
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
function Parametrer-Job-SIg-Executer-Fichier {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [parameter(Mandatory=$true)] [string] $fichier,
        [string[]] $autresParams = $null,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Parametrer-Job-Executer-PSQL-Fichier `
        -racineAPI $racineAPI `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -fichier $fichier `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'exécution d'une commande SQL via l'outil psql.exe.
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
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
function Parametrer-Job-SIg-Executer-Commande {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [parameter(Mandatory=$true)] [string] $commande,
        [string[]] $autresParams = $null,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Parametrer-Job-Executer-PSQL-Commande `
        -racineAPI $racineAPI `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -commande $commande `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur
}

# -----------------------------------------------------------------------------
# Parallélisation par jobs des transactions d'un script SQL.
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
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
function SIg-Paralleliser-Fichier-Transactions {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [parameter(Mandatory=$true)] [string] $fichierTransactions,
        [string[]] $autresParams = $null,
        [string] $dossierSortie = $null,
        [bool] $erreur = $true,
        [int] $nombreJobs = $env:NUMBER_OF_PROCESSORS - 1,
        [bool] $afficherSortieJobs = $true
    )

    Paralleliser-Fichier-PSQL-Transactions `
        -racineAPI $racineAPI `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -fichierTransactions $fichierTransactions `
        -autresParams $autresParams `
        -dossierSortie $dossierSortie `
        -erreur $erreur `
        -nombreJobs $nombreJobs `
        -afficherSortieJobs $afficherSortieJobs
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'import d'un fichier CSV.
# Le CSV doit être encodé en UTF8.
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
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
function Parametrer-Job-SIG-Importer-CSV {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $csv,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [parameter(Mandatory=$true)] [string] $table,
        [string] $delimiteur = (Get-Culture).TextInfo.ListSeparator,
        [string] $sortie = $null,
        [bool] $erreur = $true
    )

    Parametrer-Job-Importer-CSV-PostgreSQL `
        -racineAPI $racineAPI `
        -csv $csv `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -table $table `
        -delimiteur $delimiteur `
        -sortie $sortie `
        -erreur $erreur
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'import d'un GeoJSON (par appel à Ogr2Ogr).
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# $geoJSON : Le GeoJSON à importer.
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# $table : La table destination.
# $sridSource : Le SRID source.
# $sridCible : Le SRID cible.
# $multiGeom : Pour demander la création d'une géométrie multi*.
# $autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function Parametrer-Job-SIg-Importer-GeoJSON {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $geoJSON,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string] $mdp = $sigMDP,
        [parameter(Mandatory=$true)] [string] $table,
        [string] $sridSource = '4326',
        [string] $sridCible = $sridDefaut,
        [bool] $multiGeom = $true,
        [string[]] $autresParams = @('-lco SPATIAL_INDEX=GIST', '-lco GEOMETRY_NAME=geom'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Parametrer-Job-Importer-GeoJSON-Postgis `
        -racineAPI $racineAPI `
        -geoJSON $geoJSON `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -mdp $mdp `
        -table $table `
        -sridSource $sridSource `
        -sridCible $sridCible `
        -multiGeom $multiGeom `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite `
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'import d'un SHP (par appel à Ogr2Ogr).
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# $shp : Le SHP à importer.
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# $table : La table destination.
# $sridSource : Le SRID source.
# $sridCible : Le SRID cible.
# $multiGeom : Pour demander la création d'une géométrie multi*.
# $autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function Parametrer-Job-SIg-Importer-SHP {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $shp,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string] $mdp = $sigMDP,
        [parameter(Mandatory=$true)] [string] $table,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = $sridDefaut,
        [bool] $multiGeom = $true,
        [string[]] $autresParams = @('-lco SPATIAL_INDEX=GIST', '-lco GEOMETRY_NAME=geom'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Parametrer-Job-Importer-SHP-Postgis `
        -racineAPI $racineAPI `
        -shp $shp `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -mdp $mdp `
        -table $table `
        -sridSource $sridSource `
        -sridCible $sridCible `
        -multiGeom $multiGeom `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite `
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'import d'un MIF/MID (par appel à Ogr2Ogr).
# Les valeurs pré-établies des paramètres font que le SIg par défaut est ciblé.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# $mifmid : Le MIF/MID à importer.
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# $table : La table destination.
# $sridSource : Le SRID source.
# $sridCible : Le SRID cible.
# $multiGeom : Pour demander la création d'une géométrie multi*.
# $autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function Parametrer-Job-SIg-Importer-MIFMID {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $mifmid,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string] $mdp = $sigMDP,
        [parameter(Mandatory=$true)] [string] $table,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = $sridDefaut,
        [bool] $multiGeom = $true,
        [string[]] $autresParams = @('-lco SPATIAL_INDEX=GIST', '-lco GEOMETRY_NAME=geom'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Parametrer-Job-Importer-MIFMID-Postgis `
        -racineAPI $racineAPI `
        -mifmid $mifmid `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -mdp $mdp `
        -table $table `
        -sridSource $sridSource `
        -sridCible $sridCible `
        -multiGeom $multiGeom `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite `
}

# -----------------------------------------------------------------------------
# Paramètrage d'un job d'export d'un CSV.
# Les valeurs pré-établies des paramètres font que le SIg par défaut est
# utilisé comme source.
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
function Parametrer-Job-SIg-Exporter-CSV {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $csv,
        [string] $delimiteur = (Get-Culture).TextInfo.ListSeparator
    )

    Parametrer-Job-Exporter-CSV-PostgreSQL `
        -racineAPI $racineAPI `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -requete $requete `
        -csv $csv `
        -delimiteur $delimiteur
}

# -----------------------------------------------------------------------------
# Paramètrage d'un job d'export d'un dump.
# Les valeurs pré-établies des paramètres font que le SIg par défaut est
# utilisé comme source.
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
function Parametrer-Job-SIg-Exporter-Dump {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string[]] $tables = $null,
        [parameter(Mandatory=$true)] [string] $dump,
        [string[]] $autresParams = @('--inserts', '--no-owner', '--no-privileges')
    )

    Parametrer-Job-Exporter-Dump-PostgreSQL `
        -racineAPI $racineAPI `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -tables $tables `
        -dump $dump `
        -autresParams $autresParams
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'export d'un GeoJSON (par appel à Ogr2Ogr).
# Les valeurs pré-établies des paramètres font que le SIg par défaut est
# utilisé comme source.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# $requete : La requête SQL source de l'export.
# $geoJSON : Le GeoJSON d'export.
# $sridSource : Le SRID source.
# $sridCible : Le SRID cible.
# $autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function Parametrer-Job-SIg-Exporter-GeoJSON {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string] $mdp = $sigMDP,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $geoJSON,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = '4326',
        [string[]] $autresParams = @('-lco WRITE_NAME=NO'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Parametrer-Job-Exporter-GeoJSON-Postgis `
        -racineAPI $racineAPI `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -mdp $mdp `
        -requete $requete `
        -geoJSON $geoJSON `
        -sridSource $sridSource `
        -sridCible $sridCible `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'export d'un SHP (par appel à Ogr2Ogr).
# Les valeurs pré-établies des paramètres font que le SIg par défaut est
# utilisé comme source.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# $requete : La requête SQL source de l'export.
# $shp : Le SHP d'export.
# $compresser : Pour demander la génération d'un zip contenant le SHP et ses
#               dépendances.
# $sridSource : Le SRID source.
# $sridCible : Le SRID cible.
# $autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function Parametrer-Job-SIg-Exporter-SHP {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string] $mdp = $sigMDP,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $shp,
        [bool] $compresser = $false,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = $sridDefaut,
        [string[]] $autresParams = @('-lco ENCODING=UTF-8'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Parametrer-Job-Exporter-SHP-Postgis `
        -racineAPI $racineAPI `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -mdp $mdp `
        -requete $requete `
        -shp $shp `
        -compresser $compresser `
        -sridSource $sridSource `
        -sridCible $sridCible `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'export d'un GPX (par appel à Ogr2Ogr).
# Les valeurs pré-établies des paramètres font que le SIg par défaut est
# utilisé comme source.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# $requete : La requête SQL source de l'export.
# $gpx : Le GPX d'export.
# $sridSource : Le SRID source.
# $autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function Parametrer-Job-SIg-Exporter-GPX {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string] $mdp = $sigMDP,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $gpx,
        [string] $sridSource = $sridDefaut,
        [string[]] $autresParams = @('-nlt MULTILINESTRING', '-dsco GPX_USE_EXTENSIONS=YES'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Parametrer-Job-Exporter-GPX-Postgis `
        -racineAPI $racineAPI `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -mdp $mdp `
        -requete $requete `
        -gpx $gpx `
        -sridSource $sridSource `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'export d'un DXF (par appel à Ogr2Ogr).
# Les valeurs pré-établies des paramètres font que le SIg par défaut est
# utilisé comme source.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# $requete : La requête SQL source de l'export.
# $dxf : Le DXF d'export.
# $sridSource : Le SRID source.
# $sridCible : Le SRID cible.
# $autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function Parametrer-Job-SIg-Exporter-DXF {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [string] $serveur = $sigServeur,
        [string] $port = $sigPort,
        [string] $bdd = $sigBDD,
        [string] $utilisateur = $sigUtilisateur,
        [string] $mdp = $sigMDP,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $dxf,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = $sridDefaut,
        [string[]] $autresParams = $null,
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Parametrer-Job-Exporter-DXF-Postgis `
        -racineAPI $racineAPI `
        -serveur $serveur `
        -port $port `
        -bdd $bdd `
        -utilisateur $utilisateur `
        -mdp $mdp `
        -requete $requete `
        -dxf $dxf `
        -sridSource $sridSource `
        -sridCible $sridCible `
        -autresParams $autresParams `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}