. ("$PSScriptRoot\TU.ps1")

. ("$PSScriptRoot\..\..\Powershell\fonctions_oracle.ps1")

# Test de la fonction Executer-SQLPLUS-Fichier
Assert-Script -message 'Executer-SQLPLUS-Fichier' `
-avant {
    Vider-BacASable

    "SPOOL '$bas\test.txt'" | Out-File "$bas\requete.sql" -Encoding default
    "select 'test Executer-SQLPLUS-Fichier' from dual;" | Out-File "$bas\requete.sql" -Encoding default -Append
    "quit;" | Out-File "$bas\requete.sql" -Encoding default -Append
    "/" | Out-File "$bas\requete.sql" -Encoding default -Append

    Executer-SQLPLUS-Fichier -utilisateur 'test' -mdp 'test' -tnsname 'test' -fichier "$bas\requete.sql"
} `
-test {
    (Get-Content "$bas\test.txt") -ilike '*test Executer-SQLPLUS-Fichier*'
} `
-apres {
    Vider-BacASable
}

# Test de la fonction Exporter-CSV-Oracle
Assert-Script -message 'Exporter-CSV-Oracle' `
-avant {
    Vider-BacASable
    Exporter-CSV-Oracle -utilisateur 'test' -mdp 'test' -tnsname 'test' -csv "$bas\test.csv" -requete 'select ''test Exporter-CSV-Oracle'' from dual'
} `
-test {
    (Get-Content "$bas\test.csv") -ilike '*test Exporter-CSV-Oracle*'
} `
-apres {
    Vider-BacASable
}