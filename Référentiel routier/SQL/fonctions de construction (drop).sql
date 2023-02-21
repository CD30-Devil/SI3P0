-- Effacement des fonctions.
drop function if exists RechercherGiratoires(_LongueurTronconMax integer, _AngleMin integer, _AngleMax integer);
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
drop function if exists InverserTroncons(_IdIGN varchar[]);