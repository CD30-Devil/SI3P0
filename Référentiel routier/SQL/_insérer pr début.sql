-- Rédiger ici les ordres d'insertion des points de repères de début de chaque route départementale.
-- Ce fichier peut être initialisé lors de la première itération, puis comparé pour les itérations suivantes, au résultat de la fonction de recalage automatique des PR de début.
-- L'appel à la fonction de recalage est présent dans le fichier _recaler pr début.sql.
--
-- Syntaxe :
-- insert into PR (NumeroRoute, PRA, CumulDist, Geom)
-- select
--     '<NumeroRoute de rattachement du repère>'::character varying,
--     <PR+Abs du repère sous la forme PR * 10000 + Abs>::integer,
--     <Distance cumulée depuis le début de la route soit, sauf cas particulier, 0>::numeric,
--     <ST_StartPoint/ST_EndPoint>(Geom)
-- from BDT2RR_Troncon where NumeroRoute = '<NumeroRoute de rattachement du repère>' and IdIGN = '<cleabs du tronçon de début de route>';

-- 34D107
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '34D107'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '34D107' and IdIGN = 'TRONROUT0000000044748877';

-- 34D107E1
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '34D107E1'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '34D107E1' and IdIGN = 'TRONROUT0000000044744188';

-- 34D107E4
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '34D107E4'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '34D107E4' and IdIGN = 'TRONROUT0000000044741726';

-- 34D130E7
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '34D130E7'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '34D130E7' and IdIGN = 'TRONROUT0000000044740582';

-- 34D17E6
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '34D17E6'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '34D17E6' and IdIGN = 'TRONROUT0000000119234999';

-- 34D17E6
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '34D17E6'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '34D17E6' and IdIGN = 'TRONROUT0000000119234994';

-- 34D1E6
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '34D1E6'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '34D1E6' and IdIGN = 'TRONROUT0000000044747054';

-- 34D25
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '34D25'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '34D25' and IdIGN = 'TRONROUT0000000220046696';

-- 34D25
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '34D25'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '34D25' and IdIGN = 'TRONROUT0000000220046695';

-- 34D4
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '34D4'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '34D4' and IdIGN = 'TRONROUT0000000244464981';

-- 34D4
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '34D4'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '34D4' and IdIGN = 'TRONROUT0000000244464982';

-- 34D4E13
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '34D4E13'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '34D4E13' and IdIGN = 'TRONROUT0000000338943841';

-- 34D4E13
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '34D4E13'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '34D4E13' and IdIGN = 'TRONROUT0000000338943839';

-- 34D61
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '34D61'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '34D61' and IdIGN = 'TRONROUT0000000044784036';

-- 34D61
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '34D61'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '34D61' and IdIGN = 'TRONROUT0000000044784038';

-- 48D118
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '48D118'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '48D118' and IdIGN = 'TRONROUT0000000099572563';

-- 48D9
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select '48D9'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = '48D9' and IdIGN = 'TRONROUT0000000099559911';

-- D1
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D1'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D1' and IdIGN = 'TRONROUT0000000027900538';

-- D10
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D10'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D10' and IdIGN = 'TRONROUT0000000027833588';

-- D101
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D101'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D101' and IdIGN = 'TRONROUT0000000027843926';

-- D101A
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D101A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D101A' and IdIGN = 'TRONROUT0000000088881660';

-- D102
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D102'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D102' and IdIGN = 'TRONROUT0000000119280882';

-- D103
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D103'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D103' and IdIGN = 'TRONROUT0000000027937635';

-- D103
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D103'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D103' and IdIGN = 'TRONROUT0000000348280943';

-- D104
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D104'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D104' and IdIGN = 'TRONROUT0000000027962129';

-- D105
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D105'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D105' and IdIGN = 'TRONROUT0000000348280891';

-- D105
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D105'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D105' and IdIGN = 'TRONROUT0000000348280960';

-- D106
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D106'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D106' and IdIGN = 'TRONROUT0000000027841866';

-- D106
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D106'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D106' and IdIGN = 'TRONROUT0000000027841874';

-- D106A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D106A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D106A' and IdIGN = 'TRONROUT0000000027854214';

-- D107
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D107'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D107' and IdIGN = 'TRONROUT0000000332178237';

-- D107
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D107'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D107' and IdIGN = 'TRONROUT0000000332178234';

-- D107A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D107A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D107A' and IdIGN = 'TRONROUT0000000027938389';

-- D108
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D108'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D108' and IdIGN = 'TRONROUT0000000119280943';

-- D108
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D108'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D108' and IdIGN = 'TRONROUT0000000119280947';

-- D109
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D109'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D109' and IdIGN = 'TRONROUT0000000027873774';

-- D10A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D10A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D10A' and IdIGN = 'TRONROUT0000000027802170';

-- D10B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D10B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D10B' and IdIGN = 'TRONROUT0000000227728957';

-- D10C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D10C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D10C' and IdIGN = 'TRONROUT0000000027802145';

-- D10D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D10D'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D10D' and IdIGN = 'TRONROUT0000000027819789';

-- D11
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D11'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D11' and IdIGN = 'TRONROUT0000000027874454';

-- D110
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D110'::character varying, 155::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D110' and IdIGN = 'TRONROUT0000000350792716';

-- D110A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D110A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D110A' and IdIGN = 'TRONROUT0000000027891010';

-- D110B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D110B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D110B' and IdIGN = 'TRONROUT0000000027878497';

-- D110C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D110C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D110C' and IdIGN = 'TRONROUT0000000027896168';

-- D110D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D110D'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D110D' and IdIGN = 'TRONROUT0000000350792711';

-- D110E
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D110E'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D110E' and IdIGN = 'TRONROUT0000000027874595';

-- D110F
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D110F'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D110F' and IdIGN = 'TRONROUT0000000027898753';

-- D110G
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D110G'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D110G' and IdIGN = 'TRONROUT0000000027891005';

-- D111
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D111'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D111' and IdIGN = 'TRONROUT0000000118724949';

-- D111
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D111'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D111' and IdIGN = 'TRONROUT0000000118724952';

-- D111
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D111'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D111' and IdIGN = 'TRONROUT0000000118724950';

-- D111
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D111'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D111' and IdIGN = 'TRONROUT0000000118724960';

-- D112
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D112'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D112' and IdIGN = 'TRONROUT0000000027886914';

-- D112
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D112'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D112' and IdIGN = 'TRONROUT0000000027886919';

-- D113
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D113'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D113' and IdIGN = 'TRONROUT0000000027896153';

-- D113A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D113A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D113A' and IdIGN = 'TRONROUT0000000211098911';

-- D113B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D113B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D113B' and IdIGN = 'TRONROUT0000000289381983';

-- D114
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D114'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D114' and IdIGN = 'TRONROUT0000000224528378';

-- D114
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D114'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D114' and IdIGN = 'TRONROUT0000000224528393';

-- D114A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D114A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D114A' and IdIGN = 'TRONROUT0000000027857103';

-- D115
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D115'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D115' and IdIGN = 'TRONROUT0000000118266026';

-- D115
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D115'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D115' and IdIGN = 'TRONROUT0000000118266027';

-- D115
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D115'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D115' and IdIGN = 'TRONROUT0000000118266021';

-- D115A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D115A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D115A' and IdIGN = 'TRONROUT0000000027827092';

-- D116
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D116'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D116' and IdIGN = 'TRONROUT0000000356722948';

-- D116
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D116'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D116' and IdIGN = 'TRONROUT0000000356722980';

-- D116A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D116A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D116A' and IdIGN = 'TRONROUT0000000027838218';

-- D117
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D117'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D117' and IdIGN = 'TRONROUT0000002215488686';

-- D117
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D117'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D117' and IdIGN = 'TRONROUT0000002274801764';

-- D118
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D118'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D118' and IdIGN = 'TRONROUT0000000027918205';

-- D118
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D118'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D118' and IdIGN = 'TRONROUT0000000027918209';

-- D118A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D118A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D118A' and IdIGN = 'TRONROUT0000000355923504';

-- D11A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D11A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D11A' and IdIGN = 'TRONROUT0000000356420948';

-- D12
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D12'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D12' and IdIGN = 'TRONROUT0000000027972512';

-- D12
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D12'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D12' and IdIGN = 'TRONROUT0000000027972525';

-- D12
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D12'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D12' and IdIGN = 'TRONROUT0000000027972548';

-- D120
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D120'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D120' and IdIGN = 'TRONROUT0000000027844983';

-- D120B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D120B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D120B' and IdIGN = 'TRONROUT0000000027853921';

-- D120C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D120C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D120C' and IdIGN = 'TRONROUT0000000027863022';

-- D121
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D121'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D121' and IdIGN = 'TRONROUT0000000309686791';

-- D122
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D122'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D122' and IdIGN = 'TRONROUT0000000027867060';

-- D123
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D123'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D123' and IdIGN = 'TRONROUT0000000027877556';

-- D123A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D123A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D123A' and IdIGN = 'TRONROUT0000000287637038';

-- D123B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D123B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D123B' and IdIGN = 'TRONROUT0000000027909074';

-- D123C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D123C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D123C' and IdIGN = 'TRONROUT0000000027895559';

-- D124
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D124'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D124' and IdIGN = 'TRONROUT0000000118474899';

-- D124
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D124'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D124' and IdIGN = 'TRONROUT0000000118474914';

-- D125
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D125'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D125' and IdIGN = 'TRONROUT0000000220867740';

-- D125A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D125A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D125A' and IdIGN = 'TRONROUT0000000027840989';

-- D126
-- îlot
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D126'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D126' and IdIGN = 'TRONROUT0000000027910015';

-- D127
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D127'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D127' and IdIGN = 'TRONROUT0000000027919319';

-- D127
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D127'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D127' and IdIGN = 'TRONROUT0000000027919318';

-- D128
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D128'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D128' and IdIGN = 'TRONROUT0000000027791823';

-- D128
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D128'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D128' and IdIGN = 'TRONROUT0000000230103645';

-- D129
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D129'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D129' and IdIGN = 'TRONROUT0000000027842024';

-- D129
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D129'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D129' and IdIGN = 'TRONROUT0000000027842027';

-- D129A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D129A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D129A' and IdIGN = 'TRONROUT0000000027842053';

-- D129A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D129A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D129A' and IdIGN = 'TRONROUT0000000027842055';

-- D13
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D13'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D13' and IdIGN = 'TRONROUT0000000027940301';

-- D13
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D13'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D13' and IdIGN = 'TRONROUT0000000027940304';

-- D130
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D130'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D130' and IdIGN = 'TRONROUT0000000358006873';

-- D131
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D131'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D131' and IdIGN = 'TRONROUT0000000118224744';

-- D131
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D131'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D131' and IdIGN = 'TRONROUT0000000118224746';

-- D131B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D131B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D131B' and IdIGN = 'TRONROUT0000000312696500';

-- D131B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D131B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D131B' and IdIGN = 'TRONROUT0000000312696488';

-- D131C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D131C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D131C' and IdIGN = 'TRONROUT0000000027796765';

