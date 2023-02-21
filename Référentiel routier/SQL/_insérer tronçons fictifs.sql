﻿-- TODO :
-- Rédiger dans ce script les ordres de création de liens fictifs entre les sections discontinues de route pour recréer une continuité "virtuelle" du linéaire.
-- Utiliser pour cela la fonction LierTroncons présente dans fonctions de correction (create).sql.
-- La requête présente dans le fichier _rechercher discontinuités.sql permet d'identifier les routes discontinues.
--
-- Syntaxe :
-- select LierTroncons(
--     '<CleAbs du tronçon de départ>',
--     '<CleAbs du tronçon d'arrivé>',
--     '<Extrémités des tronçons à relier ; une valeur parmi dd (début-début), df (début-fin), ff (fin-fin), fd (fin-début)>'
-- );

-- 34D107
select LierTroncons('TRONROUT0000000044746145', 'TRONROUT0000000044744233', 'ff');

select LierTroncons('TRONROUT0000000044744767', 'TRONROUT0000000044744759', 'fd');
select LierTroncons('TRONROUT0000000044744759', 'TRONROUT0000000044744756', 'df');
select LierTroncons('TRONROUT0000000044744756', 'TRONROUT0000000245030409', 'fd');

-- 34D107E4
select LierTroncons('TRONROUT0000000044741177', 'TRONROUT0000002007491883', 'dd');

-- 34D4
select LierTroncons('TRONROUT0000000044813622', 'TRONROUT0000000044808591', 'ff');
select LierTroncons('TRONROUT0000000044808591', 'TRONROUT0000000044808593', 'fd');

select LierTroncons('TRONROUT0000000245033087', 'TRONROUT0000000245033089', 'fd');
select LierTroncons('TRONROUT0000000245033089', 'TRONROUT0000000338943848', 'df');
select LierTroncons('TRONROUT0000000338943848', 'TRONROUT0000000338943840', 'fd');

-- 34D61
select LierTroncons('TRONROUT0000000298299550', 'TRONROUT0000000298299547', 'df');
select LierTroncons('TRONROUT0000000298299547', 'TRONROUT0000000298299542', 'fd');
select LierTroncons('TRONROUT0000000298299542', 'TRONROUT0000000298299548', 'df');

-- D1
select LierTroncons('TRONROUT0000000242505458', 'TRONROUT0000000027952854', 'dd');
select LierTroncons('TRONROUT0000000027952854', 'TRONROUT0000000027952868', 'df');

select LierTroncons('TRONROUT0000000027966914', 'TRONROUT0000000027966937', 'ff');
select LierTroncons('TRONROUT0000000027966937', 'TRONROUT0000000027966938', 'ff');

-- D10
select LierTroncons('TRONROUT0000002270159429', 'TRONROUT0000002270159417', 'dd');

-- D101
select LierTroncons('TRONROUT0000000027834315', 'TRONROUT0000000309686802', 'dd');
select LierTroncons('TRONROUT0000000309686802', 'TRONROUT0000000329973792', 'df');

select LierTroncons('TRONROUT0000000027831482', 'TRONROUT0000000308613629', 'df');
select LierTroncons('TRONROUT0000000308613629', 'TRONROUT0000000308613628', 'ff');
select LierTroncons('TRONROUT0000000308613628', 'TRONROUT0000000308613625', 'fd');

-- D103
select LierTroncons('TRONROUT0000000027937840', 'TRONROUT0000000306295218', 'fd');

-- D104
select LierTroncons('TRONROUT0000000027965401', 'TRONROUT0000000027965498', 'ff');

-- D105
select LierTroncons('TRONROUT0000000027951179', 'TRONROUT0000000027951099', 'fd');

-- D106
select LierTroncons('TRONROUT0000000027848144', 'TRONROUT0000000027848134', 'dd');
select LierTroncons('TRONROUT0000000027848134', 'TRONROUT0000000249902820', 'dd');
select LierTroncons('TRONROUT0000000249902820', 'TRONROUT0000000249902821', 'dd');

