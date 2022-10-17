. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")
. ("$PSScriptRoot\..\..\API\PowerShell\constantes_privées.ps1")

# constantes
$dossierRapports = "$PSScriptRoot\..\Rapports\LàS_4h_notifier"

# nettoyage préalable
Remove-Item -Path "$dossierRapports\*.*"

# préparation des données
SIg-Exporter-CSV `    -csv "$dossierRapports\infos_commune_aleatoire.csv" `    -requete @"
with InfosDepartement as (
    select d.COGDepartement, sum(Population) as Population, count(c.COGCommune) as NbCommunes
    from m.Commune c
    inner join m.Departement d on c.COGDepartement = d.COGDepartement
    group by d.COGDepartement
),
InfosRegion as (
    select r.COGRegion, sum(Population) as Population, count(c.COGCommune) as NbCommunes
    from m.Commune c
    inner join m.Departement d on c.COGDepartement = d.COGDepartement
    inner join m.Region r on d.COGRegion = r.COGRegion
    group by r.COGRegion
),
InfosCommune as (
    select
        c.COGCommune, c.Nom as NomCommune, c.CodePostal as CPCommune, round(ST_Area(c.Geom)::numeric / 10000) as HectaresCommune, c.Population as PopulationCommune,
        
        d.COGDepartement, d.Nom as NomDepartement, id.NbCommunes as NbCommunesDepartement,
        row_number() over(partition by d.COGDepartement order by ST_Area(c.Geom) desc) as PositionSuperficieDepartement,
        round((ST_Area(c.Geom)::numeric * 1000 / ST_Area(d.Geom)::numeric), 3) as PartSuperficieDepartement,
        row_number() over(partition by d.COGDepartement order by c.Population desc) as PositionPopulationDepartement,
        round((c.Population::numeric * 1000 / id.Population), 3) as PartPopulationDepartement,
        
        r.COGRegion, r.Nom as NommRegion, ir.NbCommunes as NbCommunesRegion,
        row_number() over(partition by r.COGRegion order by ST_Area(c.Geom) desc) as PositionSuperficieRegion,
        round((ST_Area(c.Geom)::numeric * 1000 / ST_Area(r.Geom)::numeric), 3) as PartSuperficieRegion,
        row_number() over(partition by r.COGRegion order by c.Population desc) as PositionPopulationRegion,
        round((c.Population::numeric * 1000 / ir.Population), 3) as PartPopulationRegion,
        
        ST_X(ST_Transform(ST_Centroid(c.Geom), 4326)) as X,
        ST_Y(ST_Transform(ST_Centroid(c.Geom), 4326)) as Y,
        
        '"https://www.geoportail.gouv.fr/carte?c=' || ST_X(ST_Transform(ST_Centroid(c.Geom), 4326)) || ',' || ST_Y(ST_Transform(ST_Centroid(c.Geom), 4326)) || '&z=13&l0=ORTHOIMAGERY.ORTHOPHOTOS::GEOPORTAIL:OGC:WMTS(1)&l1=LIMITES_ADMINISTRATIVES_EXPRESS.LATEST::GEOPORTAIL:OGC:WMTS(1)&permalink=yes"' as LienGeoportail,
        '"https://www.geoportail.gouv.fr/embed/visu.html?c=' || ST_X(ST_Transform(ST_Centroid(c.Geom), 4326)) || ',' || ST_Y(ST_Transform(ST_Centroid(c.Geom), 4326)) || '&z=13&l0=ORTHOIMAGERY.ORTHOPHOTOS::GEOPORTAIL:OGC:WMTS(1;g)&l1=LIMITES_ADMINISTRATIVES_EXPRESS.LATEST::GEOPORTAIL:OGC:WMTS(1)&permalink=yes"' as LienGeoportailLimiteAdm,
        '"https://www.geoportail.gouv.fr/embed/visu.html?c=' || ST_X(ST_Transform(ST_Centroid(c.Geom), 4326)) || ',' || ST_Y(ST_Transform(ST_Centroid(c.Geom), 4326)) || '&z=13&l0=ORTHOIMAGERY.ORTHOPHOTOS::GEOPORTAIL:OGC:WMTS(1;g)&l1=INSEE.FILOSOFI.POPULATION::GEOPORTAIL:OGC:WMTS(0.8)&l2=LIMITES_ADMINISTRATIVES_EXPRESS.LATEST::GEOPORTAIL:OGC:WMTS(1)&permalink=yes"' as LienGeoportailDensitePop,
        '"https://www.geoportail.gouv.fr/embed/visu.html?c=' || ST_X(ST_Transform(ST_Centroid(c.Geom), 4326)) || ',' || ST_Y(ST_Transform(ST_Centroid(c.Geom), 4326)) || '&z=13&l0=OCSGE.COUVERTURE::GEOPORTAIL:OGC:WMTS(0.6)&l1=LIMITES_ADMINISTRATIVES_EXPRESS.LATEST::GEOPORTAIL:OGC:WMTS(1)&permalink=yes"' as LienGeoportailODS,
        '"https://www.amf.asso.fr/annuaire-communes-intercommunalites?refer=commune&insee=' || COGCommune || '"' as LienAMF
        
    from m.Commune c
    inner join m.Departement d on c.COGDepartement = d.COGDepartement
    inner join InfosDepartement id on d.COGDepartement = id.COGDepartement
    inner join m.Region r on d.COGRegion = r.COGRegion
    inner join InfosRegion ir on r.COGRegion = ir.COGRegion
    where d.COGRegion = '76'
)
select *
from InfosCommune
order by random()
limit 1
"@

