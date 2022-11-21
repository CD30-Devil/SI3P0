. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\1erD_4h_moissonner"

# -----------------------------------------------------------------------------
# Job de moisson des "features" d'un rectangle donné.
#
# Format attendu de $parametres :
# .racineAPI : Le chemin vers le dossier racine de l'API PowerShell. 
# .IdRectangle : L'identifiant unique du rectangle.
# .XMinWGS84 : La coordonnée X min en WGS84 du rectangle.
# .YMinWGS84 : La coordonnée Y min en WGS84 du rectangle.
# .XMaxWGS84 : La coordonnée X max en WGS84 du rectangle.
# .YMaxWGS84 : La coordonnée Y max en WGS84 du rectangle.
# .XMinL93 : La coordonnée X min en Lambert93 du rectangle.
# .YMinL93 : La coordonnée Y min en Lambert93 du rectangle.
# .XMaxL93 : La coordonnée X max en Lambert93 du rectangle.
# .YMaxL93 : La coordonnée Y max en Lambert93 du rectangle.
# .dossierDonnees : Le chemin vers le dossier de sauvegarde des données.
# .dossierRapports : Le chemin vers le dossier de sortie des rapports.
# -----------------------------------------------------------------------------
$Job_Moissonner_Features_Rectangle = {
    param (
        [object] $parametres
    )

    . ("$($parametres.racineAPI)\api_complète.ps1")
    . ("$($parametres.racineAPI)\constantes_privées.ps1")

    
    $url = "https://graph.mapillary.com/map_features?access_token=$cleMapillary&fields=id,aligned_direction,first_seen_at,last_seen_at,object_value,object_type,geometry&bbox=$($parametres.XMinWGS84),$($parametres.YMinWGS84),$($parametres.XMaxWGS84),$($parametres.YMaxWGS84)"
    $resultat = Invoke-RestMethod -Uri $url
        
    if ($resultat.data.Count -ge 2000) {

        # si le résultat contient 2000 "features", c'est probablement qu'on a atteint la limite du nombre de "features" renvoyé par appel API
        # on va relancer la récupération des données sur de plus petits rectangles
        SIg-Exporter-CSV -csv "$($parametres.dossierRapports)\rectangles_$($parametres.IdRectangle).csv" -requete @"
            with Rectangle as (
                select ST_Polygon(
                    ST_MakeLine(
                        array[
                            ST_MakePoint($($parametres.XMinL93), $($parametres.YMinL93)),
                            ST_MakePoint($($parametres.XMinL93), $($parametres.YMaxL93)),
                            ST_MakePoint($($parametres.XMaxL93), $($parametres.YMaxL93)),
                            ST_MakePoint($($parametres.XMaxL93), $($parametres.YMinL93)),
                            ST_MakePoint($($parametres.XMinL93), $($parametres.YMinL93))
                        ]
                    ), 2154
                ) as Geom
            )
            select
                '$($parametres.IdRectangle)-' || row_number() over() as IdRectangle,

                ST_XMin(g.Geom) as XMinL93,
                ST_YMin(g.Geom) as YMinL93,
                ST_XMax(g.Geom) as XMaxL93,
                ST_YMax(g.Geom) as YMaxL93,

                ST_XMin(TransformerEnWGS84(g.Geom)) as XMinWGS84,
                ST_YMin(TransformerEnWGS84(g.Geom)) as YMinWGS84,
                ST_XMax(TransformerEnWGS84(g.Geom)) as XMaxWGS84,
                ST_YMax(TransformerEnWGS84(g.Geom)) as YMaxWGS84

            from Rectangle r
            cross join ST_SquareGrid((ST_Perimeter(r.Geom) / 4) / 4, r.Geom) g
            where ST_Intersects(r.Geom, g.Geom) and not ST_Touches(r.Geom, g.Geom)
"@

    }
    elseif ($resultat.data.Count -gt 0) {

        Afficher-Message-Date -message "$($resultat.data.Count) features trouvées dans le rectangle $($parametres.IdRectangle)" -couleur gray

        # si le résultat contient au moins une "feature", on sauvegarde le retour en CSV
        $features = $resultat.data | `            select `                id, `                aligned_direction, `                first_seen_at, `                last_seen_at, `                object_value, `                object_type, `                @{ label='x'; expression={ $_.geometry.coordinates[0] }}, `                @{ label='y'; expression={ $_.geometry.coordinates[1] }}            
        $features | Export-Csv -NoTypeInformation -Delimiter ';' -Path "$($parametres.dossierDonnees)\$($parametres.IdRectangle).csv"

    }

}

# nettoyage préalable
Remove-Item "$dossierDonnees\*"
Remove-Item "$dossierRapports\*"

# l'objectif est de récupèrer les "features" à proximité d'une RD
# on calcule pour cela une grille de 1600m de côté sur l'emprise du référentiel routier
# et on ne conserve que les rectangles qui se trouvent à moins de 25m d'un tronçon de RD
SIg-Exporter-CSV -csv "$dossierRapports\rectangles_initiaux.csv" -requete @'
    with Emprise as (
        select ST_Collect(Geom) as Geom
        from TronconReel
    ),
    Grille as (
        select g.Geom
        from Emprise e
        cross join ST_SquareGrid(1600, e.Geom) g
    )
    select
        lpad((row_number() over())::varchar, 4, '0') as IdRectangle,

        ST_XMin(g.Geom) as XMinL93,
        ST_YMin(g.Geom) as YMinL93,
        ST_XMax(g.Geom) as XMaxL93,
        ST_YMax(g.Geom) as YMaxL93,

        ST_XMin(TransformerEnWGS84(g.Geom)) as XMinWGS84,
        ST_YMin(TransformerEnWGS84(g.Geom)) as YMinWGS84,
        ST_XMax(TransformerEnWGS84(g.Geom)) as XMaxWGS84,
        ST_YMax(TransformerEnWGS84(g.Geom)) as YMaxWGS84

    from Grille g
    where exists (select true from TronconReel t where ST_DWithin(t.Geom, g.Geom, 25))
'@

# tant qu'il y a des fichiers CSV de rectangles
while (Test-Path "$dossierRapports\rectangles_*.csv") {
    
    $parametresJobs = [Collections.ArrayList]::new()

    # on itère sur les fichiers présents
    foreach ($csv in Get-ChildItem "$dossierRapports\rectangles_*.csv") {
        
        # pour paramètrer un job de moisson des "features" pour chaque rectangle
        $parametresJobs.AddRange((
            Import-Csv -Delimiter ';' -Path $csv | select `                @{Name = 'script'; Expression = {$Job_Moissonner_Features_Rectangle}}, `                @{Name = 'racineAPI'; Expression = {"$PSScriptRoot\..\..\API\PowerShell"}}, `                @{Name = 'IdRectangle'; Expression = {$_.IdRectangle}}, `                @{Name = 'XMinWGS84'; Expression = {$_.XMinWGS84}}, `                @{Name = 'YMinWGS84'; Expression = {$_.YMinWGS84}}, `                @{Name = 'XMaxWGS84'; Expression = {$_.XMaxWGS84}}, `                @{Name = 'YMaxWGS84'; Expression = {$_.YMaxWGS84}}, `                @{Name = 'XMinL93'; Expression = {$_.XMinL93}}, `                @{Name = 'YMinL93'; Expression = {$_.YMinL93}}, `                @{Name = 'XMaxL93'; Expression = {$_.XMaxL93}}, `                @{Name = 'YMaxL93'; Expression = {$_.YMaxL93}}, `                @{Name = 'dossierDonnees'; Expression = {$dossierDonnees}}, `                @{Name = 'dossierRapports'; Expression = {$dossierRapports}}
        ))

        # et on renomme le CSV pour qu'il ne soit plus candidat à la prochaine itération
        Move-Item $csv "$($csv.FullName).done"
    }    # on exécute les jobs    Executer-Jobs -parametresJobs $parametresJobs -nombreJobs (2 * ($env:NUMBER_OF_PROCESSORS - 1))
   
}