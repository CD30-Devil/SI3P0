. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\D_4h_cartographier"
$dossierSQL4Map = "$PSScriptRoot\..\SQL.4Map"

# nettoyage préalable
Remove-Item "$dossierRapports\*"

SIg-Executer-Fichier -fichier "$dossierSQL4Map\tmp(.v).4Map (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Map (drop).txt"

# création des vues pour la production des cartes
SIg-Executer-Fichier -fichier "$dossierSQL4Map\tmp(.v).4Map (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Map (create).txt"

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
    -identifiant 'Segment3VStatut' `
    -texte @'
Cette carte présente les segments cyclables, du référentiel Véloroutes et Voies Vertes (3V), par statut.

Les statuts possibles sont :
- VV - Voie verte
- PCY - Piste cyclable
- ASP - Autre site propre
- RTE - Route
- BCY - Bande cyclable
- ICA - Itinéraire à circulation apaisée
'@

SI3P0-Ajouter-Information-Carte `
    -identifiant 'Portion3V' `
    -texte @'
Cette carte présente les portions cyclables et indique les itinéraires auxquels elles participent.
Elle donne également pour chaque portion la longueur par état d\'avancement et par statut.

Les états possibles sont :
- 1 - Tracé d'intention
- 2 - Etudes en cours
- 3 - Travaux en cours
- 4 - Ouvert
'@

SI3P0-Ajouter-Information-Carte `
    -identifiant 'Inventaire3VD30' `
    -texte @'
Cette carte présente les segments cyclables ouverts, du référentiel Véloroutes et Voies Vertes (3V), dont le Gard est propriétaire.

Les segments de routes (RTE) sont exclus.
'@

# paramétrage des jobs de génération des cartes
$parametresJobs = [Collections.ArrayList]::new()

[void]$parametresJobs.Add((
    Parametrer-Job-SI3P0-Generer-Carte `
        -sources 'VVV_SegmentEtatAvancement_4Map' `
        -carte "$si3p0ThematiquesPortailWeb\3V\Cartes dynamiques\Segments cyclables par état d'avancement.html" `
        -titre 'Segments cyclables par état d''avancement' `
        -daterTitre $true `
        -idInfo 'Segment3VEtatAvancement'))

[void]$parametresJobs.Add((
    Parametrer-Job-SI3P0-Generer-Carte `
        -sources 'VVV_SegmentStatut_4Map' `
        -carte "$si3p0ThematiquesPortailWeb\3V\Cartes dynamiques\Segments cyclables par statut.html" `
        -titre 'Segments cyclables par statut' `
        -daterTitre $true `
        -idInfo 'Segment3VStatut'))

[void]$parametresJobs.Add((
    Parametrer-Job-SI3P0-Generer-Carte `
        -sources 'VVV_Portion_4Map' `
        -carte "$si3p0ThematiquesPortailWeb\3V\Cartes dynamiques\Portions cyclables.html" `
        -titre 'Portions cyclables' `
        -daterTitre $true `
        -idInfo 'Portion3V'))

[void]$parametresJobs.Add((
    Parametrer-Job-SI3P0-Generer-Carte `
        -sources 'VVV_LineaireD30_4Map' `
        -carte "$si3p0ThematiquesPortailWeb\3V\Cartes dynamiques\Linéaire du Gard.html" `
        -titre 'Linéaire ouvert dont le Gard est propriétaire' `
        -daterTitre $true `
        -idInfo 'Inventaire3VD30'))

# exécution des jobs de génération des cartes
Executer-Jobs -parametresJobs $parametresJobs

# nettoyage final
SIg-Executer-Fichier -fichier "$dossierSQL4Map\tmp(.v).4Map (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).4Map (drop).txt"