$infosCommune = Import-Csv `    -Delimiter ';' `    -Path "$dossierRapports\infos_commune_aleatoire.csv" | select -First 1

# création de l'objet d'identification
$idsTwitter = Twitter-Creer-Identifiants `
    -cle $cleTwitter1J1C_Occitanie `    -cleSecrete $cleSecreteTwitter1J1C_Occitanie `    -jeton $jetonTwitter1J1C_Occitanie `    -jetonSecret $jetonSecretTwitter1J1C_Occitanie

# publication des tweets

# Message 1 - Introduction
Chromium-Capturer-Page `    -url $infosCommune.LienGeoportailLimiteAdm `
    -sortie "$dossierRapports\$($infosCommune.COGCommune)_limite_adm.png" `    -delaiMaxProcess 120 `    -delaiChargement 30

$retour = Twitter-Televerser-Media `    -identifiants $idsTwitter `    -cheminMedia "$dossierRapports\$($infosCommune.COGCommune)_limite_adm.png"

$idMedia = $retour.media_id

$retour = Twitter-Modifier-Statut `    -identifiants $idsTwitter `    -lat $infosCommune.Y `    -long $infosCommune.X `    -idMedias $idMedia `    -statut @"
Bonjour, aujourd'hui je vais vous parler de $($infosCommune.NomCommune), l'une des $($infosCommune.NbCommunesRegion) communes de la région #Occitanie.
"@

$idMessage = $retour.id

# Message 2 - COG/CP
$retour = Twitter-Modifier-Statut `    -identifiants $idsTwitter `    -lat $infosCommune.Y `    -long $infosCommune.X `    -enReponseA $idMessage `    -statut @"
Le Code Officiel Géographique (COG) de $($infosCommune.NomCommune) est : $($infosCommune.COGCommune).
Son code postal est : $($infosCommune.CPCommune).
"@

$idMessage = $retour.id

