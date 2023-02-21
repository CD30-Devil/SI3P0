. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierRapports = "$PSScriptRoot\..\Rapports\manuel_construire"
$dossierSQL = "$PSScriptRoot\..\SQL"

# TODO :
# Définir le search_path en fonction de la structuration de la BDD.
# A noter que la procédure crée puis efface des tables, vues et fonctions temporaires de construction.
# Le schéma souhaité pour la création de ces éléments temporaires doit donc apparaitre en premier dans le search_path.
$pgSearchPath = "tmp,m,f,d,archive,topology,public"

# -----------------------------------------------------------------------------
# Job de construction de routes du référentiel.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .bdd : La base de données cible de la construction.
# .pgSearchPath : La valeur souhaité pour le search_path PostgreSQL.
# .listeRoutes : La liste des routes à construire.
# -----------------------------------------------------------------------------
$Job_Construire_Routes = {
    param (
        $parametres
    )

    . ("$($parametres.racineAPI)\api_complète.ps1")

    $env:PGOPTIONS = "--search_path=$($parametres.pgSearchPath)"

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

Write-Host 'Ce script va effacer puis reconstruire le référentiel routier en utilisant les paramètres de connexion suivants : ' -foregroundcolor 'Red'
Write-Host "- serveur : $sigServeur" -foregroundcolor 'Red'
Write-Host "- port : $sigPort" -foregroundcolor 'Red'
Write-Host "- base de données : $bdd" -foregroundcolor 'Red'
Write-Host "- utilisateur : $sigUtilisateur" -foregroundcolor 'Red'

Write-Host 'Voulez-vous continuer ? (o/n)' -foregroundcolor 'Red'
$continue = Read-Host

if ($continue -ne 'o') {
    Write-Host 'Construction du référentiel annulée.' -foregroundcolor 'Red'
    exit
}

# -----------------------------------------------------------------------------
# définition du search_path
# -----------------------------------------------------------------------------

# Le procédure crée puis efface des tables, vues et fonctions de travail nécessaires à la construction.
# Le schéma souhaité pour la création de ces éléments temporaire doit donc apparaitre en premier dans le search_path.
$env:PGOPTIONS = "--search_path=tmp,m,f,d,archive,topology,public"

# -----------------------------------------------------------------------------
# nettoyage préalable
# -----------------------------------------------------------------------------
Afficher-Message-Date -message 'Nettoyage préalable.'

# effacement des rapports
Remove-Item "$dossierRapports\*"

# effacement du référentiel routier
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_effacer référentiel routier.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _effacer référentiel routier.txt"

# effacement des tables, vues et fonctions de travail
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\fonctions de construction (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - fonctions de construction (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\vues et vues matérialisées de construction (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - vues et vues matérialisées de construction (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\modèle de construction (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - modèle de construction (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\fonctions de correction (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - fonctions de correction (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\données de construction (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - données de construction (drop).txt"

# -----------------------------------------------------------------------------
# mise en place du contexte de travail
# -----------------------------------------------------------------------------
Afficher-Message-Date -message 'Mise en place du contexte de travail.'

# copie et correction données sources
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\données de construction (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - données de construction (create).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\fonctions de correction (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - fonctions de correction.txt"

SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_corriger source tronçon.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _corriger source tronçon.txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_corriger source pr.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _corriger source pr.txt"

# insertion des tronçons fictifs pour garantir la continuïté des routes
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_insérer tronçons fictifs.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _insérer tronçons fictifs.txt"

# création des tables, fonctions et vues de construction
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\modèle de construction (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - modèle de construction (create).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\vues et vues matérialisées de construction (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - vues et vues matérialisées de construction (create).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\fonctions de construction (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - fonctions de construction (create).txt"

# -----------------------------------------------------------------------------
# construction du référentiel routier
# -----------------------------------------------------------------------------
Afficher-Message-Date -message 'Construction du référentiel routier.'

# insertion des routes
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_insérer routes.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _insérer routes.txt"

# recherche des discontinuités restantes
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_rechercher discontinuités.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _rechercher discontinuités.txt"

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
        pgSearchPath = $pgSearchPath
        listeRoutes = $fragmentListeRoutes
    })
}

# exécution des jobs de construction
Executer-Jobs -nombreJobs $($sigNbCoeurs - 1) -parametresJobs $parametresJobs

# inversion des tronçons placés avant les PR de début
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_inverser tronçons avant pr début.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _inverser tronçons avant pr début.txt"

# mise à jour de l'attribut "Niveau"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_mettre à jour attribut niveau.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _mettre à jour attribut niveau.txt"

# suppression des giratoires n'ayant pas servi à la construction du référentiel
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_supprimer giratoires inutiles.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _supprimer giratoires inutiles.txt"

# affectation des numéros de routes aux giratoires en fonction des critères métiers
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_affecter numéro route giratoires.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _affecter numéro route giratoires.txt"

# mise à jour de l'attribut "RGC"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_mettre à jour attribut rgc.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _mettre à jour attribut rgc.txt"

# mise à jour de l'attribut "RRIR"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_mettre à jour attribut rrir.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _mettre à jour attribut rrir.txt"

# mise à jour de l'attribut "RTE"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_mettre à jour attribut rte.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _mettre à jour attribut rte.txt"

# mise à jour de l'attribut "Gauche"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_mettre à jour attribut gauche.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _mettre à jour attribut gauche.txt"

# mise à jour de l'attribut "SirenProprietaire"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_mettre à jour attribut sirenproprietaire.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _mettre à jour attribut sirenproprietaire.txt"

# mise à jour de l'attribut "SirenGestionCourante"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_mettre à jour attribut sirengestioncourante.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _mettre à jour attribut sirengestioncourante.txt"

# mise à jour de l'attribut "SirenVH"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\_mettre à jour attribut sirenvh.sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - _mettre à jour attribut sirenvh.txt"

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
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\fonctions de construction (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - fonctions de construction (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\vues et vues matérialisées de construction (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - vues et vues matérialisées de construction (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\modèle de construction (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - modèle de construction (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\fonctions de correction (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - fonctions de correction (drop).txt"
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\données de construction (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - données de construction (drop).txt"