select LierTroncons('TRONROUT0000000027851191', 'TRONROUT0000000027854210', 'df');

-- D107
select LierTroncons('TRONROUT0000000027950710', 'TRONROUT0000000027952708', 'fd');
select LierTroncons('TRONROUT0000000027952708', 'TRONROUT0000000027952709', 'df');

-- D109
select LierTroncons('TRONROUT0000000027870065', 'TRONROUT0000000027870014', 'ff');

select LierTroncons('TRONROUT0000000348797868', 'TRONROUT0000000348797869', 'dd');
select LierTroncons('TRONROUT0000000348797869', 'TRONROUT0000000027869975', 'dd');

-- D110D
select LierTroncons('TRONROUT0000000027874642', 'TRONROUT0000002322423802', 'fd');

-- D111
select LierTroncons('TRONROUT0000000220047839', 'TRONROUT0000000220047838', 'fd');
select LierTroncons('TRONROUT0000000220047838', 'TRONROUT0000002220858450', 'dd');
select LierTroncons('TRONROUT0000002220858450', 'TRONROUT0000002220858449', 'df');

-- D112
select LierTroncons('TRONROUT0000002220857607', 'TRONROUT0000002220857608', 'fd');
select LierTroncons('TRONROUT0000002220857608', 'TRONROUT0000000027876879', 'df');

select LierTroncons('TRONROUT0000000298211559', 'TRONROUT0000000298211555', 'df');
select LierTroncons('TRONROUT0000000298211555', 'TRONROUT0000000027876657', 'fd');

-- D113
select LierTroncons('TRONROUT0000000027898889', 'TRONROUT0000000027901412', 'dd');

-- D114
select LierTroncons('TRONROUT0000000295453328', 'TRONROUT0000000295453327', 'df');
select LierTroncons('TRONROUT0000000295453327', 'TRONROUT0000000220651792', 'ff');

select LierTroncons('TRONROUT0000000027873183', 'TRONROUT0000000027873167', 'ff');
select LierTroncons('TRONROUT0000000027873167', 'TRONROUT0000000027877222', 'fd');

-- D115
select LierTroncons('TRONROUT0000000358007334', 'TRONROUT0000000027841017', 'ff');
select LierTroncons('TRONROUT0000000027841017', 'TRONROUT0000000027841004', 'fd');

-- D120
select LierTroncons('TRONROUT0000000027847704', 'TRONROUT0000000027847705', 'ff');
select LierTroncons('TRONROUT0000000027847705', 'TRONROUT0000000027850811', 'fd');
select LierTroncons('TRONROUT0000000027850811', 'TRONROUT0000000027850804', 'dd');

select LierTroncons('TRONROUT0000000027863142', 'TRONROUT0000000027863123', 'dd');

-- D123
select LierTroncons('TRONROUT0000000027880967', 'TRONROUT0000000027884474', 'df');

select LierTroncons('TRONROUT0000000027900767', 'TRONROUT0000000027906269', 'df');

-- D124
select LierTroncons('TRONROUT0000000027887208', 'TRONROUT0000000027887211', 'df');

select LierTroncons('TRONROUT0000000027877592', 'TRONROUT0000000027877604', 'fd');

select LierTroncons('TRONROUT0000000027866582', 'TRONROUT0000000027863545', 'ff');
select LierTroncons('TRONROUT0000000027863545', 'TRONROUT0000000027863554', 'ff');

-- D125
select LierTroncons('TRONROUT0000000027850110', 'TRONROUT0000000027847138', 'ff');

select LierTroncons('TRONROUT0000000027844292', 'TRONROUT0000000027840695', 'ff');

-- D126
select LierTroncons('TRONROUT0000000325576747', 'TRONROUT0000000325576737', 'fd');
select LierTroncons('TRONROUT0000000325576737', 'TRONROUT0000000027899187', 'df');
select LierTroncons('TRONROUT0000000027899187', 'TRONROUT0000002292436470', 'fd');

