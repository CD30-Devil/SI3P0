-- Les fonctions suivantes permettent de corriger/completer les données sources avant la construction.
-- Elles s'appliquent aux tables source_* créées par le fichier données de construction (create).sql.

-- Création d'un lien (éventuellement fictif) entre deux tronçons.
-- Le lien est créé seulement si les deux tronçons ont le même numéro de route.
--
-- Cette fonction est notamment utile pour la création de liens fictifs afin que les routes soient continues.
--
-- Paramètres :
-- - _CleAbs1 : La clé IGN du premier tronçon.
-- - _CleAbs2 : La clé IGN du second tronçon.
-- - _Extremites : Les extremités à relier, valeur parmi dd, ff, df, fd.
-- - _Fictif (défaut : true) : Booléen indiquant si le lien doit être fictif.
-- Résultats :
-- - Ajoute à la BDTopo un lien entre les deux tronçons.
-- - Retourne un texte indiquant si le lien a bien été créé.
create or replace function LierTroncons(_CleAbs1 character varying, _CleAbs2 character varying, _Extremites character varying, _Fictif boolean default true) returns varchar as $$
begin
    
    with Lien as (
        select
            'L' || right(t1.cleabs, 11) || '-' || right(t2.cleabs, 11)::character varying as cleabs,
            _Fictif as fictif,
            t1.liens_vers_route_nommee,
            case lower(_Extremites)
                when 'dd' then ST_MakeLine(ST_StartPoint(t1.geometrie), ST_StartPoint(t2.geometrie))
                when 'ff' then ST_MakeLine(ST_EndPoint(t1.geometrie), ST_EndPoint(t2.geometrie))
                when 'df' then ST_MakeLine(ST_StartPoint(t1.geometrie), ST_EndPoint(t2.geometrie))
                when 'fd' then ST_MakeLine(ST_EndPoint(t1.geometrie), ST_StartPoint(t2.geometrie))
            end as geometrie
        from source_troncon_de_route t1
        inner join source_troncon_de_route t2 on t1.cpx_numero = t2.cpx_numero -- pour ne pas relier deux routes distinctes
        where t1.cleabs = _CleAbs1
        and t2.cleabs = _CleAbs2
    )
    insert into source_troncon_de_route (cleabs, fictif, liens_vers_route_nommee, geometrie)
    select *
    from Lien l
    where not exists (select true from source_troncon_de_route where cleabs = l.cleabs);
    
    if (FOUND) then
        return ('Lien entre ' || _CleAbs1 || ' et ' || _CleAbs2 || ' créé.')::varchar;
    else
        return ('Avertissement : Lien entre ' || _CleAbs1 || ' et ' || _CleAbs2 || ' non créé.')::varchar;
    end if;
    
end;
$$ language plpgsql;

-- Modification du sens d'un tronçon.
-- La modification est faite seulement si la valeur de sens avant modification est différente de la valeur à appliquer.
-- 
-- Cette fonction peut être utile pour corriger le sens de circulation de tronçons en sens-unique.
-- Les erreurs de sens dans la BDTopo peuvent entrainer des manques lors de la recherche des giratoires.
-- 
-- Paramètres :
-- - _CleAbs : La clé IGN du tronçon dont on souhaite modifier le sens.
-- - _Sens : Le sens à appliquer au tronçon.
-- Résultats :
-- - Modifie dans la BDTopo le sens du tronçon si celui-ci n'est pas déjà égal à _Sens.
-- - Retourne un texte indiquant si le sens a bien été modifié.
create or replace function ModifierSens(_CleAbs character varying, _Sens character varying) returns varchar as $$
begin

    update source_troncon_de_route
    set sens_de_circulation = _Sens
    where cleabs = _CleAbs
    and sens_de_circulation is distinct from _Sens;
    
    if (FOUND) then
        return ('Sens de ' || _CleAbs || ' modifié.')::varchar;
    else
        return ('Avertissement : Sens de ' || _CleAbs || ' non modifié.')::varchar;
    end if;
    
end;
$$ language plpgsql;

-- Modification de l'altimétrie d'un tronçon.
-- La modification est faite seulement si la pente du tronçon avant modification est supérieure au seuil passé en paramètre.
-- 
-- Cette fonction force l'altimétrie de tous les points de la géométrie formant le tronçon.
-- Elle permet de corriger les tronçons qui ont manifestement un problème d'altimétrie du fait de leur pente moyenne.
-- Ces erreurs d'altimétrie ont une incidence sur la calcul de la longueur des routes.
-- 
-- Paramètres :
-- - _CleAbs : La clé IGN du tronçon dont on souhaite modifier l'altimétrie.
-- - _Z : L'altimétrie à appliquer au tronçon.
-- - _SeuilPente (défaut : 50) : Le seuil (en %) de pente en dessous duquel l'altimétrie ne doit pas être modifiée.
-- Résultats :
-- - Modifie dans la BDTopo l'altimétrie du tronçon si sa pente moyenne est supérieure à _SeuilPente.
-- - Retourne un texte indiquant si l'altimétrie a bien été modifiée.
create or replace function ModifierAltimetrie(_CleAbs character varying, _Z double precision, _SeuilPente integer default 50) returns varchar as $$
declare
    _NbPoints integer;
    _PointCourant integer;
    _Geom geometry;
    _Point geometry;
