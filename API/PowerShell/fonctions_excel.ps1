. ("$PSScriptRoot\constantes.ps1")
. ("$PSScriptRoot\fonctions_outils.ps1")

# -----------------------------------------------------------------------------
# Export d'un CSV.
# Cette fonction utilise OleDB pour traiter le fichier Excel.
#
# $fournisseur : Le fournisseur OleDB pour la connexion au fichier Excel.
# $excel : Le chemin du fichier Excel source.
# $proprietesEtendues : Les propriétés étendues de connexion.
# $requete : La requête SQL source de l'export.
# $csv : Le CSV d'export.
# $delimiteur : Le delimiteur utilisé dans le fichier CSV.
# -----------------------------------------------------------------------------
function Exporter-CSV-Excel {
    param (
        [string] $fournisseur = 'Microsoft.ACE.OLEDB.12.0',
        [parameter(Mandatory=$true)] [string] $excel,
        [string] $proprietesEtendues = '',
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $csv,
        [string] $delimiteur = (Get-Culture).TextInfo.ListSeparator
    )

    Afficher-Message-Date -message "Export de $requete depuis $excel vers $csv."

    $extension = [IO.Path]::GetExtension($excel).ToLower()

    # copie locale du fichier pour éviter les problèmes de verrous et permettre le multi-processing
    New-Item -ItemType Directory -Force -Path "$dossierTravailTemp\Exporter-CSV-Excel\"
    $fichierTemp = "$dossierTravailTemp\Exporter-CSV-Excel\$(New-Guid)$extension"
    Copy-Item $excel $fichierTemp

    if ($proprietesEtendues.Equals('')) {
        
        if ($extension -eq '.xls') {
            $proprietesEtendues = 'Excel 8.0; HDR=Yes; IMEX=1; Mode=Read'
        }
        else {
            $proprietesEtendues = 'Excel 12.0 Xml; HDR=Yes; IMEX=1; Mode=Read'
        }
    }

    $chaineConnexion = "Provider=$fournisseur; Data Source=$fichierTemp; Extended Properties=`"$proprietesEtendues`";"
    
    try {
        $connexion = [Data.OleDb.OleDbConnection]::new($chaineConnexion)
        $commande = [Data.OleDb.OleDbCommand]::new($requete, $connexion)
        $adapteur = [Data.OleDb.OleDbDataAdapter]::new($commande)
        $resultat = [Data.DataTable]::new()
        
        $adapteur.Fill($resultat)
        
        if (Test-Path $csv) { Remove-Item -LiteralPath $csv }
        New-Item -ItemType Directory -Force -Path (Split-Path -Path $csv)
        $resultat | Export-Csv -Path $csv -Encoding UTF8 -Delimiter $delimiteur -NoTypeInformation
        
        $resultat.Dispose()
        $commande.Dispose()
        $connexion.Close()
        $connexion.Dispose()
        [GC]::Collect()
    }
    catch {
        Afficher-Message-Date -message "Erreur lors de l'export de $requete depuis $excel vers $csv." -couleur red
        Afficher-Message-Date -message $_ -couleur red
    }

    Remove-Item $fichierTemp
}

# -----------------------------------------------------------------------------
# Enregistrement d'une feuille Excel.
# Cette fonction utilise COM Interop pour traiter le fichier Excel.
#
# $excel : Le fichier Excel source.
# $sortie : Le chemin d'enregistrement.
# $feuille : Le nom de la feuille à enregistrer, $null pour enregistrer la
#            feuille active.
# $format : Le format d'enregistrement.
# -----------------------------------------------------------------------------
try {
    Add-Type -AssemblyName Microsoft.Office.Interop.Excel
}
catch {
    Afficher-Message-Date -message "Microsoft.Office.Interop.Excel indisponible, la fonction Enregistrer-Feuille-Excel ne pourra pas être appelée dans cette session." -couleur yellow
}
function Enregistrer-Feuille-Excel {
    param (
        [parameter(Mandatory=$true)] [string] $excel,
        [parameter(Mandatory=$true)] [string] $sortie,
        [string] $feuille = $null,
        [Microsoft.Office.Interop.Excel.xlFileFormat] $format = [Microsoft.Office.Interop.Excel.xlFileFormat]::xlCSV
    )
    
    $application = New-Object -Com Excel.Application
    $application.Visible = $false
    $application.DisplayAlerts = $false
    
    $classeur = $application.Workbooks.Open($excel, 0, $true)
    $feuilleASauvegarder = $null

    if ($feuille) {
        $feuilleASauvegarder = $classeur.Sheets.Item($feuille)
    }
    else {
        $feuilleASauvegarder = $classeur.ActiveSheet
    }

    Afficher-Message-Date -message "Enregistrement de la feuille $($feuilleASauvegarder.Name) de $excel vers $sortie."
    
    $feuilleASauvegarder.SaveAs(`
        $sortie, ` #Filename
        $format, ` #FileFormat
        $null, ` #Password
        $null, ` #WriteResPassword
        $false, ` #ReadOnlyRecommended
        $false, ` #CreateBackup
        $false, ` #AddToMru
        $null, ` #TextCodepage
        $null, ` #TextVisualLayout
        $true #Local
    )

    $feuilleASauvegarder = $null
    $classeur = $null
    $application.Quit()
    $application = $null
    [GC]::Collect()

    # pour laisser le temps à Excel de se fermer
    Start-Sleep -Milliseconds 1337
}