-- D128
select LierTroncons('TRONROUT0000000027790172', 'TRONROUT0000000116275364', 'dd');
select LierTroncons('TRONROUT0000000116275364', 'TRONROUT0000000116275365', 'df');

-- D13
select LierTroncons('TRONROUT0000000027949851', 'TRONROUT0000000027949850', 'dd');
select LierTroncons('TRONROUT0000000027949850', 'TRONROUT0000000027952295', 'df');
select LierTroncons('TRONROUT0000000027952295', 'TRONROUT0000002276893534', 'fd');
select LierTroncons('TRONROUT0000002276893534', 'TRONROUT0000002276893536', 'dd');

-- D130
select LierTroncons('TRONROUT0000000241622057', 'TRONROUT0000000241622077', 'fd');
select LierTroncons('TRONROUT0000000241622077', 'TRONROUT0000000241622087', 'df');

-- D131
select LierTroncons('TRONROUT0000000224534666', 'TRONROUT0000000027796768', 'dd');

-- D133
select LierTroncons('TRONROUT0000000027867029', 'TRONROUT0000000027867061', 'fd');

-- D134
select LierTroncons('TRONROUT0000000027766941', 'TRONROUT0000000215502567', 'dd');

-- D135
select LierTroncons('TRONROUT0000000222493600', 'TRONROUT0000000027905335', 'dd');

select LierTroncons('TRONROUT0000000119651340', 'TRONROUT0000000274512499', 'df');
select LierTroncons('TRONROUT0000000274512499', 'TRONROUT0000000027916045', 'ff');

-- D136
select LierTroncons('TRONROUT0000000027877124', 'TRONROUT0000000027877126', 'df');
select LierTroncons('TRONROUT0000000027877126', 'TRONROUT0000000027880631', 'ff');

-- D138
select LierTroncons('TRONROUT0000000027777640', 'TRONROUT0000000120845168', 'dd');

select LierTroncons('TRONROUT0000002206432615', 'TRONROUT0000002206432611', 'fd');
select LierTroncons('TRONROUT0000002206432611', 'TRONROUT0000002287731795', 'dd');

select LierTroncons('TRONROUT0000000113382520', 'TRONROUT0000000113382525', 'ff');
select LierTroncons('TRONROUT0000000113382525', 'TRONROUT0000000113382526', 'fd');

-- D139
select LierTroncons('TRONROUT0000000027962070', 'TRONROUT0000000027962032', 'df');

select LierTroncons('TRONROUT0000000348280848', 'TRONROUT0000000348281062', 'df');
select LierTroncons('TRONROUT0000000348281062', 'TRONROUT0000000324756966', 'ff');
select LierTroncons('TRONROUT0000000324756966', 'TRONROUT0000000324756967', 'fd');

-- D14
select LierTroncons('TRONROUT0000002216222429', 'TRONROUT0000000027961538', 'df');

-- D141
select LierTroncons('TRONROUT0000000349476869', 'TRONROUT0000000349476863', 'fd');
select LierTroncons('TRONROUT0000000349476863', 'TRONROUT0000002000204140', 'dd');
select LierTroncons('TRONROUT0000002000204140', 'TRONROUT0000000027769620', 'dd');

-- D147
select LierTroncons('TRONROUT0000000027801226', 'TRONROUT0000000027801221', 'ff');

-- D152
select LierTroncons('TRONROUT0000000027851949', 'TRONROUT0000000027833515', 'fd');

-- D153
select LierTroncons('TRONROUT0000000027848764', 'TRONROUT0000000027848718', 'fd');

-- D155
select LierTroncons('TRONROUT0000000027766011', 'TRONROUT0000000241622098', 'df');

-- D158
select LierTroncons('TRONROUT0000000224972840', 'TRONROUT0000000027907100', 'df');

-- D16
select LierTroncons('TRONROUT0000000027789477', 'TRONROUT0000000027789483', 'ff');
select LierTroncons('TRONROUT0000000027789483', 'TRONROUT0000000027789462', 'fd');

