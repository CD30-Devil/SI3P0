. ("$PSScriptRoot\fonctions_outils.ps1")

# -----------------------------------------------------------------------------
# Export du résultat d'une requête SQL sur une base OleDb vers un CSV.
#
# $chaineConnexion : La chaîne de connexion OleDb.
# $requete : La requête SQL source de l'export.
# $csv : Le CSV d'export.
# $delimiteur : Le delimiteur utilisé dans le fichier CSV.
# -----------------------------------------------------------------------------
function Exporter-CSV-OleDb {
    param (
        [parameter(Mandatory=$true)] [string] $chaineConnexion,
        [parameter(Mandatory=$true)] [string] $requete,
        [parameter(Mandatory=$true)] [string] $csv,
        [string] $delimiteur = (Get-Culture).TextInfo.ListSeparator
    )

    Afficher-Message-Date -message "Exécution de $requete sur une base OleDb."

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

    $resultat = $null
    $commande = $null
    $connexion = $null

    [GC]::Collect()
}