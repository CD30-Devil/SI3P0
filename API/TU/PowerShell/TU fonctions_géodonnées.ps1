. ("$PSScriptRoot\TU.ps1")

. ("$PSScriptRoot\..\..\Powershell\fonctions_géodonnées.ps1")

# Test de la fonction Executer-Ogr2Ogr
Assert-CheminExiste -message 'Executer-Ogr2Ogr' -chemin "$bas\d13.geojson" `
-avant {
    Vider-BacASable
    Executer-Ogr2Ogr -source "$PSScriptRoot\..\Ressources\fichiers SHP\D13.shp" -formatDestination 'GeoJSON' -destination "$bas\d13.geojson" -priorite High
} `
-apres {
    Vider-BacASable
}

# Test de la fonction Executer-Shp2Pgsql
Assert-CheminExiste -message 'Executer-Shp2Pgsql' -chemin "$bas\d13.sql" `
-avant {
    Vider-BacASable
    Executer-Shp2PgSql -shp "$PSScriptRoot\..\Ressources\fichiers SHP\D13.shp" -table 'table_tu_fonctions_geodonnees' -fichierSQL "$bas\d13.sql" -priorite High
} `
-apres {
    Vider-BacASable
}

# Test de la fonction Executer-Raster2Pgsql
Assert-CheminExiste -message 'Executer-Raster2Pgsql' -chemin "$bas\raster.sql" `
-avant {
    Vider-BacASable
    Executer-Raster2Pgsql -raster "$PSScriptRoot\..\Ressources\fichiers raster\FR_4000K_JP2-E080_LAMB93_FXX\*.jp2" -table 'table_tu_fonctions_geodonnees' -fichierSQL "$bas\raster.sql" -priorite High
} `
-apres {
    Vider-BacASable
}