-- D166
select LierTroncons('TRONROUT0000000027788995', 'TRONROUT0000000292956943', 'ff');

select LierTroncons('TRONROUT0000000027795951', 'TRONROUT0000000027795883', 'dd');

select LierTroncons('TRONROUT0000000027800598', 'TRONROUT0000000027800608', 'ff');

select LierTroncons('TRONROUT0000000027814163', 'TRONROUT0000000027814206', 'dd');

-- D168
select LierTroncons('TRONROUT0000000027931237', 'TRONROUT0000000358008443', 'df');

-- D17
select LierTroncons('TRONROUT0000000027768190', 'TRONROUT0000000027768185', 'fd');

-- D170E
select LierTroncons('TRONROUT0000000027849050', 'TRONROUT0000000301314344', 'fd');

-- D178
select LierTroncons('TRONROUT0000000027934809', 'TRONROUT0000000027934822', 'ff');

-- D179
select LierTroncons('TRONROUT0000002215710102', 'TRONROUT0000000027974286', 'df');
select LierTroncons('TRONROUT0000000027974286', 'TRONROUT0000000027974285', 'ff');

-- D18
select LierTroncons('TRONROUT0000000357331724', 'TRONROUT0000000027869540', 'ff');
select LierTroncons('TRONROUT0000000027869540', 'TRONROUT0000000027869537', 'fd');
select LierTroncons('TRONROUT0000000027869537', 'TRONROUT0000000027873265', 'df');
select LierTroncons('TRONROUT0000000027873265', 'TRONROUT0000000220650707', 'ff');

select LierTroncons('TRONROUT0000000027866309', 'TRONROUT0000000357996864', 'fd');
select LierTroncons('TRONROUT0000000357996864', 'TRONROUT0000002223195199', 'dd');
select LierTroncons('TRONROUT0000002223195199', 'TRONROUT0000000027866296', 'df');

-- D180
select LierTroncons('TRONROUT0000000027769697', 'TRONROUT0000000027769644', 'df');
select LierTroncons('TRONROUT0000000027769644', 'TRONROUT0000000027769650', 'ff');

-- D181
select LierTroncons('TRONROUT0000000235110872', 'TRONROUT0000000027909656', 'dd');

-- D182
select LierTroncons('TRONROUT0000000027881289', 'TRONROUT0000000027881257', 'ff');

-- D185
select LierTroncons('TRONROUT0000000027864044', 'TRONROUT0000000027867059', 'fd');

select LierTroncons('TRONROUT0000000027870606', 'TRONROUT0000000027874140', 'fd');

-- D186
select LierTroncons('TRONROUT0000000027873290', 'TRONROUT0000000027873245', 'df');
select LierTroncons('TRONROUT0000000027873245', 'TRONROUT0000000027873289', 'fd');

select LierTroncons('TRONROUT0000000357331765', 'TRONROUT0000000356822936', 'dd');

-- D19
select LierTroncons('TRONROUT0000000027889249', 'TRONROUT0000000027889139', 'dd');

-- D191
select LierTroncons('TRONROUT0000000027847835', 'TRONROUT0000000027847828', 'dd');

-- D192
select LierTroncons('TRONROUT0000000298211563', 'TRONROUT0000000298211565', 'dd');
select LierTroncons('TRONROUT0000000298211565', 'TRONROUT0000000298211562', 'dd');
select LierTroncons('TRONROUT0000000298211562', 'TRONROUT0000000027868895', 'dd');
select LierTroncons('TRONROUT0000000027868895', 'TRONROUT0000000027868894', 'dd');

-- D194
select LierTroncons('TRONROUT0000000027906375', 'TRONROUT0000000027906318', 'fd');

-- D211
select LierTroncons('TRONROUT0000000027823890', 'TRONROUT0000000027823865', 'fd');

-- D216A
select LierTroncons('TRONROUT0000000027810012', 'TRONROUT0000000113477376', 'df');

