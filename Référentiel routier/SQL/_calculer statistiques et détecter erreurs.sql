-- Statistiques et détection d'erreurs.

select '***************************************************************************************************';
select 'Statistiques.';
select '***************************************************************************************************';
select '';

select 'Nombre de routes : ' || count(*)
from Route;
select '';

select 'Nombre de routes départementales : ' || count(*)
from Route
where ClasseAdmin = 'Départementale';
select '';

select 'Nombre de points de repères : ' || count(*)
from PR;
select '';

select 'Nombre de giratoires : ' || count(*)
from Giratoire;
select '';

select 'Nombre de giratoires départementaux : ' || count(*)
from Giratoire g
inner join Route r on r.NumeroRoute = g.NumeroRoute
where r.ClasseAdmin = 'Départementale';
select '';

select 'Nombre de km (3D) de routes départementales : ' || round(sum(ST_3DLength(Geom))::numeric / 1000, 2)
from TronconReel;
select '';

select 'Nombre de km (3D) de routes départementales par niveau :';
select Niveau, round(sum(ST_3DLength(Geom))::numeric / 1000, 2)
from TronconReel
group by Niveau
order by Niveau;
select '';

select 'Nombre de km (3D) de routes à grande circulation : ' || round(sum(ST_3DLength(Geom))::numeric / 1000, 2)
from TronconReel
where RGC;
select '';

select 'Nombre de km (3D) de voies gauches : ' || round(sum(ST_3DLength(Geom))::numeric / 1000, 2)
from TronconReel
where Gauche;
select '';

select 'Nombre de km (3D) de routes départementales par nature de RRIR :';
select RRIR, round(sum(ST_3DLength(Geom))::numeric / 1000, 2)
from TronconReel
where RRIR is not null
group by RRIR
order by RRIR;
select '';

select 'Nombre de tronçons (tous compris) : ' || count(*)
from Troncon;
select '';

select 'Nombre de tronçons fictifs : ' || count(*)
from Troncon
where Fictif;
select '';

select 'Nombre de tronçons réels : ' || count(*)
from TronconReel;
select 'Remarque : La somme des tronçons réels + fictifs est différente du nombre tout compris du fait de la présence de tronçons en doublon lorsque un giratoire est commun à plusieurs routes départementales.';
select '';

select 'Taille min, max, moyenne en mètres des tronçons réels : ' || round(min(ST_3DLength(Geom))::numeric, 2) || ', ' || round(max(ST_3DLength(Geom))::numeric, 2) || ', ' || round(avg(ST_3DLength(Geom))::numeric, 2)
from TronconReel;
select '';

select '***************************************************************************************************';
select 'Détection d''erreurs concernant les giratoires.';
select '***************************************************************************************************';
select '';

select 'Liste des tronçons (NumeroRoute | IdGiratoire | IdIGN) participant à un giratoire mais dont la nature est différente de Rond-point :';
select NumeroRoute, IdGiratoire, IdIGN
from TronconReel
where IdGiratoire is not null
and Nature <> 'Rond-point'
order by NumeroRoute, IdGiratoire, IdIGN;
select 'Remarque : Après vérification de l''exactitude de la détection des giratoires, cette liste est à notifier à l''IGN.';
select '';

select 'Liste des tronçons (NumeroRoute | IdGiratoire | IdIGN) ne participant pas à un giratoire mais dont la nature est égale à Rond-point :';
select NumeroRoute, IdGiratoire, IdIGN
from TronconReel
where IdGiratoire is null
and Nature = 'Rond-point'
order by NumeroRoute, IdGiratoire, IdIGN;
select 'Remarque : Après vérification de l''exactitude de la détection des giratoires, cette liste est à notifier à l''IGN.';
select '';

select '***************************************************************************************************';
select 'Détection d''erreurs concernant les tronçons.';
select '***************************************************************************************************';
select '';

select 'Liste des tronçons (NumeroRoute | IdIGN) présents dans la BDTopo mais absents du référentiel routier construit :';
select NumeroRoute, IdIGN
from BDT2RR_Troncon
where ClasseAdmin = 'Départementale'
except
select NumeroRoute, IdIGN
from Troncon
order by NumeroRoute, IdIGN;
select 'Remarque : Cette liste devrait être vide.';
select '';

select 'Liste des tronçons (NumeroRoute | IdIGN | PrecisionAlti | Longueur 3D | Longueur 2D | Pente ) ayant une pente moyenne incohérente :';
select NumeroRoute, IdIGN, PrecisionAlti, round(ST_3DLength(Geom)::numeric, 2), round(ST_Length(Geom)::numeric, 2), round(CalculerPenteMoyenne(Geom)::numeric, 2) || '%'
from BDT2RR_Troncon
where CalculerPenteMoyenne(Geom) > 50
order by PrecisionAlti asc, CalculerPenteMoyenne(Geom) desc;
select 'Remarque : Cette liste est à notifier à l''IGN.';
select '';

select 'Liste des tronçons (NumeroRoute | IdIGN | Nature) sans sens de circulation :';
select NumeroRoute, IdIGN, Nature
from TronconReel
where SensCirculation is null
order by NumeroRoute, IdIGN;
select 'Remarque : A priori, cet attribut devrait être renseigné pour les routes départementales dans la BDTopo. A notifier à l''IGN.';
select '';

