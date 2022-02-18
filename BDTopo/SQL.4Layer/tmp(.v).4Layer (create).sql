create view tmp.Autoroute_4Layer as
select cpx_numero as "Numero", ST_LineMerge(ST_Collect(Geometrie)) as Geom
from pc.bdtopo_troncon_d_autoroute
group by cpx_numero;

create view tmp.D30Autoroute_4Layer as
select cpx_numero as "Numero", ST_LineMerge(ST_Collect(Geometrie)) as Geom
from pc.d30_bdtopo_troncon_d_autoroute
group by cpx_numero;

create view tmp.RN_4Layer as
select cpx_numero as "Numero", ST_LineMerge(ST_Collect(Geometrie)) as Geom
from pc.bdtopo_troncon_de_nationale
group by cpx_numero;

create view tmp.D30RN_4Layer as
select cpx_numero as "Numero", ST_LineMerge(ST_Collect(Geometrie)) as Geom
from pc.d30_bdtopo_troncon_de_nationale
group by cpx_numero;

create view tmp.D30VoieFerreeAgregee_4Layer as
with Agregat as (
    select Nature, (ST_Dump(ST_LineMerge(ST_Collect(t.geometrie)))).Geom
    from d.bdtopo_troncon_de_voie_ferree t
    inner join v.Gard g on ST_Intersects(t.geometrie, g.Geom)
    group by Nature
)
select Nature as "Nature", ST_3DLength(Geom) as "Longueur", Geom
from Agregat;