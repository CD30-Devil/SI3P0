. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

Executer-FichierPS -chemin "$PSScriptRoot\manuel_peupler.ps1" -process $true
Executer-FichierPS -chemin "$PSScriptRoot\manuel_vérifier.ps1" -process $true
Executer-FichierPS -chemin "$PSScriptRoot\manuel_cartographier.ps1" -process $true
Executer-FichierPS -chemin "$PSScriptRoot\manuel_exporter.ps1" -process $true
Executer-FichierPS -chemin "$PSScriptRoot\manuel_imprimer.ps1" -process $false