-- Dans le fichier _rechercher giratoires.sql, priviligier des critères de recherche des giratoires lâches de sorte à avoir des faux-positifs plutôt que des faux-négatifs.
-- Ensuite, via ce script, supprimer les faux-positifs.
--
-- Syntaxe :
-- delete from TronconGiratoire where IdGiratoire = '<IdGiratoire à supprimer>';
-- delete from Giratoire where IdGiratoire = '<IdGiratoire à supprimer>';

-- D51
delete from TronconGiratoire where IdGiratoire = '4.09361-44.29408';
delete from Giratoire where IdGiratoire = '4.09361-44.29408';

-- D901
delete from TronconGiratoire where IdGiratoire = '4.62529-44.27555';
delete from Giratoire where IdGiratoire = '4.62529-44.27555';

-- D910A
delete from TronconGiratoire where IdGiratoire = '4.00722-44.05681';
delete from Giratoire where IdGiratoire = '4.00722-44.05681';