. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\manuel_imprimer"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

QGisProcess-Imprimer-MiseEnPage `    -projet "$PSScriptRoot\..\QGis\3V.qgz" `    -miseEnPage 'ArchE' `    -pdf "$si3p0ThematiquesPortailWeb\3V\Cartes statiques\Véloroutes, voies vertes et boucles cyclo-découvertes du Gard - Format Arch E.pdf" `    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - imprimer Véloroutes, voies vertes et boucles cyclo-découvertes du Gard - Format Arch E.txt"