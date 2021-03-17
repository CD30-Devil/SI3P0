create view tmp.Autoroute_4Layer as
select cpx_numero as "Numero", ST_Union(Geometrie) as Geom
from pc.bdtopo_troncon_d_autoroute
group by cpx_numero;

create view tmp.D30Autoroute_4Layer as
select cpx_numero as "Numero", ST_Union(GeoIntersect) as Geom
from pc.d30_bdtopo_troncon_d_autoroute
group by cpx_numero;

create view tmp.RN_4Layer as
select cpx_numero as "Numero", ST_Union(Geometrie) as Geom
from pc.bdtopo_troncon_de_nationale
group by cpx_numero;

create view tmp.D30RN_4Layer as
select cpx_numero as "Numero", ST_Union(GeoIntersect) as Geom
from pc.d30_bdtopo_troncon_de_nationale
group by cpx_numero;