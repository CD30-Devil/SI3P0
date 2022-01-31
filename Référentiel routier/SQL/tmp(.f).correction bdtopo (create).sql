-- Modification du sens d'un tronçon.
-- 
-- Cette fonction peut être utile pour corriger le sens de circulation de tronçons en sens-unique.
-- Les erreurs de sens dans la BDTopo peuvent entrainer des manques lors de la recherche des giratoires.
-- 
-- Paramètres :
-- - _IdIGN : L'identifiant IGN du tronçon dont on souhaite modifier le sens.
-- - _Sens : Le sens à appliquer au tronçon.
-- Résultats :
-- - Modifie dans la BDTopo (au travers de la vue BDT2RR_SourceTronconDeRoute) le sens du tronçon si celui-ci n'est pas déjà égal à _Sens.
-- - Retourne un texte indiquant si le sens a bien été modifié.
create or replace function ModifierSens(_IdIGN character varying, _Sens character varying) returns varchar as $$
begin

    update BDT2RR_SourceTronconDeRoute
    set sens_de_circulation = _Sens
    where cleabs = _IdIGN
    and sens_de_circulation is distinct from _Sens;
    
    if (FOUND) then
        return ('Sens de ' || _IdIGN || ' modifié.')::varchar;
    else
        return ('Avertissement : Sens de ' || _IdIGN || ' non modifié.')::varchar;
    end if;
    
end;
$$ language plpgsql;

-- Modification de l'altimétrie d'un tronçon.
-- 
-- Cette fonction force l'altimétrie de tous les points de la géométrie formant le tronçon.
-- Elle permet de corriger les tronçons qui ont manifestement un problème d'altimétrie du fait de leur pente moyenne.
-- Ces erreurs d'altimétrie ont une incidence sur la calcul de la longueur des routes.
-- 
-- Paramètres :
-- - _IdIGN : L'identifiant IGN du tronçon dont on souhaite modifier l'altimétrie.
-- - _Z : L'altimétrie à appliquer au tronçon.
-- - _SeuilPente (défaut : 50) : Le seuil (en %) de pente en dessous duquel l'altimétrie ne doit pas être modifiée.
-- Résultats :
-- - Modifie dans la BDTopo (au travers de la vue BDT2RR_SourceTronconDeRoute) l'altimétrie du tronçon si sa pente moyenne est supérieure à _SeuilPente.
-- - Retourne un texte indiquant si l'altimétrie a bien été modifiée.
create or replace function ModifierAltimetrie(_IdIGN character varying, _Z double precision, _SeuilPente integer default 50) returns varchar as $$
declare
    _NbPoints integer;
    _PointCourant integer;
    _Geom geometry;
    _Point geometry;
begin
    
    select ST_NumPoints(geometrie) into strict _NbPoints
    from BDT2RR_SourceTronconDeRoute
    where cleabs = _IdIGN;
    
    select geometrie into strict _Geom
    from BDT2RR_SourceTronconDeRoute
    where cleabs = _IdIGN;

    _PointCourant = 0;

    while (_PointCourant < _NbPoints)
    loop
        _Point = ST_PointN(_Geom, _PointCourant + 1);
        _Point = ST_MakePoint(ST_X(_Point), ST_Y(_Point), _Z, ST_M(_Point));
        _Geom = ST_SetPoint(_Geom, _PointCourant, _Point);
        
        _PointCourant = _PointCourant + 1;
    end loop;

    update BDT2RR_SourceTronconDeRoute
    set geometrie = _Geom
    where cleabs = _IdIGN
    and CalculerPenteMoyenne(geometrie) > _SeuilPente;
    
    if (FOUND) then
        return ('Altimétrie de ' || _IdIGN || ' modifiée.')::varchar;
    else
        return ('Avertissement : Altimétrie de ' || _IdIGN || ' non modifiée.')::varchar;
    end if;
    
end;
$$ language plpgsql;

-- Modification du numéro de route d'un tronçon.
-- Paramètres :
-- - _IdIGN : L'identifiant IGN du tronçon dont on souhaite modifier le numéro de route.
-- - _NumeroRoute : Le numéro de route à appliquer au tronçon.
-- Résultats :
-- - Modifie dans la BDTopo (au travers de la vue BDT2RR_SourceTronconDeRoute) le numéro de route du tronçon si celui-ci n'est pas déjà égal à _NumeroRoute.
-- - Retourne un texte indiquant si le numéro de route a bien été modifié.
create or replace function ModifierNumeroRoute(_IdIGN character varying, _NumeroRoute character varying) returns varchar as $$
begin
    
    update BDT2RR_SourceTronconDeRoute
    set cpx_numero = _NumeroRoute
    where cleabs = _IdIGN
    and cpx_numero is distinct from _NumeroRoute;
    
    if (FOUND) then
        return ('Numéro de route de ' || _IdIGN || ' modifié.')::varchar;
    else
        return ('Avertissement : Numéro de route de ' || _IdIGN || ' non modifié.')::varchar;
    end if;
    
