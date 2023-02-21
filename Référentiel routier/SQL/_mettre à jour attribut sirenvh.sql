﻿-- Les conventions de gestion font que le propriétaire d'une section de route n'est pas forcément celui qui en assure la gestion courante ou la viabilité hivernale.
--
-- La construction pré-renseigne le propriétaire avec la valeur définie dans la route numérotée ou nommée.
-- Ce script permet la mise à jour de l'attribut métier "SirenVH" là où c'est nécessaire après construction
--
-- TODO :
-- Adapter ce script de sorte à corriger la valeur de l'attribut "SirenVH" là où c'est nécessaire après construction.
--
-- Syntaxe pour une section de RD :
-- update Troncon
-- set SirenVH = '<Siren>'
-- where SirenVH <> '<Siren>'
-- and NumeroRoute = '<NumeroRoute>'
-- and IdIGN in (
--     select _IdIGN
--     from RechercherTronconsEntreIdIGN(
--         '<NumeroRoute>',
--         array['<Tronçon 1 de début de section>', '<Tronçon 2 de début de section>', ..., '<Tronçon N de début de section>'],
--         array['<Tronçon 1 de fin de section>', '<Tronçon 2 de fin de section>', ..., '<Tronçon N de fin de section>']
--     )
-- );

-- NDLR : cet attribut n'est pas encore utilisé au département du Gard
update Troncon set SirenVH = null;