-- D219
select LierTroncons('TRONROUT0000000027846996', 'TRONROUT0000000027850080', 'df');

-- D22
select LierTroncons('TRONROUT0000000027953653', 'TRONROUT0000000357996022', 'fd');

select LierTroncons('TRONROUT0000000358007318', 'TRONROUT0000000358007320', 'ff');
select LierTroncons('TRONROUT0000000358007320', 'TRONROUT0000000027906029', 'ff');
select LierTroncons('TRONROUT0000000027906029', 'TRONROUT0000000224574437', 'ff');
select LierTroncons('TRONROUT0000000224574437', 'TRONROUT0000000224574436', 'fd');

select LierTroncons('TRONROUT0000000290818499', 'TRONROUT0000000241650759', 'df');
select LierTroncons('TRONROUT0000000241650759', 'TRONROUT0000000027892428', 'fd');

select LierTroncons('TRONROUT0000000027889600', 'TRONROUT0000000027889587', 'fd');

-- D220
select LierTroncons('TRONROUT0000000242519958', 'TRONROUT0000000242519968', 'fd');
select LierTroncons('TRONROUT0000000242519968', 'TRONROUT0000000027787255', 'df');

-- D23
select LierTroncons('TRONROUT0000000027811623', 'TRONROUT0000000027811613', 'dd');
select LierTroncons('TRONROUT0000000027811613', 'TRONROUT0000000027811628', 'df');
select LierTroncons('TRONROUT0000000027811628', 'TRONROUT0000000228146162', 'fd');

select LierTroncons('TRONROUT0000000220875380', 'TRONROUT0000000220875379', 'dd');
select LierTroncons('TRONROUT0000000220875379', 'TRONROUT0000000027785513', 'dd');
select LierTroncons('TRONROUT0000000027785513', 'TRONROUT0000002000583738', 'dd');
select LierTroncons('TRONROUT0000002000583738', 'TRONROUT0000000027787204', 'df');
select LierTroncons('TRONROUT0000000027787204', 'TRONROUT0000000027787195', 'ff');

-- D235
select LierTroncons('TRONROUT0000000027891706', 'TRONROUT0000000242519928', 'dd');
select LierTroncons('TRONROUT0000000242519928', 'TRONROUT0000000242519916', 'dd');

-- D24
select LierTroncons('TRONROUT0000000225280830', 'TRONROUT0000000027884769', 'dd');

select LierTroncons('TRONROUT0000000027860853', 'TRONROUT0000000027860821', 'fd');

-- D246A
select LierTroncons('TRONROUT0000000215315188', 'TRONROUT0000000027845273', 'dd');

-- D256
select LierTroncons('TRONROUT0000000027774579', 'TRONROUT0000000220174809', 'dd');

-- D259
select LierTroncons('TRONROUT0000000027805260', 'TRONROUT0000000027803133', 'fd');

-- D26
select LierTroncons('TRONROUT0000000027852790', 'TRONROUT0000000309946796', 'dd');
select LierTroncons('TRONROUT0000000309946796', 'TRONROUT0000000309946793', 'df');

select LierTroncons('TRONROUT0000002220858629', 'TRONROUT0000002220858631', 'fd');
select LierTroncons('TRONROUT0000002220858631', 'TRONROUT0000002220858634', 'df');
select LierTroncons('TRONROUT0000002220858634', 'TRONROUT0000002220858628', 'ff');
select LierTroncons('TRONROUT0000002220858628', 'TRONROUT0000000309686752', 'ff');
select LierTroncons('TRONROUT0000000309686752', 'TRONROUT0000000309686761', 'fd');

-- D264
select LierTroncons('TRONROUT0000000027912933', 'TRONROUT0000000027912936', 'df');

select LierTroncons('TRONROUT0000000230013277', 'TRONROUT0000002322424288', 'df');

-- D268
select LierTroncons('TRONROUT0000000130407460', 'TRONROUT0000000027879267', 'ff');

-- D269
select LierTroncons('TRONROUT0000000027822856', 'TRONROUT0000000350792744', 'fd');