-- D132
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D132'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D132' and IdIGN = 'TRONROUT0000000027786303';

-- D132A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D132A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D132A' and IdIGN = 'TRONROUT0000000027786210';

-- D133
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D133'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D133' and IdIGN = 'TRONROUT0000000027885076';

-- D133
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D133'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D133' and IdIGN = 'TRONROUT0000000214970306';

-- D133A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D133A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D133A' and IdIGN = 'TRONROUT0000000027867108';

-- D133B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D133B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D133B' and IdIGN = 'TRONROUT0000000027854626';

-- D134
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D134'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D134' and IdIGN = 'TRONROUT0000000027767269';

-- D134A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D134A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D134A' and IdIGN = 'TRONROUT0000000027768199';

-- D135
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D135'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D135' and IdIGN = 'TRONROUT0000000298211539';

-- D135
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D135'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D135' and IdIGN = 'TRONROUT0000000298211540';

-- D135
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D135'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D135' and IdIGN = 'TRONROUT0000000298211547';

-- D135A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D135A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D135A' and IdIGN = 'TRONROUT0000000027942726';

-- D135A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D135A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D135A' and IdIGN = 'TRONROUT0000000324756783';

-- D135B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D135B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D135B' and IdIGN = 'TRONROUT0000000027916047';

-- D135C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D135C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D135C' and IdIGN = 'TRONROUT0000000027919075';

-- D135D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D135D'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D135D' and IdIGN = 'TRONROUT0000000027916046';

-- D136
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D136'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D136' and IdIGN = 'TRONROUT0000000027844507';

-- D136B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D136B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D136B' and IdIGN = 'TRONROUT0000000027840966';

-- D136D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D136D'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D136D' and IdIGN = 'TRONROUT0000000027847408';

-- D137
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D137'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D137' and IdIGN = 'TRONROUT0000000027945925';

-- D138
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D138'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D138' and IdIGN = 'TRONROUT0000000242974696';

-- D138A
-- présence de tronçons avant le PR0
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D138A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D138A' and IdIGN = 'TRONROUT0000000027808743';

-- D138B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D138B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D138B' and IdIGN = 'TRONROUT0000000027806522';

-- D138B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D138B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D138B' and IdIGN = 'TRONROUT0000000027806523';

-- D138C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D138C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D138C' and IdIGN = 'TRONROUT0000000113382546';

-- D139
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D139'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D139' and IdIGN = 'TRONROUT0000000222904101';

-- D14
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D14'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D14' and IdIGN = 'TRONROUT0000000217470676';

-- D140
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D140'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D140' and IdIGN = 'TRONROUT0000000027955240';

-- D141
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D141'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D141' and IdIGN = 'TRONROUT0000000357263127';

-- D142
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D142'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D142' and IdIGN = 'TRONROUT0000000027966993';

-- D142
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D142'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D142' and IdIGN = 'TRONROUT0000000027966998';

-- D142A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D142A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D142A' and IdIGN = 'TRONROUT0000000027960686';

-- D143
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D143'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D143' and IdIGN = 'TRONROUT0000000027803131';

-- D143A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D143A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D143A' and IdIGN = 'TRONROUT0000000027796091';

-- D143B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D143B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D143B' and IdIGN = 'TRONROUT0000000027796060';

-- D144
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D144'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D144' and IdIGN = 'TRONROUT0000000027814228';

-- D144A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D144A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D144A' and IdIGN = 'TRONROUT0000000027817759';

-- D145
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D145'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D145' and IdIGN = 'TRONROUT0000000202618620';

-- D145A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D145A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D145A' and IdIGN = 'TRONROUT0000000327506069';

-- D146
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D146'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D146' and IdIGN = 'TRONROUT0000000027772755';

-- D146A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D146A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D146A' and IdIGN = 'TRONROUT0000000027775585';

-- D147
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D147'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D147' and IdIGN = 'TRONROUT0000000027798632';

-- D147A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D147A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D147A' and IdIGN = 'TRONROUT0000000027798713';

-- D147B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D147B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D147B' and IdIGN = 'TRONROUT0000000027796592';

-- D148
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D148'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D148' and IdIGN = 'TRONROUT0000000027786829';

-- D148A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D148A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D148A' and IdIGN = 'TRONROUT0000000027788647';

-- D149
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D149'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D149' and IdIGN = 'TRONROUT0000000027873771';

-- D15
-- îlot
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D15'::character varying, 10738::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D15' and IdIGN = 'TRONROUT0000000027944423';

-- D151
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D151'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D151' and IdIGN = 'TRONROUT0000000027833712';

-- D151A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D151A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D151A' and IdIGN = 'TRONROUT0000000027842929';

-- D151B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D151B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D151B' and IdIGN = 'TRONROUT0000000027846200';

-- D151C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D151C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D151C' and IdIGN = 'TRONROUT0000000027839656';

-- D152
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D152'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D152' and IdIGN = 'TRONROUT0000000027842698';

-- D152A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D152A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D152A' and IdIGN = 'TRONROUT0000000027848980';

-- D152B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D152B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D152B' and IdIGN = 'TRONROUT0000000211145634';

-- D152C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D152C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D152C' and IdIGN = 'TRONROUT0000000027845970';

-- D153
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D153'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D153' and IdIGN = 'TRONROUT0000000295040819';

-- D153A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D153A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D153A' and IdIGN = 'TRONROUT0000000027878293';

-- D153B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D153B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D153B' and IdIGN = 'TRONROUT0000000027839236';

-- D153C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D153C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D153C' and IdIGN = 'TRONROUT0000000027842415';

-- D153D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D153D'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D153D' and IdIGN = 'TRONROUT0000000027839311';

-- D154
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D154'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D154' and IdIGN = 'TRONROUT0000000027790285';

-- D154A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D154A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D154A' and IdIGN = 'TRONROUT0000000027788474';

-- D155
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D155'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D155' and IdIGN = 'TRONROUT0000000120485354';

-- D155
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D155'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D155' and IdIGN = 'TRONROUT0000000120485361';

-- D155
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D155'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D155' and IdIGN = 'TRONROUT0000000120485365';

-- D155
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D155'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D155' and IdIGN = 'TRONROUT0000000120485360';

-- D155A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D155A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D155A' and IdIGN = 'TRONROUT0000000291825354';

-- D156
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D156'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D156' and IdIGN = 'TRONROUT0000000027767711';

-- D156A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D156A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D156A' and IdIGN = 'TRONROUT0000000027770392';

-- D156B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D156B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D156B' and IdIGN = 'TRONROUT0000000027769470';

-- D157
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D157'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D157' and IdIGN = 'TRONROUT0000000027825878';

-- D158
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D158'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D158' and IdIGN = 'TRONROUT0000000027888482';

-- D158
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D158'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D158' and IdIGN = 'TRONROUT0000002220855574';

-- D158A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D158A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D158A' and IdIGN = 'TRONROUT0000000027898996';

-- D158B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D158B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D158B' and IdIGN = 'TRONROUT0000000211099017';

-- D158C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D158C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D158C' and IdIGN = 'TRONROUT0000000027885850';

-- D159
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D159'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D159' and IdIGN = 'TRONROUT0000000027823161';

-- D159A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D159A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D159A' and IdIGN = 'TRONROUT0000000207139197';

-- D159B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D159B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D159B' and IdIGN = 'TRONROUT0000000027823194';

-- D159C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D159C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D159C' and IdIGN = 'TRONROUT0000000027833855';

-- D15A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D15A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D15A' and IdIGN = 'TRONROUT0000000027969926';

-- D15A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D15A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D15A' and IdIGN = 'TRONROUT0000000027969953';

-- D16
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D16'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D16' and IdIGN = 'TRONROUT0000000027805847';

-- D16
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D16'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D16' and IdIGN = 'TRONROUT0000000027805829';

-- D160
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D160'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D160' and IdIGN = 'TRONROUT0000000027806223';

-- D161
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D161'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D161' and IdIGN = 'TRONROUT0000000027850779';

-- D162
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D162'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D162' and IdIGN = 'TRONROUT0000000027780232';

-- D163
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D163'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D163' and IdIGN = 'TRONROUT0000000027927716';

-- D164
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D164'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D164' and IdIGN = 'TRONROUT0000000027938427';

-- D165
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D165'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D165' and IdIGN = 'TRONROUT0000000217088142';

-- D166
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D166'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D166' and IdIGN = 'TRONROUT0000000224680278';

-- D166A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D166A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D166A' and IdIGN = 'TRONROUT0000000027820673';

-- D166B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D166B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D166B' and IdIGN = 'TRONROUT0000000358006778';

-- D166C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D166C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D166C' and IdIGN = 'TRONROUT0000000027804889';

-- D167
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D167'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D167' and IdIGN = 'TRONROUT0000000116529560';

-- D167
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D167'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D167' and IdIGN = 'TRONROUT0000000116529557';

-- D167
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D167'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D167' and IdIGN = 'TRONROUT0000000116529574';

-- D167A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D167A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D167A' and IdIGN = 'TRONROUT0000000354055242';

-- D167A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D167A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D167A' and IdIGN = 'TRONROUT0000000354055241';

-- D168
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D168'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D168' and IdIGN = 'TRONROUT0000000027924130';

-- D169
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D169'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D169' and IdIGN = 'TRONROUT0000000027861421';

-- D169A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D169A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D169A' and IdIGN = 'TRONROUT0000000027881547';

-- D16B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D16B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D16B' and IdIGN = 'TRONROUT0000000027801536';

-- D17
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D17'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D17' and IdIGN = 'TRONROUT0000000027768210';

-- D170
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D170'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D170' and IdIGN = 'TRONROUT0000000027874753';

-- D170B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D170B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D170B' and IdIGN = 'TRONROUT0000000027861576';

-- D170C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D170C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D170C' and IdIGN = 'TRONROUT0000000027874715';

-- D170D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D170D'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D170D' and IdIGN = 'TRONROUT0000000347747092';

-- D170E
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D170E'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D170E' and IdIGN = 'TRONROUT0000002007006889';

-- D170F
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D170F'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D170F' and IdIGN = 'TRONROUT0000000027878616';

-- D171
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D171'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D171' and IdIGN = 'TRONROUT0000000027777039';

-- D171A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D171A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D171A' and IdIGN = 'TRONROUT0000000027781244';

-- D172
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D172'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D172' and IdIGN = 'TRONROUT0000000099569549';

-- D174
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D174'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D174' and IdIGN = 'TRONROUT0000000027768962';

-- D175
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D175'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D175' and IdIGN = 'TRONROUT0000000358008393';

-- D176
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D176'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D176' and IdIGN = 'TRONROUT0000000027769139';

-- D177
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D177'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D177' and IdIGN = 'TRONROUT0000000119280785';

-- D177
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D177'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D177' and IdIGN = 'TRONROUT0000000119280796';

-- D178
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D178'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D178' and IdIGN = 'TRONROUT0000000337454829';

-- D178
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D178'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D178' and IdIGN = 'TRONROUT0000000337454817';

-- D179
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D179'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D179' and IdIGN = 'TRONROUT0000000027967529';

