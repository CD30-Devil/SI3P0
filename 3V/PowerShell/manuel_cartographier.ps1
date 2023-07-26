. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\manuel_cartographier"
$dossierSQL4Map = "$PSScriptRoot\..\SQL.4Map"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

SIg-Executer-Fichier -fichier "$dossierSQL4Map\4Map (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Map (drop).txt"

# création des vues pour la production des cartes
SIg-Executer-Fichier -fichier "$dossierSQL4Map\4Map (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Map (create).txt"

# ajout des textes d'information pour chacune des cartes
SI3P0-Ajouter-Information-Carte `
    -identifiant 'Segment3VEtatAvancement' `
    -texte @'
Cette carte présente les segments cyclables, du référentiel Véloroutes et Voies Vertes (3V), par état d\'avancement.

Les états possibles sont :
- 1 - Tracé d'intention
- 2 - Etudes en cours
- 3 - Travaux en cours
- 4 - Ouvert
'@

SI3P0-Ajouter-Information-Carte `
    -identifiant 'Portion3V' `
    -texte @'
Cette carte présente les portions cyclables et indique les itinéraires auxquels elles participent.
Elle donne également pour chaque portion la longueur par état d\'avancement et par statut.

Les états possibles sont :
- 1 - En service
- 2 - Partiellement en service
- 3 - Hors service
'@

# paramétrage des jobs de génération des cartes
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((
    Parametrer-Job-SI3P0-Generer-Carte `
        -sources 'D30_3VSegmentEtatAvancement_4Map' `
        -carte "$si3p0ThematiquesPortailWeb\3V\Cartes dynamiques\Segments cyclables par état d'avancement.html" `
        -titre 'Segments cyclables par état d''avancement' `
        -daterTitre $true `
        -idInfo 'Segment3VEtatAvancement'))

[void]$parametresJobs.Add((
    Parametrer-Job-SI3P0-Generer-Carte `
        -sources 'D30_3VPortion_4Map' `
        -carte "$si3p0ThematiquesPortailWeb\3V\Cartes dynamiques\Portions cyclables.html" `
        -titre 'Portions cyclables' `
        -daterTitre $true `
        -idInfo 'Portion3V'))

# exécution des jobs de génération des cartes
Executer-Jobs -parametresJobs $parametresJobs

# nettoyage final
SIg-Executer-Fichier -fichier "$dossierSQL4Map\4Map (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - 4Map (drop).txt"