# import de l'API SI3P0
. ("$PSScriptRoot\..\API\PowerShell\api_complète.ps1")

# le COG du département à traiter
$departement = '30'

# chemins de travail
$dossierDonnees = "$PSScriptRoot\Données"
$dossierRapports = "$PSScriptRoot\Rapports"

# -----------------------------------------------------------------------------
# nettoyage préalable
# -----------------------------------------------------------------------------

# effacement des rapports
Remove-Item "$dossierRapports\*.txt"
Remove-Item "$dossierRapports\*.err"

# effacement des données
Remove-Item "$dossierDonnees\*" -Recurse -Force

# effacement des tables
SIg-Effacer-Table `    -table 'BAN_CSV' `    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement BAN_CSV.txt"

SIg-Effacer-Table `    -table 'BAN_Geo' `    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement BAN_Geo.txt"

# -----------------------------------------------------------------------------
# Phase Extract amont
# -----------------------------------------------------------------------------

# téléchargement...
Telecharger `    -url "https://adresse.data.gouv.fr/data/ban/adresses/latest/csv/adresses-$departement.csv.gz" `    -enregistrerSous "$dossierDonnees\adresses-$departement.csv.gz"

#  ...et extraction de la BAN
DeGZipper `    -archive "$dossierDonnees\adresses-$departement.csv.gz" `    -extraireVers $dossierDonnees

# -----------------------------------------------------------------------------
# Phase Load
# -----------------------------------------------------------------------------

# création d'une table temporaire pour l'import du CSV
SIg-Creer-Table-Temp `    -table 'BAN_CSV' `    -colonnes `
        'id', `        'id_fantoir', `        'numero', `        'rep', `        'nom_voie', `        'code_postal', `        'code_insee', `        'nom_commune', `        'code_insee_ancienne_commune', `        'nom_ancienne_commune', `        'x', `        'y', `        'lon', `
        'lat', `        'alias', `
        'nom_ld', `        'libelle_acheminement', `        'nom_afnor', `        'source_position', `        'source_nom_voie' `
    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création BAN_CSV.txt"

# import du CSV
SIg-Importer-CSV `    -table 'BAN_CSV' `    -csv "$dossierDonnees\adresses-$departement.csv" `    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import adresses-$departement.csv.txt"

# -----------------------------------------------------------------------------
# Phase Transform
# -----------------------------------------------------------------------------

# transformation de la table "CSV" en table géographique
SIg-Executer-Commande -commande @'
create table BAN_Geo as
select
    id::varchar,
    id_fantoir::varchar,
    numero::integer,
    rep::varchar,
    nom_voie::varchar,
    code_postal::varchar,
    code_insee::varchar,
    nom_commune::varchar,
    code_insee_ancienne_commune::varchar,
    nom_ancienne_commune::varchar,
    libelle_acheminement::varchar,
    nom_afnor::varchar,
    source_position::varchar,
    source_nom_voie::varchar,
    ST_SetSRID(ST_MakePoint(x::numeric, y::numeric), 2154) as geom
from BAN_CSV;
'@

# -----------------------------------------------------------------------------
# Phase Extract aval
# -----------------------------------------------------------------------------

# recherche de la liste des communes
# passage par un fichier intermédiaire (pas mieux pour l'instant via la bibliothèque)
SIg-Executer-Commande `    -commande 'select distinct code_insee from BAN_Geo' `    -sortie "$dossierRapports\cog_communes.txt" `
    -erreur $false `
    -autresParams '--tuples-only', '--no-align'
    

# paramétrage des jobs d'export (1 GeoJSON + 1 SHP par commune)
$parametresJobs = [System.Collections.ArrayList]::new()

foreach ($cog_commune in (Get-Content "$dossierRapports\cog_communes.txt")) {

    # job d'export GeoJSON
    [void]$parametresJobs.Add(
        (Parametrer-Job-SIg-Exporter-GeoJSON `            -requete "select * from BAN_Geo where code_insee = '$cog_commune'" `            -geoJSON "$dossierDonnees\GeoJSON\BAN_$cog_commune.geojson")
    )

    # job d'export SHP
    [void]$parametresJobs.Add(
        (Parametrer-Job-SIg-Exporter-SHP `            -requete "select * from BAN_Geo where code_insee = '$cog_commune'" `            -shp "$dossierDonnees\SHP\BAN_$cog_commune.shp" `            -compresser $true)
    )

}

# exécution des jobs
# s'il n'est pas spécifié, le nombre de jobs en // est égal au nombre de coeurs da la machine - 1
Executer-Jobs -parametresJobs $parametresJobs

# -----------------------------------------------------------------------------
# nettoyage final
# -----------------------------------------------------------------------------

# effacement de la table temporaire
SIg-Effacer-Table -table 'BAN_CSV' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement BAN_CSV.txt"