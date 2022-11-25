. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

Executer-FichierPS -chemin "$PSScriptRoot\peupler.ps1" -process $true
Executer-FichierPS -chemin "$PSScriptRoot\cartographier.ps1" -process $true
Executer-FichierPS -chemin "$PSScriptRoot\notifier.ps1" -process $true