end;
$$ language plpgsql;

-- Modification du gestionnaire d'un tronçon.
-- 
-- Cette fonction est utilisée par les fonctions qui suivent : MettreEnGestionCommunale, MettreEnGestionDepartementale et MettreEnGestionNationale.
-- 
-- Paramètres :
-- - _IdIGN : L'identifiant du tronçon à modifier.
-- - _NumeroRoute : Le numero de route.
-- - _ClasseAdmin : La classe administrative.
-- - _Gestion : Le gestionnaire.
-- Résultats :
-- - Modifie dans la BDTopo (au travers de la vue BDT2RR_SourceTronconDeRoute) le gestionnaire du tronçon si celui-ci n'est pas déjà égal à _Gestion.
-- - Retourne un texte indiquant si le gestionnaire a bien été modifié.
create or replace function ModifierGestionnaire(_IdIGN character varying, _NumeroRoute character varying, _ClasseAdmin character varying, _Gestion character varying) returns varchar as $$
begin
    
    update BDT2RR_SourceTronconDeRoute
    set
        cpx_numero = _NumeroRoute,
        cpx_classement_administratif = _ClasseAdmin,
        cpx_gestionnaire = _Gestion
    where cleabs = _IdIGN
    and cpx_gestionnaire is distinct from _Gestion;
    
    if (FOUND) then
        return ('Gestionnaire de ' || _IdIGN || ' modifié.')::varchar;
    else
        return ('Avertissement : Gestionnaire de ' || _IdIGN || ' non modifié.')::varchar;
    end if;
    
end;
$$ language plpgsql;

-- Mise en gestion communale d'un tronçon.
-- 
-- Cette fonction est notamment utile en cas de déclassement d'une section de route.
-- 
-- Paramètres :
-- - _IdIGN : L'identifiant du tronçon à mettre en gestion communale.
-- Résultats :
-- - Met dans la BDTopo (au travers de la vue BDT2RR_SourceTronconDeRoute) le tronçon en gestion communale si celui-ci ne l'est pas déjà.
-- - Retourne un texte indiquant si le gestionnaire a bien été modifié.
create or replace function MettreEnGestionCommunale(_IdIGN character varying) returns varchar as $$
    select ModifierGestionnaire(_IdIGN, null, null, null);
$$ language sql;

-- Mise en gestion départementale d'un tronçon.
-- 
-- Cette fonction est notamment utile en cas de classement d'une section de route.
-- 
-- Paramètres :
-- - _IdIGN : L'identifiant du tronçon à mettre en gestion départementale.
-- - _NumeroRoute : Le numero de route.
-- - _Gestion : Le gestionnaire du tronçon.
-- Résultats :
-- - Met dans la BDTopo (au travers de la vue BDT2RR_SourceTronconDeRoute) le tronçon en gestion départementale en précisant le gestionnaire si celui-ci n'est pas déjà égal à _Gestion.
-- - Retourne un texte indiquant si le gestionnaire a bien été modifié.
create or replace function MettreEnGestionDepartementale(_IdIGN character varying, _NumeroRoute character varying, _Gestion character varying) returns varchar as $$
    select ModifierGestionnaire(_IdIGN, _NumeroRoute, 'Départementale', _Gestion);
$$ language sql;

-- Mise en gestion nationale d'un tronçon.
-- Paramètres :
-- - _IdIGN : L'identifiant du tronçon à mettre en gestion départementale.
-- - _NumeroRoute : Le numero de route.
-- - _Gestion : Le gestionnaire du tronçon.
-- Résultats :
-- - Met dans la BDTopo (au travers de la vue BDT2RR_SourceTronconDeRoute) le tronçon en gestion nationale en précisant le gestionnaire si celui-ci n'est pas déjà égal à _Gestion.
-- - Retourne un texte indiquant si le gestionnaire a bien été modifié.
create or replace function MettreEnGestionNationale(_IdIGN character varying, _NumeroRoute character varying, _Gestion character varying) returns varchar as $$
    select ModifierGestionnaire(_IdIGN, _NumeroRoute, 'Nationale', _Gestion);
$$ language sql;