# Message 3 - Département
$retour = Twitter-Modifier-Statut `    -identifiants $idsTwitter `
    -lat $infosCommune.Y `    -long $infosCommune.X `    -enReponseA $idMessage `    -statut @"
Vous l'aurez peut-être deviné, le département de $($infosCommune.NomCommune) est : $($infosCommune.NomDepartement) ($($infosCommune.COGDepartement)).
"@

$idMessage = $retour.id

# Message 4 - Population
Chromium-Capturer-Page `    -url $infosCommune.LienGeoportailDensitePop `    -sortie "$dossierRapports\$($infosCommune.COGCommune)_densite_pop.png" `    -delaiMaxProcess 120 `    -delaiChargement 30

$retour = Twitter-Televerser-Media `    -identifiants $idsTwitter `
    -cheminMedia "$dossierRapports\$($infosCommune.COGCommune)_densite_pop.png"

$idMedia = $retour.media_id

$retour = Twitter-Modifier-Statut `    -identifiants $idsTwitter `    -lat $infosCommune.Y `    -long $infosCommune.X `    -enReponseA $idMessage `    -idMedias $idMedia `    -statut @"
Sa population est de $($infosCommune.PopulationCommune) hab. ce qui la place en numéro $($infosCommune.PositionPopulationDepartement)/$($infosCommune.NbCommunesDepartement) dans son département et en $($infosCommune.PositionPopulationRegion)/$($infosCommune.NbCommunesRegion) en #Occitanie.

Cela représente $($infosCommune.PartPopulationDepartement) ‰ de la population du département et $($infosCommune.PartPopulationRegion) ‰ de la région.
"@

$idMessage = $retour.id

# Message 5 - Superficie
Chromium-Capturer-Page `    -url $infosCommune.LienGeoportailODS `    -sortie "$dossierRapports\$($infosCommune.COGCommune)_ods.png" `    -delaiMaxProcess 120 `    -delaiChargement 30

$retour = Twitter-Televerser-Media `    -identifiants $idsTwitter `    -cheminMedia "$dossierRapports\$($infosCommune.COGCommune)_ods.png"

$idMedia = $retour.media_id

$retour = Twitter-Modifier-Statut `    -identifiants $idsTwitter `    -lat $infosCommune.Y `    -long $infosCommune.X `    -enReponseA $idMessage `    -idMedias $idMedia `    -statut @"
Sa superficie est de $($infosCommune.HectaresCommune) hect. ce qui la place en numéro $($infosCommune.PositionSuperficieDepartement)/$($infosCommune.NbCommunesDepartement) dans son département et en $($infosCommune.PositionSuperficieRegion)/$($infosCommune.NbCommunesRegion) en #Occitanie.

Cela représente $($infosCommune.PartSuperficieDepartement) ‰ de la superficie du département et $($infosCommune.PartSuperficieRegion) ‰ de la région.
"@

$idMessage = $retour.id

# Message 6 - AMF
Chromium-Capturer-Page `    -url $infosCommune.LienAMF `    -sortie "$dossierRapports\$($infosCommune.COGCommune)_amf.png" `    -delaiMaxProcess 120 `    -delaiChargement 30

$retour = Twitter-Televerser-Media `    -identifiants $idsTwitter `    -cheminMedia "$dossierRapports\$($infosCommune.COGCommune)_amf.png"

$idMedia = $retour.media_id

$retour = Twitter-Modifier-Statut `    -identifiants $idsTwitter `    -lat $infosCommune.Y `    -long $infosCommune.X `    -enReponseA $idMessage `    -idMedias $idMedia `    -statut @"
Vous trouverez plus d'informations sur l'annuaire de l'Association des Maires de France (#AMF) grâce à ce lien :
$($infosCommune.LienAMF)
"@

$idMessage = $retour.id

# Message 7 - GéoPortail
$retour = Twitter-Modifier-Statut `    -identifiants $idsTwitter `    -lat $infosCommune.Y `    -long $infosCommune.X `    -enReponseA $idMessage `    -statut @"
Et plusieurs ressources sur le #GéoPortail de l'#IGN :
$($infosCommune.LienGeoPortail)
"@