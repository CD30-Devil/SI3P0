-- Les conventions de gestion font que le propriétaire d'une section de route n'est pas forcément celui qui en assure la gestion courante ou la viabilité hivernale.
--
-- La construction pré-renseigne le gestionnaire avec la valeur définie dans la route numérotée ou nommée.
-- Ce script permet la mise à jour de l'attribut métier "SirenGestionCourante" là où c'est nécessaire après construction
--
-- TODO :
-- Adapter ce script de sorte à corriger la valeur de l'attribut "SirenGestionCourante" là où c'est nécessaire après construction.
-- 
-- Syntaxe pour une section de RD :
-- update Troncon
-- set SirenGestionCourante = '<Siren>'
-- where SirenGestionCourante <> '<Siren>'
-- and NumeroRoute = '<NumeroRoute>'
-- and IdIGN in (
--     select _IdIGN
--     from RechercherTronconsEntreIdIGN(
--         '<NumeroRoute>',
--         array['<Tronçon 1 de début de section>', '<Tronçon 2 de début de section>', ..., '<Tronçon N de début de section>'],
--         array['<Tronçon 1 de fin de section>', '<Tronçon 2 de fin de section>', ..., '<Tronçon N de fin de section>']
--     )
-- );

-- 34D107 - Claret / Pompignan
update Troncon
set SirenGestionCourante = '223000019'
where SirenGestionCourante <> '223000019'
and NumeroRoute = '34D107'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '34D107',
        array['TRONROUT0000000044741725'],
        array['TRONROUT0000000027918299']
    )
);

-- 34D130E7 - Blandas / Saint-Maurice-Navacelles
update Troncon
set SirenGestionCourante = '223000019'
where SirenGestionCourante <> '223000019'
and NumeroRoute = '34D130E7'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '34D130E7',
        array['TRONROUT0000000044740582'],
        array['TRONROUT0000000044740589']
    )
);

-- 34D1E6 - Ferrières-les-Verreries / Pompignan
update Troncon
set SirenGestionCourante = '223000019'
where SirenGestionCourante <> '223000019'
and NumeroRoute = '34D1E6'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '34D1E6',
        array['TRONROUT0000000308049448'],
        array['TRONROUT0000000044740940']
    )
);

-- 34D4 - Ganges / Sumène
update Troncon
set SirenGestionCourante = '223000019'
where SirenGestionCourante <> '223000019'
and NumeroRoute = '34D4'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '34D4',
        array['TRONROUT0000000338943840', 'TRONROUT0000000338943848', 'TRONROUT0000000338943849', 'TRONROUT0000000338943845', 'TRONROUT0000000338943842', 'TRONROUT0000000338943843'],
        array['TRONROUT0000000044737766']
    )
);

-- 34D4E13 - Ganges / Sumène
update Troncon
set SirenGestionCourante = '223000019'
where SirenGestionCourante <> '223000019'
and NumeroRoute = '34D4E13'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '34D4E13',
        array['TRONROUT0000000338943839', 'TRONROUT0000000338943841', 'TRONROUT0000000338943842', 'TRONROUT0000000338943843', 'TRONROUT0000000338943849', 'TRONROUT0000000338943845'],
        array['TRONROUT0000000128724369', 'TRONROUT0000000044738116']
    )
);

-- D113 - Saint-Maurice-Navacelles / Vissec
update Troncon
set SirenGestionCourante = '223400011'
where SirenGestionCourante <> '223400011'
and NumeroRoute = 'D113'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D113',
        array['TRONROUT0000000027921459'],
        array['TRONROUT0000000027921458']
    )
);

-- D113B - Sorbs / Vissec
update Troncon
set SirenGestionCourante = '223400011'
where SirenGestionCourante <> '223400011'
and NumeroRoute = 'D113B'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D113B',
        array['TRONROUT0000000227728810'],
        array['TRONROUT0000000227728810']
    )
);

-- D141 - Aiguèze / Saint-Martin-d'Ardèche
update Troncon
set SirenGestionCourante = '220700017'
where SirenGestionCourante <> '220700017'
and NumeroRoute = 'D141'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D141',
        array['TRONROUT0000000027769601'],
        array['TRONROUT0000000027769601']
    )
);

-- D159 - Nant / Revens
update Troncon
set SirenGestionCourante = '221200017'
where SirenGestionCourante <> '221200017'
and NumeroRoute = 'D159'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D159',
        array['TRONROUT0000000027839762'],
        array['TRONROUT0000000027839762']
    )
);

