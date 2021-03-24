-- schémas spécifiques SI3P0 (f = fonctions)
set search_path to f, public;

-- ----------------------------------------------------------------------------
-- Création d'un point en coordonnées Lambert93.
-- Paramètres :
--   - _X : La valeur X du point.
--   - _Y : La valeur Y du point.
-- Résultats :
--   - Le point.
-- ----------------------------------------------------------------------------
create or replace function FabriquerPointL93(_X double precision, _Y double precision) returns geometry as $$
    select ST_SetSRID(ST_MakePoint(_X, _Y), 2154);
$$ language sql;

-- ----------------------------------------------------------------------------
-- Création d'un point en coordonnées WGS84.
-- Paramètres :
--   - _X : La valeur X (longitude) du point.
--   - _Y : La valeur Y (latitude) du point.
-- Résultats :
--   - Le point.
-- ----------------------------------------------------------------------------
create or replace function FabriquerPointWGS84(_X double precision, _Y double precision) returns geometry as $$
    select ST_SetSRID(ST_MakePoint(_X, _Y), 4326);
$$ language sql;

-- ----------------------------------------------------------------------------
-- Création d'un point en coordonnées RFG93-CC44.
-- Paramètres :
--   - _X : La valeur X du point.
--   - _Y : La valeur Y du point.
-- Résultats :
--   - Le point.
-- ----------------------------------------------------------------------------
create or replace function FabriquerPointCC44(_X double precision, _Y double precision) returns geometry as $$
    select ST_SetSRID(ST_MakePoint(_X, _Y), 3944);
$$ language sql;

-- ----------------------------------------------------------------------------
-- Transformation d'une géométrie en coordonnées Lambert93.
-- Paramètres :
--   - _Geom : La géométrie à transformer.
-- Résultats :
--   - La géométrie transformée.
-- ----------------------------------------------------------------------------
create or replace function TransformerEnL93(_Geom geometry) returns geometry as $$
    select ST_Transform(_Geom, 2154);
$$ language sql;

-- ----------------------------------------------------------------------------
-- Transformation d'une géométrie en coordonnées WGS84.
-- Paramètres :
--   - _Geom : La géométrie à transformer.
-- Résultats :
--   - La géométrie transformée.
-- ----------------------------------------------------------------------------
create or replace function TransformerEnWGS84(_Geom geometry) returns geometry as $$
    select ST_Transform(_Geom, 4326);
$$ language sql;

-- ----------------------------------------------------------------------------
-- Transformation d'une géométrie en coordonnées RFG93-CC44.
-- Paramètres :
--   - _Geom : La géométrie à transformer.
-- Résultats :
--   - La géométrie transformée.
-- ----------------------------------------------------------------------------
create or replace function TransformerEnCC44(_Geom geometry) returns geometry as $$
    select ST_Transform(_Geom, 3944);
$$ language sql;

-- ----------------------------------------------------------------------------
-- Conversion d'un point en lien vers le Géoportail.
-- Paramètres :
--   - _Point : Le point à convertir.
--   - _Couches : Les couches à afficher (défaut : null).
--   - _Zoom : Le niveau de zoom (défaut : 18).
-- Résultats :
--   - Le lien vers le Géoportail.
-- ----------------------------------------------------------------------------
create or replace function PointVersGeoportail(_Point Geometry, _Couches varchar[] default null, _Zoom integer default 18) returns text as $$
declare
    _ParametresCouches text;
    _NumeroCouche integer;
    _URL text;
begin
    _ParametresCouches = '';
    
    if (_Couches is not null) then
    
        for _NumeroCouche in 1..array_length(_Couches, 1)
        loop
            _ParametresCouches = _ParametresCouches || '&l' || (_NumeroCouche - 1) || '=' || _Couches[_NumeroCouche];
        end loop;
    end if;
    
    select 'https://www.geoportail.gouv.fr/carte?c=' || ST_X(TransformerEnWGS84(_Point)) || ',' || ST_Y(TransformerEnWGS84(_Point)) || '&z=' || _Zoom || _ParametresCouches || '&permalink=yes' into _URL;
    return  _URL;
end;
$$ language plpgsql;

-- ----------------------------------------------------------------------------
-- Conversion d'un point en lien vers Google Maps.
-- Paramètres :
--   - _Point : Le point à convertir.
-- Résultats :
--   - Le lien vers Google Maps.
-- ----------------------------------------------------------------------------
create or replace function PointVersGoogleMaps(_Point Geometry) returns text as $$
    select 'https://www.google.com/maps/search/?api=1&query=' || ST_Y(TransformerEnWGS84(_Point)) || ',' || ST_X(TransformerEnWGS84(_Point));
$$ language sql;

-- ----------------------------------------------------------------------------
-- Conversion d'un point en lien vers Google Street View.
-- Paramètres :
--   - _Point : Le point à convertir.
-- Résultats :
--   - Le lien vers Google Street View.
-- ----------------------------------------------------------------------------
create or replace function PointVersGoogleStreetView(_Point Geometry) returns text as $$
    select 'https://www.google.com/maps/@?api=1&map_action=pano&viewpoint=' || ST_Y(TransformerEnWGS84(_Point)) || ',' || ST_X(TransformerEnWGS84(_Point));
$$ language sql;

-- ----------------------------------------------------------------------------
-- Calcul du pourcentage moyen de pente d'une géométrie.
-- Paramètres :
--   - _Geom : La géométrie dont on souhaite connaître la pente.
-- Résultats :
--   - Retourne le pourcentage moyen de pente.
-- ----------------------------------------------------------------------------
create or replace function CalculerPenteMoyenne(_Geom Geometry) returns double precision as $$
    select (sqrt(pow(ST_3DLength(_Geom), 2) - pow(ST_Length(_Geom), 2)) / ST_Length(_Geom) * 100); -- pythagore : b = (c^2 - a^2)^0.5
$$ language sql;

-- ----------------------------------------------------------------------------
-- Transformation d'une géométrie en géométrie utilisable par Qlik.
-- Paramètres :
--   - _Geom : La géométrie à transformer.
-- Résultats :
--   - La géométrie transformée.
-- ----------------------------------------------------------------------------
create or replace function TransformerEnGeomQlik(_Geom Geometry) returns text as $$
    select ST_AsGeoJSON(TransformerEnWGS84(ST_Force2D(_Geom)))::json->>'coordinates';
$$ language sql;