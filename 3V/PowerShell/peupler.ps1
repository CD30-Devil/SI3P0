. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

$dateBDTopo = '2021-12-15'
$dateComplement3V = '2021-01-25'

# nettoyage préalable
Remove-Item "$dossierRapports\*.txt"
Remove-Item "$dossierRapports\*.err"

Remove-Item "$dossierTravailTemp\3v_peupler\*.csv"

SIg-Effacer-Table -table 'tmp.ItineraireCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.ItineraireCyclable.txt"
SIg-Effacer-Table -table 'tmp.PortionCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.PortionCyclable.txt"
SIg-Effacer-Table -table 'tmp.SegmentCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.SegmentCyclable.txt"
SIg-Effacer-Table -table 'tmp.complement3v' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.complement3v.txt"

# création des structures temporaires
SIg-Creer-Table-Temp -table 'tmp.ItineraireCyclable' -colonnes 'NumeroItineraireCyclable', 'NomOfficiel', 'NomUsage', 'Depart', 'Arrivee', 'EstInscrit', 'NiveauSchema', 'AnneeInscription', 'SiteWeb', 'AnneeOuverture' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.ItineraireCyclable.txt"
SIg-Creer-Table-Temp -table 'tmp.PortionCyclable' -colonnes 'Nom', 'Type', 'Description', 'NumeroItineraireCyclable', 'Ordre' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.PortionCyclable.txt"
SIg-Creer-Table-Temp -table 'tmp.SegmentCyclable' -colonnes 'EtatAvancement', 'Revetement', 'Statut', 'AnneeOuverture', 'SensUnique', 'SourceGeometrie', 'IdGeometrie', 'Fictif', 'PortionCyclable', 'Ordre', 'Proprietaires', 'Gestionnaires', 'Commentaires' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.SegmentCyclable.txt"

# conversion des feuilles du fichier Excel descripteur en CSV
Exporter-CSV-Excel -excel "$dossierDonnees\Référentiel 3V.xlsx" -requete 'select * from [ItineraireCyclable$]' -csv "$dossierTravailTemp\3v_peupler\ItineraireCyclable.csv"
Exporter-CSV-Excel -excel "$dossierDonnees\Référentiel 3V.xlsx" -requete 'select * from [PortionCyclable$]' -csv "$dossierTravailTemp\3v_peupler\PortionCyclable.csv"
Exporter-CSV-Excel -excel "$dossierDonnees\Référentiel 3V.xlsx" -requete 'select * from [SegmentCyclable$]' -csv "$dossierTravailTemp\3v_peupler\SegmentCyclable.csv"

# paramètrage des jobs d'import des données dans les structures temporaires
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-CSV -csv "$dossierTravailTemp\3v_peupler\ItineraireCyclable.csv" -table 'tmp.ItineraireCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import ItineraireCyclable.csv.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-CSV -csv "$dossierTravailTemp\3v_peupler\PortionCyclable.csv" -table 'tmp.PortionCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import PortionCyclable.csv.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-CSV -csv "$dossierTravailTemp\3v_peupler\SegmentCyclable.csv" -table 'tmp.SegmentCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import SegmentCyclable.csv.txt"))
[void]$parametresJobs.Add((Parametrer-Job-SIg-Importer-GeoJSON -geoJSON "$dossierDonnees\complement3v.geojson" -table 'tmp.complement3v' -multiGeom $false -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import complement3v.geojson.txt"))

# exécution des jobs d'import des données dans les structures temporaires
Executer-Jobs -parametresJobs $parametresJobs

# transfert des données du schéma tmp au schéma m
SIg-Executer-Fichier -fichier "$dossierSQL\_peupler.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _peupler.txt"

SIg-Executer-Commande -commande "update m.SegmentCyclable set DateSource = to_date('$dateBDTopo', 'YYYY-MM-DD') where SourceGeometrie = 'bdtopo.troncon_de_route'" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - MAJ date source bdtopo.troncon_de_route.txt"
SIg-Executer-Commande -commande "update m.SegmentCyclable set DateSource = to_date('$dateBDTopo', 'YYYY-MM-DD') where SourceGeometrie = 'bdtopo.troncon_de_voie_ferree'" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - MAJ date source bdtopo.troncon_de_voie_ferree.txt"
SIg-Executer-Commande -commande "update m.SegmentCyclable set DateSource = to_date('$dateComplement3V', 'YYYY-MM-DD') where SourceGeometrie = 'complement3v'" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - MAJ date source complement3v.txt"

# nettoyage final
Remove-Item "$dossierTravailTemp\3v_peupler\*.csv"

SIg-Effacer-Table -table 'tmp.ItineraireCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.ItineraireCyclable.txt"
SIg-Effacer-Table -table 'tmp.PortionCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.PortionCyclable.txt"
SIg-Effacer-Table -table 'tmp.SegmentCyclable' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.SegmentCyclable.txt"
SIg-Effacer-Table -table 'tmp.complement3v' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.complement3v.txt"