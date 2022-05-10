# -----------------------------------------------------------------------------
# Job d'export d'un CSV.
# Ce job utilise OleDB pour traiter le fichier Excel.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .fournisseur : Le fournisseur OleDB pour la connexion au fichier Excel.
# .excel : Le chemin du fichier Excel source.
# .proprietesEtendues : Les propriétés étendues de connexion.
# .requete : La requête SQL source de l'export.
# .csv : Le CSV d'export.
# .delimiteur : Le delimiteur utilisé dans le fichier CSV.
# -----------------------------------------------------------------------------
$Job_Exporter_CSV_Excel = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\fonctions_excel.ps1")

    Exporter-CSV-Excel `
        -fournisseur $parametres.fournisseur `
        -excel $parametres.excel `
        -proprietesEtendues $parametres.proprietesEtendues `
        -requete $parametres.requete `
        -csv $parametres.csv `
        -delimiteur $parametres.delimiteur
}

# -----------------------------------------------------------------------------
# Paramétrage d'un job d'export d'un CSV.
#
# $racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# $fournisseur : Le fournisseur OleDB pour la connexion au fichier Excel.
# $excel : Le chemin du fichier Excel source.
# $proprietesEtendues : Les propriétés étendues de connexion.
# $requete : La requête SQL source de l'export.
# $csv : Le CSV d'export.
# $delimiteur : Le delimiteur utilisé dans le fichier CSV.
# -----------------------------------------------------------------------------
function Parametrer-Job-Exporter-CSV-Excel {
    param (
        [string] $racineAPI = $PSScriptRoot,
        [string] $fournisseur = 'Microsoft.ACE.OLEDB.12.0',
        [parameter(Mandatory=$true)] [string] $excel,
        [string] $proprietesEtendues = '',
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $csv,
        [string] $delimiteur = (Get-Culture).TextInfo.ListSeparator
    )

    @{
        script = $Job_Exporter_CSV_Excel
        racineAPI = $racineAPI
        fournisseur = $fournisseur
        excel = $excel
        proprietesEtendues = $proprietesEtendues
        requete = $requete
        csv = $csv
        delimiteur = $delimiteur
    }
}