# -----------------------------------------------------------------------------
# Job d'import d'un GeoJSON (par appel à Ogr2Ogr).
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .geoJSON : Le GeoJSON à importer.
# .serveur : Le serveur de base de données.
# .port : Le port du serveur de base de données.
# .bdd : Le nom de la base de données.
# .utilisateur : L'utilisateur pour la connexion à la base de données.
# .mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# .table : La table destination.
# .sridSource : Le SRID source.
# .sridCible : Le SRID cible.
# .multiGeom : Pour demander la création d'une géométrie multi*.
# .autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# .sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# .erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# .priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
$Job_Importer_GeoJSON_Postgis = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\fonctions_postgis.ps1")

    Importer-GeoJSON-Postgis `
        -geoJSON $parametres.geoJSON `
        -serveur $parametres.serveur `
        -port $parametres.port `
        -bdd $parametres.bdd `
        -utilisateur $parametres.utilisateur `
        -mdp $parametres.mdp `
        -table $parametres.table `
        -sridSource $parametres.sridSource `
        -sridCible $parametres.sridCible `
        -multiGeom $parametres.multiGeom `
        -autresParams $parametres.autresParams `
        -sortie $parametres.sortie `
        -erreur $parametres.erreur `
        -priorite $parametres.priorite
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'import d'un GeoJSON (par appel à Ogr2Ogr).
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
function Parametrer-Job-Importer-GeoJSON-Postgis {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $geoJSON,
        [parameter(Mandatory=$true)] [string] $serveur,
        [string] $port = '5432',
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [string] $mdp = $null,
        [parameter(Mandatory=$true)] [string] $table,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = $sridDefaut,
        [bool] $multiGeom = $true,
        [string[]] $autresParams = @('-lco SPATIAL_INDEX=GIST', '-lco GEOMETRY_NAME=geom'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    @{
        script = $Job_Importer_GeoJSON_Postgis
        racineAPI = $racineAPI
        geoJSON = $geoJSON
        serveur = $serveur
        port = $port
        bdd = $bdd
        utilisateur = $utilisateur
        mdp = $mdp
        table = $table
        sridSource = $sridSource
        sridCible = $sridCible
        multiGeom = $multiGeom
        autresParams = $autresParams
        sortie = $sortie
        erreur = $erreur
        priorite = $priorite
    }
}

# -----------------------------------------------------------------------------
# Job d'import d'un SHP (par appel à Ogr2Ogr).
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .shp : Le SHP à importer.
# .serveur : Le serveur de base de données.
# .port : Le port du serveur de base de données.
# .bdd : Le nom de la base de données.
# .utilisateur : L'utilisateur pour la connexion à la base de données.
# .mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# .table : La table destination.
# .sridSource : Le SRID source.
# .sridCible : Le SRID cible.
# .multiGeom : Pour demander la création d'une géométrie multi*.
# .autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# .sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# .erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# .priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
$Job_Importer_SHP_Postgis = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\fonctions_postgis.ps1")

    Importer-SHP-Postgis `
        -shp $parametres.shp `
        -serveur $parametres.serveur `
        -port $parametres.port `
        -bdd $parametres.bdd `
        -utilisateur $parametres.utilisateur `
        -mdp $parametres.mdp `
        -table $parametres.table `
        -sridSource $parametres.sridSource `
        -sridCible $parametres.sridCible `
        -multiGeom $parametres.multiGeom `
        -autresParams $parametres.autresParams `
        -sortie $parametres.sortie `
        -erreur $parametres.erreur `
        -priorite $parametres.priorite
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'import d'un SHP (par appel à Ogr2Ogr).
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
function Parametrer-Job-Importer-SHP-Postgis {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $shp,
        [parameter(Mandatory=$true)] [string] $serveur,
        [string] $port = '5432',
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [string] $mdp = $null,
        [parameter(Mandatory=$true)] [string] $table,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = $sridDefaut,
        [bool] $multiGeom = $true,
        [string[]] $autresParams = @('-lco SPATIAL_INDEX=GIST', '-lco GEOMETRY_NAME=geom'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    @{
        script = $Job_Importer_SHP_Postgis
        racineAPI = $racineAPI
        shp = $shp
        serveur = $serveur
        port = $port
        bdd = $bdd
        utilisateur = $utilisateur
        mdp = $mdp
        table = $table
        sridSource = $sridSource
        sridCible = $sridCible
        multiGeom = $multiGeom
        autresParams = $autresParams
        sortie = $sortie
        erreur = $erreur
        priorite = $priorite
    }
}

# -----------------------------------------------------------------------------
# Job d'export d'un GeoJSON (par appel à Ogr2Ogr).
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .serveur : Le serveur de base de données.
# .port : Le port du serveur de base de données.
# .bdd : Le nom de la base de données.
# .utilisateur : L'utilisateur pour la connexion à la base de données.
# .mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# .requete : La requête SQL source de l'export.
# .geoJSON : Le GeoJSON d'export.
# .sridSource : Le SRID source.
# .sridCible : Le SRID cible.
# .autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# .sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# .erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# .priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
$Job_Exporter_GeoJSON_Postgis = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\fonctions_postgis.ps1")

    Exporter-GeoJSON-Postgis `
        -serveur $parametres.serveur `
        -port $parametres.port `
        -bdd $parametres.bdd `
        -utilisateur $parametres.utilisateur `
        -mdp $parametres.mdp `
        -requete $parametres.requete `
        -geoJSON $parametres.geoJSON `
        -sridSource $parametres.sridSource `
        -sridCible $parametres.sridCible `
        -autresParams $parametres.autresParams `
        -sortie $parametres.sortie `
        -erreur $parametres.erreur `
        -priorite $parametres.priorite
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'export d'un GeoJSON (par appel à Ogr2Ogr).
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
function Parametrer-Job-Exporter-GeoJSON-Postgis {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $serveur,
        [string] $port = '5432',
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [string] $mdp = $null,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $geoJSON,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = $sridDefaut,
        [string[]] $autresParams = @('-lco WRITE_NAME=NO'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    @{
        script = $Job_Exporter_GeoJSON_Postgis
        racineAPI = $racineAPI
        serveur = $serveur
        port = $port
        bdd = $bdd
        utilisateur = $utilisateur
        mdp = $mdp
        requete = $requete
        geoJSON = $geoJSON
        sridSource = $sridSource
        sridCible = $sridCible
        autresParams = $autresParams
        sortie = $sortie
        erreur = $erreur
        priorite = $priorite
    }
}

# -----------------------------------------------------------------------------
# Job d'export d'un SHP (par appel à Ogr2Ogr).
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .serveur : Le serveur de base de données.
# .port : Le port du serveur de base de données.
# .bdd : Le nom de la base de données.
# .utilisateur : L'utilisateur pour la connexion à la base de données.
# .mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# .requete : La requête SQL source de l'export.
# .shp : Le SHP d'export.
# .compresser : Pour demander la génération d'un zip contenant le SHP et ses
#               dépendances.
# .sridSource : Le SRID source.
# .sridCible : Le SRID cible.
# .autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# .sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# .erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# .priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
$Job_Exporter_SHP_Postgis = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\fonctions_postgis.ps1")

    Exporter-SHP-Postgis `
        -serveur $parametres.serveur `
        -port $parametres.port `
        -bdd $parametres.bdd `
        -utilisateur $parametres.utilisateur `
        -mdp $parametres.mdp `
        -requete $parametres.requete `
        -shp $parametres.shp `
        -compresser $parametres.compresser `
        -sridSource $parametres.sridSource `
        -sridCible $parametres.sridCible `
        -autresParams $parametres.autresParams `
        -sortie $parametres.sortie `
        -erreur $parametres.erreur `
        -priorite $parametres.priorite
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'export d'un SHP (par appel à Ogr2Ogr).
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
function Parametrer-Job-Exporter-SHP-Postgis {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $serveur,
        [string] $port = '5432',
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [string] $mdp = $null,
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

    @{
        script = $Job_Exporter_SHP_Postgis
        racineAPI = $racineAPI
        serveur = $serveur
        port = $port
        bdd = $bdd
        utilisateur = $utilisateur
        mdp = $mdp
        requete = $requete
        shp = $shp
        compresser = $compresser
        sridSource = $sridSource
        sridCible = $sridCible
        autresParams = $autresParams
        sortie = $sortie
        erreur = $erreur
        priorite = $priorite
    }
}

# -----------------------------------------------------------------------------
# Job d'export d'un GPX (par appel à Ogr2Ogr).
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .serveur : Le serveur de base de données.
# .port : Le port du serveur de base de données.
# .bdd : Le nom de la base de données.
# .utilisateur : L'utilisateur pour la connexion à la base de données.
# .mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# .requete : La requête SQL source de l'export.
# .gpx : Le GPX d'export.
# .sridSource : Le SRID source.
# .autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# .sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# .erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# .priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
$Job_Exporter_GPX_Postgis = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\fonctions_postgis.ps1")

    Exporter-GPX-Postgis `
        -serveur $parametres.serveur `
        -port $parametres.port `
        -bdd $parametres.bdd `
        -utilisateur $parametres.utilisateur `
        -mdp $parametres.mdp `
        -requete $parametres.requete `
        -gpx $parametres.gpx `
        -sridSource $parametres.sridSource `
        -autresParams $parametres.autresParams `
        -sortie $parametres.sortie `
        -erreur $parametres.erreur `
        -priorite $parametres.priorite
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'export d'un GPX (par appel à Ogr2Ogr).
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
function Parametrer-Job-Exporter-GPX-Postgis {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $serveur,
        [string] $port = '5432',
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [string] $mdp = $null,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $gpx,
        [string] $sridSource = $sridDefaut,
        [string[]] $autresParams = @('-nlt MULTILINESTRING', '-dsco GPX_USE_EXTENSIONS=YES'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    @{
        script = $Job_Exporter_GPX_Postgis
        racineAPI = $racineAPI
        serveur = $serveur
        port = $port
        bdd = $bdd
        utilisateur = $utilisateur
        mdp = $mdp
        requete = $requete
        gpx = $gpx
        sridSource = $sridSource
        autresParams = $autresParams
        sortie = $sortie
        erreur = $erreur
        priorite = $priorite
    }
}

# -----------------------------------------------------------------------------
# Job d'export d'un DXF (par appel à Ogr2Ogr).
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .serveur : Le serveur de base de données.
# .port : Le port du serveur de base de données.
# .bdd : Le nom de la base de données.
# .utilisateur : L'utilisateur pour la connexion à la base de données.
# .mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# .requete : La requête SQL source de l'export.
# .dxf : Le DXF d'export.
# .sridSource : Le SRID source.
# .sridCible : Le SRID cible.
# .autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# .sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# .erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# .priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
$Job_Exporter_DXF_Postgis = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\fonctions_postgis.ps1")

    Exporter-DXF-Postgis `
        -serveur $parametres.serveur `
        -port $parametres.port `
        -bdd $parametres.bdd `
        -utilisateur $parametres.utilisateur `
        -mdp $parametres.mdp `
        -requete $parametres.requete `
        -dxf $parametres.dxf `
        -sridSource $parametres.sridSource `
        -sridCible $parametres.sridCible `
        -autresParams $parametres.autresParams `
        -sortie $parametres.sortie `
        -erreur $parametres.erreur `
        -priorite $parametres.priorite
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'export d'un DXF (par appel à Ogr2Ogr).
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
function Parametrer-Job-Exporter-DXF-Postgis {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [parameter(Mandatory=$true)] [string] $serveur,
        [string] $port = '5432',
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [string] $mdp = $null,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $dxf,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = $sridDefaut,
        [string[]] $autresParams = $null,
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    @{
        script = $Job_Exporter_DXF_Postgis
        racineAPI = $racineAPI
        serveur = $serveur
        port = $port
        bdd = $bdd
        utilisateur = $utilisateur
        mdp = $mdp
        requete = $requete
        dxf = $dxf
        sridSource = $sridSource
        sridCible = $sridCible
        autresParams = $autresParams
        sortie = $sortie
        erreur = $erreur
        priorite = $priorite
    }
}