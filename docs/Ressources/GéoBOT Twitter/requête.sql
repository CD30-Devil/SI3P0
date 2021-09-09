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
        c.COGCommune, c.Nom as NomCommune, round(ST_Area(c.Geom)::numeric / 10000) as HectaresCommune, c.Population as PopulationCommune,
        
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
        
        'https://www.geoportail.gouv.fr/carte?c=' || ST_X(ST_Transform(ST_Centroid(c.Geom), 4326)) || ',' || ST_Y(ST_Transform(ST_Centroid(c.Geom), 4326)) || '&z=15&l0=ORTHOIMAGERY.ORTHOPHOTOS::GEOPORTAIL:OGC:WMTS(1)&l1=TRANSPORTNETWORKS.ROADS::GEOPORTAIL:OGC:WMTS(1)&permalink=yes' as LienGeoportail
        
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