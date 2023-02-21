-- Insertions des routes utiles au référentiel routier résultat.
insert into Route (NumeroRoute, ClasseAdmin)

-- autoroutes et nationales sur l'emprise du département en construction.
select distinct t.NumeroRoute, t.ClasseAdmin
from BDT2RR_Troncon t
inner join BDT2RR_Departement d on ST_Intersects(d.Geom, t.Geom)
where t.ClasseAdmin in ('Autoroute', 'Nationale')

union

-- routes départementales du département en construction
select distinct t.NumeroRoute, t.ClasseAdmin
from BDT2RR_Troncon t
inner join BDT2RR_Departement d on d.COGDepartement = t.COGGestionnaireRoute
where t.ClasseAdmin = 'Départementale'

union

-- autres routes
-- TODO : Saisir ici, si nécessaire, la liste des routes n'appartenant pas au département mais utiles aux référentiels (car en convention de gestion par exemple).
select distinct t.NumeroRoute, t.ClasseAdmin
from BDT2RR_Troncon t
where t.ClasseAdmin = 'Départementale'
and t.NumeroRoute in ( 
    '34D107',
    '34D107E1',
    '34D107E4',
    '34D130E7',
    '34D17E6',
    '34D1E6',
    '34D25',
    '34D4',
    '34D4E13',
    '34D61',
    '48D118',
    '48D9'
);