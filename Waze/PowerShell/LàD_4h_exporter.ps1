. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\LàD_4h_exporter"
$dossierSQL4Layer = "$PSScriptRoot\..\SQL.4Layer"

# nettoyage préalable
Remove-Item -Path "$dossierRapports\*"

SIg-Executer-Fichier -fichier "$dossierSQL4Layer\4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Layer (drop).txt"

# création des vues pour la production des exports
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\4Layer (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Layer (create).txt"

# paramétrage des jobs d'export
$parametresJobs = [Collections.ArrayList]::new()

# gpkg
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GPKG -requetes "select * from AccidentProcheRD_4Layer" -gpkg "$si3p0DossierExportGPKG\Waze\Accidents.gpkg" -couche "AccidentProcheRD" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export Accidents.gpkg.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Exporter-GPKG -requetes "select * from DegradationProcheRD_4Layer" -gpkg "$si3p0DossierExportGPKG\Waze\Dégradations.gpkg" -couche "DegradationProcheRD" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - Export Dégradations.gpkg.txt"))

# exécution des jobs d'export
Executer-Jobs -parametresJobs $parametresJobs

# nettoyage final
SIg-Executer-Fichier -fichier "$dossierSQL4Layer\4Layer (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Layer (drop).txt"