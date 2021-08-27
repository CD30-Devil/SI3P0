. ("$PSScriptRoot\TU.ps1")

. ("$PSScriptRoot\..\..\Powershell\fonctions_chromium.ps1")

# Test de la présence de 7-Zip
Assert-CheminExiste -chemin $chromium

# Test de la fonction Chromium-Capturer-Page
Assert-CheminExiste -message "Chromium-Capturer-Page" -chemin "$bas\capture.png" `
-avant {
    Vider-BacASable

    Chromium-Capturer-Page -url 'https://www.google.fr/' -sortie "$bas\capture.png"
} `
-apres {
    Vider-BacASable
}