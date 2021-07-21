-- schémas spécifiques SI3P0 (f = fonctions, m = modèle)
set search_path to f, m, public;

-- ----------------------------------------------------------------------------
-- Recherche dans la base adresses celles qui peuvent correspondre aux éléments
-- passés en paramètre.
-- Les résulats sont classés dans l'ordre de pertinence.
-- Paramètres :
--   - _Numero : Le numéro.
--   - _Repetition : La répétition du numéro.
--   - _NomVoie : Le nom de la voie.
--   - _COGCommune : Le code INSEE de la commune.
--   - _SeuilPertinence (défaut : 5) : Le seuil de pertinence avec ;
--       -> 1 : recherche de l'adresse exacte
--       -> 2 : recherche de l'adresse exacte avec tolérance sur les accents et
--              les caractères non-alphanumériques
--       -> 3 : recherche d'une adresse dans la même rue
--       -> 4 : recherche d'une adresse dans la même rue avec tolérance sur les
--              accents et les caractères non-alphanumériques
--       -> 5 : recherche floue basée sur une expression régulière
--       -> 6 : recherche par proximité syntaxique
--   - _Limit (défaut : 1) : Le nombre maximal d'adresses à retourner.
-- Résultats :
--   - Les adresses correspondantes classées par pertinence et différence de
--     numéro dans la rue.
-- ----------------------------------------------------------------------------
create or replace function RechercherAdresse(_Numero integer, _Repetition character varying, _NomVoie character varying, _COGCommune character varying, _SeuilPertinence integer default 6, _Limit integer default 1) returns table (_IdAdresse integer, _Pertinence integer, _DifferenceNumero integer) as $$
declare
    _NomVoieMinuscule character varying;
    _SansMentionLieuDit character varying;
    _RepetitionMinuscule character varying;
begin
    if (_NomVoie is null
        or _NomVoie = ''
        or _COGCommune is null
        or _COGCommune = '') then
        return;
    end if;
    
    select Lower(_NomVoie) into _NomVoieMinuscule;
    select regexp_replace(_NomVoieMinuscule, '^\s*lieu\Wdit\s*', '', 'i') into _SansMentionLieuDit;
    select Lower(_Repetition) into _RepetitionMinuscule;
    
    -- Pertinence 1 : recherche de l'adresse exacte
    return query (
        select a.IdAdresse, 1 as Pertinence, 0 as DifferenceNumero
        from Adresse a
        where (a.COGCommune = _COGCommune)
        and (a.Numero = _Numero)
        and (_RepetitionMinuscule is null or Lower(a.Repetition) = _RepetitionMinuscule)
        and (Lower(a.NomVoie) = _NomVoieMinuscule or Lower(a.NomVoie) = _SansMentionLieuDit)
        order by a.Source
        limit _Limit
    );
    
    if (found or _SeuilPertinence < 2) then
        return;
    end if;
    
    -- Pertinence 2 : recherche de l'adresse exacte avec tolérance sur les accents et les caractères non-alphanumériques
    return query (
        select a.IdAdresse, 2 as Pertinence, 0 as DifferenceNumero
        from Adresse a
        where (a.COGCommune = _COGCommune)
        and (a.Numero = _Numero)
        and (_RepetitionMinuscule is null or UnAccent(Lower(a.Repetition)) = UnAccent(_RepetitionMinuscule))
        and (RegExp_Replace(UnAccent(Lower(a.NomVoie)), '\W', ' ', 'g') = RegExp_Replace(UnAccent(_NomVoieMinuscule), '\W', ' ', 'g') or RegExp_Replace(UnAccent(Lower(a.NomVoie)), '\W', ' ', 'g') = RegExp_Replace(UnAccent(_SansMentionLieuDit), '\W', ' ', 'g'))
        order by a.Source
        limit _Limit
    );
    
    if (found or _SeuilPertinence < 3) then
        return;
    end if;
    
    -- Pertinence 3 : recherche d'une adresse dans la même rue
    return query (
        select a.IdAdresse, 3 as Pertinence, @(a.Numero - _Numero::integer) as DifferenceNumero
        from Adresse a
        where (a.COGCommune = _COGCommune)
        and (Lower(a.NomVoie) = _NomVoieMinuscule or Lower(a.NomVoie) = _SansMentionLieuDit)
        order by DifferenceNumero, a.Repetition, a.Source
        limit _Limit
    );
    
    if (found or _SeuilPertinence < 4) then
        return;
    end if;
    
    -- Pertinence 4 : recherche d'une adresse dans la même rue avec tolérance sur les accents et les caractères non-alphanumériques
    return query (
        select a.IdAdresse, 4 as Pertinence, @(a.Numero - _Numero::integer) as DifferenceNumero
        from Adresse a
        where (a.COGCommune = _COGCommune)
        and (RegExp_Replace(UnAccent(Lower(a.NomVoie)), '\W', ' ', 'g') = RegExp_Replace(UnAccent(_NomVoieMinuscule), '\W', ' ', 'g') or RegExp_Replace(UnAccent(Lower(a.NomVoie)), '\W', ' ', 'g') = RegExp_Replace(UnAccent(_SansMentionLieuDit), '\W', ' ', 'g'))
        order by DifferenceNumero, a.Repetition, a.Source
        limit _Limit
    );
    
    if (found or _SeuilPertinence < 5) then
        return;
    end if;
    
    -- Pertinence 5 : recherche floue basée sur une expression régulière
    return query (
        select a.IdAdresse, 5 as Pertinence, @(a.Numero - _Numero::integer) as DifferenceNumero
        from Adresse a
        where (a.COGCommune = _COGCommune)
        and (UnAccent(a.NomVoie) ~* ('.*' || Array_To_String(Regexp_Split_To_Array(UnAccent(_NomVoieMinuscule), '\W'), '.*') || '.*'))
        order by
            DifferenceNumero,
            case when _RepetitionMinuscule is null or _RepetitionMinuscule = '' then a.Repetition end,
            case when _RepetitionMinuscule is not null and _RepetitionMinuscule <> '' then Similarity(UnAccent(Lower(a.Repetition)), UnAccent(_RepetitionMinuscule)) end desc,
            a.Source
        limit _Limit
    );
    
    if (found or _SeuilPertinence < 6) then
        return;
    end if;
    
    -- Pertinence 6 : recherche par proximité syntaxique
    return query (
        select a.IdAdresse, 6 as Pertinence, @(a.Numero - _Numero::integer) as DifferenceNumero
        from Adresse a
        where (a.COGCommune = _COGCommune)
        order by
            Similarity(UnAccent(Lower(a.NomVoie)), UnAccent(_NomVoieMinuscule)) desc,
            DifferenceNumero,
            case when _RepetitionMinuscule is null or _RepetitionMinuscule = '' then a.Repetition end,
            case when _RepetitionMinuscule is not null and _RepetitionMinuscule <> '' then Similarity(UnAccent(Lower(a.Repetition)), UnAccent(_RepetitionMinuscule)) end desc,
            a.Source
        limit _Limit
    );

