﻿. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

# pour l'instant inactif dans l'attente de la livraison de ce correctif : https://github.com/qgis/QGIS/pull/49122
exit

$dossierRapports = "$PSScriptRoot\..\Rapports\D_4h_imprimer"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

QGisProcess-Imprimer-MiseEnPage `