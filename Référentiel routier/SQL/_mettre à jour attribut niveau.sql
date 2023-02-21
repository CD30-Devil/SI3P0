-- NDLR :
-- Au département du Gard, les tronçons sont classés en 4 niveaux de service, de 1 (le plus important) à 4 (le plus bas).
-- Ce script permet le remplissage de l'attribut métier correspondant "Niveau".
--
-- TODO :
-- Adapter ce script de sorte à renseigner la classification des routes du département.
--
-- Syntaxe pour une RD complète :
-- update Troncon
-- set Niveau = <Niveau>
-- where NumeroRoute = '<NumeroRoute>';
--
-- Syntaxe pour une section de RD :
-- update Troncon
-- set Niveau = <Niveau>
-- where NumeroRoute = '<NumeroRoute>'
-- and IdIGN in (
--     select _IdIGN
--     from RechercherTronconsEntreIdIGN(
--         '<NumeroRoute>',
--         array['<Tronçon 1 de début de section>', '<Tronçon 2 de début de section>', ..., '<Tronçon N de début de section>'],
--         array['<Tronçon 1 de fin de section>', '<Tronçon 2 de fin de section>', ..., '<Tronçon N de fin de section>']
--     )
-- );

-- mise à zéro préalable pour tous les tronçons
update Troncon set Niveau = 0;

-- RD non gardoises
update Troncon set Niveau = 4 where NumeroRoute = ('34D107');
update Troncon set Niveau = 4 where NumeroRoute = ('34D107E1');
update Troncon set Niveau = 3 where NumeroRoute = ('34D107E4');
update Troncon set Niveau = 4 where NumeroRoute = ('34D130E7');
update Troncon set Niveau = 3 where NumeroRoute = ('34D17E6');
update Troncon set Niveau = 4 where NumeroRoute = ('34D1E6');
update Troncon set Niveau = 3 where NumeroRoute = ('34D25');
update Troncon set Niveau = 3 where NumeroRoute = ('34D4');
update Troncon set Niveau = 3 where NumeroRoute = ('34D4E13');
update Troncon set Niveau = 1 where NumeroRoute = ('34D61');

update Troncon set Niveau = 3 where NumeroRoute = ('48D118');
update Troncon set Niveau = 2 where NumeroRoute = ('48D9');

-- RD multi-niveaux
-- D1
update Troncon
set Niveau = 3
where NumeroRoute = 'D1'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D1',
        array['TRONROUT0000000027900538'],
        array['TRONROUT0000000242505458', 'TRONROUT0000000357996161', 'TRONROUT0000000357996162', 'TRONROUT0000000357996163', 'TRONROUT0000000357996164']
    )
);

update Troncon
set Niveau = 2
where NumeroRoute = 'D1'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D1',
        array['TRONROUT0000000027952854', 'TRONROUT0000000027952868', 'TRONROUT0000000027952865', 'TRONROUT0000000027952855', 'TRONROUT0000000027952864', 'TRONROUT0000000027952876', 'TRONROUT0000000027952866', 'TRONROUT0000000027952867', 'TRONROUT0000000027952853', 'TRONROUT0000000027952870'],
        array['TRONROUT0000000027966937', 'TRONROUT0000000027966914']
    )
);

update Troncon
set Niveau = 3
where NumeroRoute = 'D1'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D1',
        array['TRONROUT0000000027966938'],
        array['TRONROUT0000000027969597']
    )
);

-- D127
update Troncon
set Niveau = 3
where NumeroRoute = 'D127'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D127',
        array['TRONROUT0000000027919319', 'TRONROUT0000000027919318'],
        array['TRONROUT0000000027899938']
    )
);

update Troncon
set Niveau = 4
where NumeroRoute = 'D127'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D127',
        array['TRONROUT0000002223169731'],
        array['TRONROUT0000000027894871']
    )
);

-- D13
update Troncon
set Niveau = 2
where NumeroRoute = 'D13'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D13',
        array['TRONROUT0000000027940304', 'TRONROUT0000000027940301'],
        array['TRONROUT0000000027949848', 'TRONROUT0000000027949842', 'TRONROUT0000000353904469', 'TRONROUT0000000027949846', 'TRONROUT0000000027949841', 'TRONROUT0000000027949847', 'TRONROUT0000000027949840']
    )
);

