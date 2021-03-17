. ("$PSScriptRoot\TU.ps1")

. ("$PSScriptRoot\..\..\Powershell\fonctions_oracle.ps1")

$testOracleTNS = $null
$testOracleUtilisateur = $null
$testOracleMDP = $null

# Test des variables nécessaires aux tests des fonctions Oracle qui suivent
Assert-Script -message 'Si ce test est en erreur, vous devez vérifier les variables $testOracleTNS, $testOracleUtilisateur et $testOracleMDP' `
-test {
    $testOracleTNS -and $testOracleUtilisateur -and $testOracleMDP
} 


# Test de la fonction Executer-SQLPLUS-Fichier
Assert-Script -message 'Executer-SQLPLUS-Fichier' `
-avant {
    Vider-BacASable

    "SPOOL '$bas\test.txt'" | Out-File "$bas\requete.sql" -Encoding default
    "select 'test Executer-SQLPLUS-Fichier' from dual;" | Out-File "$bas\requete.sql" -Encoding default -Append
    "quit;" | Out-File "$bas\requete.sql" -Encoding default -Append
    "/" | Out-File "$bas\requete.sql" -Encoding default -Append

    Executer-SQLPLUS-Fichier -utilisateur $testOracleUtilisateur -mdp $testOracleMDP -tnsname $testOracleTNS -fichier "$bas\requete.sql"
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
    Exporter-CSV-Oracle -utilisateur $testOracleUtilisateur -mdp $testOracleMDP -tnsname $testOracleTNS -csv "$bas\test.csv" -requete 'select ''test Exporter-CSV-Oracle'' from dual'
} `
-test {
    (Get-Content "$bas\test.csv") -ilike '*test Exporter-CSV-Oracle*'
} `
-apres {
    Vider-BacASable
}