# -----------------------------------------------------------------------------
# Constantes
# -----------------------------------------------------------------------------

$email_contact = '<contact@ma-collectivité.fr>'

$RacinePostgreSQL = '<C:\PostgreSQL\10>'
$RacineOSGeo4 = '<C:\OSGeo4W64>'
$RacineOracle = '<c:\Ora11g>'

# variables d'environnement
$Env:PGCLIENTENCODING = 'UTF8'
$Env:GDAL_DATA = "$RacineOSGeo4\share\gdal\"

# chemin vers un répertoire de travail temporaire
# pour le bon fonctionnement de certaines fonctions, il ne doit pas y avoir d'accent dans le chemin
$dossierTravailTemp = "$env:TEMP\si3p0"

# chemins vers les outils PostgreSQL
$psql = "$RacinePostgreSQL\bin\psql.exe"
$pgdump = "$RacinePostgreSQL\bin\pg_dump.exe"
$pgsql2shp = "$RacinePostgreSQL\bin\pgsql2shp.exe"
$shp2pgsql = "$RacinePostgreSQL\bin\shp2pgsql.exe"
$raster2pgsql = "$RacinePostgreSQL\bin\raster2pgsql.exe"

# chemins vers les outils et librairies Oracle
$sqlplus = "$RacineOracle\Product\bin\sqlplus.exe"
$OracleDataAccessLib = "$RacineOracle\Product\odp.net\bin\4\Oracle.DataAccess.dll"

# chemin vers Ogr2Ogr
$ogr2ogr = "$RacineOSGeo4\bin\ogr2ogr.exe"

# chemin vers 7-Zip
$7z = "$env:ProgramFiles\7-Zip\7z.exe"

# serveur e-mail sortant
$serveurSMTP = '<mon-serveur-smtp>'

# SRID par défaut
$sridDefaut = '2154'