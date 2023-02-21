-- Les conventions de gestion font que le propriétaire d'une section de route n'est pas forcément celui qui en assure la gestion courante ou la viabilité hivernale.
--
-- La construction pré-renseigne le propriétaire avec la valeur définie dans la route numérotée ou nommée.
-- Ce script permet la mise à jour de l'attribut métier "SirenProprietaire" là où c'est nécessaire après construction
--
-- TODO :
-- Adapter ce script de sorte à corriger la valeur de l'attribut "SirenProprietaire" là où c'est nécessaire après construction.
-- 
-- Syntaxe pour une section de RD :
-- update Troncon
-- set SirenProprietaire = '<Siren>'
-- where SirenProprietaire <> '<Siren>'
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
set SirenProprietaire = '223000019'
where SirenProprietaire <> '223000019'
and NumeroRoute = '34D107'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '34D107',
        array['TRONROUT0000000084336066'],
        array['TRONROUT0000000027918299']
    )
);

-- 34D107E1 - Brouzet-lès-Quissac / Vacquières
update Troncon
set SirenProprietaire = '223000019'
where SirenProprietaire <> '223000019'
and NumeroRoute = '34D107E1'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '34D107E1',
        array['TRONROUT0000000044744178'],
        array['TRONROUT0000000044744170']
    )
);

-- 34D107E1 - Brouzet-lès-Quissac / Vacquières
update Troncon
set SirenProprietaire = '223000019'
where SirenProprietaire <> '223000019'
and NumeroRoute = '34D107E1'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '34D107E1',
        array['TRONROUT0000000027931340'],
        array['TRONROUT0000000027931286']
    )
);

-- 34D107E4 - Claret / Pompignan
update Troncon
set SirenProprietaire = '223000019'
where SirenProprietaire <> '223000019'
and NumeroRoute = '34D107E4'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '34D107E4',
        array['TRONROUT0000000027921374'],
        array['TRONROUT0000000027921381']
    )
);

-- 34D17E6 - Claret / Pompignan
update Troncon
set SirenProprietaire = '223000019'
where SirenProprietaire <> '223000019'
and NumeroRoute = '34D17E6'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '34D17E6',
        array['TRONROUT0000000044742039'],
        array['TRONROUT0000000044742039']
    )
);

-- 34D25 - Rogues / Saint-Maurice-Navacelles
update Troncon
set SirenProprietaire = '223000019'
where SirenProprietaire <> '223000019'
and NumeroRoute = '34D25'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '34D25',
        array['TRONROUT0000000358008149'],
        array['TRONROUT0000000027927494']
    )
);

-- 34D25 - Gorniès / Saint-Laurent-le-Minier
update Troncon
set SirenProprietaire = '223000019'
where SirenProprietaire <> '223000019'
and NumeroRoute = '34D25'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '34D25',
        array['TRONROUT0000000027904179'],
        array['TRONROUT0000000027896101']
    )
);

-- 34D61 - Aigues-Mortes / La Grande-Motte / Marsillargues
update Troncon
set SirenProprietaire = '223000019'
where SirenProprietaire <> '223000019'
and NumeroRoute = '34D61'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '34D61',
        array['TRONROUT0000002011408116', 'TRONROUT0000002220856506'],
        array['TRONROUT0000002011408134', 'TRONROUT0000002011408110']
    )
);

-- 48D118 - Bassurels / Val-d'Aigoual
update Troncon
set SirenProprietaire = '223000019'
where SirenProprietaire <> '223000019'
and NumeroRoute = '48D118'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '48D118',
        array['TRONROUT0000000027819851'],
        array['TRONROUT0000000102078696']
    )
);

-- 48D9 - Le Pompidou / Saint-André-de-Valborgne
update Troncon
set SirenProprietaire = '223000019'
where SirenProprietaire <> '223000019'
and NumeroRoute = '48D9'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '48D9',
        array['TRONROUT0000000027799686'],
        array['TRONROUT0000000027799679']
    )
);

-- 48D9 - Gabriac / Saint-André-de-Valborgne
update Troncon
set SirenProprietaire = '223000019'
where SirenProprietaire <> '223000019'
and NumeroRoute = '48D9'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '48D9',
        array['TRONROUT0000000027802131'],
        array['TRONROUT0000000102102206']
    )
);

-- 48D9 - Saint-André-de-Valborgne / Sainte-Croix-Vallée-Française
update Troncon
set SirenProprietaire = '223000019'
where SirenProprietaire <> '223000019'
and NumeroRoute = '48D9'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        '48D9',
        array['TRONROUT0000002292436475'],
        array['TRONROUT0000002292436475']
    )
);

-- D10C - Bassurels / Saint-André-de-Valborgne
update Troncon
set SirenProprietaire = '224800011'
where SirenProprietaire <> '224800011'
and NumeroRoute = 'D10C'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D10C',
        array['TRONROUT0000000099569121'],
        array['TRONROUT0000000099569122']
    )
);

-- D156B - Chambon / Malbosc
update Troncon
set SirenProprietaire = '220700017'
where SirenProprietaire <> '220700017'
and NumeroRoute = 'D156B'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D156B',
        array['TRONROUT0000000005735306'],
        array['TRONROUT0000000005735306']
    )
);

-- D172 - Saint-Martin-de-Boubaux / Saint-Paul-la-Coste
update Troncon
set SirenProprietaire = '224800011'
where SirenProprietaire <> '224800011'
and NumeroRoute = 'D172'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D172',
        array['TRONROUT0000000099569549'],
        array['TRONROUT0000000099569550']
    )
);

