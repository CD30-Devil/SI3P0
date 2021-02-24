. ("$PSScriptRoot\TU.ps1")

. ("$PSScriptRoot\..\..\Powershell\constantes.ps1")

# Test de la présence de GDAL_DATA
Assert-CheminExiste -chemin $Env:GDAL_DATA

# Test de la présence de psql
Assert-CheminExiste -chemin $psql

# Test de la présence de pgdum
Assert-CheminExiste -chemin $pgdump

# Test de la présence de pgsql2shp
Assert-CheminExiste -chemin $pgsql2shp

# Test de la présence de shp2pgsql
Assert-CheminExiste -chemin $shp2pgsql

# Test de la présence de raster2pgsql
Assert-CheminExiste -chemin $raster2pgsql

# Test de la présence de ogr2gr
Assert-CheminExiste -chemin $ogr2ogr

# Test de la présence de sqlplus
Assert-CheminExiste -chemin $sqlplus

# Test de la présence de la librairie Oracle
Assert-CheminExiste -chemin $OracleDataAccessLib

# Test de la présence de sqlplus
Assert-CheminExiste -chemin $7z

# Test d'accès au serveur SMTP
Assert-Script -message "ping de $serveurSMTP" -test { Test-Connection $serveurSMTP -Quiet }