end;
$$ language plpgsql;

-- ----------------------------------------------------------------------------
-- Recherche dans la base adresses celles qui peuvent correspondre aux éléments
-- passés en paramètre.
-- Les résulats sont classés dans l'ordre de pertinence.
-- Paramètres :
--   - _Adresse : L'adresse (numéro, répétition et nom de voie).
--   - _COGCommune : Le code INSEE de la commune.
--   - _SeuilPertinence (défaut : 4) : Le seuil de pertinence :
--       -> 1 : recherche de l'adresse exacte
--       -> 2 : recherche de l'adresse exacte avec tolérance sur les accents et
--              les caractères non-alphanumériques
--       -> 3 : recherche d'une adresse dans la même rue
--       -> 4 : recherche d'une adresse dans la même rue avec tolérance sur les
--              accents et les caractères non-alphanumériques
--       -> 5 : recherche floue basée sur une expression régulière
--       -> 6 : recherche par proximité syntaxique
--   - _Limit (défaut : 1) : Le nombre maximal d'adresses à retourner.
-- Résultats :
--   - Les adresses correspondantes classées par pertinence et différence de
--     numéro dans la rue.
-- ----------------------------------------------------------------------------
create or replace function RechercherAdresse(_Adresse character varying, _COGCommune character varying, _SeuilPertinence integer default 6, _Limit integer default 1) returns table (_IdAdresse integer, _Pertinence integer, _DifferenceNumero integer) as $$
declare
    _Numero character varying;
    _Repetition character varying;
    _NomVoie character varying;
begin
    _NomVoie = _Adresse;
    
    -- extraction du numéro de l'adresse
    select substring(_NomVoie from '^[0-9]+') into strict _Numero;
    
    if (_Numero is not null) then
        select trim(substring(_NomVoie from length(_Numero) + 1)) into strict _NomVoie;
    else
        _Numero = '0';
    end if;
    
    -- extraction de la répétition de l'adresse
    select substring(_NomVoie from '\S+') into strict _Repetition;
    
    if exists(select true from Adresse where (COGCommune = _COGCommune) and UnAccent(Lower(Repetition)) = UnAccent(Lower(_Repetition)) limit 1) then
        select trim(substring(_NomVoie from length(_Repetition) + 1)) into strict _NomVoie;
    else
        _Repetition = '';
    end if;
    
    return query (select * from RechercherAdresse(_Numero::integer, _Repetition, _NomVoie, _COGCommune, _SeuilPertinence, _Limit));
end;
$$ language plpgsql;

-- ----------------------------------------------------------------------------
-- Recherche dans la base adresses celles se trouvant dans une commune et
-- proche d'un point donné.
-- Les résulats sont classés en fonction de l'éloignement au point.
-- Paramètres :
--   - _Point : Le point de recherche.
--   - _COGCommune : Le code INSEE de la commune.
--   - _Limit (défaut : 1) : Le nombre maximal d'adresses à retourner.
-- Résultats :
--   - Les adresses correspondantes classées en fonction de l'éloignement au point.
-- ----------------------------------------------------------------------------
create or replace function RechercherAdresse(_Point geometry, _COGCommune character varying, _Limit integer default 1) returns table (_IdAdresse integer, _Distance float) as $$

    with AdresseCommune as (
        select *
        from Adresse
        where COGCommune = _COGCommune
    )
    select
        IdAdresse,
        ST_Distance(Geom, TransformerEnL93(_Point))
    from AdresseCommune
    order by ST_Distance(Geom, TransformerEnL93(_Point)) asc
    limit _Limit

$$ language sql;