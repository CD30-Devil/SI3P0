. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

# pour l'instant inactif dans l'attente de la livraison de ce correctif : https://github.com/qgis/QGIS/pull/49122
exit

$dossierRapports = "$PSScriptRoot\..\Rapports\D_4h_imprimer"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

QGisProcess-Imprimer-MiseEnPage `    -projet "$PSScriptRoot\..\QGis\3V.qgz" `    -miseEnPage 'ArchE' `    -pdf "$si3p0ThematiquesPortailWeb\3V\Cartes statiques\Véloroutes, voies vertes et boucles cyclo-découvertes du Gard - Format Arch E.pdf" `    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - imprimer 3V - ArchE.txt"