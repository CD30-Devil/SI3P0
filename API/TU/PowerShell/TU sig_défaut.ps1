. ("$PSScriptRoot\TU.ps1")

. ("$PSScriptRoot\..\..\Powershell\sig_défaut.ps1")

# Test de la fonction SIg-Executer-Fichier
Assert-Script -message 'SIg-Executer-Fichier' `
-avant {
    Vider-BacASable
    "select 'test SIg-Executer-Fichier';" | Out-File "$bas\requete.sql" -Encoding utf8
    SIg-Executer-Fichier -fichier "$bas\requete.sql" -sortie "$bas\test.txt"
} `
-test {
    (Test-Path "$bas\test.txt") -and (Get-Content "$bas\test.txt") -ilike '*test SIg-Executer-Fichier*'
} `
-apres {
    Vider-BacASable
}

# Test de la fonction SIg-Executer-Commande
Assert-Script -message 'SIg-Executer-Commande' `
-avant {
    Vider-BacASable
    SIg-Executer-Commande -commande "select 'test SIg-Executer-Commande';" -sortie "$bas\test.txt"
} `
-test {
    (Test-Path "$bas\test.txt") -and (Get-Content "$bas\test.txt") -ilike '*test SIg-Executer-Commande*'
} `
-apres {
    Vider-BacASable
}

# Test de la fonction SIg-Creer-Table-Temp
Assert-Script -message 'SIg-Creer-Table-Temp' `
-avant {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
    SIg-Creer-Table-Temp -table 'table_tu_sig_defaut' -colonnes 'col1', 'col2', 'col3'
    SIg-Executer-Commande -commande "select * from information_schema.columns where table_name = 'table_tu_sig_defaut' order by ordinal_position" -sortie "$bas\test.txt"
} `
-test {
    if (Test-Path "$bas\test.txt") {
        $contenu = Get-Content "$bas\test.txt"
        $contenu -ilike '*col1*' -and $contenu -ilike '*col2*' -and $contenu -ilike '*col3*'
    }
    else {
        $false
    }
} `
-apres {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
}

# Test de la fonction SIg-Effacer-Table
Assert-Script -message 'SIg-Effacer-Table' `
-avant {
    Vider-BacASable
    SIg-Creer-Table-Temp -table 'table_tu_sig_defaut' -colonnes 'col1', 'col2', 'col3'
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
    SIg-Executer-Commande -commande "select count(*) from information_schema.tables where table_name = 'table_tu_sig_defaut'" -sortie "$bas\test.txt"
} `
-test {
    (Test-Path "$bas\test.txt") -and (Get-Content "$bas\test.txt") -ilike '*0*'
} `
-apres {
    Vider-BacASable
}

# Test de la fonction SIg-Effacer-Vue
Assert-Script -message 'SIg-Effacer-Vue' `
-avant {
    Vider-BacASable
    SIg-Executer-Commande -commande 'create view vue_tu_sig_defaut as select * from information_schema.tables'
    SIg-Effacer-Vue -vue 'vue_tu_sig_defaut'
    SIg-Executer-Commande -commande "select count(*) from information_schema.views where table_name = 'vue_tu_sig_defaut'" -sortie "$bas\test.txt"
} `
-test {
    (Test-Path "$bas\test.txt") -and (Get-Content "$bas\test.txt") -ilike '*0*'
} `
-apres {
    Vider-BacASable
}

# Test de la fonction SIg-Importer-CSV
Assert-Script -message 'SIg-Importer-CSV' `
-avant {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
    SIg-Creer-Table-Temp -table 'table_tu_sig_defaut' -colonnes 'col1', 'col2'
    SIg-Importer-CSV -csv "$PSScriptRoot\..\Ressources\fichiers CSV\classeur.csv" -table 'table_tu_sig_defaut'
    SIg-Executer-Commande -commande "select case when count(*) > 0 then 'ok' else 'ko' end from table_tu_sig_defaut" -sortie "$bas\test.txt"
} `
-test {
    (Test-Path "$bas\test.txt") -and (Get-Content "$bas\test.txt") -ilike '*ok*'
} `
-apres {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
}

