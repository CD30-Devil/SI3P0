. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

Executer-FichierPS -chemin "$PSScriptRoot\D_4h_vérifier.ps1" -process $true
Executer-FichierPS -chemin "$PSScriptRoot\D_4h_cartographier.ps1" -process $true
Executer-FichierPS -chemin "$PSScriptRoot\D_4h_exporter.ps1" -process $true
Executer-FichierPS -chemin "$PSScriptRoot\D_4h_imprimer.ps1" -process $false