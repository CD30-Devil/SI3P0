-- schémas spécifiques SI3P0 (tmp = temporaire, m = données)
set search_path to tmp, d, public;

create view Autoroute_4Layer as
select cpx_numero as "Numero", ST_LineMerge(ST_Collect(Geometrie)) as Geom
from bdtopo_troncon_d_autoroute
group by cpx_numero;

create view D30Autoroute_4Layer as
select cpx_numero as "Numero", ST_LineMerge(ST_Collect(Geometrie)) as Geom
from d30_bdtopo_troncon_d_autoroute
group by cpx_numero;

create view RN_4Layer as
select cpx_numero as "Numero", ST_LineMerge(ST_Collect(Geometrie)) as Geom
from bdtopo_troncon_de_nationale
group by cpx_numero;

create view D30RN_4Layer as
select cpx_numero as "Numero", ST_LineMerge(ST_Collect(Geometrie)) as Geom
from d30_bdtopo_troncon_de_nationale
group by cpx_numero;

create view D30VoieFerreeAgregee_4Layer as
with Agregat as (
    select Nature, (ST_Dump(ST_LineMerge(ST_Collect(t.geometrie)))).Geom
    from d30_bdtopo_troncon_de_voie_ferree t
    group by Nature
)
select Nature as "Nature", ST_3DLength(Geom) as "Longueur", Geom
from Agregat;