-- D279
select LierTroncons('TRONROUT0000000027837567', 'TRONROUT0000000027840509', 'df');

-- D283A
select LierTroncons('TRONROUT0000000027793476', 'TRONROUT0000000027791884', 'fd');

-- D290
select LierTroncons('TRONROUT0000000027858238', 'TRONROUT0000000356420307', 'dd');

-- D3
select LierTroncons('TRONROUT0000000027910679', 'TRONROUT0000000027910726', 'ff');

-- D301
select LierTroncons('TRONROUT0000002008353512', 'TRONROUT0000000088881870', 'fd');
select LierTroncons('TRONROUT0000000088881870', 'TRONROUT0000002008353513', 'df');
select LierTroncons('TRONROUT0000002008353513', 'TRONROUT0000000027770985', 'fd');

select LierTroncons('TRONROUT0000000027768924', 'TRONROUT0000000027768927', 'df');

-- D306
select LierTroncons('TRONROUT0000000027779472', 'TRONROUT0000000357261012', 'fd');

-- D309
select LierTroncons('TRONROUT0000000224528372', 'TRONROUT0000000027838108', 'dd');

-- D322
select LierTroncons('TRONROUT0000000027866079', 'TRONROUT0000000027866075', 'df');

-- D323
select LierTroncons('TRONROUT0000000027848988', 'TRONROUT0000000027849001', 'df');

-- D329
select LierTroncons('TRONROUT0000000027861648', 'TRONROUT0000000357639449', 'dd');

-- D343
select LierTroncons('TRONROUT0000000119160123', 'TRONROUT0000000222674842', 'dd');

-- D35
select LierTroncons('TRONROUT0000000119651710', 'TRONROUT0000000119651707', 'df');
select LierTroncons('TRONROUT0000000119651707', 'TRONROUT0000000027903846', 'fd');

-- D351
select LierTroncons('TRONROUT0000000027894329', 'TRONROUT0000000223323202', 'fd');

select LierTroncons('TRONROUT0000000027891873', 'TRONROUT0000000027889102', 'ff');

-- D35A
select LierTroncons('TRONROUT0000000027934960', 'TRONROUT0000000027934957', 'df');

-- D370
select LierTroncons('TRONROUT0000000211397839', 'TRONROUT0000002220855582', 'dd');
select LierTroncons('TRONROUT0000002220855582', 'TRONROUT0000000301314388', 'df');

-- D39
select LierTroncons('TRONROUT0000000027825606', 'TRONROUT0000000027816391', 'dd');

-- D4
select LierTroncons('TRONROUT0000000027856085', 'TRONROUT0000000027856119', 'dd');
select LierTroncons('TRONROUT0000000027856119', 'TRONROUT0000000027856115', 'dd');

-- D403
select LierTroncons('TRONROUT0000000027935818', 'TRONROUT0000000353797280', 'ff');

-- D405
select LierTroncons('TRONROUT0000000027844212', 'TRONROUT0000000027847197', 'df');

-- D406
select LierTroncons('TRONROUT0000000312696903', 'TRONROUT0000000312696884', 'fd');
select LierTroncons('TRONROUT0000000312696884', 'TRONROUT0000000027809572', 'dd');

-- D409
select LierTroncons('TRONROUT0000000354737579', 'TRONROUT0000000027817276', 'dd');

-- D40D
select LierTroncons('TRONROUT0000000027950693', 'TRONROUT0000000027952825', 'fd');

-- D420
select LierTroncons('TRONROUT0000000027855077', 'TRONROUT0000000027855093', 'df');

-- D427
select LierTroncons('TRONROUT0000000027902426', 'TRONROUT0000000027902396', 'ff');

-- D500
select LierTroncons('TRONROUT0000000027910283', 'TRONROUT0000000027910284', 'df');
select LierTroncons('TRONROUT0000000027910284', 'TRONROUT0000000027912949', 'fd');

