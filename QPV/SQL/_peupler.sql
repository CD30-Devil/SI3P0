start transaction;

set constraints all deferred;

delete from m.QPV_Commune;
delete from m.QPV;

-- insertion des quartiers prioritaires de la ville
insert into m.QPV (CodeQPV, Nom, Geom)
select Code_QP, Nom_QP, ST_CollectionExtract(ST_MakeValid(Geom), 3)
from tmp.QPV;

-- ajout du lien quartier prioritaire <-> commune
insert into m.QPV_Commune (CodeQPV, COGCommune)
select qp.CodeQPV, c.COGCommune
from m.QPV qp
inner join m.Commune c on ST_Intersects(qp.Geom, c.Geom) and not ST_Touches(qp.Geom, c.Geom)
where ST_IsValid(qp.Geom);

commit;