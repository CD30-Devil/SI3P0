start transaction;

set constraints all deferred;

delete from m.ParcelleCadastrale_UniteLegale;
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
from tmp.Cadastre_LieuDit;

-- insertion des sections cadastrales
insert into m.SectionCadastrale (IdSectionCadastrale, COGCommune, Prefixe, Code)
select
    id,
    commune,
    prefixe,
    code
from tmp.Cadastre_Section;

-- insertion des sections manquantes vis à vis des parcelles
insert into m.SectionCadastrale (IdSectionCadastrale, COGCommune, Prefixe, Code)
select
    cp.commune || cp.prefixe || lpad(cp.section, 2, '0') as id,
    cp.commune,
    cp.prefixe,
    cp.section
from tmp.Cadastre_Parcelle cp
left join tmp.Cadastre_Section cs on cs.commune = cp.commune and cs.code = cp.section
where cs.Id is null
group by cp.commune, cp.prefixe, cp.section;

-- insertion des parcelles cadastrales
insert into m.ParcelleCadastrale (IdParcelleCadastrale, IdSectionCadastrale, Numero, Contenance, Geom)
select
    id,
    substring(id from 1 for 10),
    numero,
    contenance,
    geom
from tmp.Cadastre_Parcelle;

-- insertion des liens des ayants droit entre les parcelles cadastrales et les unités légales
insert into m.ParcelleCadastrale_UniteLegale (IdParcelleCadastrale, Siren, CodeDroitCadastral)
select
    distinct
    pc.IdParcelleCadastrale,
    ppm.siren,
    ppm.code_droit as CodeDroitCadastral
from tmp.ParcellePersonneMorale ppm
inner join m.ParcelleCadastrale pc on pc.IdParcelleCadastrale = (ppm.code_departement || ppm.code_commune || lpad(trim(ppm.prefixe), 3, '0') || lpad(ppm.section, 2, '0') || ppm.num_plan)
where Siren ~ '^\d{9}$';

commit;