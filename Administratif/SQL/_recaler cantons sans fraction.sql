-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;

-- Recalage par alignement sur les communes qui composent le canton
with CommuneMultiCantons as (
    -- recherche des communes participants à plusieurs cantons
    select COGCommune
    from Commune_Canton
    group by COGCommune
    having count(COGCanton) > 1
),
CantonSansFractionCommune as (
    -- recherche des cantons sans fraction de communes
    select COGCanton
    from Canton
    except
    select COGCanton
    from Commune_Canton cc
    inner join CommuneMultiCantons cmc on cmc.COGCommune = cc.COGCommune
),
UnionCommunes as (
    -- pour chaque canton sans fraction, calcul de l'union des géométries des communes qui le composent
    select csfc.COGCanton, ST_Multi(ST_Union(co.Geom)) as Geom
    from CantonSansFractionCommune csfc
    inner join Commune_Canton cc on cc.COGCanton = csfc.COGCanton
    inner join Commune co on co.COGCommune = cc.COGCommune
    group by csfc.COGCanton
)
-- mise à jour de la géométries des cantons sans fraction de communes
update Canton ca
set Geom = uc.Geom
from UnionCommunes uc
where ca.COGCanton = uc.COGCanton;