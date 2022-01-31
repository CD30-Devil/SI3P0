-- schémas spécifiques SI3P0 (f = fonctions, m = modèle)
set search_path to f, m, public;

drop function if exists PRAEnTexte(_PRA integer);

drop function if exists PointVersPRA(_Point geometry, _RayonRecherche integer);
drop function if exists PointVersPRA(_Point geometry, _NumeroRoute character varying, _RayonRecherche integer);
drop function if exists PointVersCumulDist(_Point geometry, _RayonRecherche integer);
drop function if exists PointVersCumulDist(_Point geometry, _NumeroRoute character varying, _RayonRecherche integer);

drop function if exists PRAVersPoint(_NumeroRoute character varying, _PRA integer, _Limit integer);
drop function if exists CumulDistVersPoint(_NumeroRoute character varying, _CumulDist numeric, _Limit integer);

drop function if exists RecalerPointSurRoute(_Point geometry, _InclureGiratoire boolean, _RayonRecherche integer);
drop function if exists RecalerPointSurRoute(_Point geometry, _NumeroRoute character varying, _InclureGiratoire boolean, _RayonRecherche integer);

drop function if exists RechercherTronconSurEmprise(_NumeroRoute character varying, _PRAD integer, _PRAF integer, _InclureGiratoire boolean);
drop function if exists RechercherTronconSurEmprise(_NumeroRoute character varying, _PRA integer, _InclureGiratoire boolean);
drop function if exists RechercherTronconSurEmprise(_NumeroRoute character varying, _CumulDistD numeric, _CumulDistF numeric, _InclureGiratoire boolean);
drop function if exists RechercherTronconSurEmprise(_NumeroRoute character varying, _CumulDist numeric, _InclureGiratoire boolean);

drop function if exists RechercherTronconsEntreIdIGN(_NumeroRoute varchar, _IdIGNDebut varchar[], _IdIGNFin varchar[]);

drop function if exists RechercherGiratoireAProximite(_NumeroRoute character varying, _PRA integer);
drop function if exists RechercherGiratoireAProximite(_NumeroRoute character varying, _CumulDist numeric);

drop function if exists ExtraireSousTroncon(_Troncon Troncon, _PRAD integer, _PRAF integer);
drop function if exists ExtraireSousTroncon(_Troncon Troncon, _CumulDistD numeric, _CumulDistD numeric);

drop function if exists CumulDistVersPRA(_NumeroRoute character varying, _CumulDist numeric);
drop function if exists PRAVersCumulDist(_NumeroRoute character varying, _PRA integer);