update Troncon
set Niveau = 3
where NumeroRoute = 'D13'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D13',
        array['TRONROUT0000000027952295', 'TRONROUT0000000027952293'],
        array['TRONROUT0000000116529603', 'TRONROUT0000000116529604']
    )
);

update Troncon
set Niveau = 2
where NumeroRoute = 'D13'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D13',
        array['TRONROUT0000000116529617'],
        array['TRONROUT0000000027964920']
    )
);

-- D135
update Troncon
set Niveau = 4
where NumeroRoute = 'D135'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D135',
        array['TRONROUT0000000298211539', 'TRONROUT0000000298211540', 'TRONROUT0000000298211546', 'TRONROUT0000000298211538', 'TRONROUT0000000298211547'],
        array['TRONROUT0000000222493600']
    )
);

update Troncon
set Niveau = 1
where NumeroRoute = 'D135'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D135',
        array['TRONROUT0000000027905335'],
        array['TRONROUT0000000027972170', 'TRONROUT0000000027973522', 'TRONROUT0000000324756978', 'TRONROUT0000000027973520', 'TRONROUT0000000027973521', 'TRONROUT0000000027972171', 'TRONROUT0000000324756977']
    )
);

update Troncon
set Niveau = 4
where NumeroRoute = 'D135'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D135',
        array['TRONROUT0000000324756973', 'TRONROUT0000000324756976'],
        array['TRONROUT0000000027975666']
    )
);

-- D138
update Troncon
set Niveau = 2
where NumeroRoute = 'D138'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D138',
        array['TRONROUT0000000242974696'],
        array['TRONROUT0000002206432615', 'TRONROUT0000002206432611']
    )
);

update Troncon
set Niveau = 4
where NumeroRoute = 'D138'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D138',
        array['TRONROUT0000002287731795', 'TRONROUT0000002287731793', 'TRONROUT0000002287731796', 'TRONROUT0000002287731794'],
        array['TRONROUT0000000027808861']
    )
);

-- D139
update Troncon
set Niveau = 3
where NumeroRoute = 'D139'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D139',
        array['TRONROUT0000000222904101'],
        array['TRONROUT0000000027963491', 'TRONROUT0000000027963490']
    )
);

update Troncon
set Niveau = 2
where NumeroRoute = 'D139'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D139',
        array['TRONROUT0000000027963513', 'TRONROUT0000000027963539', 'TRONROUT0000000027963544', 'TRONROUT0000000027963510', 'TRONROUT0000000027963500', 'TRONROUT0000000220058427', 'TRONROUT0000000027963506', 'TRONROUT0000000027963511', 'TRONROUT0000000027963521'],
        array['TRONROUT0000000027968225', 'TRONROUT0000000027968234', 'TRONROUT0000000027968226', 'TRONROUT0000000027968231', 'TRONROUT0000000027968238', 'TRONROUT0000000027968230']
    )
);

update Troncon
set Niveau = 3
where NumeroRoute = 'D139'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D139',
        array['TRONROUT0000000027968237', 'TRONROUT0000000027968236'],
        array['TRONROUT0000002216222427']
    )
);

-- D14
update Troncon
set Niveau = 2
where NumeroRoute = 'D14'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D14',
        array['TRONROUT0000000217470676'],
        array['TRONROUT0000002216941607', 'TRONROUT0000002216941608', 'TRONROUT0000002216941611', 'TRONROUT0000002216941612', 'TRONROUT0000000027958419', 'TRONROUT0000002216941605', 'TRONROUT0000000027958417']
    )
);

update Troncon
set Niveau = 3
where NumeroRoute = 'D14'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D14',
        array['TRONROUT0000000027958430', 'TRONROUT0000002216941610'],
        array['TRONROUT0000000027937998']
    )
);

-- D142
update Troncon
set Niveau = 4
where NumeroRoute = 'D142'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D142',
        array['TRONROUT0000000027966998', 'TRONROUT0000000027966993'],
        array['TRONROUT0000000120834962', 'TRONROUT0000002005292237']
    )
);