begin
    
    select ST_NumPoints(geometrie) into strict _NbPoints
    from source_troncon_de_route
    where cleabs = _CleAbs;
    
    select geometrie into strict _Geom
    from source_troncon_de_route
    where cleabs = _CleAbs;

    _PointCourant = 0;

    while (_PointCourant < _NbPoints)
    loop
        _Point = ST_PointN(_Geom, _PointCourant + 1);
        _Point = ST_MakePoint(ST_X(_Point), ST_Y(_Point), _Z, ST_M(_Point));
        _Geom = ST_SetPoint(_Geom, _PointCourant, _Point);
        
        _PointCourant = _PointCourant + 1;
    end loop;

    update source_troncon_de_route
    set geometrie = _Geom
    where cleabs = _CleAbs
    and CalculerPenteMoyenne(geometrie) > _SeuilPente;
    
    if (FOUND) then
        return ('Altimétrie de ' || _CleAbs || ' modifiée.')::varchar;
    else
        return ('Avertissement : Altimétrie de ' || _CleAbs || ' non modifiée.')::varchar;
    end if;
    
end;
$$ language plpgsql;

-- Création d'un route numérotée ou nommée.
-- La route est créée seulement si une route ne porte pas déjà la même valeur de CleAbs.
-- Paramètres :
-- - _CleAbs : L'identifiant de la route numérotée ou nommée à créer.
-- - _TypeDeRoute : Le type de la route (ex : Départementale).
-- - _Numero : Le numéro de la route (ex : D346).
-- - _Gestionnaire : Le gestionnaire de la route (ex : Gard)
-- Résultats :
-- - Ajoute à la BDTopo une route numérotée ou nommée si aucune autre route porteuse de la même _CleAbs existe au préalable.
-- - Retourne un texte indiquant si le route a bien été crée.
create or replace function CreerRouteNumeroteeOuNommee(_CleAbs character varying, _TypeDeRoute character varying, _Numero character varying, _Gestionnaire character varying) returns varchar as $$
begin

    insert into source_route_numerotee_ou_nommee (cleabs, type_de_route, numero, gestionnaire)
    select _CleAbs, _TypeDeRoute, _Numero, _Gestionnaire
    where not exists (
        select true
        from source_route_numerotee_ou_nommee
        where cleabs = _CleAbs
    );
    
    if (FOUND) then
        return ('Route numérotée ou nommée ' || _CleAbs || ' crée.')::varchar;
    else
        return ('Avertissement : Route numérotée ou nommée ' || _CleAbs || ' non crée.')::varchar;
    end if;
end
$$ language plpgsql;

-- Modification du lien vers la route numérotée ou nommée d'un tronçon.
-- La modification est faite seulement si le tronçon n'est pas déjà lié à la route numérotée ou nommmée.
--
-- Cette fonction peut par exemple servir à déclasser avant construction une section de route qui est toujours départementale selon l'IGN.
-- Les appels à cette fonction correspondent en général à des corrections à apporter à la BDTopo qu'il convient de signaler à l'IGN.
--
-- Paramètres :
-- - _CleAbs : La clé IGN du tronçon dont on souhaite modifier le lien.
-- - _CleAbsRouteNumeroteeOuNommee : La clé de la route numérotée ou nommée à lier au troncon.
-- Résultats :
-- - Modifie dans la BDTopo le lien vers la route numérotée ou nommée du tronçon si celui-ci n'est pas déjà égal à _CleAbs.
-- - Retourne un texte indiquant si le lien a bien été modifié.
create or replace function ModifierLienVersRouteNumeroteeOuNommee(_CleAbs character varying, _CleAbsRouteNumeroteeOuNommee character varying) returns varchar as $$
begin
    
    update source_troncon_de_route
    set liens_vers_route_nommee = _CleAbsRouteNumeroteeOuNommee
    where cleabs = _CleAbs
    and liens_vers_route_nommee is distinct from _CleAbsRouteNumeroteeOuNommee;
    
    if (FOUND) then
        return ('Lien vers la route numérotée ou nommée de ' || _CleAbs || ' modifié.')::varchar;
    else
        return ('Avertissement : Lien vers la route numérotée ou nommée de ' || _CleAbs || ' non modifié.')::varchar;
    end if;
    
end;
$$ language plpgsql;