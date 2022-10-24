-- schémas spécifiques SI3P0 (m = modèle, tmp = temporaire)
set search_path to m, tmp, public;

start transaction;

set constraints all deferred;

delete from QPV_Commune;
delete from QPV;

-- insertion des quartiers prioritaires de la ville
insert into QPV (CodeQPV, Nom, Geom)
select Code_QP, Nom_QP, ST_CollectionExtract(ST_MakeValid(Geom), 3)
from source_qpv;

-- ajout du lien quartier prioritaire <-> commune
insert into QPV_Commune (CodeQPV, COGCommune)
select qp.CodeQPV, c.COGCommune
from QPV qp
inner join Commune c on ST_Intersects(qp.Geom, c.Geom) and not ST_Touches(qp.Geom, c.Geom)
where ST_IsValid(qp.Geom);

commit;