# Test de la fonction SIg-Importer-GeoJSON
Assert-Script -message 'SIg-Importer-GeoJSON' `
-avant {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
    SIg-Importer-GeoJSON -geoJSON "$PSScriptRoot\..\Ressources\fichiers GeoJSON\d13.geojson" -table 'table_tu_sig_defaut' -priorite High
    SIg-Executer-Commande -commande "select * from information_schema.columns where table_name = 'table_tu_sig_defaut' order by ordinal_position" -sortie "$bas\test.txt"
} `
-test {
    if (Test-Path "$bas\test.txt") {
        $contenu = Get-Content "$bas\test.txt"
        $contenu -ilike '*idtroncon*' -and $contenu -ilike '*numeroroute*' -and $contenu -ilike '*geom*'
    }
    else {
        $false
    }
} `
-apres {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
}

# Test de la fonction SIg-Importer-SHP
Assert-Script -message 'SIg-Importer-SHP' `
-avant {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
    SIg-Importer-SHP -shp "$PSScriptRoot\..\Ressources\fichiers SHP\d13.shp" -table 'table_tu_sig_defaut' -priorite High
    SIg-Executer-Commande -commande "select * from information_schema.columns where table_name = 'table_tu_sig_defaut' order by ordinal_position" -sortie "$bas\test.txt"
} `
-test {
    if (Test-Path "$bas\test.txt") {
        $contenu = Get-Content "$bas\test.txt"
        $contenu -ilike '*idtroncon*' -and $contenu -ilike '*numerorout*' -and $contenu -ilike '*geom*'
    }
    else {
        $false
    }
} `
-apres {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
}

# Test de la fonction SIg-Exporter-CSV
Assert-CheminExiste -message 'SIg-Exporter-CSV' -chemin "$bas\test.csv" `
-avant {
    Vider-BacASable
    SIg-Exporter-CSV -requete 'select * from information_schema.tables' -csv "$bas\test.csv"
} `
-apres {
    Vider-BacASable
}

# Test de la fonction SIg-Exporter-Dump
Assert-CheminExiste -message 'SIg-Exporter-Dump' -chemin "$bas\test.sql" `
-avant {
    Vider-BacASable
    SIg-Exporter-Dump -tables 'information_schema.tables', 'information_schema.views' -dump "$bas\test.sql"
} `
-apres {
    Vider-BacASable
}

# Test de la fonction SIg-Exporter-GeoJSON
Assert-CheminExiste -message 'SIg-Exporter-GeoJSON' -chemin "$bas\test.geojson" `
-avant {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
    SIg-Importer-GeoJSON -geoJSON "$PSScriptRoot\..\Ressources\fichiers GeoJSON\d13.geojson" -table 'table_tu_sig_defaut'
    SIg-Exporter-GeoJSON -requete 'select * from table_tu_sig_defaut' -geoJSON "$bas\test.geojson" -priorite High
} `
-apres {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
}

# Test de la fonction SIg-Exporter-SHP sans compression
Assert-CheminExiste -message 'SIg-Exporter-SHP sans compression' -chemin "$bas\test.shp" `
-avant {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
    SIg-Importer-GeoJSON -geoJSON "$PSScriptRoot\..\Ressources\fichiers GeoJSON\d13.geojson" -table 'table_tu_sig_defaut'
    SIg-Exporter-SHP -requete 'select * from table_tu_sig_defaut' -shp "$bas\test.shp" -priorite High
} `
-apres {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
}

# Test de la fonction SIg-Exporter-SHP avec compression
Assert-CheminExiste -message 'SIg-Exporter-SHP avec compression' -chemin "$bas\test.zip" `
-avant {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
    SIg-Importer-GeoJSON -geoJSON "$PSScriptRoot\..\Ressources\fichiers GeoJSON\d13.geojson" -table 'table_tu_sig_defaut'
    SIg-Exporter-SHP -requete 'select * from table_tu_sig_defaut' -shp "$bas\test.shp" -compresser $true -priorite High
} `
-apres {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
}

# Test de la fonction SIg-Exporter-DXF
Assert-CheminExiste -message 'SIg-Exporter-DXF' -chemin "$bas\test.dxf" `
-avant {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
    SIg-Importer-GeoJSON -geoJSON "$PSScriptRoot\..\Ressources\fichiers GeoJSON\d13.geojson" -table 'table_tu_sig_defaut'
    SIg-Exporter-DXF -requete 'select * from table_tu_sig_defaut' -dxf "$bas\test.dxf" -priorite High
} `
-apres {
    Vider-BacASable
    SIg-Effacer-Table -table 'table_tu_sig_defaut'
}