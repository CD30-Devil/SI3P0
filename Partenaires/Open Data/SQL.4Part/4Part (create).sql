\timing

-- schémas spécifiques SI3P0 (tmp = temporaire, m = modèle, d = données, f = fonctions)
set search_path to tmp, m, d, f, public;

-- >> 3V ----------------------------------------------------------------------

create materialized view D30_OpenData_3V_4Part as
with PointSegment as (
    select
        IdSegmentCyclable,
        (ST_DumpPoints(geom)).path[1] as NumPoint,
        ST_Z((ST_DumpPoints(geom)).geom) as AltiPoint
    from SegmentCyclable
),
DeniveleSegment as (
    select
        IdSegmentCyclable,
        case
            when AltiPoint > lead(AltiPoint, 1) over(partition by IdSegmentCyclable order by NumPoint) then AltiPoint - lead(AltiPoint, 1) over(partition by IdSegmentCyclable order by NumPoint)
            else 0
        end as DNegatif,
        case
            when AltiPoint < lead(AltiPoint, 1) over(partition by IdSegmentCyclable order by NumPoint) then lead(AltiPoint, 1) over(partition by IdSegmentCyclable order by NumPoint) - AltiPoint
            else 0
        end as DPositif
    from PointSegment
)
select
    ic.NumeroItineraireCyclable as "NumeroItineraire",
    ic.NomOfficiel as "NomItineraire",
    pc.Nom as "NomPortion",
    tpc.Description as "TypePortion",
    s.Description as "StatutSegment",
    r.Description as "RevetementSegment",
    sc.SensUnique  as "SensUniqueSegment",
    round(sum(dc.DNegatif)::numeric, 1) as "EstimationDNegatifSegment",
    round(sum(dc.DPositif)::numeric, 1) as "EstimationDPositifSegment",
    sc.SourceGeometrie as "SourceGeometrieSegment",
    sc.IdGeometrie as "IdGeometrieSegment",
    sc.Geom
from SegmentCyclable sc
inner join DeniveleSegment dc on dc.IdSegmentCyclable = sc.IdSegmentCyclable
left join Statut3V s on s.CodeStatut3V = sc.CodeStatut3V
left join Revetement3V r on r.CodeRevetement3V = sc.CodeRevetement3V
left join SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join TypePortionCyclable tpc on tpc.CodeTypePortionCyclable = pc.CodeTypePortionCyclable
left join PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
inner join ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable
where sc.CodeEtatAvancement3V = '4' and not sc.Fictif
group by ic.NumeroItineraireCyclable, pc.IdPortionCyclable, sc.IdSegmentCyclable, tpc.CodeTypePortionCyclable, r.CodeRevetement3V, s.CodeStatut3V, pi.Ordre
order by ic.NumeroItineraireCyclable, pi.Ordre;

create index D30_OpenData_3V_4Part_NumeroItineraire_IDX on D30_OpenData_3V_4Part ("NumeroItineraire");

-- << 3V ----------------------------------------------------------------------

-- >> référentiel routier -----------------------------------------------------

create view D30_OpenData_Troncon_4Part as
select
    IdTroncon as "IdTroncon",
    IdIGN as "IdIGN",
    NumeroRoute as "NumeroRoute",
    SirenProprietaire as "SirenProprietaire",
    SirenGestionCourante as "SirenGestionCourante",
    SirenVH as "SirenVH",
    CumulDistD as "CumulDistanceDebut",
    CumulDistF as "CumulDistanceFin",
    PRAEnTexte(CumulDistVersPRA(NumeroRoute, CumulDistD)) as "PRAbsDebut",
    PRAEnTexte(CumulDistVersPRA(NumeroRoute, CumulDistF)) as "PRAbsFin",
    Niveau as "Niveau",
    case when (RGC) then 'Vrai' else 'Faux' end as "RGC",
    RRIR as "RRIR",
    case when (ItineraireVert) then 'Vrai' else 'Faux' end as "ItineraireVert",
    case when (Urbain) then 'Vrai' else 'Faux' end as "Urbain",
    Nature as "Nature",
    NbVoies as "NbVoies",
    case (SensCirculation)
        when 1 then 'Croissant'
        when 2 then 'Décroissant'
        when 3 then 'Double'
    end as "SensCirculation",
    case when (Gauche) then 'Vrai' else 'Faux' end as "VoieGauche",
    PositionSol as "PositionParRapportAuSol",
    case when (GueOuRadier) then 'Vrai' else 'Faux' end as "GueOuRadier",
    IdGiratoire as "IdGiratoire",
    Geom
from TronconReel
where SirenProprietaire = '223000019'
or SirenGestionCourante = '223000019'
or SirenVH = '223000019';