-- D18
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D18'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D18' and IdIGN = 'TRONROUT0000000027886913';

-- D18
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D18'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D18' and IdIGN = 'TRONROUT0000000027886920';

-- D180
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D180'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D180' and IdIGN = 'TRONROUT0000000027778022';

-- D181
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D181'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D181' and IdIGN = 'TRONROUT0000000027915294';

-- D181A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D181A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D181A' and IdIGN = 'TRONROUT0000000027909585';

-- D181B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D181B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D181B' and IdIGN = 'TRONROUT0000000027906903';

-- D182
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D182'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D182' and IdIGN = 'TRONROUT0000002202046520';

-- D182
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D182'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D182' and IdIGN = 'TRONROUT0000002202046519';

-- D183
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D183'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D183' and IdIGN = 'TRONROUT0000000027927530';

-- D183A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D183A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D183A' and IdIGN = 'TRONROUT0000000339458844';

-- D184
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D184'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D184' and IdIGN = 'TRONROUT0000000027769419';

-- D185
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D185'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D185' and IdIGN = 'TRONROUT0000000027854862';

-- D185A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D185A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D185A' and IdIGN = 'TRONROUT0000000027858016';

-- D186
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D186'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D186' and IdIGN = 'TRONROUT0000000027873307';

-- D186A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D186A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D186A' and IdIGN = 'TRONROUT0000000027866229';

-- D187
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D187'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D187' and IdIGN = 'TRONROUT0000000027784138';

-- D187A
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D187A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D187A' and IdIGN = 'TRONROUT0000002004486968';

-- D187A
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D187A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D187A' and IdIGN = 'TRONROUT0000002004486969';

-- D187C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D187C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D187C' and IdIGN = 'TRONROUT0000000027782601';

-- D188
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D188'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D188' and IdIGN = 'TRONROUT0000000027912134';

-- D188A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D188A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D188A' and IdIGN = 'TRONROUT0000000027909119';

-- D188B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D188B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D188B' and IdIGN = 'TRONROUT0000000027900916';

-- D189
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D189'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D189' and IdIGN = 'TRONROUT0000002274732161';

-- D189A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D189A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D189A' and IdIGN = 'TRONROUT0000000027875009';

-- D18C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D18C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D18C' and IdIGN = 'TRONROUT0000000027869633';

-- D18C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D18C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D18C' and IdIGN = 'TRONROUT0000000027869650';

-- D18C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D18C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D18C' and IdIGN = 'TRONROUT0000000027869651';

-- D18D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D18D'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D18D' and IdIGN = 'TRONROUT0000000027889414';

-- D19
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D19'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D19' and IdIGN = 'TRONROUT0000000027883505';

-- D19
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D19'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D19' and IdIGN = 'TRONROUT0000000027883506';

-- D190
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D190'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D190' and IdIGN = 'TRONROUT0000000312696471';

-- D190A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D190A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D190A' and IdIGN = 'TRONROUT0000000027864521';

-- D191
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D191'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D191' and IdIGN = 'TRONROUT0000000027851009';

-- D191A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D191A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D191A' and IdIGN = 'TRONROUT0000002000681241';

-- D192
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D192'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D192' and IdIGN = 'TRONROUT0000000027889114';

-- D193
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D193'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D193' and IdIGN = 'TRONROUT0000000027825748';

-- D194
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D194'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D194' and IdIGN = 'TRONROUT0000002202030068';

-- D194
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D194'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D194' and IdIGN = 'TRONROUT0000002202030069';

-- D194A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D194A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D194A' and IdIGN = 'TRONROUT0000000027877751';

-- D194B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D194B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D194B' and IdIGN = 'TRONROUT0000000027914598';

-- D194C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D194C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D194C' and IdIGN = 'TRONROUT0000002220856145';

-- D194D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D194D'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D194D' and IdIGN = 'TRONROUT0000000027917768';

-- D195
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D195'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D195' and IdIGN = 'TRONROUT0000000258569089';

-- D195
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D195'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D195' and IdIGN = 'TRONROUT0000000258569069';

-- D196
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D196'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D196' and IdIGN = 'TRONROUT0000000027769191';

-- D196A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D196A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D196A' and IdIGN = 'TRONROUT0000000027769202';

-- D197
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D197'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D197' and IdIGN = 'TRONROUT0000000027964995';

-- D198
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D198'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D198' and IdIGN = 'TRONROUT0000000220730015';

-- D199
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D199'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D199' and IdIGN = 'TRONROUT0000000027769733';

-- D19A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D19A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D19A' and IdIGN = 'TRONROUT0000000027883464';

-- D19B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D19B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D19B' and IdIGN = 'TRONROUT0000000027891864';

-- D1A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D1A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D1A' and IdIGN = 'TRONROUT0000000027903331';

-- D2
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D2'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D2' and IdIGN = 'TRONROUT0000002215457063';

-- D20
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D20'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D20' and IdIGN = 'TRONROUT0000000027816392';

-- D200
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D200'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D200' and IdIGN = 'TRONROUT0000000027884768';

-- D201
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D201'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D201' and IdIGN = 'TRONROUT0000000027917692';

-- D202
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D202'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D202' and IdIGN = 'TRONROUT0000000027978025';

-- D203
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D203'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D203' and IdIGN = 'TRONROUT0000000130410493';

-- D203
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D203'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D203' and IdIGN = 'TRONROUT0000000130410491';

-- D204
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D204'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D204' and IdIGN = 'TRONROUT0000000027844865';

-- D205
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D205'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D205' and IdIGN = 'TRONROUT0000000298548643';

-- D205
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D205'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D205' and IdIGN = 'TRONROUT0000000298548642';

-- D206
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D206'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D206' and IdIGN = 'TRONROUT0000000099569548';

-- D207
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D207'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D207' and IdIGN = 'TRONROUT0000000225242301';

-- D207A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D207A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D207A' and IdIGN = 'TRONROUT0000000027860824';

-- D208
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D208'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D208' and IdIGN = 'TRONROUT0000000027906725';

-- D208
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D208'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D208' and IdIGN = 'TRONROUT0000000307230953';

-- D208A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D208A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D208A' and IdIGN = 'TRONROUT0000000027924213';

-- D209
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D209'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D209' and IdIGN = 'TRONROUT0000002223170224';

-- D209
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D209'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D209' and IdIGN = 'TRONROUT0000002223170227';

-- D209A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D209A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D209A' and IdIGN = 'TRONROUT0000000027860448';

-- D20A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D20A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D20A' and IdIGN = 'TRONROUT0000000211145681';

-- D20B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D20B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D20B' and IdIGN = 'TRONROUT0000000027854999';

-- D20C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D20C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D20C' and IdIGN = 'TRONROUT0000000027870848';

-- D20D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D20D'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D20D' and IdIGN = 'TRONROUT0000000027870844';

-- D21
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D21'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D21' and IdIGN = 'TRONROUT0000000027851763';

-- D210
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D210'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D210' and IdIGN = 'TRONROUT0000000297461550';

-- D210A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D210A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D210A' and IdIGN = 'TRONROUT0000000027903303';

-- D211
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D211'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D211' and IdIGN = 'TRONROUT0000000027820806';

-- D211
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D211'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D211' and IdIGN = 'TRONROUT0000000027820809';

-- D212
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D212'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D212' and IdIGN = 'TRONROUT0000000220651701';

-- D213
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D213'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D213' and IdIGN = 'TRONROUT0000000027870479';

-- D215
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D215'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D215' and IdIGN = 'TRONROUT0000000027887397';

-- D215A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D215A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D215A' and IdIGN = 'TRONROUT0000000027877649';

-- D215B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D215B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D215B' and IdIGN = 'TRONROUT0000000027877686';

-- D216
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D216'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D216' and IdIGN = 'TRONROUT0000000027812407';

-- D216
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D216'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D216' and IdIGN = 'TRONROUT0000000027812470';

-- D216
-- îlot
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D216'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D216' and IdIGN = 'TRONROUT0000000027812409';

-- D216A
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D216A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D216A' and IdIGN = 'TRONROUT0000000119280962';

-- D216A
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D216A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D216A' and IdIGN = 'TRONROUT0000000119280969';

-- D217
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D217'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D217' and IdIGN = 'TRONROUT0000000027825166';

-- D217A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D217A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D217A' and IdIGN = 'TRONROUT0000000027819252';

-- D217B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D217B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D217B' and IdIGN = 'TRONROUT0000000027816055';

-- D218
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D218'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D218' and IdIGN = 'TRONROUT0000000118236779';

-- D218A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D218A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D218A' and IdIGN = 'TRONROUT0000000027829567';

-- D219
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D219'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D219' and IdIGN = 'TRONROUT0000000027837564';

-- D22
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D22'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D22' and IdIGN = 'TRONROUT0000000027953820';

-- D220
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D220'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D220' and IdIGN = 'TRONROUT0000002000583773';

-- D221
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D221'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D221' and IdIGN = 'TRONROUT0000000358007308';

-- D221
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D221'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D221' and IdIGN = 'TRONROUT0000000358007307';

-- D222
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D222'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D222' and IdIGN = 'TRONROUT0000002275746001';

-- D222
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D222'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D222' and IdIGN = 'TRONROUT0000000027955614';

-- D223
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D223'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D223' and IdIGN = 'TRONROUT0000000027897051';

-- D225
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D225'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D225' and IdIGN = 'TRONROUT0000000027895054';

-- D226
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D226'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D226' and IdIGN = 'TRONROUT0000000027873280';

-- D227
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D227'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D227' and IdIGN = 'TRONROUT0000000027876738';

-- D228
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D228'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D228' and IdIGN = 'TRONROUT0000000027872592';

-- D229
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D229'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D229' and IdIGN = 'TRONROUT0000000118475036';

-- D22A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D22A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D22A' and IdIGN = 'TRONROUT0000002003753683';

-- D23
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D23'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D23' and IdIGN = 'TRONROUT0000002222396220';

-- D230
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D230'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D230' and IdIGN = 'TRONROUT0000000027844878';

-- D231
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D231'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D231' and IdIGN = 'TRONROUT0000000027885907';

-- D232
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D232'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D232' and IdIGN = 'TRONROUT0000000027882352';

-- D233
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D233'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D233' and IdIGN = 'TRONROUT0000000307398650';

-- D234
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D234'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D234' and IdIGN = 'TRONROUT0000000027921297';

-- D235
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D235'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D235' and IdIGN = 'TRONROUT0000000027883310';

-- D235
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D235'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D235' and IdIGN = 'TRONROUT0000000027883309';

-- D236
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D236'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D236' and IdIGN = 'TRONROUT0000000357331355';

-- D237
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D237'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D237' and IdIGN = 'TRONROUT0000000027805031';

-- D238
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D238'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D238' and IdIGN = 'TRONROUT0000000027817823';

-- D238A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D238A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D238A' and IdIGN = 'TRONROUT0000000027817859';

-- D239
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D239'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D239' and IdIGN = 'TRONROUT0000000027885623';

-- D239B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D239B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D239B' and IdIGN = 'TRONROUT0000000027891070';

-- D23A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D23A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D23A' and IdIGN = 'TRONROUT0000000220174410';

