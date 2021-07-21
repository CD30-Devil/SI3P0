start transaction;

set constraints all deferred;

delete from m.ParcelleCadastrale;
delete from m.SectionCadastrale;
delete from m.LieuDit;

select pg_catalog.setval('m.lieudit_idlieudit_seq', 1, false);

-- insertion des lieux-dits
insert into m.LieuDit(COGCommune, Nom, Geom)
select
    commune,
    nom,
    geom
from d.Cadastre_LieuDit;

-- insertion des sections cadastrales
insert into m.SectionCadastrale (IdSectionCadastrale, COGCommune, Prefixe, Code, Geom)
select
    id,
    commune,
    prefixe,
    code,
    geom
from d.Cadastre_Section;

-- insertion des parcelles cadastrales
insert into m.ParcelleCadastrale (IdParcelleCadastrale, IdSectionCadastrale, Numero, Contenance, Geom)
select
    id,
    substring(id from 1 for 10),
    numero,
    contenance,
    Geom
from d.Cadastre_Parcelle;

commit;