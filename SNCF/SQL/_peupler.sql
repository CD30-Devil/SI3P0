-- schémas spécifiques SI3P0 (m = modèle, tmp = temporaire)
set search_path to m, tmp, public;

start transaction;

set constraints all deferred;

delete from PN;
delete from PortionLigneSNCF;
delete from LigneSNCF;

select pg_catalog.setval('pn_idpn_seq', 1, false);

-- insertion des lignes hors geom
insert into LigneSNCF (CodeLigneSNCF, Libelle)
select distinct code_ligne, lib_ligne
from source_lignesncf;

-- insertion des portions
insert into PortionLigneSNCF (IdGaia, CodeLigneSNCF, PKD, PKF, Statut, Geom)
with id_unique as (
    select distinct idgaia
    from source_lignesncf
)
select portion_unique.*
from id_unique
cross join lateral (
    select
        idgaia,
        code_ligne,
        pkd,
        pkf,
        statut,
        geom
    from source_lignesncf l
    where l.idgaia = id_unique.idgaia
    order by ST_NumPoints(geom) desc -- critère de choix totalement arbitraire
    limit 1
) portion_unique;

-- mise à jour des geom des lignes
with GeomLigne as (
    select CodeLigneSNCF, ST_Multi(ST_Union(Geom)) as Geom
    from PortionLigneSNCF
    group by CodeLigneSNCF
)
update LigneSNCF l
set Geom = gl.Geom
from GeomLigne gl
where l.CodeLigneSNCF = gl.CodeLigneSNCF;

-- insertion des PN
insert into PN (NumClassePN, CodeLigneSNCF, Libelle, Obstacle, PK, Geom)
select
    case
        when mnemo ~ 'CLASSE [0-9]{2}' then substring(mnemo from 8 for 2)::integer
    end,
    (select CodeLigneSNCF from LigneSNCF where CodeLigneSNCF = code_ligne),
    libelle,
    obstacle,
    pk,
    geom
from source_pn;

commit;