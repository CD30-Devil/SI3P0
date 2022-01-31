. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\construire"
$dossierSQL = "$PSScriptRoot\..\SQL"

# -----------------------------------------------------------------------------
# Job de construction de routes du référentiel.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .listeRoutes : La liste des routes à construire.
# .bdd : La base de données cible de la construction.
# -----------------------------------------------------------------------------
$Job_Construire_Routes = {
    param (
        $parametres
    )

    . ("$($parametres.racineAPI)\api_complète.ps1")

    # définition du search_path
    $env:PGOPTIONS = "--search_path=tmp,m,v,f,public"

    foreach ($route in $parametres.listeRoutes) {
        SIg-Executer-Commande -bdd $parametres.bdd -commande "select * from ConstruireRoute('$route', 20, 200)"
    }
}

# -----------------------------------------------------------------------------
# choix de la base de données d'exécution
# -----------------------------------------------------------------------------

$bddProduction = $sigBDD
$bddQualification = "$($bddProduction)_qualif"

$bdd = Choisir-Option 'Merci de choisir la base de données cible de la construction' -options $bddProduction, $bddQualification

Write-Host 'Ce script va effacer puis reconstruire le référentiel routier en utilisant les paramètres de connexion suivants : ' -foregroundcolor 'green'
Write-Host "- serveur : $sigServeur" -foregroundcolor 'green'
Write-Host "- port : $sigPort" -foregroundcolor 'green'
Write-Host "- base de données : $bdd" -foregroundcolor 'green'
Write-Host "- utilisateur : $sigUtilisateur" -foregroundcolor 'green'

Write-Host 'Voulez-vous continuer ? (o/n)' -foregroundcolor 'green'
$continue = Read-Host

if ($continue -ne 'o') {
    Write-Host 'Construction du référentiel annulée.' -foregroundcolor 'green'
    exit
}

# -----------------------------------------------------------------------------
# définition du search_path
# -----------------------------------------------------------------------------

# Le procédure crée puis efface des tables, vues et fonctions de travail nécessaires à la construction.
# Le schéma souhaité pour la création de ces éléments temporaire doit donc apparaitre en premier dans le search_path.
$env:PGOPTIONS = "--search_path=tmp,m,v,f,public"

# -----------------------------------------------------------------------------
# nettoyage préalable
# -----------------------------------------------------------------------------
Afficher-Message-Date -message 'Nettoyage préalable.'

# effacement des rapports
Remove-Item "$dossierRapports\*.txt"
Remove-Item "$dossierRapports\*.err"
Remove-Item "$dossierRapports\*.sql"

# effacement du référentiel routier
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_effacer référentiel routier.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _effacer référentiel routier.txt"

# effacement des tables, vues et fonctions de travail
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tmp(.f).correction bdtopo (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.f).correction bdtopo (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tmp(.f).construction référentiel routier (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.f).construction référentiel routier (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tmp(.m).construction référentiel routier (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.m).construction référentiel routier (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tmp(.v).construction référentiel routier (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).construction référentiel routier (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tmp(.d).construction référentiel routier (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.d).construction référentiel routier (drop).txt"

# -----------------------------------------------------------------------------
# mise en place du contexte de travail
# -----------------------------------------------------------------------------
Afficher-Message-Date -message 'Mise en place du contexte de travail.'

# création des tables, vues et fonctions de travail
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tmp(.d).construction référentiel routier (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.d).construction référentiel routier (create).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tmp(.v).construction référentiel routier (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).construction référentiel routier (create).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tmp(.m).construction référentiel routier (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.m).construction référentiel routier (create).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tmp(.f).construction référentiel routier (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.f).construction référentiel routier (create).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tmp(.f).correction bdtopo (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.f).correction bdtopo (create).txt"

# -----------------------------------------------------------------------------
# construction du référentiel routier
# -----------------------------------------------------------------------------
Afficher-Message-Date -message 'Construction du référentiel routier.'

# correction préalable des données sources
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_corriger source tronçon.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _corriger source tronçon.txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_corriger source pr.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _corriger source pr.txt"

# insertion des tronçons fictifs pour garantir la continuïté des routes
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_insérer tronçons fictifs.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _insérer tronçons fictifs.txt"

# recherche des discontinuités restantes
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_rechercher discontinuités.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _rechercher discontinuités.txt"

# insertion des routes
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_insérer routes.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _insérer routes.txt"

# lancement de la recherche des giratoires
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_rechercher giratoires.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _rechercher giratoires.txt"

# correction a posteriori des erreurs de détection des giratoires
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_corriger giratoires.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _corriger giratoires.txt"

# recalage des PR de début (fichier SQL résultat à comparer avec le script d'insertion des PR de début)
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_recaler pr début.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _recaler pr début.sql" -autresParams '--tuples-only', '--no-align'

# insertion des PR de début
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_insérer pr début.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _insérer pr début.txt"

# recherche des routes à construire
$fichierListeRoutes = "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _rechercher routes à construire.txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_rechercher routes à construire.sql" -sortie $fichierListeRoutes -autresParams '--tuples-only', '--no-align'

# paramétrage de 32 jobs de construction
$listeRoutes = Get-Content $fichierListeRoutes
$fragmentsListeRoutes = Fragmenter-Liste -liste $listeRoutes -nombreFragments 32

$parametresJobs = [Collections.ArrayList]::new()

foreach ($fragmentListeRoutes in $fragmentsListeRoutes) {
    [void]$parametresJobs.Add(@{
        script = $Job_Construire_Routes
        racineAPI = "$PSScriptRoot\..\..\API\PowerShell"
        bdd = $bdd
        listeRoutes = $fragmentListeRoutes
    })
}

# exécution des jobs de construction
Executer-Jobs -nombreJobs $($sigNbCoeurs - 1) -parametresJobs $parametresJobs

# mise à jour des niveaux
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_mettre à jour niveaux.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _mettre à jour niveaux.txt"

# affectation des numéros de routes aux giratoires en fonction des critères métiers
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_affecter numéro route giratoires.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _affecter numéro route giratoires.txt"

# mise à jour des RGC
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_mettre à jour rgc.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _mettre à jour rgc.txt"

# mise à jour des RRIR
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_mettre à jour rrir.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _mettre à jour rrir.txt"

# mise à jour des voies gauches
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_mettre à jour voies gauches.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _mettre à jour voies gauches.txt"

# -----------------------------------------------------------------------------
# production de statistiques et détection d'erreurs
# -----------------------------------------------------------------------------
Afficher-Message-Date -message 'Production de statistiques et détection d''erreurs.'

SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_calculer statistiques et détecter erreurs.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _calculer statistiques et détecter erreurs.txt" -autresParams '--tuples-only', '--no-align'

# -----------------------------------------------------------------------------
# nettoyage final de la base de données
# -----------------------------------------------------------------------------
Afficher-Message-Date -message 'Nettoyage final de la base de données.'

# effacement des tables, vues et fonctions de travail
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tmp(.f).correction bdtopo (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.f).correction bdtopo (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tmp(.f).construction référentiel routier (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.f).construction référentiel routier (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tmp(.m).construction référentiel routier (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.m).construction référentiel routier (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tmp(.v).construction référentiel routier (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.v).construction référentiel routier (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tmp(.d).construction référentiel routier (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tmp(.d).construction référentiel routier (drop).txt"