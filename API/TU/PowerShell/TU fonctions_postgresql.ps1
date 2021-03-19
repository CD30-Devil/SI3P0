. ("$PSScriptRoot\TU.ps1")

. ("$PSScriptRoot\..\..\Powershell\fonctions_postgresql.ps1")

# Test de la fonction Rechercher-MDP-PGPass
Assert-Script -message 'Rechercher-MDP-PGPass' `
-test {
    if (Test-Path "$env:APPDATA\postgresql\pgpass.conf") {
        $ligne = Get-Content "$env:APPDATA\postgresql\pgpass.conf" -First 1
        $mdp = Rechercher-MDP-PGPass
        $ligne -ilike "*:$mdp"
    }
    else {
        $false
    }
}