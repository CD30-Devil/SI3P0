. ("$PSScriptRoot\..\..\Powershell\fonctions_outils.ps1")

Executer-FichierPS -chemin "$PSScriptRoot\TU constantes.ps1" -process $true
Executer-FichierPS -chemin "$PSScriptRoot\TU fonctions_archives.ps1" -process $true
Executer-FichierPS -chemin "$PSScriptRoot\TU fonctions_es.ps1" -process $true
Executer-FichierPS -chemin "$PSScriptRoot\TU fonctions_excel.ps1" -process $true
Executer-FichierPS -chemin "$PSScriptRoot\TU fonctions_géodonnées.ps1" -process $false
Executer-FichierPS -chemin "$PSScriptRoot\TU fonctions_oracle.ps1" -process $true -process32 $true
Executer-FichierPS -chemin "$PSScriptRoot\TU fonctions_postgresql.ps1" -process $true
Executer-FichierPS -chemin "$PSScriptRoot\TU fonctions_web.ps1" -process $true
Executer-FichierPS -chemin "$PSScriptRoot\TU sig_défaut.ps1" -process $true