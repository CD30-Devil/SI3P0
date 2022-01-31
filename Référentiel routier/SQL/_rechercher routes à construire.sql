-- Seules les routes départementales sont à construire.
select NumeroRoute
from Route
where ClasseAdmin = 'Départementale'
order by NumeroRoute;