select LierTroncons('TRONROUT0000000298548602', 'TRONROUT0000000298548605', 'df');
select LierTroncons('TRONROUT0000000298548605', 'TRONROUT0000002292139411', 'ff');

-- D502
select LierTroncons('TRONROUT0000000027907418', 'TRONROUT0000000027907386', 'fd');

-- D51
select LierTroncons('TRONROUT0000000027778620', 'TRONROUT0000000115814885', 'df');
select LierTroncons('TRONROUT0000000115814885', 'TRONROUT0000000115814892', 'fd');

select LierTroncons('TRONROUT0000000027768082', 'TRONROUT0000000027767540', 'df');

select LierTroncons('TRONROUT0000000027765523', 'TRONROUT0000000027765517', 'fd');

-- D550
select LierTroncons('TRONROUT0000000294172993', 'TRONROUT0000000027775228', 'df');

-- D6
select LierTroncons('TRONROUT0000000027795675', 'TRONROUT0000000027795699', 'ff');
select LierTroncons('TRONROUT0000000027795699', 'TRONROUT0000000027797421', 'fd');
select LierTroncons('TRONROUT0000000027797421', 'TRONROUT0000000027799998', 'dd');

-- D6086
select LierTroncons('TRONROUT0000000027775902', 'TRONROUT0000000027775904', 'dd');
select LierTroncons('TRONROUT0000000027775904', 'TRONROUT0000000027800261', 'dd');
select LierTroncons('TRONROUT0000000027800261', 'TRONROUT0000000027800260', 'dd');

select LierTroncons('TRONROUT0000000027886635', 'TRONROUT0000000027886638', 'ff');
select LierTroncons('TRONROUT0000000027886638', 'TRONROUT0000000027889180', 'ff');

-- D6100
select LierTroncons('TRONROUT0000000027886588', 'TRONROUT0000000027886581', 'ff');
select LierTroncons('TRONROUT0000000027886581', 'TRONROUT0000000027879211', 'fd');
select LierTroncons('TRONROUT0000000027879211', 'TRONROUT0000000027879212', 'df');

-- D6100B
select LierTroncons('TRONROUT0000000027882586', 'TRONROUT0000000219384557', 'ff');

-- D6100C
select LierTroncons('TRONROUT0000000027882504', 'TRONROUT0000000027882616', 'dd');

-- D6110
select LierTroncons('TRONROUT0000000027824923', 'TRONROUT0000000027824935', 'dd');
select LierTroncons('TRONROUT0000000027824935', 'TRONROUT0000000027815847', 'df');

-- D7
select LierTroncons('TRONROUT0000002206442586', 'TRONROUT0000002206442585', 'ff');
select LierTroncons('TRONROUT0000002206442585', 'TRONROUT0000002206442584', 'fd');
select LierTroncons('TRONROUT0000002206442584', 'TRONROUT0000000120844611', 'dd');
select LierTroncons('TRONROUT0000000120844611', 'TRONROUT0000000120844605', 'df');

-- D736
select LierTroncons('TRONROUT0000000027873044', 'TRONROUT0000000224574350', 'fd');
select LierTroncons('TRONROUT0000000224574350', 'TRONROUT0000000224574356', 'df');

-- D787
select LierTroncons('TRONROUT0000000220872127', 'TRONROUT0000000220872128', 'ff');
select LierTroncons('TRONROUT0000000220872128', 'TRONROUT0000000220872126', 'ff');
select LierTroncons('TRONROUT0000000220872126', 'TRONROUT0000000027796196', 'fd');
select LierTroncons('TRONROUT0000000027796196', 'TRONROUT0000000027796204', 'df');
select LierTroncons('TRONROUT0000000027796204', 'TRONROUT0000000027796197', 'ff');

-- D789
select LierTroncons('TRONROUT0000000027882363', 'TRONROUT0000000027882338', 'dd');

-- D842
select LierTroncons('TRONROUT0000000027963827', 'TRONROUT0000000027965589', 'df');