create view D30_OpenData_PR_4Part as
select
    IdPR as "IdPR",
    pr.NumeroRoute as "NumeroRoute",
    CumulDist as "CumulDistance",
    PRAEnTexte(PRA) as "PRAbsTexte",
    PRA as "PRAbs",
    pr.Geom
from PR pr
inner join Troncon t on t.NumeroRoute = pr.NumeroRoute and ST_DWithin(t.Geom, pr.Geom, 0.5)
where t.SirenProprietaire = '223000019'
or t.SirenGestionCourante = '223000019'
or t.SirenVH = '223000019'
group by pr.IdPR;

create view D30_OpenData_Giratoire_4Part as
select
    g.IdGiratoire as "IdGiratoire",
    g.NumeroRoute as "NumeroRoute",
    min(t.CumulDistD) as "CumulDistance",
    PRAEnTexte(CumulDistVersPRA(g.NumeroRoute, min(t.CumulDistD))) as "PRAbs",
    max(t.Niveau) as "Niveau",
    g.Geom
from Giratoire g
inner join Troncon t on t.IdGiratoire = g.IdGiratoire and t.NumeroRoute = g.NumeroRoute
where t.SirenProprietaire = '223000019'
or t.SirenGestionCourante = '223000019'
or t.SirenVH = '223000019'
group by g.IdGiratoire;

create view D30_OpenData_RDAgregeeParNiveau_4Part as
select
    t.NumeroRoute as "NumeroRoute",
    t.Niveau as "Niveau",
    t.SirenProprietaire as "SirenProprietaire",
    t.SirenGestionCourante as "SirenGestionCourante",
    t.SirenVH as "SirenVH",
    ST_LineMerge(ST_Collect(t.Geom)) as Geom
from TronconReel t
where SirenProprietaire = '223000019'
or SirenGestionCourante = '223000019'
or SirenVH = '223000019'
group by t.NumeroRoute, t.Niveau, t.SirenProprietaire, t.SirenGestionCourante, t.SirenVH;

-- << référentiel routier -----------------------------------------------------

-- >> comparatif référentiel routier / OSM ------------------------------------

