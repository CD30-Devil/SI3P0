﻿. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\manuel_imprimer"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

QGisProcess-Imprimer-MiseEnPage `