-- D9
select LierTroncons('TRONROUT0000000027814017', 'TRONROUT0000000027814015', 'ff');
select LierTroncons('TRONROUT0000000027814015', 'TRONROUT0000000202618621', 'ff');

-- D901
select LierTroncons('TRONROUT0000000027771211', 'TRONROUT0000000027765111', 'dd');

-- D907
select LierTroncons('TRONROUT0000000027870000', 'TRONROUT0000000027870005', 'dd');
select LierTroncons('TRONROUT0000000027870005', 'TRONROUT0000000027869997', 'df');

select LierTroncons('TRONROUT0000000027860784', 'TRONROUT0000000027860785', 'ff');

-- D936
select LierTroncons('TRONROUT0000002000681156', 'TRONROUT0000000027863440', 'fd');

-- D976
select LierTroncons('TRONROUT0000000027836779', 'TRONROUT0000000027834004', 'fd');
select LierTroncons('TRONROUT0000000027834004', 'TRONROUT0000000027834002', 'df');

-- D979
select LierTroncons('TRONROUT0000000027922379', 'TRONROUT0000000027963540', 'fd');
select LierTroncons('TRONROUT0000000027963540', 'TRONROUT0000000027963547', 'dd');

select LierTroncons('TRONROUT0000000027972314', 'TRONROUT0000000027972312', 'ff');
select LierTroncons('TRONROUT0000000027972312', 'TRONROUT0000000027973705', 'ff');
select LierTroncons('TRONROUT0000000027973705', 'TRONROUT0000000027973706', 'ff');

-- D980
select LierTroncons('TRONROUT0000000334850345', 'TRONROUT0000000334850350', 'dd');
select LierTroncons('TRONROUT0000000334850350', 'TRONROUT0000000027826159', 'df');
select LierTroncons('TRONROUT0000000027826159', 'TRONROUT0000000309946791', 'ff');
select LierTroncons('TRONROUT0000000309946791', 'TRONROUT0000000309946780', 'ff');

-- D981
select LierTroncons('TRONROUT0000000356722965', 'TRONROUT0000000356722964', 'ff');
select LierTroncons('TRONROUT0000000356722964', 'TRONROUT0000000027835152', 'ff');
select LierTroncons('TRONROUT0000000027835152', 'TRONROUT0000000295453377', 'fd');

select LierTroncons('TRONROUT0000000123915328', 'TRONROUT0000000123915329', 'ff');
select LierTroncons('TRONROUT0000000123915329', 'TRONROUT0000000118589808', 'fd');
select LierTroncons('TRONROUT0000000118589808', 'TRONROUT0000000118589809', 'dd');

select LierTroncons('TRONROUT0000000339199997', 'TRONROUT0000002324024814', 'fd');

-- D982
select LierTroncons('TRONROUT0000000027851461', 'TRONROUT0000000027854434', 'dd');
select LierTroncons('TRONROUT0000000027854434', 'TRONROUT0000000027854439', 'dd');

select LierTroncons('TRONROUT0000000027857303', 'TRONROUT0000000295443565', 'df');
select LierTroncons('TRONROUT0000000295443565', 'TRONROUT0000000295453317', 'fd');
select LierTroncons('TRONROUT0000000295453317', 'TRONROUT0000002285691843', 'dd');

select LierTroncons('TRONROUT0000000027856711', 'TRONROUT0000000119306549', 'dd');
select LierTroncons('TRONROUT0000000119306549', 'TRONROUT0000000027856620', 'df');

-- D999
select LierTroncons('TRONROUT0000000027939103', 'TRONROUT0000000027935382', 'fd');
select LierTroncons('TRONROUT0000000027935382', 'TRONROUT0000000027935385', 'dd');

select LierTroncons('TRONROUT0000000027928360', 'TRONROUT0000000027928366', 'df');
select LierTroncons('TRONROUT0000000027928366', 'TRONROUT0000000027929821', 'fd');

select LierTroncons('TRONROUT0000000027890919', 'TRONROUT0000000027890927', 'ff');