-- schémas spécifiques SI3P0 (m = modèle, f = fonctions, tmp = temporaire)
set search_path to m, f, tmp, public;

start transaction;

set constraints all deferred;

delete from Adresse;

select pg_catalog.setval('adresse_idadresse_seq', 1, false);

-- insertion des adresses
insert into Adresse (COGCommune, Numero, Repetition, NomVoie, Source, IdSource, Position, Geom)
select
    commune_insee,
    numero::integer,
    coalesce(suffixe, ''),
    voie_nom,
    case source
        when 'commune' then '1-commune'
        when 'laposte' then '2-laposte'
        when 'arcep' then '3-arcep'
        when 'cadastre' then '4-cadastre'
        else '5-autre'
    end,
    cle_interop,
    case position
        when 'logement' then '1-logement'
        when 'cage d''escalier' then '2-cage d''escalier'
        when 'bâtiment' then '3-bâtiment'
        when 'entrée' then '4-entrée'
        when 'délivrance postale' then '5-délivrance postale'
        when 'parcelle' then '6-parcelle'
        when 'service technique' then '7-service technique'
        when 'segment' then '8-segment'
        else '9-autre'
    end,
    FabriquerPointL93(x::numeric, y::numeric)
from source_adresse;

commit;