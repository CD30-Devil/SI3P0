. ("$PSScriptRoot\constantes.ps1")
. ("$PSScriptRoot\fonctions_outils.ps1")

# -----------------------------------------------------------------------------
# Exécution de Ogr2Ogr.
#
# $source : La source.
# $formatDestination : Le format destination.
# $destination : La destination.
# $autresParams : Les paramètres d'appel supplémentaires à Ogr2Ogr.
# $sortie : Chemin de redirection de la sortie standard, $null pour ne pas
#           activer la redirection.
# $erreur : Pour demander, lorsque la redirection de la sortie standard est
#           activée, la redirection de la sortie erreur. Le fichier de sortie
#           porte le même nom que celui de la sortie standard avec ajout de
#           l'extension .err.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function Executer-Ogr2Ogr {
    param (
        [parameter(Mandatory=$true)] [string] $source,
        [parameter(Mandatory=$true)] [string] $formatDestination,
        [parameter(Mandatory=$true)] [string] $destination,
        [string[]] $autresParams = $null,
        [string] $sortie = $null,
        [bool] $erreur = $true,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    $sourceSansMDP = $source -replace 'password=\w*', 'password=****'
    $destinationSansMDP = $destination -replace 'password=\w*', 'password=****'

    $parametres = [Collections.ArrayList]::new()
    [void]$parametres.Add("-f `"$formatDestination`"")
    [void]$parametres.Add("`"$destination`"")
    [void]$parametres.Add("`"$source`"")

    $parametresSansMDP = [Collections.ArrayList]::new()
    [void]$parametresSansMDP.Add("-f `"$formatDestination`"")
    [void]$parametresSansMDP.Add("`"$destinationSansMDP`"")
    [void]$parametresSansMDP.Add("`"$sourceSansMDP`"")

    if ($autresParams) {
        [void]$parametres.AddRange($autresParams)
        [void]$parametresSansMDP.AddRange($autresParams)
    }

    Afficher-Message-Date -message "Ogr2Ogr de $sourceSansMDP vers $destinationSansMDP."
    Afficher-Message-Date -message "`"$ogr2ogr`" $parametresSansMDP" -couleur gray

    if ($sortie) {
        New-Item -ItemType Directory -Force -Path (Split-Path -Path $sortie)

        if ($erreur) {
            $process = Start-Process -FilePath "`"$ogr2ogr`"" -WindowStyle Hidden -ArgumentList $parametres -PassThru -RedirectStandardOutput $sortie -RedirectStandardError "$sortie.err"
        }
        else {
            $process = Start-Process -FilePath "`"$ogr2ogr`"" -WindowStyle Hidden -ArgumentList $parametres -PassThru -RedirectStandardOutput $sortie
        }
    }
    else {
        $process = Start-Process -FilePath "`"$ogr2ogr`"" -WindowStyle Hidden -ArgumentList $parametres -PassThru
    }

    $process.PriorityClass = $priorite
    $process.WaitForExit()
}

# -----------------------------------------------------------------------------
# Exécution de Shp2Pgsql.
#
# /!\ L'appel à shp2pgsql ne fonctionne pas lorsqu'il est fait dans un
#     sous-processus.
#
# $shp : Le SHP source.
# $table : La table destination.
# $fichierSQL : Le fichier SQL de sortie.
# $autresParams : Les paramètres d'appel supplémentaires à Shp2Pgsql.
# $supprimerVarcharLimit : Pour demander la suppression de la taille limite des
#                          varchar dans le SQL généré.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function Executer-Shp2Pgsql {
    param (
        [parameter(Mandatory=$true)] [string] $shp,
        [parameter(Mandatory=$true)] [string] $table,
        [parameter(Mandatory=$true)] [string] $fichierSQL,
        [string[]] $autresParams = $null,
        [bool] $supprimerVarcharLimit = $false,
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    $parametres = [Collections.ArrayList]::new()

    if ($autresParams) {
        [void]$parametres.AddRange($autresParams)
    }

    [void]$parametres.Add("`"$shp`"")
    [void]$parametres.Add($table)

    New-Item -ItemType Directory -Force -Path (Split-Path -Path $fichierSQL)

    Afficher-Message-Date -message "Shp2Pgsql de $shp vers $fichierSQL."
    Afficher-Message-Date -message "`"$shp2pgsql`" $parametres" -couleur gray

    $process = Start-Process -FilePath "`"$shp2pgsql`"" -WindowStyle Hidden -RedirectStandardOutput $fichierSQL -ArgumentList $parametres -PassThru
    $process.PriorityClass = $priorite
    $process.WaitForExit()

    if ($supprimerVarcharLimit) {
        $contenu = Get-Content -Path "$fichierSQL" | Out-String
        $contenu -replace 'varchar\([0-9]+\)', 'varchar' | Out-File -FilePath "$fichierSQL" -Encoding utf8
    }
}

# -----------------------------------------------------------------------------
# Exécution de Raster2Pgsql.
#
# $raster : Le raster source.
# $table : La table destination.
# $fichierSQL : Le fichier SQL de sortie.
# $autresParams : Les paramètres d'appel supplémentaires à Raster2Pgsql.
# $priorite : La priorité donnée au processus.
# -----------------------------------------------------------------------------
function Executer-Raster2Pgsql {
    param (
        [parameter(Mandatory=$true)] [string] $raster,
        [parameter(Mandatory=$true)] [string] $table,
        [parameter(Mandatory=$true)] [string] $fichierSQL,
        [string[]] $autresParams = @('-C', "-s $sridDefaut", '-t 200x200', '-l 2,4,8', '-F', '-I'),
        [System.Diagnostics.ProcessPriorityClass] $priorite = [System.Diagnostics.ProcessPriorityClass]::Normal
    )

    $parametres = [Collections.ArrayList]::new()

    if ($autresParams) {
        [void]$parametres.AddRange($autresParams)
    }

    [void]$parametres.Add("`"$raster`"")
    [void]$parametres.Add($table)

    New-Item -ItemType Directory -Force -Path (Split-Path -Path $fichierSQL)

    Afficher-Message-Date -message "Raster2Pgsql de $raster vers $fichierSQL."
    Afficher-Message-Date -message "`"$raster2pgsql`" $parametres" -couleur gray

    $process = Start-Process -FilePath "`"$raster2pgsql`"" -WindowStyle Hidden -RedirectStandardOutput $fichierSQL -ArgumentList $parametres -PassThru
    $process.PriorityClass = $priorite
    $process.WaitForExit()
}