update Troncon
set Niveau = 3
where NumeroRoute = 'D142'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D142',
        array['TRONROUT0000000120834974', 'TRONROUT0000000120834958', 'TRONROUT0000000120834979', 'TRONROUT0000000356958695', 'TRONROUT0000000120834977', 'TRONROUT0000000120834980', 'TRONROUT0000000120834976', 'TRONROUT0000000120834978', 'TRONROUT0000000120834973', 'TRONROUT0000002005292238'],
        array['TRONROUT0000000027960872']
    )
);

-- D16
update Troncon
set Niveau = 1
where NumeroRoute = 'D16'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D16',
        array['TRONROUT0000000027805847', 'TRONROUT0000000027805829', 'TRONROUT0000000027805837', 'TRONROUT0000000027805849', 'TRONROUT0000000027805836', 'TRONROUT0000000027805835', 'TRONROUT0000000312696331', 'TRONROUT0000000027805848', 'TRONROUT0000000027805831', 'TRONROUT0000000027805828', 'TRONROUT0000000027805838', 'TRONROUT0000000027805830'],
        array['TRONROUT0000000027796766']
    )
);

update Troncon
set Niveau = 3
where NumeroRoute = 'D16'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D16',
        array['TRONROUT0000000027796681'],
        array['TRONROUT0000000027789477']
    )
);

update Troncon
set Niveau = 2
where NumeroRoute = 'D16'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D16',
        array['TRONROUT0000000027789462', 'TRONROUT0000000027789483', 'TRONROUT0000000027789469', 'TRONROUT0000000027789467', 'TRONROUT0000000027789461', 'TRONROUT0000000027789488', 'TRONROUT0000000027789468', 'TRONROUT0000000027789471', 'TRONROUT0000000027789466'],
        array['TRONROUT0000000248372431']
    )
);

-- D19
update Troncon
set Niveau = 1
where NumeroRoute = 'D19'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D19',
        array['TRONROUT0000000027883505', 'TRONROUT0000000027883506', 'TRONROUT0000000027883515', 'TRONROUT0000000027883513', 'TRONROUT0000000027883516', 'TRONROUT0000000027883511', 'TRONROUT0000000027883514', 'TRONROUT0000000027883522'],
        array['TRONROUT0000000027883479', 'TRONROUT0000000027883474', 'TRONROUT0000000027883475', 'TRONROUT0000000027883476', 'TRONROUT0000000027883480', 'TRONROUT0000000027883481']
    )
);

update Troncon
set Niveau = 4
where NumeroRoute = 'D19'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D19',
        array['TRONROUT0000000027883458', 'TRONROUT0000000027883447'],
        array['TRONROUT0000000027904610']
    )
);

-- D39
update Troncon
set Niveau = 2
where NumeroRoute = 'D39'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D39',
        array['TRONROUT0000000027885260', 'TRONROUT0000000027885162', 'TRONROUT0000000027885172', 'TRONROUT0000000027885173', 'TRONROUT0000000027885170'],
        array['TRONROUT0000000027851757']
    )
);

update Troncon
set Niveau = 3
where NumeroRoute = 'D39'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D39',
        array['TRONROUT0000000027848729'],
        array['TRONROUT0000000099571846']
    )
);

-- D51
update Troncon
set Niveau = 2
where NumeroRoute = 'D51'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D51',
        array['TRONROUT0000000027779798'],
        array['TRONROUT0000000027772782']
    )
);


update Troncon
set Niveau = 3
where NumeroRoute = 'D51'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D51',
        array['TRONROUT0000000027772787', 'TRONROUT0000000027772764'],
        array['TRONROUT0000000027765380']
    )
);

-- D765
update Troncon
set Niveau = 2
where NumeroRoute = 'D765'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D765',
        array['TRONROUT0000002206432619', 'TRONROUT0000002206432617'],
        array['TRONROUT0000000356707715', 'TRONROUT0000000356707716', 'TRONROUT0000000356707707', 'TRONROUT0000000358008712', 'TRONROUT0000002011760398', 'TRONROUT0000000356707713', 'TRONROUT0000000356707714']
    )
);