-- D23A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D23A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D23A' and IdIGN = 'TRONROUT0000000027844234';

-- D23A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D23A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D23A' and IdIGN = 'TRONROUT0000000027844290';

-- D23B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D23B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D23B' and IdIGN = 'TRONROUT0000000027780676';

-- D24
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D24'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D24' and IdIGN = 'TRONROUT0000000027895798';

-- D24
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D24'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D24' and IdIGN = 'TRONROUT0000000027895799';

-- D240
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D240'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D240' and IdIGN = 'TRONROUT0000000242705864';

-- D240
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D240'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D240' and IdIGN = 'TRONROUT0000000242705885';

-- D241
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D241'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D241' and IdIGN = 'TRONROUT0000000027791358';

-- D242
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D242'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D242' and IdIGN = 'TRONROUT0000000119281115';

-- D243
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D243'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D243' and IdIGN = 'TRONROUT0000000120485311';

-- D243
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D243'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D243' and IdIGN = 'TRONROUT0000000027774228';

-- D243A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D243A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D243A' and IdIGN = 'TRONROUT0000002000669257';

-- D244
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D244'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D244' and IdIGN = 'TRONROUT0000000027777278';

-- D245
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D245'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D245' and IdIGN = 'TRONROUT0000000223323018';

-- D245A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D245A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D245A' and IdIGN = 'TRONROUT0000000027857683';

-- D246
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D246'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D246' and IdIGN = 'TRONROUT0000000027845274';

-- D246A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D246A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D246A' and IdIGN = 'TRONROUT0000000027848211';

-- D247
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D247'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D247' and IdIGN = 'TRONROUT0000000027835175';

-- D247
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D247'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D247' and IdIGN = 'TRONROUT0000000027835181';

-- D247
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D247'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D247' and IdIGN = 'TRONROUT0000000027835185';

-- D248
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D248'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D248' and IdIGN = 'TRONROUT0000000027835263';

-- D249
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D249'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D249' and IdIGN = 'TRONROUT0000000035525079';

-- D249
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D249'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D249' and IdIGN = 'TRONROUT0000000242505400';

-- D25
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D25'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D25' and IdIGN = 'TRONROUT0000000027888014';

-- D25
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D25'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D25' and IdIGN = 'TRONROUT0000000027888026';

-- D250
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D250'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D250' and IdIGN = 'TRONROUT0000000027917952';

-- D251
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D251'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D251' and IdIGN = 'TRONROUT0000000211398080';

-- D252
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D252'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D252' and IdIGN = 'TRONROUT0000000027823092';

-- D253
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D253'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D253' and IdIGN = 'TRONROUT0000000027827345';

-- D253
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D253'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D253' and IdIGN = 'TRONROUT0000000027827370';

-- D254
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D254'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D254' and IdIGN = 'TRONROUT0000000027944172';

-- D254
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D254'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D254' and IdIGN = 'TRONROUT0000000027944175';

-- D255
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D255'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D255' and IdIGN = 'TRONROUT0000000027982358';

-- D255B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D255B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D255B' and IdIGN = 'TRONROUT0000000323799293';

-- D255B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D255B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D255B' and IdIGN = 'TRONROUT0000000027983737';

-- D255B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D255B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D255B' and IdIGN = 'TRONROUT0000000027983738';

-- D256
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D256'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D256' and IdIGN = 'TRONROUT0000000027773165';

-- D256
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D256'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D256' and IdIGN = 'TRONROUT0000000027773166';

-- D257
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D257'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D257' and IdIGN = 'TRONROUT0000000027936017';

-- D257
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D257'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D257' and IdIGN = 'TRONROUT0000000027936040';

-- D257
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D257'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D257' and IdIGN = 'TRONROUT0000000027936038';

-- D258
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D258'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D258' and IdIGN = 'TRONROUT0000000027854750';

-- D259
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D259'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D259' and IdIGN = 'TRONROUT0000000027805253';

-- D26
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D26'::character varying, 20555::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D26' and IdIGN = 'TRONROUT0000000119160082';

-- D26
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D26'::character varying, 20555::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D26' and IdIGN = 'TRONROUT0000000119160078';

-- D260
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D260'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D260' and IdIGN = 'TRONROUT0000000027822517';

-- D260
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D260'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D260' and IdIGN = 'TRONROUT0000000027822533';

-- D260
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D260'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D260' and IdIGN = 'TRONROUT0000000088881392';

-- D261
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D261'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D261' and IdIGN = 'TRONROUT0000000027835125';

-- D262
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D262'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D262' and IdIGN = 'TRONROUT0000000027950018';

-- D262
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D262'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D262' and IdIGN = 'TRONROUT0000000027950053';

-- D263
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D263'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D263' and IdIGN = 'TRONROUT0000000027816643';

-- D264
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D264'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D264' and IdIGN = 'TRONROUT0000000298548582';

-- D264
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D264'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D264' and IdIGN = 'TRONROUT0000000298548583';

-- D265
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D265'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D265' and IdIGN = 'TRONROUT0000000027973935';

-- D266
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D266'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D266' and IdIGN = 'TRONROUT0000000027772403';

-- D266A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D266A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D266A' and IdIGN = 'TRONROUT0000000027772240';

-- D266B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D266B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D266B' and IdIGN = 'TRONROUT0000000027772358';

-- D266C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D266C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D266C' and IdIGN = 'TRONROUT0000000027773688';

-- D267
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D267'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D267' and IdIGN = 'TRONROUT0000000027837985';

-- D268
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D268'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D268' and IdIGN = 'TRONROUT0000000356790079';

-- D268
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D268'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D268' and IdIGN = 'TRONROUT0000000356790071';

-- D269
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D269'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D269' and IdIGN = 'TRONROUT0000000350792851';

-- D269B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D269B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D269B' and IdIGN = 'TRONROUT0000000027822844';

-- D269C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D269C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D269C' and IdIGN = 'TRONROUT0000000027822842';

-- D26A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D26A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D26A' and IdIGN = 'TRONROUT0000000027834311';

-- D27
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D27'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D27' and IdIGN = 'TRONROUT0000000288524088';

-- D27
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D27'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D27' and IdIGN = 'TRONROUT0000000288524089';

-- D270
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D270'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D270' and IdIGN = 'TRONROUT0000000211098960';

-- D270
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D270'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D270' and IdIGN = 'TRONROUT0000000211098961';

-- D270
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D270'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D270' and IdIGN = 'TRONROUT0000000211098963';

-- D270A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D270A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D270A' and IdIGN = 'TRONROUT0000000027893855';

-- D270B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D270B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D270B' and IdIGN = 'TRONROUT0000000027891240';

-- D271
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D271'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D271' and IdIGN = 'TRONROUT0000000027839303';

-- D272
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D272'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D272' and IdIGN = 'TRONROUT0000000027874882';

-- D272A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D272A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D272A' and IdIGN = 'TRONROUT0000000027874908';

-- D272B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D272B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D272B' and IdIGN = 'TRONROUT0000002007007095';

-- D272C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D272C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D272C' and IdIGN = 'TRONROUT0000000027871220';

-- D272D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D272D'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D272D' and IdIGN = 'TRONROUT0000000027867793';

-- D272E
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D272E'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D272E' and IdIGN = 'TRONROUT0000000027874919';

-- D272F
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D272F'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D272F' and IdIGN = 'TRONROUT0000000027867809';

-- D272F
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D272F'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D272F' and IdIGN = 'TRONROUT0000000027867813';

-- D272G
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D272G'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D272G' and IdIGN = 'TRONROUT0000000356420057';

-- D272H
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D272H'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D272H' and IdIGN = 'TRONROUT0000000027867810';

-- D273
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D273'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D273' and IdIGN = 'TRONROUT0000000027888525';

-- D273A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D273A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D273A' and IdIGN = 'TRONROUT0000000027893883';

-- D274
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D274'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D274' and IdIGN = 'TRONROUT0000000027809155';

-- D275
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D275'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D275' and IdIGN = 'TRONROUT0000000027963931';

-- D276
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D276'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D276' and IdIGN = 'TRONROUT0000000027781805';

-- D276A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D276A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D276A' and IdIGN = 'TRONROUT0000000027781814';

-- D277
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D277'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D277' and IdIGN = 'TRONROUT0000000027806258';

-- D278
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D278'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D278' and IdIGN = 'TRONROUT0000000337199343';

-- D279
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D279'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D279' and IdIGN = 'TRONROUT0000000027829354';

-- D27A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D27A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D27A' and IdIGN = 'TRONROUT0000000027890197';

-- D27B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D27B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D27B' and IdIGN = 'TRONROUT0000000027890196';

-- D27C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D27C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D27C' and IdIGN = 'TRONROUT0000000027898436';

-- D27D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D27D'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D27D' and IdIGN = 'TRONROUT0000000027901007';

-- D27D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D27D'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D27D' and IdIGN = 'TRONROUT0000000027901012';

-- D28
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D28'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D28' and IdIGN = 'TRONROUT0000000027816683';

-- D280
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D280'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D280' and IdIGN = 'TRONROUT0000000027830090';

-- D282
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D282'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D282' and IdIGN = 'TRONROUT0000000307220219';

-- D283
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D283'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D283' and IdIGN = 'TRONROUT0000000027791768';

-- D283A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D283A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D283A' and IdIGN = 'TRONROUT0000000027793476';

-- D283B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D283B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D283B' and IdIGN = 'TRONROUT0000000027791806';

-- D283C
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D283C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D283C' and IdIGN = 'TRONROUT0000000350791653';

-- D284
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D284'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D284' and IdIGN = 'TRONROUT0000000027836093';

-- D284A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D284A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D284A' and IdIGN = 'TRONROUT0000000027833296';

-- D284B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D284B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D284B' and IdIGN = 'TRONROUT0000000027836059';

-- D285
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D285'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D285' and IdIGN = 'TRONROUT0000000027870373';

-- D285
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D285'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D285' and IdIGN = 'TRONROUT0000000027870393';

-- D286
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D286'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D286' and IdIGN = 'TRONROUT0000000027790025';

-- D287
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D287'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D287' and IdIGN = 'TRONROUT0000000027886359';

-- D288
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D288'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D288' and IdIGN = 'TRONROUT0000000027975734';

-- D288
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D288'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D288' and IdIGN = 'TRONROUT0000000027975737';

-- D289
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D289'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D289' and IdIGN = 'TRONROUT0000000230049584';

-- D289A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D289A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D289A' and IdIGN = 'TRONROUT0000000027976183';

-- D29
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D29'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D29' and IdIGN = 'TRONROUT0000000027771637';

-- D290
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D290'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D290' and IdIGN = 'TRONROUT0000000027867298';

-- D291
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D291'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D291' and IdIGN = 'TRONROUT0000000211397858';

-- D292
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D292'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D292' and IdIGN = 'TRONROUT0000000027875076';

-- D292A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D292A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D292A' and IdIGN = 'TRONROUT0000000027882384';

-- D293
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D293'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D293' and IdIGN = 'TRONROUT0000000359408868';

