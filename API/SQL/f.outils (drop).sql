drop function if exists f.TransformerEnGeomQlik(_Geom Geometry);
drop function if exists f.FabriquerPointL93(_X double precision, _Y double precision);
drop function if exists f.FabriquerPointWGS84(_X double precision, _Y double precision);
drop function if exists f.TransformerEnL93(_Geom geometry);
drop function if exists f.TransformerEnWGS84(_Geom geometry);
drop function if exists f.PointVersGeoportail(_Point Geometry, _Couches varchar[], _Zoom integer);
drop function if exists f.PointVersGoogleMaps(_Point Geometry);
drop function if exists f.PointVersGoogleStreetView(_Point Geometry);
drop function if exists f.CalculerPenteMoyenne(_Geom Geometry);