update Troncon
set Niveau = 3
where NumeroRoute = 'D765'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D765',
        array['TRONROUT0000000356707704', 'TRONROUT0000000356707712'],
        array['TRONROUT0000000220052841', 'TRONROUT0000000220052755', 'TRONROUT0000002203639430', 'TRONROUT0000002203639429']
    )
);

-- D9
update Troncon
set Niveau = 2
where NumeroRoute = 'D9'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D9',
        array['TRONROUT0000000027820140'],
        array['TRONROUT0000000027817219', 'TRONROUT0000000027817220', 'TRONROUT0000000027817223', 'TRONROUT0000000027817218', 'TRONROUT0000000027817222', 'TRONROUT0000000027817221']
    )
);

update Troncon
set Niveau = 3
where NumeroRoute = 'D9'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D9',
        array['TRONROUT0000000027817190', 'TRONROUT0000000027817207'],
        array['TRONROUT0000000119160069', 'TRONROUT0000000119160057', 'TRONROUT0000000119160062']
    )
);

-- D979
update Troncon
set Niveau = 2
where NumeroRoute = 'D979'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D979',
        array['TRONROUT0000000005729468'],
        array['TRONROUT0000000027972352', 'TRONROUT0000000027972358', 'TRONROUT0000000027972317', 'TRONROUT0000000027972303', 'TRONROUT0000000027972308', 'TRONROUT0000000027972300', 'TRONROUT0000000027972315', 'TRONROUT0000000027972353']
    )
);

update Troncon
set Niveau = 1
where NumeroRoute = 'D979'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D979',
        array['TRONROUT0000000027973705', 'TRONROUT0000000027973706', 'TRONROUT0000000027973721', 'TRONROUT0000000027973707', 'TRONROUT0000000027973693', 'TRONROUT0000000027973692', 'TRONROUT0000000027973709', 'TRONROUT0000000027973754', 'TRONROUT0000000027973700', 'TRONROUT0000000027973701'],
        array['TRONROUT0000000027983007', 'TRONROUT0000000027983009', 'TRONROUT0000000027983006', 'TRONROUT0000000027983008', 'TRONROUT0000000214230349', 'TRONROUT0000000214230353', 'TRONROUT0000000027982985']
    )
);

-- D981
update Troncon
set Niveau = 1
where NumeroRoute = 'D981'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D981',
        array['TRONROUT0000000027818736', 'TRONROUT0000000027818753', 'TRONROUT0000000027818726', 'TRONROUT0000000027818727', 'TRONROUT0000000027818731', 'TRONROUT0000000027818722', 'TRONROUT0000000027818728', 'TRONROUT0000000027818758', 'TRONROUT0000000027818759', 'TRONROUT0000000027818760'],
        array['TRONROUT0000000027824660', 'TRONROUT0000000027824642', 'TRONROUT0000000027824644', 'TRONROUT0000000027824645', 'TRONROUT0000000027824658', 'TRONROUT0000000027824659']
    )
);

update Troncon
set Niveau = 2
where NumeroRoute = 'D981'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D981',
        array['TRONROUT0000000027824647', 'TRONROUT0000000027824653'],
        array['TRONROUT0000000123915335', 'TRONROUT0000000123915342', 'TRONROUT0000000123915339', 'TRONROUT0000000123915338', 'TRONROUT0000000123915333']
    )
);

update Troncon
set Niveau = 1
where NumeroRoute = 'D981'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D981',
        array['TRONROUT0000000118589809', 'TRONROUT0000000118589808', 'TRONROUT0000000118589800', 'TRONROUT0000000118589805', 'TRONROUT0000000118589803', 'TRONROUT0000000118589801', 'TRONROUT0000000118589802', 'TRONROUT0000000118589804'],
        array['TRONROUT0000000027883511', 'TRONROUT0000000027883514', 'TRONROUT0000000027883522', 'TRONROUT0000000027883515', 'TRONROUT0000000027883513', 'TRONROUT0000000027883516']
    )
);