-- D293
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D293'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D293' and IdIGN = 'TRONROUT0000000359408876';

-- D294
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D294'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D294' and IdIGN = 'TRONROUT0000000027836385';

-- D294
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D294'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D294' and IdIGN = 'TRONROUT0000000027836387';

-- D295
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D295'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D295' and IdIGN = 'TRONROUT0000000027846206';

-- D296
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D296'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D296' and IdIGN = 'TRONROUT0000000258569088';

-- D296
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D296'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D296' and IdIGN = 'TRONROUT0000000258569071';

-- D297
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D297'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D297' and IdIGN = 'TRONROUT0000000027791831';

-- D297
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D297'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D297' and IdIGN = 'TRONROUT0000000027791828';

-- D297A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D297A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D297A' and IdIGN = 'TRONROUT0000000027793349';

-- D297B
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D297B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D297B' and IdIGN = 'TRONROUT0000000358006837';

-- D297C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D297C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D297C' and IdIGN = 'TRONROUT0000002215384016';

-- D297C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D297C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D297C' and IdIGN = 'TRONROUT0000002215384009';

-- D298
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D298'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D298' and IdIGN = 'TRONROUT0000000027783759';

-- D298
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D298'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D298' and IdIGN = 'TRONROUT0000000027783763';

-- D298A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D298A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D298A' and IdIGN = 'TRONROUT0000000027780870';

-- D299A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D299A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D299A' and IdIGN = 'TRONROUT0000000027874981';

-- D29A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D29A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D29A' and IdIGN = 'TRONROUT0000000027771564';

-- D2A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D2A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D2A' and IdIGN = 'TRONROUT0000000027896442';

-- D2B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D2B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D2B' and IdIGN = 'TRONROUT0000002287726140';

-- D2E
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D2E'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D2E' and IdIGN = 'TRONROUT0000000027878917';

-- D2E
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D2E'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D2E' and IdIGN = 'TRONROUT0000000027878918';

-- D3
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D3'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D3' and IdIGN = 'TRONROUT0000000242620238';

-- D3
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D3'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D3' and IdIGN = 'TRONROUT0000000242620224';

-- D300
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D300'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D300' and IdIGN = 'TRONROUT0000000027906031';

-- D301
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D301'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D301' and IdIGN = 'TRONROUT0000000356670919';

-- D302
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D302'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D302' and IdIGN = 'TRONROUT0000000027930947';

-- D303
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D303'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D303' and IdIGN = 'TRONROUT0000000027790790';

-- D303
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D303'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D303' and IdIGN = 'TRONROUT0000000027790791';

-- D303
-- îlot
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D303'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D303' and IdIGN = 'TRONROUT0000000027790799';

-- D304
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D304'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D304' and IdIGN = 'TRONROUT0000000027771237';

-- D304
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D304'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D304' and IdIGN = 'TRONROUT0000000027771232';

-- D305
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D305'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D305' and IdIGN = 'TRONROUT0000000027853223';

-- D306
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D306'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D306' and IdIGN = 'TRONROUT0000000027776248';

-- D307
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D307'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D307' and IdIGN = 'TRONROUT0000000027866024';

-- D308
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D308'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D308' and IdIGN = 'TRONROUT0000000027931135';

-- D309
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D309'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D309' and IdIGN = 'TRONROUT0000000027841235';

-- D31
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D31'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D31' and IdIGN = 'TRONROUT0000000027790159';

-- D310
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D310'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D310' and IdIGN = 'TRONROUT0000000353120381';

-- D311
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D311'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D311' and IdIGN = 'TRONROUT0000000119281124';

-- D312
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D312'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D312' and IdIGN = 'TRONROUT0000000027776595';

-- D313
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D313'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D313' and IdIGN = 'TRONROUT0000000315830479';

-- D314
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D314'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D314' and IdIGN = 'TRONROUT0000000027768629';

-- D315
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D315'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D315' and IdIGN = 'TRONROUT0000000027766096';

-- D315A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D315A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D315A' and IdIGN = 'TRONROUT0000000350791584';

-- D315A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D315A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D315A' and IdIGN = 'TRONROUT0000000350791583';

-- D316
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D316'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D316' and IdIGN = 'TRONROUT0000000309545779';

-- D317
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D317'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D317' and IdIGN = 'TRONROUT0000000348081826';

-- D318
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D318'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D318' and IdIGN = 'TRONROUT0000000027768159';

-- D318A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D318A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D318A' and IdIGN = 'TRONROUT0000000027768149';

-- D318B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D318B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D318B' and IdIGN = 'TRONROUT0000000027768674';

-- D319
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D319'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D319' and IdIGN = 'TRONROUT0000000027822612';

-- D319
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D319'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D319' and IdIGN = 'TRONROUT0000000027822614';

-- D32
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D32'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D32' and IdIGN = 'TRONROUT0000000027806185';

-- D320
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D320'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D320' and IdIGN = 'TRONROUT0000000027766860';

-- D321
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D321'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D321' and IdIGN = 'TRONROUT0000000027781109';

-- D322
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D322'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D322' and IdIGN = 'TRONROUT0000000027866127';

-- D323
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D323'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D323' and IdIGN = 'TRONROUT0000000027848983';

-- D324A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D324A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D324A' and IdIGN = 'TRONROUT0000000027824922';

-- D324A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D324A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D324A' and IdIGN = 'TRONROUT0000000027824930';

-- D325
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D325'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D325' and IdIGN = 'TRONROUT0000000027838594';

-- D326
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D326'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D326' and IdIGN = 'TRONROUT0000000027870990';

-- D326A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D326A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D326A' and IdIGN = 'TRONROUT0000000211397945';

-- D326B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D326B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D326B' and IdIGN = 'TRONROUT0000002322423748';

-- D327
-- bretelle d'accès depuis la D999
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D327'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D327' and IdIGN = 'TRONROUT0000000027871030';

-- D328
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D328'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D328' and IdIGN = 'TRONROUT0000000027784881';

-- D329
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D329'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D329' and IdIGN = 'TRONROUT0000000027867567';

-- D329A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D329A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D329A' and IdIGN = 'TRONROUT0000000027861647';

-- D32A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D32A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D32A' and IdIGN = 'TRONROUT0000000027804115';

-- D32B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D32B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D32B' and IdIGN = 'TRONROUT0000000027797140';

-- D330
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D330'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D330' and IdIGN = 'TRONROUT0000000027812041';

-- D330A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D330A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D330A' and IdIGN = 'TRONROUT0000000027814879';

-- D331
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D331'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D331' and IdIGN = 'TRONROUT0000000027912242';

-- D331
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D331'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D331' and IdIGN = 'TRONROUT0000000027912257';

-- D331
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D331'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D331' and IdIGN = 'TRONROUT0000000284090178';

-- D332
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D332'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D332' and IdIGN = 'TRONROUT0000000027838761';

-- D332
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D332'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D332' and IdIGN = 'TRONROUT0000000027838768';

-- D333
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D333'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D333' and IdIGN = 'TRONROUT0000000027819432';

-- D334
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D334'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D334' and IdIGN = 'TRONROUT0000000027828447';

-- D334A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D334A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D334A' and IdIGN = 'TRONROUT0000000356415059';

-- D335
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D335'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D335' and IdIGN = 'TRONROUT0000000027895628';

-- D336
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D336'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D336' and IdIGN = 'TRONROUT0000000027871274';

-- D336A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D336A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D336A' and IdIGN = 'TRONROUT0000000356420050';

-- D337
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D337'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D337' and IdIGN = 'TRONROUT0000000298189187';

-- D338
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D338'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D338' and IdIGN = 'TRONROUT0000002000681023';

-- D339
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D339'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D339' and IdIGN = 'TRONROUT0000000027821240';

-- D339
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D339'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D339' and IdIGN = 'TRONROUT0000002220856806';

-- D340
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D340'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D340' and IdIGN = 'TRONROUT0000000027798400';

-- D341
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D341'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D341' and IdIGN = 'TRONROUT0000000027845880';

-- D341A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D341A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D341A' and IdIGN = 'TRONROUT0000000027845885';

-- D343
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D343'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D343' and IdIGN = 'TRONROUT0000000027777652';

-- D344
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D344'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D344' and IdIGN = 'TRONROUT0000000080385908';

-- D345
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D345'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D345' and IdIGN = 'TRONROUT0000000027950552';

-- D345A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D345A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D345A' and IdIGN = 'TRONROUT0000000220119140';

-- D346
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D346'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D346' and IdIGN = 'TRONROUT0000000324756436';

-- D347
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D347'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D347' and IdIGN = 'TRONROUT0000000027874251';

-- D348
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D348'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D348' and IdIGN = 'TRONROUT0000000027836416';

-- D349
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D349'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D349' and IdIGN = 'TRONROUT0000000027885470';

-- D349A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D349A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D349A' and IdIGN = 'TRONROUT0000000358008259';

-- D35
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D35'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D35' and IdIGN = 'TRONROUT0000000271266735';

-- D35
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D35'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D35' and IdIGN = 'TRONROUT0000000271266687';

-- D350
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D350'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D350' and IdIGN = 'TRONROUT0000000027778304';

-- D350A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D350A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D350A' and IdIGN = 'TRONROUT0000000027778386';

-- D350B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D350B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D350B' and IdIGN = 'TRONROUT0000000027778298';

-- D351
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D351'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D351' and IdIGN = 'TRONROUT0000000298548540';

-- D351
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D351'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D351' and IdIGN = 'TRONROUT0000000298548601';

-- D351A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D351A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D351A' and IdIGN = 'TRONROUT0000000027902097';

-- D352
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D352'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D352' and IdIGN = 'TRONROUT0000000116845292';

-- D353
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D353'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D353' and IdIGN = 'TRONROUT0000000027801806';

-- D354
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D354'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D354' and IdIGN = 'TRONROUT0000000027861591';

-- D355
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D355'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D355' and IdIGN = 'TRONROUT0000002322421554';

-- D356
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D356'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D356' and IdIGN = 'TRONROUT0000000027809625';

-- D357
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D357'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D357' and IdIGN = 'TRONROUT0000000027783352';

-- D357A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D357A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D357A' and IdIGN = 'TRONROUT0000000027786698';

-- D359
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D359'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D359' and IdIGN = 'TRONROUT0000000027857556';

-- D35A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D35A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D35A' and IdIGN = 'TRONROUT0000000027938622';

-- D360
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D360'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D360' and IdIGN = 'TRONROUT0000000334850348';

-- D361
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D361'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D361' and IdIGN = 'TRONROUT0000000229375654';

-- D361A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D361A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D361A' and IdIGN = 'TRONROUT0000000027786651';

-- D362
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D362'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D362' and IdIGN = 'TRONROUT0000000228088549';

-- D363
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D363'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D363' and IdIGN = 'TRONROUT0000002005292243';

-- D364
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D364'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D364' and IdIGN = 'TRONROUT0000002275645629';

-- D365
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D365'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D365' and IdIGN = 'TRONROUT0000000027865630';

-- D366
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D366'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D366' and IdIGN = 'TRONROUT0000000027845487';

-- D367
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D367'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D367' and IdIGN = 'TRONROUT0000000027830189';

