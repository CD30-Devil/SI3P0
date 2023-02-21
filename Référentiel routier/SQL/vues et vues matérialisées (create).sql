-- NDLR : schémas spécifiques SI3P0 (m = modèle)
-- TODO : adapter le search_path en fonction de la structure de la BDD cible
set search_path to m, public;

create view TronconReel as
select t.*
from Troncon t
left join Giratoire g on g.IdGiratoire = t.IdGiratoire and t.NumeroRoute = g.NumeroRoute
where not t.Fictif
and (t.IdGiratoire is null or g.IdGiratoire is not null);