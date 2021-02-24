. ("$PSScriptRoot\TU.ps1")

. ("$PSScriptRoot\..\..\Powershell\fonctions_postgresql.ps1")

# Test de la fonction Rechercher-MDP-PGPass
Assert-Script -message 'Rechercher-MDP-PGPass' `
-test {
    (Rechercher-MDP-PGPass -serveur 'srw-dummy' -port '5432' -bdd 'bdd-dummy' -utilisateur 'usr-dummy') -eq 'pwd-dummy'
}