-- D367A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D367A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D367A' and IdIGN = 'TRONROUT0000000224380231';

-- D367A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D367A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D367A' and IdIGN = 'TRONROUT0000000224380229';

-- D368
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D368'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D368' and IdIGN = 'TRONROUT0000000027771316';

-- D369
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D369'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D369' and IdIGN = 'TRONROUT0000000027882249';

-- D37
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D37'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D37' and IdIGN = 'TRONROUT0000000027803220';

-- D370
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D370'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D370' and IdIGN = 'TRONROUT0000000027874749';

-- D371
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D371'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D371' and IdIGN = 'TRONROUT0000000027785553';

-- D372
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D372'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D372' and IdIGN = 'TRONROUT0000000027885550';

-- D374
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D374'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D374' and IdIGN = 'TRONROUT0000000119288860';

-- D375
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D375'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D375' and IdIGN = 'TRONROUT0000000027766962';

-- D376
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D376'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D376' and IdIGN = 'TRONROUT0000000027771118';

-- D377
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D377'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D377' and IdIGN = 'TRONROUT0000000130407672';

-- D377
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D377'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D377' and IdIGN = 'TRONROUT0000000130407684';

-- D378
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D378'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D378' and IdIGN = 'TRONROUT0000000027967253';

-- D378A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D378A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D378A' and IdIGN = 'TRONROUT0000000335665339';

-- D378A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D378A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D378A' and IdIGN = 'TRONROUT0000000335665341';

-- D37A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D37A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D37A' and IdIGN = 'TRONROUT0000000027789458';

-- D37B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D37B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D37B' and IdIGN = 'TRONROUT0000000027784250';

-- D38
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D38'::character varying, 20766::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D38' and IdIGN = 'TRONROUT0000000027942335';

-- D38
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D38'::character varying, 20766::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D38' and IdIGN = 'TRONROUT0000000217273752';

-- D380
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D380'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D380' and IdIGN = 'TRONROUT0000000027842695';

-- D381
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D381'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D381' and IdIGN = 'TRONROUT0000000027977458';

-- D383
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D383'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D383' and IdIGN = 'TRONROUT0000000027795262';

-- D383A
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D383A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D383A' and IdIGN = 'TRONROUT0000000027795258';

-- D384
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D384'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D384' and IdIGN = 'TRONROUT0000000027770097';

-- D384
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D384'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D384' and IdIGN = 'TRONROUT0000000088881843';

-- D384
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D384'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D384' and IdIGN = 'TRONROUT0000000088881845';

-- D385
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D385'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D385' and IdIGN = 'TRONROUT0000000309546174';

-- D385A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D385A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D385A' and IdIGN = 'TRONROUT0000000027810636';

-- D386
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D386'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D386' and IdIGN = 'TRONROUT0000000027771467';

-- D387
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D387'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D387' and IdIGN = 'TRONROUT0000000027833661';

-- D39
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D39'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D39' and IdIGN = 'TRONROUT0000000027885260';

-- D391
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D391'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D391' and IdIGN = 'TRONROUT0000000027841304';

-- D394
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D394'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D394' and IdIGN = 'TRONROUT0000000027912032';

-- D395
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D395'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D395' and IdIGN = 'TRONROUT0000000119160122';

-- D39A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D39A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D39A' and IdIGN = 'TRONROUT0000000027830805';

-- D39B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D39B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D39B' and IdIGN = 'TRONROUT0000000027825602';

-- D39C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D39C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D39C' and IdIGN = 'TRONROUT0000000027822716';

-- D3A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D3A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D3A' and IdIGN = 'TRONROUT0000000220650409';

-- D3A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D3A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D3A' and IdIGN = 'TRONROUT0000000220650410';

-- D3B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D3B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D3B' and IdIGN = 'TRONROUT0000000027872816';

-- D3B
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D3B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D3B' and IdIGN = 'TRONROUT0000000298189571';

-- D3B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D3B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D3B' and IdIGN = 'TRONROUT0000000027872817';

-- D4
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D4'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D4' and IdIGN = 'TRONROUT0000000119280790';

-- D4
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D4'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D4' and IdIGN = 'TRONROUT0000000119280792';

-- D40
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D40'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D40' and IdIGN = 'TRONROUT0000000216766946';

-- D401
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D401'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D401' and IdIGN = 'TRONROUT0000000027943653';

-- D402
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D402'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D402' and IdIGN = 'TRONROUT0000000027901657';

-- D403
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D403'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D403' and IdIGN = 'TRONROUT0000000027932076';

-- D403
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D403'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D403' and IdIGN = 'TRONROUT0000000027932071';

-- D404
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D404'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D404' and IdIGN = 'TRONROUT0000000027853284';

-- D405
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D405'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D405' and IdIGN = 'TRONROUT0000000202638284';

-- D406
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D406'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D406' and IdIGN = 'TRONROUT0000000027807260';

-- D407
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D407'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D407' and IdIGN = 'TRONROUT0000000224528306';

-- D407
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D407'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D407' and IdIGN = 'TRONROUT0000000224528307';

-- D408
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D408'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D408' and IdIGN = 'TRONROUT0000002201847128';

-- D408
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D408'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D408' and IdIGN = 'TRONROUT0000002201847129';

-- D409
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D409'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D409' and IdIGN = 'TRONROUT0000000027823578';

-- D40A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D40A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D40A' and IdIGN = 'TRONROUT0000000027946104';

-- D40A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D40A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D40A' and IdIGN = 'TRONROUT0000000357974143';

-- D40A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D40A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D40A' and IdIGN = 'TRONROUT0000000357974144';

-- D40A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D40A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D40A' and IdIGN = 'TRONROUT0000002322422565';

-- D40B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D40B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D40B' and IdIGN = 'TRONROUT0000000027951329';

-- D40C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D40C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D40C' and IdIGN = 'TRONROUT0000000027943549';

-- D40C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D40C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D40C' and IdIGN = 'TRONROUT0000000220119528';

-- D40C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D40C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D40C' and IdIGN = 'TRONROUT0000000220119649';

-- D40C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D40C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D40C' and IdIGN = 'TRONROUT0000000220119732';

-- D40D
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D40D'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D40D' and IdIGN = 'TRONROUT0000002003596382';

-- D40D
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D40D'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D40D' and IdIGN = 'TRONROUT0000002003596385';

-- D412
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D412'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D412' and IdIGN = 'TRONROUT0000000027964275';

-- D412
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D412'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D412' and IdIGN = 'TRONROUT0000000027964284';

-- D412
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D412'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D412' and IdIGN = 'TRONROUT0000000027964290';

-- D413
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D413'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D413' and IdIGN = 'TRONROUT0000000027904230';

-- D416
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D416'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D416' and IdIGN = 'TRONROUT0000000027796985';

-- D418
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D418'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D418' and IdIGN = 'TRONROUT0000000027916624';

-- D42
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D42'::character varying, 50000::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D42' and IdIGN = 'TRONROUT0000000027947558';

-- D42
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D42'::character varying, 50000::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D42' and IdIGN = 'TRONROUT0000000027947554';

-- D420
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D420'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D420' and IdIGN = 'TRONROUT0000000027851961';

-- D420A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D420A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D420A' and IdIGN = 'TRONROUT0000002007006907';

-- D422
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D422'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D422' and IdIGN = 'TRONROUT0000000027906011';

-- D424
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D424'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D424' and IdIGN = 'TRONROUT0000000027889730';

-- D427
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D427'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D427' and IdIGN = 'TRONROUT0000000027899930';

-- D427
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D427'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D427' and IdIGN = 'TRONROUT0000000027899913';

-- D430
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D430'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D430' and IdIGN = 'TRONROUT0000000027768545';

-- D432
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D432'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D432' and IdIGN = 'TRONROUT0000000118236931';

-- D432A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D432A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D432A' and IdIGN = 'TRONROUT0000000027793578';

-- D432B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D432B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D432B' and IdIGN = 'TRONROUT0000000027793573';

-- D434A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D434A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D434A' and IdIGN = 'TRONROUT0000000027766968';

-- D435
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D435'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D435' and IdIGN = 'TRONROUT0000002000391080';

-- D437
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D437'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D437' and IdIGN = 'TRONROUT0000000220174618';

-- D44
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D44'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D44' and IdIGN = 'TRONROUT0000000077474095';

-- D440
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D440'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D440' and IdIGN = 'TRONROUT0000000027948878';

-- D440
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D440'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D440' and IdIGN = 'TRONROUT0000000027948892';

-- D440
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D440'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D440' and IdIGN = 'TRONROUT0000000120485670';

-- D442
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D442'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D442' and IdIGN = 'TRONROUT0000000027954411';

-- D442
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D442'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D442' and IdIGN = 'TRONROUT0000000027954418';

-- D442A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D442A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D442A' and IdIGN = 'TRONROUT0000000027954350';

-- D442A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D442A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D442A' and IdIGN = 'TRONROUT0000000027954351';

-- D447
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D447'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D447' and IdIGN = 'TRONROUT0000000220729985';

-- D448
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D448'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D448' and IdIGN = 'TRONROUT0000000228321839';

-- D45
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D45'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D45' and IdIGN = 'TRONROUT0000000119651754';

-- D45
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D45'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D45' and IdIGN = 'TRONROUT0000000119651753';

-- D450
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D450'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D450' and IdIGN = 'TRONROUT0000000027827828';

-- D451
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D451'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D451' and IdIGN = 'TRONROUT0000000027765697';

-- D452
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D452'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D452' and IdIGN = 'TRONROUT0000000358008371';

-- D453
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D453'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D453' and IdIGN = 'TRONROUT0000000027777433';

-- D454
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D454'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D454' and IdIGN = 'TRONROUT0000000027793479';

-- D46
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D46'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D46' and IdIGN = 'TRONROUT0000000044811672';

-- D47
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D47'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D47' and IdIGN = 'TRONROUT0000000027846202';

-- D47A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D47A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D47A' and IdIGN = 'TRONROUT0000000356415008';

-- D47B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D47B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D47B' and IdIGN = 'TRONROUT0000000027836552';

-- D47C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D47C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D47C' and IdIGN = 'TRONROUT0000000027808724';

-- D48A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D48A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D48A' and IdIGN = 'TRONROUT0000000027881991';

-- D48N
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D48N'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D48N' and IdIGN = 'TRONROUT0000000027882043';

-- D48N
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D48N'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D48N' and IdIGN = 'TRONROUT0000000027882103';

-- D48S
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D48S'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D48S' and IdIGN = 'TRONROUT0000000027927498';

-- D49
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D49'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D49' and IdIGN = 'TRONROUT0000002267953649';

-- D5
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D5'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D5' and IdIGN = 'TRONROUT0000000027800137';

-- D5
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D5'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D5' and IdIGN = 'TRONROUT0000000027800193';

-- D50
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D50'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D50' and IdIGN = 'TRONROUT0000000027815655';

-- D500
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D500'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D500' and IdIGN = 'TRONROUT0000000350792177';

-- D500
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D500'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D500' and IdIGN = 'TRONROUT0000000350792178';

