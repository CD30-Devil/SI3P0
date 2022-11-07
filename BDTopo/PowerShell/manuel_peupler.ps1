. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\manuel_peupler"
$dossierSQL = "$PSScriptRoot\..\SQL"

# détermine l'archive de la BDTopo la plus récente
$archiveBDTopo = Get-ChildItem "$dossierDonnees\BDTOPO_3-0_TOUSTHEMES_SQL_LAMB93_FXX_*.7z.001" | sort -Property Name -Descending | select -First 1

# liste des thèmes à importer
$themes = @(
    # administratif
    @{ nom = 'commune'; type = "geometry(MultiPolygon,2154)" }
    @{ nom = 'departement'; type = "geometry(MultiPolygon,2154)" }
    @{ nom = 'epci'; type = "geometry(MultiPolygon,2154)" }
    @{ nom = 'region'; type = "geometry(MultiPolygon,2154)" }
    
    # bati
    @{ nom = 'batiment'; type = "geometry(MultiPolygonZ,2154)" }

    # hydrographie
    @{ nom = 'cours_d_eau'; type = "geometry(MultiLineString,2154)" }
    @{ nom = 'plan_d_eau'; type = "geometry(MultiPolygon,2154)" }
    @{ nom = 'surface_hydrographique'; type = "geometry(MultiPolygonZ,2154)" }
    @{ nom = 'troncon_hydrographique'; type = "geometry(LineStringZ,2154)" }

    # occupation du sol
    @{ nom = 'zone_de_vegetation'; type = "geometry(MultiPolygon,2154)" }

    # services et activités
    @{ nom = 'ligne_electrique'; type = "geometry(LineStringZ,2154)" }
    @{ nom = 'zone_d_activite_ou_d_interet'; type = "geometry(MultiPolygon,2154)" }

    # transport
    @{ nom = 'point_de_repere'; type = "geometry(Point,2154)" }
    @{ nom = 'route_numerotee_ou_nommee'; type = "geometry(MultiLineString,2154)" }
    @{ nom = 'troncon_de_route'; type = "geometry(LineStringZ,2154)" }
    @{ nom = 'troncon_de_voie_ferree'; type = "geometry(LineStringZ,2154)" }
    @{ nom = 'voie_ferree_nommee'; type = "geometry(MultiLineString,2154)" }
)

# -----------------------------------------------------------------------------
# Job d'import d'un thème de la BDTopo dans le schéma d.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell.
# .archiveBDTopo : Le chemin vers l'archive de la BDTopo.
# .bdd : La base de données cible de l'import.
# .theme : Le nom du thème à importer. La table correspondante portera le nom
#          du thème préfixé par BDTopo_.
# .type : Le type de la géométrie à importer.
# .dossierRapports : Le chemin vers le dossier de sortie des rapports.
# -----------------------------------------------------------------------------
$Job_Importer_BDTopo = {
    param (
        $parametres
    )

    . ("$($parametres.racineAPI)\api_complète.ps1")
    
    $dossierExtraction = "$([IO.Path]::GetDirectoryName($parametres.archiveBDTopo))\extraction\"
    $theme = $parametres.theme

    # extraction du fichier SQL du thème
    Executer-7Z -commande 'e' -archive "`"$($parametres.archiveBDTopo)`"" -autresParams "-o`"$dossierExtraction`"", "-ir!$theme.sql", "-aoa"
    
    # génération d'un fichier de lancement qui fixe préalablement le search_path
    "set search_path to tmp, public; \ir '$theme.sql'" | Out-File "$dossierExtraction\lancement_$theme.sql" -Encoding utf8

    SIg-Executer-Fichier `        -bdd $parametres.bdd `        -fichier "$dossierExtraction\lancement_$theme.sql" `        -sortie "$($parametres.dossierRapports)\$theme - chargement.txt"

    Remove-Item "$dossierExtraction\lancement_$theme.sql"
    Remove-Item "$dossierExtraction\$theme.sql"

    SIg-Executer-Commande `        -bdd $parametres.bdd `        -sortie "$($parametres.dossierRapports)\$theme - transfert vers le schéma d.txt" `        -commande @"
            start transaction;

            drop table if exists d.bdtopo_$theme;
            create table d.bdtopo_$theme as select * from tmp.$theme limit 0;
            alter table d.bdtopo_$theme alter column geometrie set data type $($parametres.type);
            insert into d.bdtopo_$theme select * from tmp.$theme;

            drop table tmp.$theme;

            commit;
"@
}

$bdd = Choisir-Option 'Merci de choisir la base de données cible de l''import' -options $sigBDD, 'si3p0_qualif'

# nettoyage préalable
Remove-Item "$dossierRapports\*"
Remove-Item "$([IO.Path]::GetDirectoryName($archiveBDTopo))\extraction\*"

SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\tables de précalcul (drop).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - tables de précalcul (drop).txt"

# paramétrage des jobs d'import des données
$parametresJobs = [Collections.ArrayList]::new()

foreach ($theme in $themes) {

    [void]$parametresJobs.Add(@{
        script = $Job_Importer_BDTopo
        racineAPI = "$PSScriptRoot\..\..\API\PowerShell"
        archiveBDTopo = $archiveBDTopo; bdd = $bdd
        theme = $theme.nom
        type = $theme.type
        dossierRapports = $dossierRapports
    })

}

# exécution des jobs d'import des données
Executer-Jobs -parametresJobs $parametresJobs

# création des index
SIg-Executer-Fichier -bdd $bdd -fichier "$dossierSQL\index (create).sql" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - index (create).txt"

# création des tables de précalcul
SIg-Paralleliser-Fichier-Transactions -fichier "$dossierSQL\tables de précalcul (create).sql" -dossierSortie $dossierRapports