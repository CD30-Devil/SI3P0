-- Au Département du Gard, lorsque plusieurs routes départementales se rencontrent à un giratoire,
-- le giratoire est affecté à la route de plus haut niveau de service ou, si les niveaux sont égaux, à la route ayant le plus petit numéro.
-- 
-- Si cette requête n'est pas lancée, l'affectation par défaut est celle de la BDTopo.

with Critere as (
    select distinct
        IdGiratoire,
        NumeroRoute,
        min(Niveau) as Critere1,
        (regexp_replace(substring(NumeroRoute from 2), '\D.*', ''))::integer as Critere2,
        (regexp_replace(substring(NumeroRoute from 2), '^\d*', '')) as Critere3
    from Troncon
    where IdGiratoire is not null
    group by IdGiratoire, NumeroRoute
    order by IdGiratoire, Critere1, Critere2, Critere3
),
Classement as (
    select row_number() over(partition by IdGiratoire order by Critere1, Critere2) as Classement, *
    from Critere
),
NumeroRouteGiratoire as (
    select g.IdGiratoire, g.NumeroRoute as NumeroRouteActuel, c.NumeroRoute as NumeroRouteClassement, c.Classement, c.Critere1, c.Critere2, c.Critere3
    from Giratoire g
    inner join Route r on r.NumeroRoute = g.NumeroRoute
    inner join Classement c on c.IdGiratoire = g.IdGiratoire
    where r.ClasseAdmin = 'Départementale'
    and c.Classement = 1
)
update Giratoire g
set NumeroRoute = nrg.NumeroRouteClassement
from NumeroRouteGiratoire nrg
where g.IdGiratoire = nrg.IdGiratoire
and NumeroRoute <> nrg.NumeroRouteClassement;