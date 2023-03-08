-- schémas spécifiques SI3P0 (m = modèle, tmp = temporaire)
set search_path to m, tmp, public;

start transaction;

set constraints all deferred;

delete from ConseillerMunicipal;

select pg_catalog.setval('conseillermunicipal_idconseillermunicipal_seq', 1, false);

-- insertion des conseillers municipaux
insert into ConseillerMunicipal (COGCommune, Sexe, Nom, Prenom, Fonction)
select
    CodeCommune,
    Sexe,
    NomElu,
    PrenomElu,
    LibelleFonction
from source_conseillermunicipal;

commit;