. ("$PSScriptRoot\TU.ps1")

. ("$PSScriptRoot\..\..\Powershell\fonctions_chrome.ps1")

# Test de la présence de 7-Zip
Assert-CheminExiste -chemin $chrome

# Test de la fonction Chrome-Capturer-Page
Assert-CheminExiste -message "Chrome-Capturer-Page" -chemin "$bas\capture.png" `
-avant {
    Vider-BacASable

    Chrome-Capturer-Page -url 'https://www.google.fr/' -sortie "$bas\capture.png"
} `
-apres {
    Vider-BacASable
}