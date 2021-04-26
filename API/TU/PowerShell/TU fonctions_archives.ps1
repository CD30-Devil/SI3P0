. ("$PSScriptRoot\TU.ps1")

. ("$PSScriptRoot\..\..\Powershell\fonctions_archives.ps1")

# Test de la présence de 7-Zip
Assert-CheminExiste -chemin $7z

# Test de la fonction Zipper
Assert-CheminExiste -message "Zipper" -chemin "$bas\test.zip" `
-avant {
    Vider-BacASable

    'fichier de test' | Out-File -FilePath "$bas\test.txt"
    Zipper -dossier $bas -archiverDans "$bas\test.zip"
} `
-apres {
    Vider-BacASable
}

# Test de la fonction DeZipper
Assert-CheminExiste -message "DeZipper" -chemin "$bas\dezip\test.txt" `
-avant {
    Vider-BacASable

    'fichier de test' | Out-File ( New-Item -Path "$bas\zip\test.txt" -Force )
    Zipper -dossier "$bas\zip\" -archiverDans "$bas\test.zip"
    DeZipper -archive "$bas\test.zip" -extraireVers "$bas\dezip"
} `
-apres {
    Vider-BacASable
}

# Test de la fonction GZipper
Assert-CheminExiste -message "GZipper" -chemin "$bas\D13.geojson.gz" `
-avant {
    Vider-BacASable

    Copy-Item "$PSScriptRoot\..\Ressources\fichiers GeoJSON\D13.geojson" -Destination $bas
    GZipper -fichier "$bas\D13.geojson" -archiverDans "$bas"
} `
-apres {
    Vider-BacASable
}

# Test de la fonction DeGZipper d'un .gz
Assert-CheminExiste -message "DeGZipper .gz" -chemin "$bas\48-etalab.csv" `
-avant {
    Vider-BacASable

    Copy-Item "$PSScriptRoot\..\Ressources\fichiers archive\48-etalab.csv.gz" -Destination $bas
    DeGZipper -archive "$bas\48-etalab.csv.gz" -extraireVers "$bas"
} `
-apres {
    Vider-BacASable
}

# Test de la fonction DeGZipper d'un .tgz
Assert-CheminExiste -message "DeGZipper .tgz" -chemin "$bas\fichiers Excel.tar" `
-avant {
    Vider-BacASable

    Copy-Item "$PSScriptRoot\..\Ressources\fichiers archive\fichiers Excel.tgz" -Destination $bas
    DeGZipper -archive "$bas\fichiers Excel.tgz" -extraireVers "$bas"
} `
-apres {
    Vider-BacASable
}

# Test de la fonction 7Z-Compresser-Dossier
Assert-CheminExiste -message "7Z-Compresser-Dossier" -chemin "$bas\test.zip" `
-avant {
    Vider-BacASable

    'fichier de test' | Out-File -FilePath "$bas\test.txt"
    7Z-Compresser-Dossier -dossier $bas -archiverDans "$bas\test.zip"
} `
-apres {
    Vider-BacASable
}

# Test de la fonction 7Z-Compresser-Fichier
Assert-CheminExiste -message "7Z-Compresser-Fichier" -chemin "$bas\test.zip" `
-avant {
    Vider-BacASable

    'fichier de test' | Out-File -FilePath "$bas\test.txt"
    7Z-Compresser-Fichier -fichier "$bas\test.txt" -archiverDans "$bas\test.zip"
} `
-apres {
    Vider-BacASable
}

# Test de la fonction 7Z-Decompresser
Assert-CheminExiste -message "7Z-Decompresser" -chemin "$bas\dezip\test.txt" `
-avant {
    Vider-BacASable

    'fichier de test' | Out-File ( New-Item -Path "$bas\zip\test.txt" -Force )
    Zipper -dossier "$bas\zip" -archiverDans "$bas\test.zip"
    7Z-Decompresser -archive "$bas\test.zip" -extraireVers "$bas\dezip"
} `
-apres {
    Vider-BacASable
}

# Test de la fonction 7Z-Decompresser-Ici
Assert-Script -message "7Z-Decompresser-Ici" `
-avant {
    Vider-BacASable

    Copy-Item "$PSScriptRoot\..\Ressources\fichiers archive\dxf-cc-30356000AB01.tar.bz2" -Destination $bas
    7Z-Decompresser-Ici -archive "$bas\dxf-cc-30356000AB01.tar.bz2" -supprimer $true
} `
-test {
    (Test-Path "$bas\dxf-cc-30356000AB01.tar") -and (-not (Test-Path "$bas\dxf-cc-30356000AB01.tar.bz2"))
} `
-apres {
    Vider-BacASable
}