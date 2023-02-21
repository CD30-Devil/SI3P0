-- Recalage des points de repères de début aux extrémités des routes départementales.
-- Cette fonction n'est pas en mesure de recaler les PR de début des routes qui démarrent par un cycle (ilot).
-- Elle peut aussi retourner de faux PR pour les petites routes types bretelles au regard du rayon de recherche.
-- Enfin, il est parfois souhaitable de ne pas mettre le PR aux estrémités lorsqu'une route débute au croisement avec une double voie.
--
-- De fait, la fonction ne peuple pas directement la table PR mais retourne le code SQL des requêtes d'insertion.
-- Il convient de vérifier/corriger manuellement le résultat obtenu.

select * from RecalerPRDeb(
    25 -- TODO : Adapter le rayon de recherche d'une extrémité de route autour du premier PR en fonction de la qualité des données d'entrée.
);