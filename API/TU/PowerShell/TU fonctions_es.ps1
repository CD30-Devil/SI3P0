. ("$PSScriptRoot\TU.ps1")

. ("$PSScriptRoot\..\..\Powershell\fonctions_es.ps1")

# Test de la fonction Changer-Encodage
Assert-Script -message 'Changer-Encodage' `
-avant {
    Vider-BacASable

    'aàbcdeéèê' | Out-File -FilePath "$bas\test.txt" -Encoding default
    Changer-Encodage -fichier "$bas\test.txt" -encodageAvant 'iso-8859-1' -encodageApres 'utf-8'
} `
-test {
    [System.IO.File]::ReadAllBytes("$bas\test.txt")[0] -eq 0xEF -and [System.IO.File]::ReadAllBytes("$bas\test.txt")[1] -eq 0xBB -and [System.IO.File]::ReadAllBytes("$bas\test.txt")[2] -eq 0xBF
} `
-apres {
    Vider-BacASable
}