-- D183A - Aramon / Saint-Pierre-de-Mézoargues
update Troncon
set SirenProprietaire = '221300015'
where SirenProprietaire <> '221300015'
and NumeroRoute = 'D183A'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D183A',
        array['TRONROUT0000000040697362'],
        array['TRONROUT0000000040697339']
    )
);

-- D183A - Aramon / Boulbon
update Troncon
set SirenProprietaire = '221300015'
where SirenProprietaire <> '221300015'
and NumeroRoute = 'D183A'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D183A',
        array['TRONROUT0000000040696263'],
        array['TRONROUT0000000040695115']
    )
);

-- D184 - Bordezac / Malbosc
update Troncon
set SirenProprietaire = '220700017'
where SirenProprietaire <> '220700017'
and NumeroRoute = 'D184'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D184',
        array['TRONROUT0000000005734875'],
        array['TRONROUT0000000005734875']
    )
);

-- D206 - Saint-Martin-de-Boubaux / Saint-Paul-la-Coste
update Troncon
set SirenProprietaire = '224800011'
where SirenProprietaire <> '224800011'
and NumeroRoute = 'D206'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D206',
        array['TRONROUT0000000099569548'],
        array['TRONROUT0000000099569548']
    )
);

-- D39 - Moissac-Vallée-Française / Saint-André-de-Valborgne
update Troncon
set SirenProprietaire = '224800011'
where SirenProprietaire <> '224800011'
and NumeroRoute = 'D39'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D39',
        array['TRONROUT0000000099571846'],
        array['TRONROUT0000000099571846']
    )
);

-- D402 - Aramon / Barbentane 
update Troncon
set SirenProprietaire = '221300015'
where SirenProprietaire <> '221300015'
and NumeroRoute = 'D402'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D402',
        array['TRONROUT0000000040692294'],
        array['TRONROUT0000000040692294']
    )
);

-- D430 - Banne / Gagnières
update Troncon
set SirenProprietaire = '220700017'
where SirenProprietaire <> '220700017'
and NumeroRoute = 'D430'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D430',
        array['TRONROUT0000000005734518'],
        array['TRONROUT0000000005734518']
    )
);

-- D45 - Corconne / Sauteyrargues
update Troncon
set SirenProprietaire = '223400011'
where SirenProprietaire <> '223400011'
and NumeroRoute = 'D45'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D45',
        array['TRONROUT0000000044743055'],
        array['TRONROUT0000000044743055']
    )
);

-- D46 - Marsillargues / Saint-Laurent-d'Aigouze
update Troncon
set SirenProprietaire = '223400011'
where SirenProprietaire <> '223400011'
and NumeroRoute = 'D46'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D46',
        array['TRONROUT0000000044811672'],
        array['TRONROUT0000000044811672']
    )
);

-- D47 - Lanuéjols / Meyrueis
update Troncon
set SirenProprietaire = '224800011'
where SirenProprietaire <> '224800011'
and NumeroRoute = 'D47'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D47',
        array['TRONROUT0000000099571630'],
        array['TRONROUT0000000099571630']
    )
);

-- D58 - Saintes-Maries-de-la-Mer / Vauvert
update Troncon
set SirenProprietaire = '221300015'
where SirenProprietaire <> '221300015'
and NumeroRoute = 'D58'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D58',
        array['TRONROUT0000000040824590'],
        array['TRONROUT0000000040824590']
    )
);

-- D6572 - Arles / Saint-Gilles
update Troncon
set SirenProprietaire = '221300015'
where SirenProprietaire <> '221300015'
and NumeroRoute = 'D6572'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D6572',
        array['TRONROUT0000002000558315'],
        array['TRONROUT0000002000558315']
    )
);

-- D904 - Courry / Saint-Paul-le-Jeune
update Troncon
set SirenProprietaire = '220700017'
where SirenProprietaire <> '220700017'
and NumeroRoute = 'D904'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D904',
        array['TRONROUT0000000005733782'],
        array['TRONROUT0000000005733782']
    )
);

-- D906 - Ponteils-et-Brésis / Saint-André-Capcèze
update Troncon
set SirenProprietaire = '224800011'
where SirenProprietaire <> '224800011'
and NumeroRoute = 'D906'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D906',
        array['TRONROUT0000000099540197'],
        array['TRONROUT0000000099540197']
    )
);

-- D976 - Orange / Roquemaure
update Troncon
set SirenProprietaire = '228400016'
where SirenProprietaire <> '228400016'
and NumeroRoute = 'D976'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D976',
        array['TRONROUT0000000038131341'],
        array['TRONROUT0000000038131340']
    )
);

-- D979 - Barjac / Vagnas
update Troncon
set SirenProprietaire = '220700017'
where SirenProprietaire <> '220700017'
and NumeroRoute = 'D979'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D979',
        array['TRONROUT0000000005729468'],
        array['TRONROUT0000000005729468']
    )
);

-- D994 - Lamotte-du-Rhône / Pont-Saint-Esprit
update Troncon
set SirenProprietaire = '228400016'
where SirenProprietaire <> '228400016'
and NumeroRoute = 'D994'
and IdIGN in (
    select _IdIGN
    from RechercherTronconsEntreIdIGN(
        'D994',
        array['TRONROUT0000002274914334'],
        array['TRONROUT0000000038087428']
    )
);

-- remise à null pour des tronçons qui ne sont pas "réels"
update Troncon t
set SirenProprietaire = null
where t.IdTroncon not in (select IdTroncon from TronconReel);