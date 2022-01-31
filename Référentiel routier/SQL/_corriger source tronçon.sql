-- Rédiger ici les ordres de corrections des tronçons à appliquer à la donnée source préalablement à la construction du référentiel routier.
-- Utiliser pour cela les fonctions de corrections disponibles dans le fichier tmp(.f).correction bdtopo (create).sql.
--
-- Ce script est à adapter au gré des livraisons millésimées de la BDTopo pour :
-- - supprimer les corrections prises en compte par l'IGN,
-- - ajouter les nouvelles corrections (notamment les classements/déclassements).

-- Corrections de la BDTopo version 3.0 en date du 2021-09

-- D152A
select MettreEnGestionCommunale('TRONROUT0000000027839467');
select MettreEnGestionCommunale('TRONROUT0000000027839464');

-- D269
select MettreEnGestionDepartementale('TRONROUT0000000350792744', 'D269', 'Gard'); -- notifier directement par mail à l'IGN qui se charge de faire la modification
select MettreEnGestionDepartementale('TRONROUT0000000211145678', 'D269', 'Gard'); -- notifier directement par mail à l'IGN qui se charge de faire la modification
select MettreEnGestionDepartementale('TRONROUT0000000027819853', 'D269', 'Gard'); -- notifier directement par mail à l'IGN qui se charge de faire la modification
select MettreEnGestionDepartementale('TRONROUT0000000027819842', 'D269', 'Gard'); -- notifier directement par mail à l'IGN qui se charge de faire la modification
select MettreEnGestionDepartementale('TRONROUT0000000211145525', 'D269', 'Gard'); -- notifier directement par mail à l'IGN qui se charge de faire la modification
select MettreEnGestionDepartementale('TRONROUT0000000211145537', 'D269', 'Gard'); -- notifier directement par mail à l'IGN qui se charge de faire la modification

-- D320
select MettreEnGestionCommunale('TRONROUT0000000005735192'); -- contribution directe, transaction 247342, re-modifier après coup par l'IGN Lyon.
select MettreEnGestionCommunale('TRONROUT0000000005735105'); -- contribution directe, transaction 247342, re-modifier après coup par l'IGN Lyon.
select MettreEnGestionCommunale('TRONROUT0000000313094358'); -- contribution directe, transaction 247342, re-modifier après coup par l'IGN Lyon.
select MettreEnGestionCommunale('TRONROUT0000000005735111'); -- contribution directe, transaction 247342, re-modifier après coup par l'IGN Lyon.

-- D39
select ModifierNumeroRoute('TRONROUT0000002272926500', 'D39'); -- contribution directe, transaction 247476

-- D46
select MettreEnGestionDepartementale('TRONROUT0000000044811672', 'D46', 'Gard'); -- contribution directe, transaction 247477

-- D22
-- TODO/Remarque : CP du 4 avril 2019 - délibération N ° 34
-- Déclassement temporaire le temps de la construction de l'établissement scolaire.
-- A NE PAS PRENDRE EN COMPTE DANS LA BDTOPO PAR L'IGN
select MettreEnGestionCommunale('TRONROUT0000000027955652');
select MettreEnGestionCommunale('TRONROUT0000000027955659');
select MettreEnGestionCommunale('TRONROUT0000000027955666');