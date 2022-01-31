-- Insertions des routes (départementales, nationales et autoroutes) présentes dans les données sources au référentiel routier résultat.
insert into Route (NumeroRoute, ClasseAdmin)
select distinct NumeroRoute, ClasseAdmin
from BDT2RR_Troncon
order by NumeroRoute;