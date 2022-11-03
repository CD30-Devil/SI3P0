-- schémas spécifiques SI3P0 (m = modèle, tmp = temporaire)
set search_path to m, tmp, public;

start transaction;

set constraints all deferred;

delete from ParcelleCadastrale_UniteLegale;
delete from ParcelleCadastrale;
delete from SectionCadastrale;
delete from LieuDit;

select pg_catalog.setval('lieudit_idlieudit_seq', 1, false);

-- insertion des lieux-dits
insert into LieuDit(COGCommune, Nom, Geom)
select
    commune,
    nom,
    geom
from source_cadastre_lieudit;

-- insertion des sections cadastrales
insert into SectionCadastrale (IdSectionCadastrale, COGCommune, Prefixe, Code)
select
    id,
    commune,
    prefixe,
    code
from source_cadastre_section;

-- insertion des sections manquantes vis à vis des parcelles
insert into SectionCadastrale (IdSectionCadastrale, COGCommune, Prefixe, Code)
select
    cp.commune || cp.prefixe || lpad(cp.section, 2, '0') as id,
    cp.commune,
    cp.prefixe,
    cp.section
from source_cadastre_parcelle cp
left join source_cadastre_section cs on cs.commune = cp.commune and cs.code = cp.section
where cs.Id is null
group by cp.commune, cp.prefixe, cp.section;

-- insertion des parcelles cadastrales
insert into ParcelleCadastrale (IdParcelleCadastrale, IdSectionCadastrale, Numero, Contenance, Geom)
select
    id,
    substring(id from 1 for 10),
    numero,
    contenance,
    geom
from source_cadastre_parcelle;

-- insertion des liens des ayants droit entre les parcelles cadastrales et les unités légales
insert into ParcelleCadastrale_UniteLegale (IdParcelleCadastrale, Siren, CodeDroitCadastral)
select
    distinct
    pc.IdParcelleCadastrale,
    ppm.siren,
    ppm.code_droit as CodeDroitCadastral
from source_parcelle_personnemorale ppm
inner join ParcelleCadastrale pc on pc.IdParcelleCadastrale = (ppm.code_departement || ppm.code_commune || lpad(trim(ppm.prefixe), 3, '0') || lpad(ppm.section, 2, '0') || ppm.num_plan)
where Siren ~ '^\d{9}$';

commit;