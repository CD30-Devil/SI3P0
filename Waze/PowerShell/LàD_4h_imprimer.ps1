. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\LàD_4h_imprimer"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

# impression
QGisProcess-Imprimer-MiseEnPage `    -projet "$PSScriptRoot\..\QGis\Accidentologie.qgz" `    -miseEnPage 'ArchE' `    -pdf "$si3p0ThematiquesPortailWeb\Waze\Cartes statiques\Carte de chaleur des accidents - Format ArchE.pdf" `    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - imprimer Carte de chaleur des accidents - Format ArchE.txt"QGisProcess-Imprimer-MiseEnPage `    -projet "$PSScriptRoot\..\QGis\Dégradations.qgz" `    -miseEnPage 'ArchE' `    -pdf "$si3p0ThematiquesPortailWeb\Waze\Cartes statiques\Carte de chaleur des dégradations - Format ArchE.pdf" `    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - imprimer Carte de chaleur des dégradations - Format ArchE.txt"