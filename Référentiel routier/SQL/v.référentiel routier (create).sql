-- schémas spécifiques SI3P0 (v = vues, m = modèle)
set search_path to v, m, public;

create or replace view TronconReel as
select t.*
from Troncon t
left join Giratoire g on g.IdGiratoire = t.IdGiratoire and t.NumeroRoute = g.NumeroRoute
where not t.Fictif
and (t.IdGiratoire is null or g.IdGiratoire is not null);