-- TODO :
-- Rédiger ici les ordres de corrections à appliquer à la donnée source préalablement à la construction du référentiel routier.
-- Utiliser pour cela les fonctions de corrections disponibles dans le fichier fonctions de correction (create).sql.
--
-- Ce script est à adapter au gré des livraisons millésimées de la BDTopo pour :
-- - supprimer les corrections prises en compte par l'IGN,
-- - ajouter les nouvelles corrections (notamment les classements/déclassements).

-- Corrections de la BDTopo version 3.3 en date du 2023-03

-- D18/D22 - contribution directe 327054
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027889590', 'ROUTNOMM0000000027985810');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000220651779', 'ROUTNOMM0000000027985810');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027889583', 'ROUTNOMM0000000027985810');

-- D6572A - Parking PL - Aimargues
select CreerRouteNumeroteeOuNommee('ROUTE_D6572A', 'Départementale', 'D6572A', 'Gard'); -- voir avec l'IGN s'il faut identifier cette bretelle comme départementale dans la BDTopo
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000002007706328', 'ROUTE_D6572A');

-- D9 - contribution directe 327017
select ModifierSens('TRONROUT0000002330388017', 'Sens direct');
select ModifierSens('TRONROUT0000002330388008', 'Sens direct');
select ModifierSens('TRONROUT0000002330388020', 'Sens direct');
select ModifierSens('TRONROUT0000002330388000', 'Sens direct');
select ModifierSens('TRONROUT0000002330388021', 'Sens direct');
select ModifierSens('TRONROUT0000002330388007', 'Sens direct');
select ModifierSens('TRONROUT0000002330388028', 'Sens direct');
select ModifierSens('TRONROUT0000002330388016', 'Sens direct');

-- ****************************************************************************
-- convention de gestion OA avec le D07 du 26/06/2019
-- ****************************************************************************

-- D6086 - 07D86 - Pont de Saint-Just - contribution directe 315510
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027771726', 'ROUTNOMM0000000023984225/ROUTNOMM0000000027985738');
-- D141 - 07D200 - Pont suspendu de Saint-Martin-d'Ardèche - contribution directe 315511
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027769601', 'ROUTNOMM0000000005735707/ROUTNOMM0000000027985215');
-- D904 - 07D104 - Pont de l'amariser / la pierre plantée - contribution directe 315512
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000005733782', 'ROUTNOMM0000000024802955/ROUTNOMM0000000027985286');
-- D156B - 07D52 - Pont du barrage de Sénéchas - contribution directe 315513
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000005735306', 'ROUTNOMM0000000005735740/ROUTNOMM0000000027985139');
-- D184 - 07D310 - Pont de Rieubert - contribution directe 315514
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000005734875', 'ROUTNOMM0000000005735735/ROUTNOMM0000000027985131');
-- D430 - 07D310A - Pont des oulettes - contribution directe 315515
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000005734518', 'ROUTNOMM0000000005735734/ROUTNOMM0000000027985130');
-- D979 - 07D579 - Pont de Vagnas - contribution directe 315516
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000005729468', 'ROUTNOMM0000000005735721/ROUTNOMM0000000027985866');

-- ****************************************************************************
-- convention de gestion OA avec le D13 du 27/06/2006
-- ****************************************************************************

-- D58 - 13D38C - Pont de Sylvéréal - contribution directe 315517
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000040824590', 'ROUTNOMM0000000040993291/ROUTNOMM0000000027985861');
-- D6113 - 13D113 - Nouveau pont de Fourques - contribution directe 315518
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027971151', 'ROUTNOMM0000000040993221/ROUTNOMM0000000027985836');
-- D15A - 13D35A - Ancien pont suspendu de Fourques - contribution directe 315519
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027969908', 'ROUTNOMM0000000040993199/ROUTNOMM0000000027985834');
-- D90 - 13D99B - Nouveau pont de Beaucaire-Tarascon - contribution directe 315520
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027946933', 'ROUTNOMM0000000040993124/ROUTNOMM0000000027985789');

-- ****************************************************************************
-- convention de gestion OA avec le D34 du 17/11/2003
-- ****************************************************************************

-- D45 - 34D17 - Pont de Corconne - contribution directe 315521
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000044743055', 'ROUTNOMM0000000044994868/ROUTNOMM0000000027985740');

-- ****************************************************************************
-- convention de gestion routes avec le D48 du 24/03/2010
-- ****************************************************************************

-- D51 - 48D51 - Ponteils-et-Brésis - contribution directe 315523
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027765517', 'ROUTNOMM0000000099572759/ROUTNOMM0000000027985191');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027765511', 'ROUTNOMM0000000099572759/ROUTNOMM0000000027985191');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027765509', 'ROUTNOMM0000000099572759/ROUTNOMM0000000027985191');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027765381', 'ROUTNOMM0000000099572759/ROUTNOMM0000000027985191');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000356359450', 'ROUTNOMM0000000099572759/ROUTNOMM0000000027985191');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027765380', 'ROUTNOMM0000000099572759/ROUTNOMM0000000027985191');

-- D906 - 48D906 - Saint-André-Capcèze - contribution directe 315524
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000099540197', 'ROUTNOMM0000000099572757/ROUTNOMM0000000027985272');

-- ****************************************************************************
-- convention de gestion OA avec le D84 du 13/11/2019
-- ****************************************************************************

-- D994
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000002274914334', 'ROUTNOMM0000000027985175/ROUTNOMM0000000038231796');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000038087428', 'ROUTNOMM0000000027985175/ROUTNOMM0000000038231796');