-- D500
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D500'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D500' and IdIGN = 'TRONROUT0000000350792194';

-- D500A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D500A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D500A' and IdIGN = 'TRONROUT0000000298548606';

-- D500A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D500A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D500A' and IdIGN = 'TRONROUT0000000298548538';

-- D501
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D501'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D501' and IdIGN = 'TRONROUT0000000027886313';

-- D502
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D502'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D502' and IdIGN = 'TRONROUT0000000027928008';

-- D504
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D504'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D504' and IdIGN = 'TRONROUT0000000027846891';

-- D505
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D505'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D505' and IdIGN = 'TRONROUT0000000027899534';

-- D509
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D509'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D509' and IdIGN = 'TRONROUT0000000027820589';

-- D50A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D50A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D50A' and IdIGN = 'TRONROUT0000000027827903';

-- D50B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D50B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D50B' and IdIGN = 'TRONROUT0000000027827929';

-- D50C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D50C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D50C' and IdIGN = 'TRONROUT0000000027819089';

-- D50D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D50D'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D50D' and IdIGN = 'TRONROUT0000000027822078';

-- D50D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D50D'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D50D' and IdIGN = 'TRONROUT0000000027822079';

-- D51
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D51'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D51' and IdIGN = 'TRONROUT0000000027779798';

-- D512
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D512'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D512' and IdIGN = 'TRONROUT0000000027776579';

-- D513
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D513'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D513' and IdIGN = 'TRONROUT0000000027898956';

-- D514
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D514'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D514' and IdIGN = 'TRONROUT0000000027880707';

-- D518
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D518'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D518' and IdIGN = 'TRONROUT0000000027889580';

-- D51A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D51A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D51A' and IdIGN = 'TRONROUT0000000027772735';

-- D51B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D51B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D51B' and IdIGN = 'TRONROUT0000000027781150';

-- D51C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D51C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D51C' and IdIGN = 'TRONROUT0000000027782745';

-- D51D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D51D'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D51D' and IdIGN = 'TRONROUT0000000027775333';

-- D51F
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D51F'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D51F' and IdIGN = 'TRONROUT0000000027772744';

-- D51G
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D51G'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D51G' and IdIGN = 'TRONROUT0000000027781292';

-- D52
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D52'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D52' and IdIGN = 'TRONROUT0000000027774245';

-- D522
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D522'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D522' and IdIGN = 'TRONROUT0000000027920742';

-- D522
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D522'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D522' and IdIGN = 'TRONROUT0000000297461586';

-- D522
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D522'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D522' and IdIGN = 'TRONROUT0000000297461593';

-- D522
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D522'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D522' and IdIGN = 'TRONROUT0000000297461590';

-- D52A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D52A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D52A' and IdIGN = 'TRONROUT0000000027775828';

-- D532
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D532'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D532' and IdIGN = 'TRONROUT0000000027790286';

-- D537
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D537'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D537' and IdIGN = 'TRONROUT0000000027784254';

-- D540
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D540'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D540' and IdIGN = 'TRONROUT0000000027936573';

-- D540
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D540'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D540' and IdIGN = 'TRONROUT0000000027936600';

-- D540
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D540'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D540' and IdIGN = 'TRONROUT0000000335665075';

-- D546
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D546'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D546' and IdIGN = 'TRONROUT0000000027935873';

-- D548
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D548'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D548' and IdIGN = 'TRONROUT0000000027852120';

-- D548A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D548A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D548A' and IdIGN = 'TRONROUT0000000027831027';

-- D550
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D550'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D550' and IdIGN = 'TRONROUT0000000027775176';

-- D551
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D551'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D551' and IdIGN = 'TRONROUT0000000220729973';

-- D553
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D553'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D553' and IdIGN = 'TRONROUT0000000027825487';

-- D56
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D56'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D56' and IdIGN = 'TRONROUT0000000027961709';

-- D56
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D56'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D56' and IdIGN = 'TRONROUT0000000027961727';

-- D57
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D57'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D57' and IdIGN = 'TRONROUT0000000119651734';

-- D57
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D57'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D57' and IdIGN = 'TRONROUT0000000119651752';

-- D58
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D58'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D58' and IdIGN = 'TRONROUT0000000027979751';

-- D58E
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D58E'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D58E' and IdIGN = 'TRONROUT0000000027982374';

-- D59
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D59'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D59' and IdIGN = 'TRONROUT0000000027781647';

-- D59
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D59'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D59' and IdIGN = 'TRONROUT0000000027781649';

-- D59
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D59'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D59' and IdIGN = 'TRONROUT0000000088881759';

-- D59B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D59B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D59B' and IdIGN = 'TRONROUT0000000027784469';

-- D59EX
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D59EX'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D59EX' and IdIGN = 'TRONROUT0000000027784489';

-- D59EX
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D59EX'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D59EX' and IdIGN = 'TRONROUT0000000027784480';

-- D5A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D5A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D5A' and IdIGN = 'TRONROUT0000002206558210';

-- D6
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6' and IdIGN = 'TRONROUT0000000027812440';

-- D6
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6' and IdIGN = 'TRONROUT0000000027812467';

-- D60
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D60'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D60' and IdIGN = 'TRONROUT0000000027803896';

-- D60
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D60'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D60' and IdIGN = 'TRONROUT0000000027803905';

-- D603
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D603'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D603' and IdIGN = 'TRONROUT0000000119281011';

-- D603
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D603'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D603' and IdIGN = 'TRONROUT0000000119281005';

-- D607
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D607'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D607' and IdIGN = 'TRONROUT0000000027807443';

-- D607A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D607A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D607A' and IdIGN = 'TRONROUT0000000027809663';

-- D6086
-- tronçons gérés par le D07 avant le PR0 sur le territoire du D30
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6086'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6086' and IdIGN = 'TRONROUT0000000027771726';

-- D609
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D609'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D609' and IdIGN = 'TRONROUT0000000027823287';

-- D60A
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D60A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D60A' and IdIGN = 'TRONROUT0000000248354453';

-- D60B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D60B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D60B' and IdIGN = 'TRONROUT0000000027803802';

-- D60C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D60C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D60C' and IdIGN = 'TRONROUT0000000027803806';

-- D60D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D60D'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D60D' and IdIGN = 'TRONROUT0000000027803818';

-- D60D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D60D'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D60D' and IdIGN = 'TRONROUT0000000027803821';

-- D6100
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6100'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6100' and IdIGN = 'TRONROUT0000000220173925';

-- D6100A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6100A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6100A' and IdIGN = 'TRONROUT0000000027882591';

-- D6100A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6100A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6100A' and IdIGN = 'TRONROUT0000000027882595';

-- D6100B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6100B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6100B' and IdIGN = 'TRONROUT0000000027882586';

-- D6100C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6100C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6100C' and IdIGN = 'TRONROUT0000000027882504';

-- D6100D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6100D'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6100D' and IdIGN = 'TRONROUT0000000027882580';

-- D6101
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6101'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6101' and IdIGN = 'TRONROUT0000000027886625';

-- D6101
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6101'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6101' and IdIGN = 'TRONROUT0000000027886637';

-- D6110
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6110'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6110' and IdIGN = 'TRONROUT0000002215456453';

-- D6113
-- tronçons gérés par le D13 avant le PR0 sur le territoire du D30
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6113'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6113' and IdIGN = 'TRONROUT0000000027971151';

-- D6113A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6113A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6113A' and IdIGN = 'TRONROUT0000000027959563';

-- D6113A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6113A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6113A' and IdIGN = 'TRONROUT0000000027959585';

-- D6113A
-- îlot
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6113A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6113A' and IdIGN = 'TRONROUT0000000027959560';

-- D6113B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6113B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6113B' and IdIGN = 'TRONROUT0000000027959558';

-- D6113B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6113B'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6113B' and IdIGN = 'TRONROUT0000000027959566';

-- D613
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D613'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D613' and IdIGN = 'TRONROUT0000000120836735';

-- D613
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D613'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D613' and IdIGN = 'TRONROUT0000000120836730';

-- D618
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D618'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D618' and IdIGN = 'TRONROUT0000000202677326';

-- D62
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D62'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D62' and IdIGN = 'TRONROUT0000000027980087';

-- D62
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D62'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D62' and IdIGN = 'TRONROUT0000000027980129';

-- D62
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D62'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D62' and IdIGN = 'TRONROUT0000000027980127';

-- D622
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D622'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D622' and IdIGN = 'TRONROUT0000000027862993';

-- D62A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D62A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D62A' and IdIGN = 'TRONROUT0000000027983131';

-- D62A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D62A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D62A' and IdIGN = 'TRONROUT0000000027983137';

-- D62B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D62B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D62B' and IdIGN = 'TRONROUT0000000027982586';

-- D62B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D62B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D62B' and IdIGN = 'TRONROUT0000000027982597';

-- D62B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D62B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D62B' and IdIGN = 'TRONROUT0000000027982600';

-- D62C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D62C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D62C' and IdIGN = 'TRONROUT0000000027982589';

-- D62C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D62C'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D62C' and IdIGN = 'TRONROUT0000000027982606';

-- D6313
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6313'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6313' and IdIGN = 'TRONROUT0000000027969704';

-- D6313
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6313'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6313' and IdIGN = 'TRONROUT0000000027969705';

-- D632
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D632'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D632' and IdIGN = 'TRONROUT0000000027801984';

-- D640
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D640'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D640' and IdIGN = 'TRONROUT0000000027940936';

-- D640
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D640'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D640' and IdIGN = 'TRONROUT0000000027940931';

-- D642
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D642'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D642' and IdIGN = 'TRONROUT0000000027855589';

-- D643
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D643'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D643' and IdIGN = 'TRONROUT0000000027800843';

-- D648
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D648'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D648' and IdIGN = 'TRONROUT0000000027878651';

-- D649
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D649'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D649' and IdIGN = 'TRONROUT0000000241622115';

-- D649
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D649'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D649' and IdIGN = 'TRONROUT0000000241622110';

-- D650
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D650'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D650' and IdIGN = 'TRONROUT0000000027834484';

-- D650
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D650'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D650' and IdIGN = 'TRONROUT0000002005263839';

-- D650
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D650'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D650' and IdIGN = 'TRONROUT0000002005263840';

-- D6572
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6572'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6572' and IdIGN = 'TRONROUT0000000027972517';

-- D6572
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6572'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6572' and IdIGN = 'TRONROUT0000000027972518';

-- D6572
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6572'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6572' and IdIGN = 'TRONROUT0000000027972516';

-- D6572
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6572'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6572' and IdIGN = 'TRONROUT0000000027972546';

-- D6572A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6572A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6572A' and IdIGN = 'TRONROUT0000002007706328';

-- D6580
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6580'::character varying, 190065::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6580' and IdIGN = 'TRONROUT0000000027846571';

-- D6580
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6580'::character varying, 190065::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6580' and IdIGN = 'TRONROUT0000000027846576';

-- D677
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D677'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D677' and IdIGN = 'TRONROUT0000000027855504';

-- D680
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D680'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D680' and IdIGN = 'TRONROUT0000000027862286';

