-- NDLR :
-- La BDTopo propose depuis la version 3.0 la valeur "Rond-point" pour l'attribut "nature" des tronçons.
-- L'algortihme de recherche ne se base pas sur cette valeur d'attribut ce qui permet d'identifier d'éventuelles erreurs dans la BDTopo.
-- Le résultat de la recherche est comparé à la BDTopo grâce à deux requêtes présentes dans le fichier _calculer statistiques et détecter erreurs.sql.
--
-- TODO :
-- Pour la recherche des giratoires, priviligier des critères lâches de sorte à avoir des faux-positifs plutôt que des faux-négatifs.
-- Ensuite, via le script _corriger giratoires.sql, supprimer les faux-positifs.

select * from RechercherGiratoires(
    150, -- TODO : Fixer la longueur maximale en mètres d'un troncon pouvant participer à un giratoire.
    90, -- TODO : Fixer l'angle minimal en degrés formé par un troncon de giratoire et son précédent/suivant.
    200 -- TODO : Fixer l'angle maximal en degrés formé par un troncon de giratoire et son précédent/suivant. Un angle plus grand peut permettre de rattraper des approximations de numérisation et de retrouver les giratoires en forme de 8.
);