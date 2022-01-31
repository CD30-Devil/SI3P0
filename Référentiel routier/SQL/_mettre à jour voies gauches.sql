-- Ce script permet de positionner les voies gauches.
-- Celles-ci se définissent comme les voies dont le sens de circulation est décroissant par rapport aux PR et qui sont séparées (mur, glissière, surlargeur) de la voie croissante correspondante.
--
-- Syntaxe pour une RD complète :
-- update Troncon
-- set Gauche = true
-- where NumeroRoute = '<NumeroRoute>'
-- and SensCirculation = 2;
--
-- Syntaxe pour une section de RD :
-- update Troncon
-- set Gauche = true
-- where NumeroRoute = '<NumeroRoute>'
-- and SensCirculation = 2
-- and IdIGN in (
--     select _IdIGN
--     from RechercherTronconsEntreIdIGN(
--         '<NumeroRoute>',
--         array['<Tronçon 1 de début de section>', '<Tronçon 2 de début de section>', ..., '<Tronçon N de début de section>'],
--         array['<Tronçon 1 de fin de section>', '<Tronçon 2 de fin de section>', ..., '<Tronçon N de fin de section>']
--     )
-- );
--
-- A faire :
-- - Mettre préalablement les attributs Gauche de tous les tronçons à false.
-- - Mettre, en fin de script, à null l'attribut Gauche des tronçons fictifs.

update Troncon
set Gauche = false;

update Troncon
set Gauche = true
where NumeroRoute = 'D16'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D16',
        array['TRONROUT0000000027805829', 'TRONROUT0000000027805847'],
        array['TRONROUT0000000027803668', 'TRONROUT0000000358006828']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D367A'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D367A',
        array['TRONROUT0000000224380229', 'TRONROUT0000000224380231'],
        array['TRONROUT0000000224380252', 'TRONROUT0000000224380278']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D40'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D40',
        array['TRONROUT0000000027940942', 'TRONROUT0000000027940929'],
        array['TRONROUT0000000241650865', 'TRONROUT0000000241650878']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D42'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D42',
        array['TRONROUT0000000356723510', 'TRONROUT0000000356723509'],
        array['TRONROUT0000000356723299', 'TRONROUT0000000356723524']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D51'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D51',
        array['TRONROUT0000000241622072', 'TRONROUT0000000241622071'],
        array['TRONROUT0000000241622063', 'TRONROUT0000000241622065']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D60'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D60',
        array['TRONROUT0000000027810185', 'TRONROUT0000000027810193'],
        array['TRONROUT0000000027812447', 'TRONROUT0000000027812435']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D6086'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D6086',
        array['TRONROUT0000000242620247', 'TRONROUT0000000027916065'],
        array['TRONROUT0000000274512348', 'TRONROUT0000000274512347']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D6100'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D6100',
        array['TRONROUT0000000027879211', 'TRONROUT0000000027879212'],
        array['TRONROUT0000000027882521', 'TRONROUT0000000027882496']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D6113'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D6113',
        array['TRONROUT0000000224437677', 'TRONROUT0000000224437683'],
        array['TRONROUT0000000027969940', 'TRONROUT0000000027969941']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D6113'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D6113',
        array['TRONROUT0000000353797316', 'TRONROUT0000000353797315'],
        array['TRONROUT0000000224380330', 'TRONROUT0000000224380358']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D6113'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D6113',
        array['TRONROUT0000000224380363', 'TRONROUT0000000224380366'],
        array['TRONROUT0000000027945255', 'TRONROUT0000000027945256']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D62'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D62',
        array['TRONROUT0000000027980127', 'TRONROUT0000000027980129'],
        array['TRONROUT0000000027980840', 'TRONROUT0000000027980844']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D62A'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D62A',
        array['TRONROUT0000000027983131', 'TRONROUT0000000027983137'],
        array['TRONROUT0000000027981948', 'TRONROUT0000000027981944']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D62B'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D62B',
        array['TRONROUT0000000214230334', 'TRONROUT0000000027982991'],
        array['TRONROUT0000000323799294', 'TRONROUT0000000323799297']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D6313'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D6313',
        array['TRONROUT0000000027969704', 'TRONROUT0000000027969705'],
        array['TRONROUT0000000027973691', 'TRONROUT0000000027973694']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D640'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D640',
        array['TRONROUT0000000027940931', 'TRONROUT0000000027940936'],
        array['TRONROUT0000000027936988', 'TRONROUT0000000027937003']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D6580'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D6580',
        array['TRONROUT0000000333823852', 'TRONROUT0000000333823843'],
        array['TRONROUT0000000027875939', 'TRONROUT0000000219384591']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D90'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D90',
        array['TRONROUT0000000292183623', 'TRONROUT0000000292183618'],
        array['TRONROUT0000000292183627', 'TRONROUT0000000292183628']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D906'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D906',
        array['TRONROUT0000000258051898', 'TRONROUT0000000258051886'],
        array['TRONROUT0000000258051893', 'TRONROUT0000000258051897']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D907'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D907',
        array['TRONROUT0000000027838969', 'TRONROUT0000000027838970'],
        array['TRONROUT0000000027838930', 'TRONROUT0000000027838928']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D979'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D979',
        array['TRONROUT0000000027973705', 'TRONROUT0000000027973706'],
        array['TRONROUT0000000359408837', 'TRONROUT0000000027975729']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D979'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D979',
        array['TRONROUT0000000359408845', 'TRONROUT0000000359408847'],
        array['TRONROUT0000000359408835', 'TRONROUT0000000359408843']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D979'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D979',
        array['TRONROUT0000000027977645', 'TRONROUT0000000027977646'],
        array['TRONROUT0000000027980555', 'TRONROUT0000000027980122']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D999'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D999',
        array['TRONROUT0000000353798533', 'TRONROUT0000000353798517'],
        array['TRONROUT0000000027928366', 'TRONROUT0000000027928360']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D999'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D999',
        array['TRONROUT0000000027878392', 'TRONROUT0000000094082479'],
        array['TRONROUT0000000094083526', 'TRONROUT0000000027878409']
    )
);

update Troncon
set Gauche = true
where NumeroRoute = 'D999'
and SensCirculation = 2
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D999',
        array['TRONROUT0000000295450180', 'TRONROUT0000000295450127'],
        array['TRONROUT0000000295450154', 'TRONROUT0000000295450166']
    )
);

-- Remise à null pour les tronçons fictifs.
update Troncon
set Gauche = null
where Fictif;