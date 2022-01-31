-- Recherche des discontinuités pouvant nécessiter la création de tronçons fictifs.
with Giratoire as (
    select ST_CollectionExtract(unnest(ST_ClusterIntersecting(Geom)), 2) as Geom
    from BDT2RR_Troncon
    where Nature = 'Rond-point'
),
UnionTronconEtGiratoire as (
    select NumeroRoute, ClasseAdmin, Geom
    from BDT2RR_Troncon
    union
    select distinct t.NumeroRoute, t.ClasseAdmin, g.Geom
    from Giratoire g
    inner join BDT2RR_Troncon t on ST_Intersects(t.Geom, g.Geom)
)
select NumeroRoute, array_length(ST_ClusterIntersecting(Geom), 1) as NbParties
from UnionTronconEtGiratoire
where ClasseAdmin = 'Départementale'
group by NumeroRoute
having array_length(ST_ClusterIntersecting(Geom), 1) > 1
order by NumeroRoute;