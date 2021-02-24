. ("$PSScriptRoot\TU.ps1")

. ("$PSScriptRoot\..\..\Powershell\fonctions_excel.ps1")

# Test de la fonction Exporter-CSV-Excel depuis un xls
Assert-CheminExiste -message 'Exporter-CSV-Excel depuis un xls' -chemin "$bas\test.csv" `
-avant {
    Vider-BacASable
    Exporter-CSV-Excel -excel "$PSScriptRoot\..\Ressources\fichiers Excel\classeur.xls" -requete 'select * from [Feuille$]' -csv "$bas\test.csv"
} `
-apres {
    Vider-BacASable
}

# Test de la fonction Exporter-CSV-Excel depuis un xlsx
Assert-CheminExiste -message 'Exporter-CSV-Excel depuis un xlsx' -chemin "$bas\test.csv" `
-avant {
    Vider-BacASable
    Exporter-CSV-Excel -excel "$PSScriptRoot\..\Ressources\fichiers Excel\classeur.xlsx" -requete 'select * from [Feuille$]' -csv "$bas\test.csv"
} `
-apres {
    Vider-BacASable
}

# Test de la fonction Enregistrer-Feuille-Excel
Assert-CheminExiste -message 'Enregistrer-Feuille-Excel' -chemin "$bas\test.csv" `
-avant {
    Vider-BacASable
    Enregistrer-Feuille-Excel -excel "$PSScriptRoot\..\Ressources\fichiers Excel\classeur.xlsx" -feuille 'Feuille 2' -sortie "$bas\test.csv"
} `
-apres {
    Vider-BacASable
}