. ("$PSScriptRoot\constantes.ps1")
. ("$PSScriptRoot\fonctions_outils.ps1")

Add-Type -AssemblyName System.IO.Compression.FileSystem

# -----------------------------------------------------------------------------
# Compression d'un dossier en archive Zip.
#
# $dossier : Le dossier à compresser.
# $archiverDans : L'emplacement de compression.
# -----------------------------------------------------------------------------
function Zipper {
    param(
        [parameter(Mandatory=$true)] [string] $dossier,
        [parameter(Mandatory=$true)] [string] $archiverDans
    )
    
    Afficher-Message-Date -message "Compression de $dossier dans $archiverDans."
    [System.IO.Compression.ZipFile]::CreateFromDirectory($dossier, $archiverDans)
}

# -----------------------------------------------------------------------------
# Décompression d'une archive Zip.
#
# $archive : L'archive à décompresser.
# $extraireVers : L'emplacement de décompression.
# -----------------------------------------------------------------------------
function DeZipper {
    param(
        [parameter(Mandatory=$true)] [string] $archive,
        [parameter(Mandatory=$true)] [string] $extraireVers
    )
    
    Afficher-Message-Date -message "Décompression de $archive vers $extraireVers."
    [System.IO.Compression.ZipFile]::ExtractToDirectory($archive, $extraireVers)
}

# -----------------------------------------------------------------------------
# Compression d'un fichier en archive GZip.
#
# $fichier : Le fichier à compresser.
# $archiverDans : L'emplacement de compression.
# -----------------------------------------------------------------------------
function GZipper {
    param(
        [parameter(Mandatory=$true)] [string] $fichier,
        [parameter(Mandatory=$true)] [string] $archiverDans
    )
    
    Afficher-Message-Date -message "Compression de $fichier dans $archiverDans."

    $cheminSortie = "$archiverDans\$([System.IO.Path]::GetFileName($fichier)).gz"
    
    $fluxEntree = [System.IO.FileStream]::new($fichier, ([System.IO.FileMode]::Open), ([System.IO.FileAccess]::Read))
    $fluxSortie = [System.IO.File]::Create($cheminSortie)
    $fluxGZSortie = [System.IO.Compression.GZipStream]::new($fluxSortie, ([System.IO.Compression.CompressionMode]::Compress))
    
    $fluxEntree.CopyTo($fluxGZSortie);

    $fluxGZSortie.Close()
    $fluxSortie.Close()
    $fluxEntree.Close()

    $fluxGZSortie = $null
    $fluxSortie = $null
    $fluxEntree = $null
}

# -----------------------------------------------------------------------------
# Décompression d'une archive GZip.
#
# $archive : L'archive à décompresser.
# $extraireVers : L'emplacement de décompression.
# -----------------------------------------------------------------------------
function DeGZipper {
    param(
        [parameter(Mandatory=$true)] [string] $archive,
        [parameter(Mandatory=$true)] [string] $extraireVers
    )

    Afficher-Message-Date -message "Décompression de $archive vers $extraireVers."

    $cheminSortie = "$extraireVers\$([System.IO.Path]::GetFileNameWithoutExtension($archive))"
    
    if ('.tgz' -eq ([System.IO.Path]::GetExtension($archive))) {
        $cheminSortie = "$cheminSortie.tar"
    }

    $fluxEntree = [System.IO.FileStream]::new($archive, ([System.IO.FileMode]::Open), ([System.IO.FileAccess]::Read))
    $fluxGZEntree = [System.IO.Compression.GZipStream]::new($fluxEntree, ([System.IO.Compression.CompressionMode]::Decompress))
    $fluxSortie = [System.IO.File]::Create($cheminSortie)

    $fluxGZEntree.CopyTo($fluxSortie);

    $fluxSortie.Close()
    $fluxGZEntree.Close()
    $fluxEntree.Close()

    $fluxSortie = $null
    $fluxGZEntree = $null
    $fluxEntree = $null
}

# -----------------------------------------------------------------------------
# Exécution de 7-Zip.
#
# $commande : La commande, cf. documentation 7-Zip.
# $archive : L'archive source ou cible.
# $autresParams : Les paramètres d'appel supplémentaires à 7-Zip.
# -----------------------------------------------------------------------------
Function Executer-7Z {
    param(
        [parameter(Mandatory=$true)] [string] $commande,
        [parameter(Mandatory=$true)] [string] $archive,
        [string[]] $autresParams = $null
    )

    $parametres = New-Object System.Collections.ArrayList
    [void]$parametres.Add($commande)
    [void]$parametres.Add("`"$archive`"")

    if ($autresParams) {
        [void]$parametres.AddRange($autresParams)
    }

    Afficher-Message-Date -message "`"$7z`" $parametres" -couleur gray
    Start-Process -FilePath "`"$7z`"" -WindowStyle Hidden -Wait -ArgumentList $parametres
}

# -----------------------------------------------------------------------------
# Compression d'un dossier en utilisant 7z.
#
# $dossier : Le dossier à compresser.
# $archiverDans : L'emplacement de compression.
# -----------------------------------------------------------------------------
function 7Z-Compresser-Dossier {
    param(
        [parameter(Mandatory=$true)] [string] $dossier,
        [parameter(Mandatory=$true)] [string] $archiverDans
    )
    
    Afficher-Message-Date -message "Compression de $dossier dans $archiverDans avec 7z."
    Executer-7Z -commande 'a' -archive $archiverDans -autresParams "`"$dossier\*`""
}

# -----------------------------------------------------------------------------
# Compression d'un fichier en utilisant 7z.
#
# $fichier : Le fichier à compresser.
# $archiverDans : L'emplacement de compression.
# -----------------------------------------------------------------------------
function 7Z-Compresser-Fichier {
    param(
        [parameter(Mandatory=$true)] [string] $fichier,
        [parameter(Mandatory=$true)] [string] $archiverDans
    )
    
    Afficher-Message-Date -message "Compression de $fichier dans $archiverDans avec 7z."
    Executer-7Z -commande 'a' -archive $archiverDans -autresParams "`"$fichier`""
}

# -----------------------------------------------------------------------------
# Décompression d'une archive en utilisant 7z.
#
# $archive : L'archive à décompresser.
# $extraireVers : L'emplacement de décompression.
# -----------------------------------------------------------------------------
function 7Z-Decompresser {
    param(
        [parameter(Mandatory=$true)] [string] $archive,
        [parameter(Mandatory=$true)] [string] $extraireVers
    )
    
    Afficher-Message-Date -message "Décompression de $archive vers $extraireVers avec 7z."
    Executer-7Z -commande 'x' -archive $archive -autresParams "-o`"$extraireVers`""
}

# -----------------------------------------------------------------------------
# Décompression sur place d'une archive en utilisant 7z.
#
# $archive : L'archive à extraire sur place.
# $supprimer : Pour demander la suppression de l'archive après décompression.
# -----------------------------------------------------------------------------
function 7Z-Decompresser-Ici {
    param(
        [parameter(Mandatory=$true)] [string] $archive,
        [bool] $supprimer = $false
    )
    
    7Z-Decompresser -archive $archive -extraireVers ([System.IO.Path]::GetDirectoryName($archive))

    if ($supprimer) {
        Remove-Item $archive
    }
}