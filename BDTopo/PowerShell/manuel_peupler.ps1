. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\manuel_peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

# détermine l'archive de la BDTopo la plus récente
$archiveBDTopo = Get-ChildItem "$dossierDonnees\BDTOPO_3-0_TOUSTHEMES_SQL_LAMB93_FXX_*.7z.001" | sort -Property Name -Descending | select -First 1

# -----------------------------------------------------------------------------
# Job d'import d'un thème de la BDTopo dans le schéma d.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .archiveBDTopo : Le chemin vers l'archive de la BDTopo.
# .bdd : La base de données cible de l'import.
# .theme : Le nom du thème à importer. La table correspondante portera le nom
#          du thème préfixé par BDTopo_.
# .typeGeometrie : Le type de la géométrie à importer.
# .dossierRapports : Le chemin vers le dossier de sortie des rapports.
# -----------------------------------------------------------------------------
$Job_Importer_BDTopo = {
    param (
        $parametres
    )

    . ("$($parametres.racineAPI)\api_complète.ps1")

    # extraction du fichier sql
    Executer-7Z -commande 'e' -archive "`"$($parametres.archiveBDTopo)`"" -autresParams "-o`"$dossierTravailTemp\bdtopo_peupler`"", "-ir!$($parametres.theme).sql", "-aoa"
    
    # adaptation du contenu du fichier aux besoins spécifiques si3p0
    $lecture = [System.IO.File]::OpenText("$dossierTravailTemp\bdtopo_peupler\$($parametres.theme).sql")
    $ligne = ''


    # drop
    # le "drop" contenu dans le fichier est ignoré et remplacé par un drop sans 'CASCADE'
    while ('BEGIN;' -ne ($ligne = $lecture.ReadLine())) {
    }

    SIg-Executer-Commande `        -bdd $parametres.bdd `        -sortie "$($parametres.dossierRapports)\$($parametres.theme) - $(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement.txt" `        -commande @"
            set search_path to d, public;
            drop table if exists bdtopo_$($parametres.theme);
"@


    # create
    # le "create" est adapté pour spécifier le schéma et changer le nom de la table
    $ordreCreate = ''
    while ('COMMIT;' -ne ($ligne = $lecture.ReadLine())) {
        $ordreCreate += $ligne
    }

    $ordreCreate = $ordreCreate.replace("`"$($parametres.theme)`"", "bdtopo_$($parametres.theme)")
    $ordreCreate = $ordreCreate.replace("SELECT AddGeometryColumn('$($parametres.theme)','geometrie',2154,'GEOMETRY',", "SELECT AddGeometryColumn('bdtopo_$($parametres.theme)', 'geometrie', 2154, '$($parametres.typeGeometrie)', ")
    
    SIg-Executer-Commande `        -bdd $parametres.bdd `        -sortie "$($parametres.dossierRapports)\$($parametres.theme) - $(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création.txt" `        -commande @"
            set search_path to d, public;
            $ordreCreate
"@

    # on complète par un delete au cas ou le drop n'aurait pas fonctionné
    SIg-Executer-Commande `        -bdd $parametres.bdd `        -sortie "$($parametres.dossierRapports)\$($parametres.theme) - $(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - raz.txt" `        -commande @"
            set search_path to d, public;
            delete from bdtopo_$($parametres.theme);
"@


    # copy
    # le "copy" est adapté pour spécifier le schéma et changer le nom de la table
    while (!($ligne = $lecture.ReadLine()).StartsWith('COPY')) {
    }

    $ordreCopy = $ligne
    while (!$ligne.EndsWith('FROM STDIN;')) {
        $ligne = $lecture.ReadLine()
        $ordreCopy += $ligne
    }

    $ordreCopy = $ordreCopy.replace("`"$($parametres.theme)`"", "bdtopo_$($parametres.theme)")

    # de plus, le "copy" est fait par paquet d'environ 1Go de données
    $premier = 1
    $dernier = 0

    $fichierSQL = "$dossierTravailTemp\bdtopo_peupler\copy_$($parametres.theme) (offset $premier).sql"
    $ecriture = [System.IO.StreamWriter]::new($fichierSQL)
    $ecriture.WriteLine('set search_path to d, public;')
    $ecriture.WriteLine($ordreCopy)

    while ('\.' -ne ($ligne = $lecture.ReadLine())) {

        $ecriture.WriteLine($ligne)
        $dernier++

        if ((Get-Childitem $fichierSQL).length -gt 1GB) {
            
            $ecriture.Close()
            $ecriture = $null

            Afficher-Message-Date -message "Import des entités $premier à $dernier du thème $($parametres.theme)"

            SIg-Executer-Fichier `                -bdd $parametres.bdd `                -sortie "$($parametres.dossierRapports)\$($parametres.theme) - $(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import de $premier à $dernier.txt" `                -fichier "$dossierTravailTemp\bdtopo_peupler\copy_$($parametres.theme) (offset $premier).sql"

            Remove-Item -Path "$dossierTravailTemp\bdtopo_peupler\copy_$($parametres.theme) (offset $premier).sql"
            
            $premier = $dernier + 1

            $fichierSQL = "$dossierTravailTemp\bdtopo_peupler\copy_$($parametres.theme) (offset $premier).sql"
            $ecriture = [System.IO.StreamWriter]::new($fichierSQL)
            $ecriture.WriteLine('set search_path to d, public;')
            $ecriture.WriteLine($ordreCopy)
        }
    }

    $lecture.Close()
    $lecture = $null

    Remove-Item -Path "$dossierTravailTemp\bdtopo_peupler\$($parametres.theme).sql"

    $ecriture.Close()
    $ecriture = $null

    if ($dernier -ge $premier) {
        Afficher-Message-Date -message "Import des entités $premier à $dernier du thème $($parametres.theme)"

        SIg-Executer-Fichier `            -bdd $parametres.bdd `            -sortie "$($parametres.dossierRapports)\$($parametres.theme) - $(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import de $premier à $dernier.txt" `            -fichier "$dossierTravailTemp\bdtopo_peupler\copy_$($parametres.theme) (offset $premier).sql"

        Remove-Item -Path "$dossierTravailTemp\bdtopo_peupler\copy_$($parametres.theme) (offset $premier).sql"
    }
    
}

$bdd = Choisir-Option 'Merci de choisir la base de données cible de l''import' -options $sigBDD, 'si3p0_qualif'

# nettoyage préalable
Remove-Item "$dossierRapports\*"
Remove-Item "$dossierTravailTemp\bdtopo_peupler\*"

SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tables de précalcul (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tables de précalcul (drop).txt"

# paramétrage des jobs d'import des données
$parametresJobs = [Collections.ArrayList]::new()

# administratif
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'commune'; typeGeometrie = 'MULTIPOLYGON'; dossierRapports = $dossierRapports })
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'departement'; typeGeometrie = 'MULTIPOLYGON'; dossierRapports = $dossierRapports })
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'epci'; typeGeometrie = 'MULTIPOLYGON'; dossierRapports = $dossierRapports })
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'region'; typeGeometrie = 'MULTIPOLYGON'; dossierRapports = $dossierRapports })

# bati
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'batiment'; typeGeometrie = 'MULTIPOLYGON'; dossierRapports = $dossierRapports })

# hydrographie
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'cours_d_eau'; typeGeometrie = 'MULTILINESTRING'; dossierRapports = $dossierRapports })
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'plan_d_eau'; typeGeometrie = 'MULTIPOLYGON'; dossierRapports = $dossierRapports })
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'surface_hydrographique'; typeGeometrie = 'MULTIPOLYGON'; dossierRapports = $dossierRapports })
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'troncon_hydrographique'; typeGeometrie = 'LINESTRING'; dossierRapports = $dossierRapports })

# occupation du sol
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'zone_de_vegetation'; typeGeometrie = 'MULTIPOLYGON'; dossierRapports = $dossierRapports })

# services et activités
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'ligne_electrique'; typeGeometrie = 'LINESTRING'; dossierRapports = $dossierRapports })
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'zone_d_activite_ou_d_interet'; typeGeometrie = 'MULTIPOLYGON'; dossierRapports = $dossierRapports })

# transport
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'point_de_repere'; typeGeometrie = 'POINT'; dossierRapports = $dossierRapports })
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'route_numerotee_ou_nommee'; typeGeometrie = 'MULTILINESTRING'; dossierRapports = $dossierRapports })
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'troncon_de_route'; typeGeometrie = 'LINESTRING'; dossierRapports = $dossierRapports })
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'troncon_de_voie_ferree'; typeGeometrie = 'LINESTRING'; dossierRapports = $dossierRapports })
[void]$parametresJobs.Add(@{ script = $Job_Importer_BDTopo; racineAPI = "$PSScriptRoot\..\..\API\PowerShell"; archiveBDTopo = $archiveBDTopo; bdd = $bdd; theme = 'voie_ferree_nommee'; typeGeometrie = 'MULTILINESTRING'; dossierRapports = $dossierRapports })

# exécution des jobs d'import des données
Executer-Jobs -parametresJobs $parametresJobs -nombreJobs 3

# création des index
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\index (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - index (create).txt"

# création des tables de précalcul
SIg-Paralleliser-Fichier-Transactions -fichier "$dossierSQL\tables de précalcul (create).sql" -dossierSortie $dossierRapports