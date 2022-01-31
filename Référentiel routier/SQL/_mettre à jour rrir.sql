-- Ce script est utile pour définir le Réseau Routier d'Intérêt Régional (RIRR) fixées par délibération de la région.
--
-- Syntaxe pour une RD complète :
-- update Troncon
-- set RRIR = '<Nature du RRID>'
-- where NumeroRoute = '<NumeroRoute>';
--
-- Syntaxe pour une section de RD :
-- update Troncon
-- set RRIR = '<Nature du RRID>'
-- where NumeroRoute = '<NumeroRoute>'
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
-- - Mettre préalablement les attributs RRIR de tous les tronçons à null.
-- - Mettre, en fin de script, à null l'attribut RRIR des tronçons fictifs.

update Troncon
set RRIR = null;

update Troncon
set RRIR = 'Connexion pôle urbain économique'
where NumeroRoute = 'D6'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D6',
        array['TRONROUT0000000027812467', 'TRONROUT0000000027812440', 'TRONROUT0000000027812489', 'TRONROUT0000000027812485', 'TRONROUT0000000027812483', 'TRONROUT0000000027812482', 'TRONROUT0000000027812481', 'TRONROUT0000000027812487', 'TRONROUT0000000027812486', 'TRONROUT0000000027812484', 'TRONROUT0000000249688693', 'TRONROUT0000000027812490', 'TRONROUT0000000027812488'],
        array['TRONROUT0000000027795699', 'TRONROUT0000000027795675']
    )
);

update Troncon
set RRIR = 'Ouverture interrégionale'
where NumeroRoute = 'D6100'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D6100',
        array['TRONROUT0000000027879211', 'TRONROUT0000000027879212'],
        array['TRONROUT0000000027882521', 'TRONROUT0000000027882496']
    )
);

update Troncon
set RRIR = 'Connexion pôle urbain économique'
where NumeroRoute = 'D6110'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D6110',
        array['TRONROUT0000002215456453'],
        array['TRONROUT0000000027824935', 'TRONROUT0000000027824923', 'TRONROUT0000000027824947', 'TRONROUT0000000027824948', 'TRONROUT0000000027821900', 'TRONROUT0000000027821827', 'TRONROUT0000000027821825', 'TRONROUT0000000027821830', 'TRONROUT0000000027824949']
    )
);

update Troncon
set RRIR = 'Ouverture interrégionale'
where NumeroRoute = 'D6580';

update Troncon
set RRIR = 'Ouverture interrégionale'
where NumeroRoute = 'D90'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D90',
        array['TRONROUT0000000027935424', 'TRONROUT0000000027935371', 'TRONROUT0000000217274193', 'TRONROUT0000002002165044', 'TRONROUT0000000027935358', 'TRONROUT0000000027935380', 'TRONROUT0000000027935375', 'TRONROUT0000002215581936', 'TRONROUT0000000027935364', 'TRONROUT0000000027935381', 'TRONROUT0000000027935359'],
        array['TRONROUT0000000027946950']
    )
);

update Troncon
set RRIR = 'Ouverture interrégionale'
where NumeroRoute = 'D904';

update Troncon
set RRIR = 'Connexion pôle urbain économique'
where NumeroRoute = 'D906';

update Troncon
set RRIR = 'Connexion pôle urbain économique'
where NumeroRoute = 'D979'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D979',
        array['TRONROUT0000000027856741'],
        array['TRONROUT0000000027922379']
    )
);

update Troncon
set RRIR = 'Ouverture interrégionale'
where NumeroRoute = 'D999'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D999',
        array['TRONROUT0000000027935382', 'TRONROUT0000000027935385'],
        array['TRONROUT0000000027928366', 'TRONROUT0000000027928360']
    )
);

update Troncon
set RRIR = 'Connexion pôle urbain économique'
where NumeroRoute = 'D999'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D999',
        array['TRONROUT0000000027930031'],
        array['TRONROUT0000000027885966']
    )
);

-- Remise à null pour des tronçons fictifs.
update Troncon
set RRIR = null
where Fictif;