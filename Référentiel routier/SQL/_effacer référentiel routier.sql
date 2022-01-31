-- Effacement du contenu des tables.
delete from Troncon;
delete from PR;
delete from Giratoire;
delete from Route;

-- Remise à zéro des auto-incréments.
select pg_catalog.setval('pr_idpr_seq', 1, false);
select pg_catalog.setval('troncon_idtroncon_seq', 1, false);