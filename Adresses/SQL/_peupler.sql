start transaction;

set constraints all deferred;

delete from m.Adresse;

select pg_catalog.setval('m.adresse_idadresse_seq', 1, false);

-- insertion des adresses Etalab
insert into m.Adresse (COGCommune, Numero, Repetition, NomVoie, Source, IdSource, Geom)
select
    code_insee,
    numero::integer,
    coalesce(rep, ''),
    nom_voie,
    '1-Etalab',
    id,
    FabriquerPointL93(x::numeric, y::numeric)
from tmp.Adresse_Etalab;

-- insertion des adresses "fictives" DGFIP
insert into m.Adresse (COGCommune, Numero, Repetition, NomVoie, Source, IdSource, Geom)
select
    commune_code,
    numero::integer,
    coalesce(suffixe, ''),
    voie_nom,
    '2-DGFIP',
    cle_interop,
    FabriquerPointL93(x::numeric, y::numeric)
from tmp.Adresse_DGFIP
where pseudo_numero = 'true';

commit;