select 'Liste des tronçons ayant deux départs ou arrivées à double-sens :';
select distinct t1.NumeroRoute, t1.IdIGN
from Troncon t1
inner join Troncon t2 on t1.IdTroncon <> t2.IdTroncon and t1.NumeroRoute = t2.NumeroRoute and ST_Equals(ST_EndPoint(t1.Geom), ST_StartPoint(t2.Geom))
inner join Troncon t3 on t1.IdTroncon <> t3.IdTroncon and t1.NumeroRoute = t3.NumeroRoute and ST_Equals(ST_EndPoint(t1.Geom), ST_StartPoint(t3.Geom))
where t1.SensCirculation = 0
and t2.SensCirculation = 0
and t3.SensCirculation = 0
and t2.IdTroncon <> t3.IdTroncon
union
select distinct t1.NumeroRoute, t1.IdIGN
from Troncon t1
inner join Troncon t2 on t1.IdTroncon <> t2.IdTroncon and t1.NumeroRoute = t2.NumeroRoute and ST_Equals(ST_StartPoint(t1.Geom), ST_EndPoint(t2.Geom))
inner join Troncon t3 on t1.IdTroncon <> t3.IdTroncon and t1.NumeroRoute = t3.NumeroRoute and ST_Equals(ST_StartPoint(t1.Geom), ST_EndPoint(t3.Geom))
where t1.SensCirculation = 0
and t2.SensCirculation = 0
and t3.SensCirculation = 0
and t2.IdTroncon <> t3.IdTroncon
order by 1, 2;
select 'Remarque : Une route ne se divise généralement pas en deux branches à double sens. Vérifier manuellement cette liste.';
select '';

select '***************************************************************************************************';
select 'Détection d''erreurs concernant les tronçons fictifs.';
select '***************************************************************************************************';
select '';

select 'Liste des tronçons fictifs ayant plusieurs tronçons réels de la même RD à une des extrémités :';
select tf.NumeroRoute, tf.IdIGN
from Troncon tf
inner join TronconReel tr
on tf.NumeroRoute = tr.NumeroRoute
and (ST_Equals(ST_StartPoint(tf.Geom), ST_StartPoint(tr.Geom)) or ST_Equals(ST_StartPoint(tf.Geom), ST_EndPoint(tr.Geom)))
where tf.Fictif
group by tf.IdTroncon, tf.NumeroRoute, tf.IdIGN
having count(*) > 1
union
select tf.NumeroRoute, tf.IdIGN
from Troncon tf
inner join TronconReel tr on tf.NumeroRoute = tr.NumeroRoute and (ST_Equals(ST_EndPoint(tf.Geom), ST_StartPoint(tr.Geom)) or ST_Equals(ST_EndPoint(tf.Geom), ST_EndPoint(tr.Geom)))
where tf.Fictif
group by tf.IdTroncon, tf.NumeroRoute, tf.IdIGN
having count(*) > 1
order by 1, 2;
select 'Remarque : Vérifier manuellement que ces tronçons fictifs sont correctement définis car il arrive que l''IGN change le sens de numérisation de tronçons.';
select '';

select '***************************************************************************************************';
select 'Détection d''erreurs concernant les PR.';
select '***************************************************************************************************';
select '';

select 'Liste des routes départementales n''ayant pas de PR0 :';
select NumeroRoute
from Route
where ClasseAdmin = 'Départementale'
except
select NumeroRoute
from PR
where PRA = 0
order by NumeroRoute;
select 'Remarque : Vérifier manuellement que ces routes ne commencent effectivement pas par un PR0.';
select '';

select 'Liste des routes départementales ayant plusieurs tronçons à moins d''un mêtre du PR de début :';
select distinct pr.NumeroRoute
from PR pr
inner join Troncon t on t.NumeroRoute = pr.NumeroRoute and ST_DWithin(pr.Geom, t.Geom, 1)
where pr.CumulDist = 0
and t.IdGiratoire is null
group by pr.IdPR, pr.NumeroRoute
having count(IdTroncon) > 1
order by NumeroRoute;
select 'Remarque : Vérifier manuellement que le PR de début est correctement positionné sur ces routes car il arrive que l''IGN change le sens de numérisation de tronçons.';
select '';

select 'Liste des PR (NumeroRoute | PRA 1 | PRA 2) distincts mais géographiquement égaux sur une même route :';
select pr1.NumeroRoute, pr1.PRA, pr2.PRA
from PR pr1
inner join PR pr2 on pr1.NumeroRoute = pr2.NumeroRoute and ST_Equals(pr1.Geom, pr2.Geom) and pr1.IdPR > pr2.IdPR;
select 'Remarque : Cette liste devrait être vide.';
select '';

select 'Liste des PR (NumeroRoute | PRA | Distance) à moins de 2m d''une voie gauche :';
select pr.NumeroRoute, pr.PRA, t.Geom <-> pr.Geom
from PR pr
inner join Troncon t on t.NumeroRoute = pr.NumeroRoute and ST_DWithin(t.Geom, pr.Geom, 2)
where t.Gauche and pr.PRA <> 0
order by 3 desc;
select 'Remarque : La procédure gère uniquement les PR sur voies doubles ou droites. Recaler si besoin ces PR sur la voie de droite correspondante.';
select '';

select 'Liste des couples de PR proches ou au contraire éloignés (NumeroRoute | PRA 1 | PRA 2 | Distance inter PR) :';
select distinct pr1.NumeroRoute, pr1.PRA, pr2.PRA, pr2.CumulDist - pr1.CumulDist
from PR pr1
inner join PR pr2 on pr1.NumeroRoute = pr2.NumeroRoute and pr1.PRA + 10000 = pr2.PRA
where pr2.CumulDist - pr1.CumulDist not between 250 and 2000
order by 1, 2, 3;
select 'Remarque : Vérifier manuellement qu''il n''y a pas d''erreur sur la localisation de ces PR.';
select '';