# -----------------------------------------------------------------------------
# Constantes
# -----------------------------------------------------------------------------

$email_generique = '<contact@ma-collectivité.fr>'
$email_contact = '<moi@ma-collectivité.fr>'

$racinePostgreSQL = '<C:\PostgreSQL\10>'
$racineOSGeo4W = '<C:\OSGeo4W64>'
$racineOracle = '<c:\Ora11g>'

# variables d'environnement
$Env:PGCLIENTENCODING = 'UTF8'
$Env:GDAL_DATA = "$racineOSGeo4W\share\gdal\"

# chemin vers un répertoire de travail temporaire
# pour le bon fonctionnement de certaines fonctions, il ne doit pas y avoir d'accent dans le chemin
$dossierTravailTemp = "$env:TEMP\si3p0"

# chemins vers les outils PostgreSQL
$psql = "$racinePostgreSQL\bin\psql.exe"
$pgdump = "$racinePostgreSQL\bin\pg_dump.exe"
$pgsql2shp = "$racinePostgreSQL\bin\pgsql2shp.exe"
$shp2pgsql = "$racinePostgreSQL\bin\shp2pgsql.exe"
$raster2pgsql = "$racinePostgreSQL\bin\raster2pgsql.exe"

# chemins vers les outils et librairies Oracle
$sqlplus = "$racineOracle\Product\bin\sqlplus.exe"
$OracleDataAccessLib = "$racineOracle\Product\odp.net\bin\4\Oracle.DataAccess.dll"

# chemin vers Ogr2Ogr
$ogr2ogr = "$racineOSGeo4W\bin\ogr2ogr.exe"

# chemin vers 7-Zip
$7z = "$env:ProgramFiles\7-Zip\7z.exe"

# chemin vers un navigateur basé sur Chromium (Google Chrome, Microsoft Edge, ...)
$chromium = "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
#$chromium = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"

# serveur e-mail sortant
$serveurSMTP = '<mon-serveur-smtp>'

# SRID par défaut
$sridDefaut = '2154'