create view D30_OpenData_ComparatifRefRoutierOSM_4Part as
-- CTE de sélection des routes départementales du Gard selon le Gard
with rd_refroutier as (
    select
        regexp_replace(NumeroRoute, '^\d{2}D', 'D') as NumeroRoute,
        IdIGN,
        Geom
    from TronconReel
    where SirenProprietaire = '223000019'
    and IdGiratoire is null -- on exclut les giratoires de l'analyse car ils n'ont pas de numéro de route dans OSM
),
-- CTE de sélection des routes départementales du Gard selon OSM
rd_osm AS (
    select
        ref AS NumeroRoute,
        id as IdOSM,
        Geom
    from d30_osm_route_departementale
),
-- CTE de calcul des buffers 5m et 10m sur le réseau routier départemental selon le Gard
buffer_rd_refroutier as (
    select NumeroRoute, ST_Union(ST_Buffer(geom, 5)) as Buffer5, ST_Union(ST_Buffer(geom, 10)) as Buffer10
    from rd_refroutier
    group by NumeroRoute
),
-- CTE de calcul des buffers 5m et 10m sur le réseau routier départemental selon OSM
buffer_rd_osm as (
    select NumeroRoute, ST_Union(ST_Buffer(geom, 5)) as Buffer5, ST_Union(ST_Buffer(geom, 10)) as Buffer10
    from rd_osm
    group by NumeroRoute
),
-- CTE de superposition des buffers OSM sur le réseau routier départemental selon le Gard
refroutier_vs_osm as (
    select
        'Référentiel routier du Gard' as Source,
        rr.IdIGN as IdSource,
        
        case
            when recouvrement10_complet.NumeroRoute is null and recouvrement5_complet_autrerd.NumeroRoute is null then 'Possible omission'
            when recouvrement10_complet.NumeroRoute is null and recouvrement5_complet_autrerd.NumeroRoute is not null then 'Possible erreur de numérotation'
            when recouvrement10_complet.NumeroRoute is not null then 'Possible décalage de numérisation'
        end as NatureEcart,
        
        case
            when recouvrement10_complet.NumeroRoute is null and recouvrement5_complet_autrerd.NumeroRoute is null
                then concat_ws(' ', 'Cette section de', rr.NumeroRoute, 'présente dans le référentiel routier du Gard n''a pas d''équivalent dans les 10m sur OSM.')
            when recouvrement10_complet.NumeroRoute is null and recouvrement5_complet_autrerd.NumeroRoute is not null
                then concat_ws(' ', 'Cette section de', rr.NumeroRoute, 'présente dans le référentiel routier du Gard a un équivalent dans les 5m sur OSM mais avec le numéro', recouvrement5_complet_autrerd.NumeroRoute, '.')
            when recouvrement10_complet.NumeroRoute is not null
                then concat_ws(' ', 'Cette section de', rr.NumeroRoute, 'présente dans le référentiel routier du Gard a un équivalent sur OSM mais à plus de 5m.')
        end as Description,
        
        case
            when recouvrement5_partiel.NumeroRoute is null then rr.Geom
            else ST_Difference(rr.Geom, recouvrement5_partiel.Buffer5)
        end as Geom
        
    from rd_refroutier rr
    left join buffer_rd_osm recouvrement5_complet on recouvrement5_complet.NumeroRoute = rr.NumeroRoute and ST_Covers(recouvrement5_complet.Buffer5, rr.Geom)
    left join buffer_rd_osm recouvrement5_partiel on recouvrement5_partiel.NumeroRoute = rr.NumeroRoute and ST_Intersects(recouvrement5_partiel.Buffer5, rr.Geom)
    left join buffer_rd_osm recouvrement5_complet_autrerd on recouvrement5_complet_autrerd.NumeroRoute <> rr.NumeroRoute and ST_Covers(recouvrement5_complet_autrerd.Buffer5, rr.Geom)
    left join buffer_rd_osm recouvrement10_complet on recouvrement10_complet.NumeroRoute = rr.NumeroRoute and ST_Covers(recouvrement10_complet.Buffer10, rr.Geom)
    where recouvrement5_complet.NumeroRoute is null
),
-- CTE de superposition des buffers Gard sur le réseau routier départemental selon OSM
osm_vs_refroutier as (
    select
        'OpenStreetMap' as Source,
        osm.IdOSM as IdSource,
        
        case
            when recouvrement10_complet.NumeroRoute is null and recouvrement5_complet_autrerd.NumeroRoute is null then 'Possible excédent'
            when recouvrement10_complet.NumeroRoute is null and recouvrement5_complet_autrerd.NumeroRoute is not null then 'Possible erreur de numérotation'
            when recouvrement10_complet.NumeroRoute is not null then 'Possible décalage de numérisation'
        end as NatureEcart,
        
        case
            when recouvrement10_complet.NumeroRoute is null and recouvrement5_complet_autrerd.NumeroRoute is null
                then concat_ws(' ', 'Cette section de', osm.NumeroRoute, 'présente dans OSM n''a pas d''équivalent dans les 10m sur le référentiel routier du Gard.')
            when recouvrement10_complet.NumeroRoute is null and recouvrement5_complet_autrerd.NumeroRoute is not null
                then concat_ws(' ', 'Cette section de', osm.NumeroRoute, 'présente dans OSM a un équivalent dans les 5m sur le référentiel routier du Gard mais avec le numéro', recouvrement5_complet_autrerd.NumeroRoute, '.')
            when recouvrement10_complet.NumeroRoute is not null
                then concat_ws(' ', 'Cette section de', osm.NumeroRoute, 'présente dans OSM a un équivalent sur le référentiel routier du Gard mais à plus de 5m.')
        end as Description,
        
        case
            when recouvrement5_partiel.NumeroRoute is null then osm.Geom
            else ST_Difference(osm.Geom, recouvrement5_partiel.Buffer5)
        end as Geom
        
    from rd_osm osm
    left join buffer_rd_refroutier recouvrement5_complet on recouvrement5_complet.NumeroRoute = osm.NumeroRoute and ST_Covers(recouvrement5_complet.Buffer5, osm.Geom)
    left join buffer_rd_refroutier recouvrement5_partiel on recouvrement5_partiel.NumeroRoute = osm.NumeroRoute and ST_Intersects(recouvrement5_partiel.Buffer5, osm.Geom)
    left join buffer_rd_refroutier recouvrement5_complet_autrerd on recouvrement5_complet_autrerd.NumeroRoute <> osm.NumeroRoute and ST_Covers(recouvrement5_complet_autrerd.Buffer5, osm.Geom)
    left join buffer_rd_refroutier recouvrement10_complet on recouvrement10_complet.NumeroRoute = osm.NumeroRoute and ST_Covers(recouvrement10_complet.Buffer10, osm.Geom)
    where recouvrement5_complet.NumeroRoute is null
)
select Source, IdSource, NatureEcart, Description, ST_Multi(ST_Force2D(geom))
from refroutier_vs_osm
union all
select Source, IdSource, NatureEcart, Description, ST_Multi(ST_Force2D(geom))
from osm_vs_refroutier;

-- << comparatif référentiel routier / OSM ------------------------------------