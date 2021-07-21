-- schémas spécifiques SI3P0 (f = fonctions)
set search_path to f, public;

drop function if exists TransformerEnGeomQlik(_Geom Geometry);
drop function if exists FabriquerPointL93(_X double precision, _Y double precision);
drop function if exists FabriquerPointWGS84(_X double precision, _Y double precision);
drop function if exists TransformerEnL93(_Geom geometry);
drop function if exists TransformerEnWGS84(_Geom geometry);
drop function if exists PointVersGeoportail(_Point Geometry, _Couches varchar[], _Zoom integer);
drop function if exists PointVersGoogleMaps(_Point Geometry);
drop function if exists PointVersGoogleStreetView(_Point Geometry);
drop function if exists CalculerPenteMoyenne(_Geom Geometry);