update Troncon
set Niveau = 3
where NumeroRoute = 'D981'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D981',
        array['TRONROUT0000000027883519', 'TRONROUT0000000027883508'],
        array['TRONROUT0000000308655969', 'TRONROUT0000000027889262', 'TRONROUT0000000308655970', 'TRONROUT0000000027889259', 'TRONROUT0000000308655968', 'TRONROUT0000000308655967']
    )
);

-- RD de niveau 1
update Troncon set Niveau = 1 where NumeroRoute = ('D135B'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D135C'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D135D'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D19A'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D40'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D42'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D60'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6086'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D60B'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D60C'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D60D'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6100'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6100A'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6100B'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6100C'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6100D'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6101'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6110'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6113'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6113A'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6113B'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D62'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D62A'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D62B'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D62C'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6313'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D640'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6572'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6572A'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D6580'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D90'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D904'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D90A'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D90B'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D910A'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D979A'); 
update Troncon set Niveau = 1 where NumeroRoute = ('D999');

-- RD de niveau 2
update Troncon set Niveau = 2 where NumeroRoute = ('D128'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D129'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D131'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D15'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D177'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D2'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D22'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D225'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D24'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D255'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D260'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D262'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D2E'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D324A'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D35'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D38'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D385'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D385A'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D442'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D45'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D46'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D48N'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D540'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D56'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D57'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D58'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D59'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D613'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D7'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D765A'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D901'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D906'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D907'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D936'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D976'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D980'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D982'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D986'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D986L'); 
update Troncon set Niveau = 2 where NumeroRoute = ('D994');

-- RD de niveau 3
update Troncon set Niveau = 3 where NumeroRoute = ('D10'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D101'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D101A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D10B'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D10C'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D10D'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D11'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D113'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D113A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D113B'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D114'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D11A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D125'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D126'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D130'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D132'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D138A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D145'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D157'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D158'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D15A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D160'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D163'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D18'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D181'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D181A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D181B'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D183'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D183A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D192'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D19B'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D1A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D202'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D22A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D23'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D235'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D241'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D242'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D25'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D26'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D263'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D269'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D26A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D27'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D279'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D28'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D2B'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D3'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D340'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D343'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D346'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D350'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D351'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D37'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D395'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D3B'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D4'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D402'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D404'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D405'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D407'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D40A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D40C'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D40D'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D418'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D427'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D442A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D47'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D47A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D47B'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D47C'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D48S'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D49'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D5'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D50'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D502'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D50A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D50B'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D50C'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D51A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D51B'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D51C'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D51F'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D58E'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D6A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D6C'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D6D'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D712'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D780'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D7A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D8'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D814'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D900'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D916'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D926'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D926A'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D983'); 
update Troncon set Niveau = 3 where NumeroRoute = ('D998');

-- RD de niveau 4
update Troncon set Niveau = 4 where NumeroRoute = ('D102'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D103'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D104'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D105'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D106'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D106A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D107'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D107A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D108'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D109'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D10A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D110'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D110A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D110B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D110C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D110D'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D110E'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D110F'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D110G'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D111'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D112'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D114A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D115'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D115A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D116'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D116A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D117'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D118'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D118A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D12'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D120'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D120B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D120C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D121'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D122'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D123'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D123A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D123B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D123C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D124'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D125A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D129A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D131B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D131C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D132A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D133'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D133A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D133B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D134'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D134A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D135A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D136'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D136B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D136D'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D137'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D138B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D138C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D140'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D141'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D142A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D143'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D143A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D143B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D144'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D144A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D145A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D146'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D146A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D147'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D147A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D147B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D148'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D148A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D149'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D151'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D151A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D151B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D151C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D152'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D152A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D152B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D152C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D153'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D153A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D153B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D153C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D153D'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D154'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D154A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D155'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D155A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D156'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D156A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D156B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D158A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D158B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D158C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D159'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D159A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D159B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D159C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D161'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D162'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D164'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D165'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D166'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D166A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D166B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D166C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D167'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D167A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D168'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D169'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D169A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D16B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D17'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D170'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D170B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D170C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D170D'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D170E'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D170F'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D171'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D171A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D172'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D174'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D175'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D176'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D178'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D179'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D180'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D182'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D184'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D185'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D185A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D186'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D186A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D187'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D187A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D187C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D188'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D188A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D188B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D189'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D189A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D18C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D18D'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D190'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D190A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D191'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D191A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D193'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D194'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D194A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D194B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D194C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D194D'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D195'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D196'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D196A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D197'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D198'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D199'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D20'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D200'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D201'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D203'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D204'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D205'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D206'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D207'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D207A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D208'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D208A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D209'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D209A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D20A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D20B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D20C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D20D'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D21'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D210'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D210A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D211'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D212'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D213'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D215'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D215A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D215B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D216'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D216A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D217'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D217A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D217B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D218'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D218A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D219'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D220'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D221'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D222'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D223'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D226'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D227'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D228'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D229'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D230'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D231'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D232'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D233'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D234'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D236'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D237'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D238'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D238A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D239'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D239B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D23A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D23B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D240'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D243'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D243A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D244'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D245'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D245A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D246'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D246A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D247'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D248'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D249'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D250'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D251'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D252'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D253'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D254'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D255B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D256'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D257'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D258'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D259'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D261'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D264'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D265'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D266'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D266A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D266B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D266C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D267'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D268'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D269B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D269C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D270'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D270A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D270B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D271'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D272'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D272A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D272B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D272C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D272D'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D272E'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D272F'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D272G'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D272H'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D273'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D273A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D274'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D275'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D276'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D276A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D277'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D278'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D27A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D27B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D27C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D27D'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D280'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D282'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D283'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D283A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D283B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D283C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D284'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D284A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D284B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D285'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D286'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D287'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D288'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D289'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D289A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D29'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D290'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D291'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D292'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D292A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D293'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D294'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D295'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D296'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D297'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D297A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D297B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D297C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D298'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D298A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D299A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D29A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D2A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D300'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D301'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D302'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D303'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D304'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D305'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D306'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D307'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D308'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D309'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D31'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D310'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D311'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D312'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D313'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D314'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D315'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D315A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D316'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D317'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D318'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D318A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D318B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D319'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D32'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D320'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D321'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D322'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D323'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D325'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D326'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D326A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D326B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D327'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D328'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D329'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D329A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D32A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D32B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D330'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D330A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D331'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D332'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D333'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D334'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D334A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D335'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D336'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D336A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D337'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D338'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D339'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D341'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D341A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D344'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D345'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D345A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D347'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D348'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D349'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D349A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D350A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D350B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D351A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D352'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D353'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D354'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D355'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D356'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D357'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D357A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D359'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D35A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D360'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D361'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D361A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D362'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D363'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D364'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D365'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D366'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D367'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D367A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D368'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D369'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D370'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D371'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D372'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D374'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D375'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D376'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D377'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D378'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D378A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D37A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D37B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D380'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D381'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D383'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D383A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D384'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D386'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D387'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D391'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D394'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D39A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D39B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D39C'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D3A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D401'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D403'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D406'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D408'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D409'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D40B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D412'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D413'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D416'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D420'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D420A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D422'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D424'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D430'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D432'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D432A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D432B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D434A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D435'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D437'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D44'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D440'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D447'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D448'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D450'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D451'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D452'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D453'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D454'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D48A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D500'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D500A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D501'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D504'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D505'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D509'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D50D'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D512'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D513'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D514'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D518'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D51D'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D51G'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D52'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D522'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D52A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D532'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D537'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D546'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D548'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D548A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D550'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D551'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D553'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D59B'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D59EX'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D5A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D603'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D607'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D607A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D609'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D60A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D618'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D622'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D632'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D642'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D643'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D648'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D649'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D650'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D677'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D680'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D686'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D687'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D701'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D702'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D703'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D706'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D710'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D713'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D714'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D715'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D716'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D718'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D720'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D722'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D723'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D724'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D728'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D736'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D736A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D737'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D742'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D746'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D747'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D754'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D755'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D757'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D763'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D764'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D779'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D787'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D789'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D790'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D790A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D792'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D803'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D812'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D813'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D823'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D842'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D842A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D843'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D865'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D892'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D901A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D986A'); 
update Troncon set Niveau = 4 where NumeroRoute = ('D999B');

-- remise à null pour les tronçons fictifs
update Troncon
set Niveau = null
where Fictif;