-- TODO :
-- Rédiger ici les ordres de corrections à appliquer à la donnée source préalablement à la construction du référentiel routier.
-- Utiliser pour cela les fonctions de corrections disponibles dans le fichier fonctions de correction (create).sql.
--
-- Ce script est à adapter au gré des livraisons millésimées de la BDTopo pour :
-- - supprimer les corrections prises en compte par l'IGN,
-- - ajouter les nouvelles corrections (notamment les classements/déclassements).

-- Corrections de la BDTopo version 3.3 en date du 2022-12

-- 34D4 - Signalement https://espacecollaboratif.ign.fr/georem/735646
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000002275964814', 'ROUTNOMM0000000044994860');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000129715983', 'ROUTNOMM0000000044994860');

-- 34D107E4 - Signalement https://espacecollaboratif.ign.fr/georem/735647
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027921374', 'ROUTNOMM0000000044994526');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027921381', 'ROUTNOMM0000000044994526');

-- D138A - contribution directe 315501
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000356374451', 'ROUTNOMM0000000027985317');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027811081', 'ROUTNOMM0000000027985317');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027811082', 'ROUTNOMM0000000027985317');

-- D1 - contribution directe 315502
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027950687', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000354504860', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027950712', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027950765', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000222493696', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027950753', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000296550201', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000296550203', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000296550202', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027950759', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027950779', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027950770', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027950768', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027950769', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027952787', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000222493486', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027952835', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027952823', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027952818', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027952826', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027952803', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027952788', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027952851', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027952852', null);

-- D16A - contribution directe 315503
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027796705', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027796648', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027796658', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027796647', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027796646', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027796660', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027796650', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027796653', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027796644', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027794944', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000356837151', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027794953', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027794947', null);

-- D172/D206 - contribution directe 315504
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000099569549', 'ROUTNOMM0000000027985296');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000099569550', 'ROUTNOMM0000000027985296');

-- D283D - contribution directe 315505
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000320613995', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000002000670022', null);

-- D310 - contribution directe 315506
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000224437879', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000224437896', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000224437897', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000224437881', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000224437885', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000354835720', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000224437894', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000224437893', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000309946448', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027829142', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027829133', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000002322421710', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000220873772', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027829183', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000356389992', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000354668332', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027829208', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027829185', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027829209', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000002322421711', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000353120380', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027829184', null);

-- D500 - contribution directe 315091
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027910258', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000002002165059', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027910192', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027910104', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000002002164868', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000002002165060', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000002002165061', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000002002165062', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000002002165069', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000339201319', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000339201318', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000339201316', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000339201317', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027910135', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027910176', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027910174', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000220173302', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000298548536', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000298548631', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000220173301', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000298548633', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000298548632', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000002292139407', 'ROUTNOMM0000000027985724');

-- D6086 (Déclassement du 01/09/2022 au profit de Pont-Saint-Esprit - partiellement pris en compte dans le précédent référentiel, mauvaise interprétation de ma part de l'arrêté de déclassement) - contribution directe 315507
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027779224', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000348700070', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027779225', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027779223', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027779261', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027779222', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027779290', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027779307', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027779306', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027779308', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027779291', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027779292', null);

-- D6572A - Parking PL - Aimargues
select CreerRouteNumeroteeOuNommee('ROUTE_D6572A', 'Départementale', 'D6572A', 'Gard'); -- voir avec l'IGN s'il faut identifier cette bretelle comme départementale dans la BDTopo
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000002007706328', 'ROUTE_D6572A');

-- D789 (Retour UT - Jean-Pierre Bourelly) - contribution directe 315508
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000243558810', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000243558811', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027882374', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000211098906', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000243558812', null);
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027882382', null);

-- D999 - contribution directe 315509
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027890927', 'ROUTNOMM0000000027985775');

-- ****************************************************************************
-- convention de gestion OA avec le D07 du 26/06/2019
-- ****************************************************************************

