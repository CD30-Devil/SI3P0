-- Effacement des fonctions.
drop function if exists LierTroncons(_IdIGN1 character varying, _IdIGN2 character varying, _Extremites character varying, _Fictif boolean);
drop function if exists RechercherGiratoires(_LongueurTronconMax integer, _BorneAngleGauche integer, _BorneAngleDroit integer);
drop function if exists RecalerPRDeb(_RayonRecherche integer);
drop function if exists ConstruireRoute(_NumeroRoute character varying, _RayonRecherchePR integer, _LongueurMaxTroncon integer);
drop function if exists AjouterPremierTronconLineaire(_NumeroRoute character varying);
drop function if exists AjouterPremierTronconGiratoire(_NumeroRoute character varying);
drop function if exists AjouterLineaire(_NumeroRoute character varying);
drop function if exists AjouterGiratoire(_NumeroRoute character varying);
drop function if exists RecalerPR(_NumeroRoute character varying, integer);
drop function if exists CalculerCumulDistPR(_NumeroRoute character varying);
drop function if exists DecouperTronconSurPR(_NumeroRoute character varying);
drop function if exists DecouperTronconSuperieurA(_NumeroRoute character varying, _Longueur integer);