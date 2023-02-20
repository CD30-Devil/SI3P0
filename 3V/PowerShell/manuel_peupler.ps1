﻿. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\manuel_peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

$dateBDTopo = '2022-12-15'
$dateComplement3V = '2023-02-17'

# nettoyage préalable
Remove-Item "$dossierRapports\*"
Remove-Item "$dossierTravailTemp\3v_peupler\*"

SIg-Effacer-Table -table 'tmp.Source_ItineraireCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.Source_ItineraireCyclable.txt"
SIg-Effacer-Table -table 'tmp.Source_PortionCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.Source_PortionCyclable.txt"
SIg-Effacer-Table -table 'tmp.Source_SegmentCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmpSource_.SegmentCyclable.txt"
SIg-Effacer-Table -table 'tmp.Source_Complement3v' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.Source_Complement3v.txt"

# création des structures temporaires
SIg-Creer-Table-Temp -table 'tmp.Source_ItineraireCyclable' -colonnes 'NumeroItineraireCyclable', 'NomOfficiel', 'NomUsage', 'Depart', 'Arrivee', 'EstInscrit', 'NiveauSchema', 'AnneeInscription', 'SiteWeb', 'AnneeOuverture' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.Source_ItineraireCyclable.txt"
SIg-Creer-Table-Temp -table 'tmp.Source_PortionCyclable' -colonnes 'Nom', 'Type', 'Description', 'NumeroItineraireCyclable', 'Ordre' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.Source_PortionCyclable.txt"
SIg-Creer-Table-Temp -table 'tmp.Source_SegmentCyclable' -colonnes 'EtatAvancement', 'Revetement', 'Statut', 'AnneeOuverture', 'SensUnique', 'SourceGeometrie', 'IdGeometrie', 'Fictif', 'PortionCyclable', 'Ordre', 'Proprietaires', 'Gestionnaires', 'Commentaires' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.Source_SegmentCyclable.txt"

# paramètrage des jobs de conversion des feuilles du fichier Excel descripteur en CSV
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((Parametrer-Job-Exporter-CSV-Excel -excel "$dossierDonnees\Référentiel 3V.xlsx" -requete 'select * from [ItineraireCyclable$]' -csv "$dossierTravailTemp\3v_peupler\ItineraireCyclable.csv"))
[void]$parametresJobs.Add((Parametrer-Job-Exporter-CSV-Excel -excel "$dossierDonnees\Référentiel 3V.xlsx" -requete 'select * from [PortionCyclable$]' -csv "$dossierTravailTemp\3v_peupler\PortionCyclable.csv"))
[void]$parametresJobs.Add((Parametrer-Job-Exporter-CSV-Excel -excel "$dossierDonnees\Référentiel 3V.xlsx" -requete 'select * from [SegmentCyclable$]' -csv "$dossierTravailTemp\3v_peupler\SegmentCyclable.csv"))

# exécution des jobs de conversion des feuilles du fichier Excel descripteur en CSV
Executer-Jobs -parametresJobs $parametresJobs

# paramètrage des jobs d'import des données dans les structures temporaires
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-CSV -csv "$dossierTravailTemp\3v_peupler\ItineraireCyclable.csv" -table 'tmp.Source_ItineraireCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import ItineraireCyclable.csv.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-CSV -csv "$dossierTravailTemp\3v_peupler\PortionCyclable.csv" -table 'tmp.Source_PortionCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import PortionCyclable.csv.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-CSV -csv "$dossierTravailTemp\3v_peupler\SegmentCyclable.csv" -table 'tmp.Source_SegmentCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import SegmentCyclable.csv.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-GeoJSON -geoJSON "$dossierDonnees\complement3v.geojson" -table 'tmp.Source_Complement3v' -multiGeom $false -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import complement3v.geojson.txt"))

# exécution des jobs d'import des données dans les structures temporaires
Executer-Jobs -parametresJobs $parametresJobs

# transfert des données du schéma tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

SIg-Executer-Commande -commande "update m.SegmentCyclable set DateSource = to_date('$dateBDTopo', 'YYYY-MM-DD') where SourceGeometrie = 'bdtopo.troncon_de_route'" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - MAJ date source bdtopo.troncon_de_route.txt"
SIg-Executer-Commande -commande "update m.SegmentCyclable set DateSource = to_date('$dateBDTopo', 'YYYY-MM-DD') where SourceGeometrie = 'bdtopo.troncon_de_voie_ferree'" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - MAJ date source bdtopo.troncon_de_voie_ferree.txt"
SIg-Executer-Commande -commande "update m.SegmentCyclable set DateSource = to_date('$dateComplement3V', 'YYYY-MM-DD') where SourceGeometrie = 'complement3v'" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - MAJ date source complement3v.txt"

# nettoyage final
Remove-Item "$dossierTravailTemp\3v_peupler\*"

SIg-Effacer-Table -table 'tmp.Source_ItineraireCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.Source_ItineraireCyclable.txt"
SIg-Effacer-Table -table 'tmp.Source_PortionCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.Source_PortionCyclable.txt"
SIg-Effacer-Table -table 'tmp.Source_SegmentCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.Source_SegmentCyclable.txt"
SIg-Effacer-Table -table 'tmp.Source_Complement3v' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.Source_Complement3v.txt"