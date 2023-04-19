-- NDLR :
-- La BDTopo comprend certains tronçons qui visent à assurer la continuité topologique d'une route.
-- C'est notamment le cas lorsqu'une route croise une autre route à chaussées séparées.
--
-- Au département du Gard, le PR de début est parfois positionné après ces tronçons de continuité.
-- Il faut donc à l'issue de la construction les inverser pour qu'ils se retrouvent numérisés dans le sens croissant des PR.
-- Cette inversion entraine aussi le passage en distances cumulées négatives.
--
-- TODO :
-- Rédiger ici les ordres d'inversion des tronçons placés avant les PR de début.
--
-- Syntaxe :
-- select * from InverserTroncons(array['<Tronçon 1>', '<Tronçon 2>', ..., '<Tronçon N>']);

-- D101A
select * from InverserTroncons(array['TRONROUT0000000088881660']);

-- D103
select * from InverserTroncons(array['TRONROUT0000000348280943', 'TRONROUT0000000027937635']);

-- D106
select * from InverserTroncons(array['TRONROUT0000000027841866', 'TRONROUT0000000027841874']);

-- D111
select * from InverserTroncons(array['TRONROUT0000000118724960', 'TRONROUT0000000118724950']);

-- D114
select * from InverserTroncons(array['TRONROUT0000000224528393', 'TRONROUT0000000224528378']);

-- D116
select * from InverserTroncons(array['TRONROUT0000000356722948', 'TRONROUT0000000356722980']);

-- D117
select * from InverserTroncons(array['TRONROUT0000002215488684', 'TRONROUT0000002274801763']);

-- D135
select * from InverserTroncons(array['TRONROUT0000000298211540']);

-- D138A
select * from InverserTroncons(array['TRONROUT0000000356374451']);

-- D155
select * from InverserTroncons(array['TRONROUT0000000120485365', 'TRONROUT0000000120485360']);

-- D187A
select * from InverserTroncons(array['TRONROUT0000002004486969', 'TRONROUT0000002004486968']);

-- D194
select * from InverserTroncons(array['TRONROUT0000002202030068', 'TRONROUT0000002202030069']);

-- D216A
select * from InverserTroncons(array['TRONROUT0000000119280962', 'TRONROUT0000000119280969']);

-- D222
select * from InverserTroncons(array['TRONROUT0000002275745999', 'TRONROUT0000002275745971']);

-- D243
select * from InverserTroncons(array['TRONROUT0000000120485311', 'TRONROUT0000000027774228']);

-- D257
select * from InverserTroncons(array['TRONROUT0000000027936017']);

-- D283C
select * from InverserTroncons(array['TRONROUT0000000350791653']);

-- D293
select * from InverserTroncons(array['TRONROUT0000000359408868', 'TRONROUT0000000359408876']);

-- D297B
select * from InverserTroncons(array['TRONROUT0000000358006837']);

-- D304
select * from InverserTroncons(array['TRONROUT0000000027771232']);

-- D306
select * from InverserTroncons(array['TRONROUT0000000027776248']);

-- D327
select * from InverserTroncons(array['TRONROUT0000000027871030']);

-- D383A
select * from InverserTroncons(array['TRONROUT0000000027795258']);

-- D3B
select * from InverserTroncons(array['TRONROUT0000000298189571']);

-- D408
select * from InverserTroncons(array['TRONROUT0000002201847128', 'TRONROUT0000002201847129']);

-- D40D
select * from InverserTroncons(array['TRONROUT0000002003596385', 'TRONROUT0000002003596382']);

-- D437
select * from InverserTroncons(array['TRONROUT0000000220174618', 'TRONROUT0000000220174610']);

-- D440
select * from InverserTroncons(array['TRONROUT0000000120485670']);

-- D522
select * from InverserTroncons(array['TRONROUT0000000297461593', 'TRONROUT0000000297461590']);

-- D59
select * from InverserTroncons(array['TRONROUT0000000027781649', 'TRONROUT0000000088881759']);

-- D6086
select * from InverserTroncons(array['TRONROUT0000000027771726']);

-- D60A
select * from InverserTroncons(array['TRONROUT0000000248354453']);

-- D6113
select * from InverserTroncons(array['TRONROUT0000000027971151']);

-- D764
select * from InverserTroncons(array['TRONROUT0000000224433786', 'TRONROUT0000000224433785']);

-- D8
select * from InverserTroncons(array['TRONROUT0000000027873436', 'TRONROUT0000000027873442']);

-- D901
select * from InverserTroncons(array['TRONROUT0000000027773074', 'TRONROUT0000000027773075']);

-- D904
select * from InverserTroncons(array['TRONROUT0000000005733782']);

-- D907
select * from InverserTroncons(array['TRONROUT0000002200513390']);

-- D986L
select * from InverserTroncons(array['TRONROUT0000000220173855', 'TRONROUT0000000220173858']);