-- D6086 - 07D86 - Pont de Saint-Just - contribution directe 315510
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027771726', 'ROUTNOMM0000000027985738/ROUTNOMM0000000023984225');
-- D141 - 07D200 - Pont suspendu de Saint-Martin-d'Ardèche - contribution directe 315511
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027769601', 'ROUTNOMM0000000027985215/ROUTNOMM0000000005735707');
-- D904 - 07D104 - Pont de l'amariser / la pierre plantée - contribution directe 315512
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000005733782', 'ROUTNOMM0000000027985286/ROUTNOMM0000000024802955');
-- D156B - 07D52 - Pont du barrage de Sénéchas - contribution directe 315513
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000005735306', 'ROUTNOMM0000000027985139/ROUTNOMM0000000005735740');
-- D184 - 07D310 - Pont de Rieubert - contribution directe 315514
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000005734875', 'ROUTNOMM0000000027985131/ROUTNOMM0000000005735735');
-- D430 - 07D310A - Pont des oulettes - contribution directe 315515
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000005734518', 'ROUTNOMM0000000027985130/ROUTNOMM0000000005735734');
-- D979 - 07D579 - Pont de Vagnas - contribution directe 315516
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000005729468', 'ROUTNOMM0000000027985866/ROUTNOMM0000000005735721');

-- ****************************************************************************
-- convention de gestion OA avec le D13 du 27/06/2006
-- ****************************************************************************

-- D58 - 13D38C - Pont de Sylvéréal - contribution directe 315517
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000040824590', 'ROUTNOMM0000000027985861/ROUTNOMM0000000040993291');
-- D6113 - 13D113 - Nouveau pont de Fourques - contribution directe 315518
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027971151', 'ROUTNOMM0000000027985836/ROUTNOMM0000000040993221');
-- D15A - 13D35A - Ancien pont suspendu de Fourques - contribution directe 315519
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027969908', 'ROUTNOMM0000000027985834/ROUTNOMM0000000040993199');
-- D90 - 13D99B - Nouveau pont de Beaucaire-Tarascon - contribution directe 315520
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027946933', 'ROUTNOMM0000000027985789/ROUTNOMM0000000040993124');

-- ****************************************************************************
-- convention de gestion OA avec le D34 du 17/11/2003
-- ****************************************************************************

-- D45 - 34D17 - Pont de Corconne - contribution directe 315521
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000044743055', 'ROUTNOMM0000000027985740/ROUTNOMM0000000044994868');

-- ****************************************************************************
-- convention de gestion routes avec le D34 du 17/11/2003
-- ****************************************************************************

-- D25 - 34D17E6 - contribution directe 315522
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027918311', 'ROUTNOMM0000000027985751');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027918313', 'ROUTNOMM0000000027985751');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027918314', 'ROUTNOMM0000000027985751');

-- ****************************************************************************
-- convention de gestion routes avec le D48 du 24/03/2010
-- ****************************************************************************

-- D51 - 48D51 - Ponteils-et-Brésis - contribution directe 315523
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027765517', 'ROUTNOMM0000000027985191/ROUTNOMM0000000099572759');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027765511', 'ROUTNOMM0000000027985191/ROUTNOMM0000000099572759');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027765509', 'ROUTNOMM0000000027985191/ROUTNOMM0000000099572759');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027765381', 'ROUTNOMM0000000027985191/ROUTNOMM0000000099572759');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000356359450', 'ROUTNOMM0000000027985191/ROUTNOMM0000000099572759');
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000027765380', 'ROUTNOMM0000000027985191/ROUTNOMM0000000099572759');

-- D906 - 48D906 - Saint-André-Capcèze - contribution directe 315524
select ModifierLienVersRouteNumeroteeOuNommee('TRONROUT0000000099540197', 'ROUTNOMM0000000027985272/ROUTNOMM0000000099572757');