-- D15A - Arles / Fourques
update Troncon
set SirenGestionCourante = '221300015'
where SirenGestionCourante <> '221300015'
and NumeroRoute = 'D15A'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D15A',
        array['TRONROUT0000000027969908'],
        array['TRONROUT0000000027969908']
    )
);

-- D195 - La Cadière-et-Cambo / Montoulieu
update Troncon
set SirenGestionCourante = '223400011'
where SirenGestionCourante <> '223400011'
and NumeroRoute = 'D195'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D195',
        array['TRONROUT0000000258569069', 'TRONROUT0000000258569089'],
        array['TRONROUT0000000027893593']
    )
);

-- D222 - Saussines / Sommières
update Troncon
set SirenGestionCourante = '223400011'
where SirenGestionCourante <> '223400011'
and NumeroRoute = 'D222'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D222',
        array['TRONROUT0000000027957511'],
        array['TRONROUT0000000027957511']
    )
);

-- D265 - Aimargues / Marsillargues (/!\ voie déclassée par le D34 à la commune de Marsillargues - convention de gestion caduque ?)
update Troncon
set SirenGestionCourante = '213401516'
where SirenGestionCourante <> '213401516'
and NumeroRoute = 'D265'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D265',
        array['TRONROUT0000000027976252'],
        array['TRONROUT0000000027976252']
    )
);


-- D273 - Campestre-et-Luc / Le Cros
update Troncon
set SirenGestionCourante = '223400011'
where SirenGestionCourante <> '223400011'
and NumeroRoute = 'D273'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D273',
        array['TRONROUT0000000027907146'],
        array['TRONROUT0000000027907146']
    )
);

-- D412 - Aubais / Villetelle
update Troncon
set SirenGestionCourante = '223400011'
where SirenGestionCourante <> '223400011'
and NumeroRoute = 'D412'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D412',
        array['TRONROUT0000000027964295'],
        array['TRONROUT0000000027964295']
    )
);

-- D51 - Ponteils-et-Brésis / Saint-André-Capcèze
update Troncon
set SirenGestionCourante = '224800011'
where SirenGestionCourante <> '224800011'
and NumeroRoute = 'D51'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D51',
        array['TRONROUT0000000027765523'],
        array['TRONROUT0000000027765380']
    )
);

-- D6086 - Pont-Saint-Esprit / Saint-Just-d'Ardèche
update Troncon
set SirenGestionCourante = '220700017'
where SirenGestionCourante <> '220700017'
and NumeroRoute = 'D6086'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D6086',
        array['TRONROUT0000000027771726'],
        array['TRONROUT0000000027771726']
    )
);

-- D6100 - Avignon / Les Angles
update Troncon
set SirenGestionCourante = '228400016'
where SirenGestionCourante <> '228400016'
and NumeroRoute = 'D6100'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D6100',
        array['TRONROUT0000002327161302', 'TRONROUT0000000027882496'],
        array['TRONROUT0000002327161302', 'TRONROUT0000000027882496']
    )
);

-- D6113 - Arles / Fourques
update Troncon
set SirenGestionCourante = '221300015'
where SirenGestionCourante <> '221300015'
and NumeroRoute = 'D6113'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D6113',
        array['TRONROUT0000000027971151'],
        array['TRONROUT0000000027971151']
    )
);

-- D62 - Aigues-Mortes / La Grande-Motte
update Troncon
set SirenGestionCourante = '223400011'
where SirenGestionCourante <> '223400011'
and NumeroRoute = 'D62'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D62',
        array['TRONROUT0000000027980846', 'TRONROUT0000000027980851'],
        array['TRONROUT0000000027980845']
    )
);

-- D90 - Beaucaire / Tarascon
update Troncon
set SirenGestionCourante = '221300015'
where SirenGestionCourante <> '221300015'
and NumeroRoute = 'D90'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D90',
        array['TRONROUT0000000027946933'],
        array['TRONROUT0000000027946933']
    )
);

-- D999 - La Cadière-et-Cambo / Moulès-et-Baucels
update Troncon
set SirenGestionCourante = '223400011'
where SirenGestionCourante <> '223400011'
and NumeroRoute = 'D999'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D999',
        array['TRONROUT0000000027888190'],
        array['TRONROUT0000000027890919']
    )
);

-- remise à null pour des tronçons qui ne sont pas "réels"
update Troncon t
set SirenGestionCourante = null
where t.IdTroncon not in (select IdTroncon from TronconReel);