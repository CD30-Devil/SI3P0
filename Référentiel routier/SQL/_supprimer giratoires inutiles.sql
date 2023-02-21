-- Suppression des giratoires n'ayant pas servi à la construction du référentiel routier.
delete
from Giratoire g
where not exists (
    select IdGiratoire
    from Troncon t
    where t.IdGiratoire = g.IdGiratoire
);