-- D686
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D686'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D686' and IdIGN = 'TRONROUT0000000027774437';

-- D687
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D687'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D687' and IdIGN = 'TRONROUT0000000027794531';

-- D6A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6A' and IdIGN = 'TRONROUT0000000119296584';

-- D6A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6A' and IdIGN = 'TRONROUT0000000119296592';

-- D6C
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6C'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6C' and IdIGN = 'TRONROUT0000000027805094';

-- D6D
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D6D'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D6D' and IdIGN = 'TRONROUT0000000027809559';

-- D7
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D7'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D7' and IdIGN = 'TRONROUT0000000027873422';

-- D7
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D7'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D7' and IdIGN = 'TRONROUT0000000027873430';

-- D701
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D701'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D701' and IdIGN = 'TRONROUT0000000027834056';

-- D702
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D702'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D702' and IdIGN = 'TRONROUT0000000027904748';

-- D703
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D703'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D703' and IdIGN = 'TRONROUT0000000027938116';

-- D706
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D706'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D706' and IdIGN = 'TRONROUT0000000027854208';

-- D710
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D710'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D710' and IdIGN = 'TRONROUT0000000027825882';

-- D712
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D712'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D712' and IdIGN = 'TRONROUT0000000118237106';

-- D712
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D712'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D712' and IdIGN = 'TRONROUT0000000118237124';

-- D713
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D713'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D713' and IdIGN = 'TRONROUT0000000358008171';

-- D713
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D713'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D713' and IdIGN = 'TRONROUT0000000358008172';

-- D714
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D714'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D714' and IdIGN = 'TRONROUT0000000225879414';

-- D715
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D715'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D715' and IdIGN = 'TRONROUT0000000027837981';

-- D715
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D715'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D715' and IdIGN = 'TRONROUT0000000027837982';

-- D716
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D716'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D716' and IdIGN = 'TRONROUT0000000130410428';

-- D716
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D716'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D716' and IdIGN = 'TRONROUT0000000130410412';

-- D718
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D718'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D718' and IdIGN = 'TRONROUT0000000027981251';

-- D718
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D718'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D718' and IdIGN = 'TRONROUT0000000027981321';

-- D720
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D720'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D720' and IdIGN = 'TRONROUT0000000027869538';

-- D720
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D720'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D720' and IdIGN = 'TRONROUT0000000357331723';

-- D720
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D720'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D720' and IdIGN = 'TRONROUT0000000027869536';

-- D722
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D722'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D722' and IdIGN = 'TRONROUT0000000027923708';

-- D723
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D723'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D723' and IdIGN = 'TRONROUT0000000027877525';

-- D723
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D723'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D723' and IdIGN = 'TRONROUT0000000357996895';

-- D724
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D724'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D724' and IdIGN = 'TRONROUT0000000027869872';

-- D728
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D728'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D728' and IdIGN = 'TRONROUT0000000027786670';

-- D736
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D736'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D736' and IdIGN = 'TRONROUT0000000027873051';

-- D736A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D736A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D736A' and IdIGN = 'TRONROUT0000000027880543';

-- D737
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D737'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D737' and IdIGN = 'TRONROUT0000000357996203';

-- D742
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D742'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D742' and IdIGN = 'TRONROUT0000000027963714';

-- D746
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D746'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D746' and IdIGN = 'TRONROUT0000000027775565';

-- D746
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D746'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D746' and IdIGN = 'TRONROUT0000000088881806';

-- D747
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D747'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D747' and IdIGN = 'TRONROUT0000000027803450';

-- D754
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D754'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D754' and IdIGN = 'TRONROUT0000000027941885';

-- D755
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D755'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D755' and IdIGN = 'TRONROUT0000000027938086';

-- D757
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D757'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D757' and IdIGN = 'TRONROUT0000000027822949';

-- D763
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D763'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D763' and IdIGN = 'TRONROUT0000000027927767';

-- D764
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D764'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D764' and IdIGN = 'TRONROUT0000000224433785';

-- D764
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D764'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D764' and IdIGN = 'TRONROUT0000000224433786';

-- D765
-- îlot
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D765'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D765' and IdIGN = 'TRONROUT0000002206432619';

-- D765A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D765A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D765A' and IdIGN = 'TRONROUT0000000027806616';

-- D765A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D765A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D765A' and IdIGN = 'TRONROUT0000000027806617';

-- D779
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D779'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D779' and IdIGN = 'TRONROUT0000000027978984';

-- D780
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D780'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D780' and IdIGN = 'TRONROUT0000000027861995';

-- D780
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D780'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D780' and IdIGN = 'TRONROUT0000000333862955';

-- D787
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D787'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D787' and IdIGN = 'TRONROUT0000000027798545';

-- D789
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D789'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D789' and IdIGN = 'TRONROUT0000000027878775';

-- D790
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D790'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D790' and IdIGN = 'TRONROUT0000000027878696';

-- D790A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D790A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D790A' and IdIGN = 'TRONROUT0000000227885134';

-- D792
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D792'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D792' and IdIGN = 'TRONROUT0000000027876471';

-- D7A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D7A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D7A' and IdIGN = 'TRONROUT0000000220120003';

-- D8
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D8'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D8' and IdIGN = 'TRONROUT0000000027873436';

-- D8
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D8'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D8' and IdIGN = 'TRONROUT0000000027873442';

-- D803
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D803'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D803' and IdIGN = 'TRONROUT0000000027913134';

-- D812
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D812'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D812' and IdIGN = 'TRONROUT0000000027830933';

-- D813
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D813'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D813' and IdIGN = 'TRONROUT0000000027899019';

-- D814
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D814'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D814' and IdIGN = 'TRONROUT0000000223333504';

-- D823
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D823'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D823' and IdIGN = 'TRONROUT0000000220651823';

-- D842
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D842'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D842' and IdIGN = 'TRONROUT0000000027963812';

-- D842A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D842A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D842A' and IdIGN = 'TRONROUT0000000027963848';

-- D843
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D843'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D843' and IdIGN = 'TRONROUT0000000347552313';

-- D865
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D865'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D865' and IdIGN = 'TRONROUT0000000027802355';

-- D892
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D892'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D892' and IdIGN = 'TRONROUT0000000027872582';

-- D9
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D9'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D9' and IdIGN = 'TRONROUT0000000027820140';

-- D90
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D90'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D90' and IdIGN = 'TRONROUT0000000217273876';

-- D90
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D90'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D90' and IdIGN = 'TRONROUT0000000217273884';

-- D900
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D900'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D900' and IdIGN = 'TRONROUT0000000027879384';

-- D900
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D900'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D900' and IdIGN = 'TRONROUT0000000027875917';

-- D900
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D900'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D900' and IdIGN = 'TRONROUT0000000027875918';

-- D901
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D901'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D901' and IdIGN = 'TRONROUT0000000027773081';

-- D901
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D901'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D901' and IdIGN = 'TRONROUT0000000027773074';

-- D901
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D901'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D901' and IdIGN = 'TRONROUT0000000027773075';

-- D901A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D901A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D901A' and IdIGN = 'TRONROUT0000000027770070';

-- D904
-- tronçons gérés par le D30 avant le PR0 sur le territoire du D07
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D904'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D904' and IdIGN = 'TRONROUT0000000005733782';

-- D906
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D906'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D906' and IdIGN = 'TRONROUT0000000027803836';

-- D906
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D906'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D906' and IdIGN = 'TRONROUT0000000027803887';

-- D907
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D907'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D907' and IdIGN = 'TRONROUT0000000216766864';

-- D907
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D907'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D907' and IdIGN = 'TRONROUT0000000027913763';

-- D907
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D907'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D907' and IdIGN = 'TRONROUT0000002200513390';

-- D90A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D90A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D90A' and IdIGN = 'TRONROUT0000000027942381';

-- D90A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D90A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D90A' and IdIGN = 'TRONROUT0000000027942382';

-- D90B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D90B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D90B' and IdIGN = 'TRONROUT0000000027944542';

-- D90B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D90B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D90B' and IdIGN = 'TRONROUT0000000027944543';

-- D90B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D90B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D90B' and IdIGN = 'TRONROUT0000000027944549';

-- D910A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D910A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D910A' and IdIGN = 'TRONROUT0000000027830370';

-- D916
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D916'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D916' and IdIGN = 'TRONROUT0000000027815796';

-- D926
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D926'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D926' and IdIGN = 'TRONROUT0000000335665129';

-- D926
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D926'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D926' and IdIGN = 'TRONROUT0000000335665133';

-- D926A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D926A'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D926A' and IdIGN = 'TRONROUT0000000027916691';

-- D936
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D936'::character varying, 90800::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D936' and IdIGN = 'TRONROUT0000000356723060';

-- D936
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D936'::character varying, 90800::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D936' and IdIGN = 'TRONROUT0000000356723026';

-- D976
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D976'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D976' and IdIGN = 'TRONROUT0000000119280807';

-- D976
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D976'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D976' and IdIGN = 'TRONROUT0000000119280813';

-- D979
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D979'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D979' and IdIGN = 'TRONROUT0000000005729468';

-- D979A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D979A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D979A' and IdIGN = 'TRONROUT0000000027980545';

-- D980
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D980'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D980' and IdIGN = 'TRONROUT0000000027774975';

-- D980
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D980'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D980' and IdIGN = 'TRONROUT0000000353719880';

-- D981
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D981'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D981' and IdIGN = 'TRONROUT0000000027818736';

-- D981
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D981'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D981' and IdIGN = 'TRONROUT0000000027818753';

-- D982
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D982'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D982' and IdIGN = 'TRONROUT0000000118229716';

-- D982
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D982'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D982' and IdIGN = 'TRONROUT0000000118229706';

-- D983
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D983'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D983' and IdIGN = 'TRONROUT0000000027813435';

-- D986
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D986'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D986' and IdIGN = 'TRONROUT0000000027808671';

-- D986A
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D986A'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D986A' and IdIGN = 'TRONROUT0000000350792743';

-- D986L
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D986L'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D986L' and IdIGN = 'TRONROUT0000000220173850';

-- D986L
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D986L'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D986L' and IdIGN = 'TRONROUT0000000220173855';

-- D986L
-- tronçons de continuité topo
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D986L'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D986L' and IdIGN = 'TRONROUT0000000220173858';

-- D986L
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D986L'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D986L' and IdIGN = 'TRONROUT0000000220650478';

-- D994
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D994'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D994' and IdIGN = 'TRONROUT0000000027775862';

-- D994
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D994'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D994' and IdIGN = 'TRONROUT0000000222493721';

-- D998
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D998'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D998' and IdIGN = 'TRONROUT0000000027768214';

-- D999
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D999'::character varying, 0::integer, 0::numeric, ST_StartPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D999' and IdIGN = 'TRONROUT0000000027942080';

-- D999B
insert into PR (NumeroRoute, PRA, CumulDist, Geom) select 'D999B'::character varying, 0::integer, 0::numeric, ST_EndPoint(Geom) from BDT2RR_Troncon where NumeroRoute = 'D999B' and IdIGN = 'TRONROUT0000000027914871';