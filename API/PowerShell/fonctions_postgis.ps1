. ("$PSScriptRoot\constantes.ps1")
. ("$PSScriptRoot\fonctions_outils.ps1")
. ("$PSScriptRoot\fonctions_archives.ps1")
. ("$PSScriptRoot\fonctions_géodonnées.ps1")
. ("$PSScriptRoot\fonctions_postgresql.ps1")

# -----------------------------------------------------------------------------
# Import d'un GeoJSON (par appel à Ogr2Ogr).
#
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
function Importer-GeoJSON-Postgis {
    param (
        [parameter(Mandatory=$true)] [string] $geoJSON,
        [parameter(Mandatory=$true)] [string] $serveur,
        [string] $port = '5432',
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [string] $mdp = $null,
        [parameter(Mandatory=$true)] [string] $table,
        [string] $sridSource = '4326',
        [string] $sridCible = $sridDefaut,
        [bool] $multiGeom = $true,
        [string[]] $autresParams = @('-lco SPATIAL_INDEX=GIST', '-lco GEOMETRY_NAME=geom'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Afficher-Message-Date -message "Import de $geoJSON vers $serveur\$bdd."

    if (!$mdp) {
        $mdp = Rechercher-MDP-PGPass -serveur $serveur -port $port -bdd $bdd -utilisateur $utilisateur
    }
    
    $parametres = [Collections.ArrayList]::new()
    [void]$parametres.Add("-nln $table")
    [void]$parametres.Add("-s_srs EPSG:$sridSource")
    [void]$parametres.Add("-t_srs EPSG:$sridCible")
    
    if ($multiGeom) {
        [void]$parametres.Add('-nlt PROMOTE_TO_MULTI')
    }

    if ($autresParams) {
        [void]$parametres.AddRange($autresParams)
    }

    Executer-Ogr2Ogr `
        -source $geoJSON `
        -formatDestination 'PostgreSQL' `
        -destination "PG:host=$serveur port=$port dbname=$bdd user=$utilisateur password=$mdp" `
        -autresParams $parametres `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Import d'un SHP (par appel à Ogr2Ogr).
#
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
function Importer-SHP-Postgis {
    param (
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

    Afficher-Message-Date -message "Import de $shp vers $serveur\$bdd."

    if (!$mdp) {
        $mdp = Rechercher-MDP-PGPass -serveur $serveur -port $port -bdd $bdd -utilisateur $utilisateur
    }
    
    $parametres = [Collections.ArrayList]::new()
    [void]$parametres.Add("-nln $table")
    [void]$parametres.Add("-s_srs EPSG:$sridSource")
    [void]$parametres.Add("-t_srs EPSG:$sridCible")
    
    if ($multiGeom) {
        [void]$parametres.Add('-nlt PROMOTE_TO_MULTI')
    }

    if ($autresParams) {
        [void]$parametres.AddRange($autresParams)
    }

    Executer-Ogr2Ogr `
        -source $shp `
        -formatDestination 'PostgreSQL' `
        -destination "PG:host=$serveur port=$port dbname=$bdd user=$utilisateur password=$mdp" `
        -autresParams $parametres `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Import d'une couche d'un GPKG (par appel à Ogr2Ogr).
#
# $gpkg : Le GPKG contenant la couche à importer.
# $couche : La couche à importer.
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
function Importer-GPKG-Postgis {
    param (
        [parameter(Mandatory=$true)] [string] $gpkg,
        [parameter(Mandatory=$true)] [string] $couche,
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

    Afficher-Message-Date -message "Import de $gpkg[$couche] vers $serveur\$bdd."

    if (!$mdp) {
        $mdp = Rechercher-MDP-PGPass -serveur $serveur -port $port -bdd $bdd -utilisateur $utilisateur
    }
    
    $parametres = [Collections.ArrayList]::new()

    [void]$parametres.Add("-sql `"select * from $couche`"")

    [void]$parametres.Add("-nln $table")
    [void]$parametres.Add("-s_srs EPSG:$sridSource")
    [void]$parametres.Add("-t_srs EPSG:$sridCible")
    
    if ($multiGeom) {
        [void]$parametres.Add('-nlt PROMOTE_TO_MULTI')
    }

    if ($autresParams) {
        [void]$parametres.AddRange($autresParams)
    }

    Executer-Ogr2Ogr `
        -source $gpkg `
        -formatDestination 'PostgreSQL' `
        -destination "PG:host=$serveur port=$port dbname=$bdd user=$utilisateur password=$mdp" `
        -autresParams $parametres `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Import d'un MIF/MID (par appel à Ogr2Ogr).
#
# $midmid : Le MIF/MID à importer.
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
function Importer-MIFMID-Postgis {
    param (
        [parameter(Mandatory=$true)] [string] $mifmid,
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

    Afficher-Message-Date -message "Import de $mifmid vers $serveur\$bdd."

    if (!$mdp) {
        $mdp = Rechercher-MDP-PGPass -serveur $serveur -port $port -bdd $bdd -utilisateur $utilisateur
    }
    
    $parametres = [Collections.ArrayList]::new()
    [void]$parametres.Add("-nln $table")
    [void]$parametres.Add("-s_srs EPSG:$sridSource")
    [void]$parametres.Add("-t_srs EPSG:$sridCible")
    
    if ($multiGeom) {
        [void]$parametres.Add('-nlt PROMOTE_TO_MULTI')
    }

    if ($autresParams) {
        [void]$parametres.AddRange($autresParams)
    }

    Executer-Ogr2Ogr `
        -source $mifmid `
        -formatDestination 'PostgreSQL' `
        -destination "PG:host=$serveur port=$port dbname=$bdd user=$utilisateur password=$mdp" `
        -autresParams $parametres `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Export d'un GeoJSON (par appel à Ogr2Ogr).
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
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function Exporter-GeoJSON-Postgis {
    param (
        [parameter(Mandatory=$true)] [string] $serveur,
        [string] $port = '5432',
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [string] $mdp = $null,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $geoJSON,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = '4326',
        [string[]] $autresParams = @('-lco WRITE_NAME=NO'),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Afficher-Message-Date -message "Export de $requete depuis $serveur\$bdd vers $geoJSON."

    if (!$mdp) {
        $mdp = Rechercher-MDP-PGPass -serveur $serveur -port $port -bdd $bdd -utilisateur $utilisateur
    }
    
    $parametres = [Collections.ArrayList]::new()
    [void]$parametres.Add("-s_srs EPSG:$sridSource")
    [void]$parametres.Add("-t_srs EPSG:$sridCible")
    [void]$parametres.Add("-sql `"$requete`"")

    if ($autresParams) {
        [void]$parametres.AddRange($autresParams)
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Path $geoJSON)
    if (Test-Path $geoJSON) {
        Remove-Item $geoJSON
    }

    Executer-Ogr2Ogr `
        -source "PG:host=$serveur port=$port dbname=$bdd user=$utilisateur password=$mdp" `
        -formatDestination 'GeoJSON' `
        -destination $geoJSON `
        -autresParams $parametres `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Export d'un SHP (par appel à Ogr2Ogr).
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
function Exporter-SHP-Postgis {
    param (
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

    Afficher-Message-Date -message "Export de $requete depuis $serveur\$bdd vers $shp."

    if (!$mdp) {
        $mdp = Rechercher-MDP-PGPass -serveur $serveur -port $port -bdd $bdd -utilisateur $utilisateur
    }
    
    $parametres = [Collections.ArrayList]::new()
    [void]$parametres.Add("-s_srs EPSG:$sridSource")
    [void]$parametres.Add("-t_srs EPSG:$sridCible")
    [void]$parametres.Add("-sql `"$requete`"")

    if ($autresParams) {
        [void]$parametres.AddRange($autresParams)
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Path $shp)

    if ($compresser) {

        $nomShp = [System.IO.Path]::GetFileNameWithoutExtension($shp)
        $dossierTemp = "$dossierTravailTemp\Exporter-SHP-Postgis\$(New-Guid)"
        $shpTemp = "$dossierTemp\$nomShp.shp"
        $shpZip = "$([System.IO.Path]::GetDirectoryName($shp))\$nomShp.zip"

        New-Item -ItemType Directory -Force -Path $dossierTemp

        Executer-Ogr2Ogr `
            -source "PG:host=$serveur port=$port dbname=$bdd user=$utilisateur password=$mdp" `
            -formatDestination 'ESRI Shapefile' `
            -destination $shpTemp `
            -autresParams $parametres `
            -sortie $sortie `
            -erreur $erreur `
            -priorite $priorite
        
        if (Test-Path $shpZip) { Remove-Item -LiteralPath $shpZip }
        Zipper -dossier $dossierTemp -archiverDans $shpZip

        Remove-Item $dossierTemp -Recurse
    }
    else {
        Executer-Ogr2Ogr `
            -source "PG:host=$serveur port=$port dbname=$bdd user=$utilisateur password=$mdp" `
            -formatDestination 'ESRI Shapefile' `
            -destination $shp `
            -autresParams $parametres `
            -sortie $sortie `
            -erreur $erreur `
            -priorite $priorite
    }
}

# -----------------------------------------------------------------------------
# Export d'un GPKG (par appel à Ogr2Ogr).
#
# $serveur : Le serveur de base de données.
# $port : Le port du serveur de base de données.
# $bdd : Le nom de la base de données.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# $mdp : Le mot de passe pour la connexion à la base de données, $null pour
#        lire le mot de passe depuis le pgpass.conf.
# $requetes : Les requêtes SQL sources de l'export.
# $gpkg : Le GPKG d'export.
# $couches : Le nom de chaque couche dans le GPKG cible à classer dans l'ordre
#            respectif des requêtes SQL.
# $ecraserGPKG : Pour indiquer s'il faut mettre à jour ou écraser le GPKG.
# $ecraserCouche : Pour indiquer s'il faut compléter ou écraser les couches.
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
function Exporter-GPKG-Postgis {
    param (
        [parameter(Mandatory=$true)] [string] $serveur,
        [string] $port = '5432',
        [parameter(Mandatory=$true)] [string] $bdd,
        [parameter(Mandatory=$true)] [string] $utilisateur,
        [string] $mdp = $null,
        [parameter(Mandatory=$true)] [string[]] $requetes,
        [parameter(Mandatory=$true)] [string] $gpkg,
        [parameter(Mandatory=$true)] [string[]] $couches,
        [bool] $ecraserGPKG = $true,
        [bool] $ecraserCouche = $true,
        [string] $sridSource = $sridDefaut,
        [string] $sridCible = $sridDefaut,
        [string[]] $autresParams = @(),
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    Afficher-Message-Date -message "Export de $requete depuis $serveur\$bdd vers $gpkg."

    if (!$mdp) {
        $mdp = Rechercher-MDP-PGPass -serveur $serveur -port $port -bdd $bdd -utilisateur $utilisateur
    }
    
    New-Item -ItemType Directory -Force -Path (Split-Path -Path $gpkg)

    if ($ecraserGPKG -and (Test-Path $gpkg)) {
        Remove-Item $gpkg
    }

    for ($n = 0; $n -lt $requetes.Count; $n++) {

        $parametres = [Collections.ArrayList]::new()
        [void]$parametres.Add("-s_srs EPSG:$sridSource")
        [void]$parametres.Add("-t_srs EPSG:$sridCible")
        [void]$parametres.Add("-sql `"$($requetes[$n])`"")
        [void]$parametres.Add("-nln $($couches[$n])")

        if (Test-Path $gpkg) {
            [void]$parametres.Add("-update")
        }

        if ($ecraserCouche) {
            [void]$parametres.Add("-overwrite")
        }

        if ($autresParams) {
            [void]$parametres.AddRange($autresParams)
        }

        if ($sortie) {
            $sortie_couche = "$([IO.Path]::GetDirectoryName($sortie))\$([IO.Path]::GetFileNameWithoutExtension($sortie)) - $($couches[$n])$([IO.Path]::GetExtension($sortie))"
        }
        else {
            $sortie_couche = $null
        }

        Executer-Ogr2Ogr `
            -source "PG:host=$serveur port=$port dbname=$bdd user=$utilisateur password=$mdp" `
            -formatDestination 'GPKG' `
            -destination $gpkg `
            -autresParams $parametres `
            -sortie $sortie_couche `
            -erreur $erreur `
            -priorite $priorite
    }
}

# -----------------------------------------------------------------------------
# Export d'un GPX (par appel à Ogr2Ogr).
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
function Exporter-GPX-Postgis {
    param (
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

    Afficher-Message-Date -message "Export de $requete depuis $serveur\$bdd vers $gpx."

    if (!$mdp) {
        $mdp = Rechercher-MDP-PGPass -serveur $serveur -port $port -bdd $bdd -utilisateur $utilisateur
    }
    
    $parametres = [Collections.ArrayList]::new()
    [void]$parametres.Add("-s_srs EPSG:$sridSource")
    [void]$parametres.Add('-t_srs EPSG:4326')
    [void]$parametres.Add("-sql `"$requete`"")

    if ($autresParams) {
        [void]$parametres.AddRange($autresParams)
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Path $gpx)
    if (Test-Path $gpx) {
        Remove-Item $gpx
    }

    Executer-Ogr2Ogr `
        -source "PG:host=$serveur port=$port dbname=$bdd user=$utilisateur password=$mdp" `
        -formatDestination 'GPX' `
        -destination $gpx `
        -autresParams $parametres `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}

# -----------------------------------------------------------------------------
# Export d'un DXF (par appel à Ogr2Ogr).
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
function Exporter-DXF-Postgis {
    param (
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

    Afficher-Message-Date -message "Export de $requete depuis $serveur\$bdd vers $dxf."

    if (!$mdp) {
        $mdp = Rechercher-MDP-PGPass -serveur $serveur -port $port -bdd $bdd -utilisateur $utilisateur
    }
    
    $parametres = [Collections.ArrayList]::new()
    [void]$parametres.Add("-s_srs EPSG:$sridSource")
    [void]$parametres.Add("-t_srs EPSG:$sridCible")
    [void]$parametres.Add("-sql `"$requete`"")

    if ($autresParams) {
        [void]$parametres.AddRange($autresParams)
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Path $dxf)

    Executer-Ogr2Ogr `
        -source "PG:host=$serveur port=$port dbname=$bdd user=$utilisateur password=$mdp" `
        -formatDestination 'DXF' `
        -destination $dxf `
        -autresParams $parametres `
        -sortie $sortie `
        -erreur $erreur `
        -priorite $priorite
}