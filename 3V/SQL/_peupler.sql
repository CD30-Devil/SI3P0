start transaction;

set constraints all deferred;

delete from m.SegmentCyclable_Gestionnaire;
delete from m.SegmentCyclable_Proprietaire;
delete from m.PortionCyclable_ItineraireCyclable;
delete from m.SegmentCyclable_PortionCyclable;
delete from m.ItineraireCyclable;
delete from m.PortionCyclable;
delete from m.SegmentCyclable;
delete from m.PRCyclable;

select pg_catalog.setval('m.portioncyclable_idportioncyclable_seq', 1, false);
select pg_catalog.setval('m.segmentcyclable_idsegmentcyclable_seq', 1, false);
select pg_catalog.setval('m.prcyclable_idprcyclable_seq', 1, false);

-- insertion des itinéraires cyclables
insert into m.ItineraireCyclable (NumeroItineraireCyclable, NomOfficiel, NomUsage, Depart, Arrivee, EstInscrit, NiveauSchema, AnneeInscription, SiteWeb, AnneeOuverture)
select distinct
    NumeroItineraireCyclable,
    NomOfficiel,
    NomUsage,
    (select string_agg(Nom, ', ') from m.Commune where COGCommune = any(regexp_split_to_array(Depart, '[^0-9]+'))),
    (select string_agg(Nom, ', ') from m.Commune where COGCommune = any(regexp_split_to_array(Arrivee, '[^0-9]+'))),
    case EstInscrit when 'oui' then true when 'non' then false else null end,
    NiveauSchema,
    case when AnneeInscription ~ '^[0-9]{4}$' then AnneeInscription::integer else null end,
    SiteWeb,
    case when AnneeOuverture ~ '^[0-9]{4}$' then AnneeOuverture::integer else null end
from tmp.ItineraireCyclable;

-- insertion des portions cyclables
insert into m.PortionCyclable (CodeTypePortionCyclable, Nom, Description)
select distinct
    case Type
        when 'ETP - Etape' then 'ETP'
        when 'VAR - Variante' then 'VAR'
        when 'PRV - Portion provisoire' then 'PRV'
        when 'OBS - Portion observée' then 'OBS'
        else null
    end,
    Nom,
    Description
from tmp.PortionCyclable
order by Nom;

-- ajout du lien portion <-> itinéraire
insert into m.PortionCyclable_ItineraireCyclable (IdPortionCyclable, NumeroItineraireCyclable, Ordre)
select distinct
    pc.IdPortionCyclable,
    ic.NumeroItineraireCyclable,
    case when tpc.Ordre ~ '^[0-9]+$' then tpc.Ordre::integer else null end
from m.PortionCyclable pc
inner join tmp.PortionCyclable tpc on (pc.CodeTypePortionCyclable is null or tpc.Type like pc.CodeTypePortionCyclable || '%') and tpc.Nom = pc.Nom and tpc.Description = pc.Description
inner join m.ItineraireCyclable ic on ic.NumeroItineraireCyclable = tpc.NumeroItineraireCyclable;

-- insertion des segments cyclables
with RechercheGeom as (
    select distinct
        tsc.SourceGeometrie,
        tsc.IdGeometrie,
        case
            when tsc.SourceGeometrie = 'bdtopo.troncon_de_route' and tdr.Sens_De_Circulation = 'Sens inverse' then ST_Reverse(tdr.Geometrie)
            when tsc.SourceGeometrie = 'bdtopo.troncon_de_route' then tdr.Geometrie
            when tsc.SourceGeometrie = 'bdtopo.troncon_de_voie_ferree' then tdvf.Geometrie
            when tsc.SourceGeometrie = 'complement3v' then ST_Force3D(comp.Geom)
            else null
        end as Geom
    from tmp.SegmentCyclable tsc
    left join d.bdtopo_troncon_de_route tdr on tsc.SourceGeometrie = 'bdtopo.troncon_de_route' and tsc.IdGeometrie = tdr.CleAbs
    left join d.bdtopo_troncon_de_voie_ferree tdvf on tsc.SourceGeometrie = 'bdtopo.troncon_de_voie_ferree' and tsc.IdGeometrie = tdvf.CleAbs
    left join tmp.complement3v comp on tsc.SourceGeometrie = 'complement3v' and tsc.IdGeometrie = comp.Id
)
insert into m.SegmentCyclable (CodeEtatAvancement3V, CodeRevetement3V, CodeStatut3V, AnneeOuverture, SensUnique, DateSaisie, SourceGeometrie, IdGeometrie, Fictif, Geom)
select distinct
    case tsc.EtatAvancement
        when '01 - Projet' then 1
        when '02 - Tracé arrêté' then 2
        when '03 - Travaux en cours' then 3
        when '04 - Ouvert' then 4
        else null
    end,
    case tsc.Revetement
        when 'LIS - Lisse' then 'LIS'
        when 'RUG - Rugueux' then 'RUG'
        when 'MEU - Meuble' then 'MEU'
        else null
    end,
    case tsc.Statut
        when 'VV - Voie verte' then 'VV'
        when 'PCY - Piste cyclable' then 'PCY'
        when 'ASP - Autre site propre' then 'ASP'
        when 'RTE - Route' then 'RTE'
        when 'BCY - Bande cyclable' then 'BCY'
        when 'ICA - Itinéraire à circulation apaisée' then 'ICA'
        else null
    end,
    case when AnneeOuverture ~ '^[0-9]{4}$' then AnneeOuverture::integer else null end,
    case tsc.SensUnique when 'oui' then true when 'non' then false else null end,
    current_date,
    tsc.SourceGeometrie,
    tsc.IdGeometrie,
    case tsc.Fictif when 'oui' then true when 'non' then false else null end,
    rg.Geom
from tmp.SegmentCyclable tsc
inner join RechercheGeom rg on tsc.SourceGeometrie = rg.SourceGeometrie and tsc.IdGeometrie = rg.IdGeometrie;

update m.SegmentCyclable set PrecisionEstimee = 'Non estimée' where CodeEtatAvancement3V <> 4;
update m.SegmentCyclable set PrecisionEstimee = 'Métrique' where CodeEtatAvancement3V = 4 and SourceGeometrie = 'bdtopo.troncon_de_route';
update m.SegmentCyclable set PrecisionEstimee = 'Décamétrique' where CodeEtatAvancement3V = 4 and SourceGeometrie <> 'bdtopo.troncon_de_route';

-- ajout du lien segment <-> portion
insert into m.SegmentCyclable_PortionCyclable (IdSegmentCyclable, IdPortionCyclable)
select distinct
    sc.IdSegmentCyclable,
    pc.IdPortionCyclable
from m.SegmentCyclable sc
inner join tmp.SegmentCyclable tsc on sc.SourceGeometrie = tsc.SourceGeometrie and sc.IdGeometrie = tsc.IdGeometrie and tsc.EtatAvancement like ('0' || sc.CodeEtatAvancement3V || '%')
inner join m.PortionCyclable pc on pc.Nom = tsc.PortionCyclable;

-- ajustement du sens de numérisation des segments au sens de la portion
with SegmentOrdonneParPortion as (
    select distinct sc.IdSegmentCyclable, pc.IdPortionCyclable, tsc.Ordre::integer, sc.Geom
    from m.SegmentCyclable sc
    inner join m.SegmentCyclable_PortionCyclable sp on sc.IdSegmentCyclable = sp.IdSegmentCyclable
    inner join m.PortionCyclable pc on sp.IdPortionCyclable = pc.IdPortionCyclable
    inner join tmp.SegmentCyclable tsc on sc.SourceGeometrie = tsc.SourceGeometrie and sc.IdGeometrie = tsc.IdGeometrie and tsc.EtatAvancement like ('0' || sc.CodeEtatAvancement3V || '%')
),
CoupleSegments as (
    select prec.IdPortionCyclable, prec.IdSegmentCyclable as IdSegmentCyclablePrec, prec.Geom as GeomPrec, prec.Ordre as OrdrePrec, suiv.IdSegmentCyclable as IdSegmentCyclableSuiv, suiv.Geom as GeomSuiv, suiv.Ordre as OrdreSuiv
    from SegmentOrdonneParPortion prec, SegmentOrdonneParPortion suiv
    where prec.Ordre + 1 = suiv.Ordre
    and prec.IdSegmentCyclable <> suiv.IdSegmentCyclable
    and prec.IdPortionCyclable = suiv.IdPortionCyclable
    and (
        ST_Equals(ST_StartPoint(prec.Geom), ST_StartPoint(suiv.Geom))
        or ST_Equals(ST_StartPoint(prec.Geom), ST_EndPoint(suiv.Geom))
        or ST_Equals(ST_EndPoint(prec.Geom), ST_EndPoint(suiv.Geom))
        or ST_Equals(ST_EndPoint(prec.Geom), ST_StartPoint(suiv.Geom))
    )
),
SegmentARetourner as (
    -- cas 1 : le point de fin du segment précédent n'est pas égal à l'intersection (segment précédent - segment suivant)
    select IdSegmentCyclablePrec as IdSegmentCyclable, ST_Reverse(GeomPrec) as Geom
    from CoupleSegments cs
    where not ST_Equals(ST_Intersection(GeomPrec, GeomSuiv), ST_EndPoint(GeomPrec))

    union

    -- cas 2 : le point de départ du segment suivant n'est pas égal à l'intersection (segment précédent - segment suivant)
    select IdSegmentCyclableSuiv as IdSegmentCyclable, ST_Reverse(GeomSuiv) as Geom
    from CoupleSegments cs
    where not ST_Equals(ST_Intersection(GeomPrec, GeomSuiv), ST_StartPoint(GeomSuiv))
)
update m.SegmentCyclable sc
set Geom = sar.Geom
from (select distinct * from SegmentARetourner) sar
where sc.IdSegmentCyclable = sar.IdSegmentCyclable;

-- ajout des communes traversées dans la description des portions
with PortionCyclableCommune as (
    select distinct pc.IdPortionCyclable, c.Nom
    from m.PortionCyclable pc
    inner join m.SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    inner join m.Commune c on ST_Intersects(sc.Geom, c.Geom)
    order by pc.IdPortionCyclable, c.Nom
),
AjoutDescription as (
    select
        IdPortionCyclable,
        'Commune(s) traversée(s) : ' || (string_agg(Nom, ', ')) as Ajout
    from PortionCyclableCommune
    group by IdPortionCyclable
)
update m.PortionCyclable pc
set Description = case
        when Description is null or trim(both from Description) = ''
        then Ajout
        else concat_ws(' | ', Description, Ajout)
    end
from AjoutDescription ad
where pc.IdPortionCyclable = ad.IdPortionCyclable;

-- ajout de la distance à la description des portions
with DistancesPortionParEtat as (
    select pc.IdPortionCyclable, sc.CodeEtatAvancement3V, round(sum(ST_Length(geom))::numeric / 1000, 2) as Distance
    from m.PortionCyclable pc
    inner join m.SegmentCyclable_PortionCyclable ps on ps.IdPortionCyclable = pc.IdPortionCyclable
    inner join m.SegmentCyclable sc on sc.IdSegmentCyclable = ps.IdSegmentCyclable
    group by pc.IdPortionCyclable, sc.CodeEtatAvancement3V
),
AjoutDescription as (
    select
        p.IdPortionCyclable,
        'Distance : ' || coalesce(sum(total.Distance), 0) || ' km ' ||
        '(Ouvert : ' || coalesce(sum(ouve.Distance), 0) || ' km, ' ||
        'Travaux en cours : ' || coalesce(sum(trvx.Distance), 0) || ' km, ' ||
        'Tracé arrêté : ' || coalesce(sum(tarr.Distance), 0) || ' km, ' ||
        'Projet : ' || coalesce(sum(proj.Distance), 0) || ' km)' as Ajout
    from PortionCyclable p
    left join (select IdPortionCyclable, sum(Distance) as Distance from DistancesPortionParEtat group by IdPortionCyclable) total on total.IdPortionCyclable = p.IdPortionCyclable
    left join DistancesPortionParEtat ouve on ouve.IdPortionCyclable = p.IdPortionCyclable and ouve.CodeEtatAvancement3V = 4
    left join DistancesPortionParEtat trvx on trvx.IdPortionCyclable = p.IdPortionCyclable and trvx.CodeEtatAvancement3V = 3
    left join DistancesPortionParEtat tarr on tarr.IdPortionCyclable = p.IdPortionCyclable and tarr.CodeEtatAvancement3V = 2
    left join DistancesPortionParEtat proj on proj.IdPortionCyclable = p.IdPortionCyclable and proj.CodeEtatAvancement3V = 1
    group by p.IdPortionCyclable
)
update m.PortionCyclable pc
set Description = case
        when Description is null or trim(both from Description) = ''
        then Ajout
        else concat_ws(' | ', Description, Ajout)
    end
from AjoutDescription ad
where pc.IdPortionCyclable = ad.IdPortionCyclable;

-- ajout du lien segment <-> gestionnaire
-- TODO requête à revoir lorsque la base SIRENE sera dans le schéma m
insert into m.SegmentCyclable_Gestionnaire (IdSegmentCyclable, Siren)
select distinct
    sc.IdSegmentCyclable,
    ul.Siren
from m.SegmentCyclable sc
inner join tmp.SegmentCyclable tsc on sc.SourceGeometrie = tsc.SourceGeometrie and sc.IdGeometrie = tsc.IdGeometrie and ((sc.Fictif and tsc.Fictif = 'oui') or (not(sc.Fictif) and tsc.Fictif = 'non'))
inner join d.Sirene_UniteLegale ul on ul.Siren = any(regexp_split_to_array(tsc.Gestionnaires, '[^0-9]+'));

-- ajout du lien segment <-> propriétaire
-- TODO requête à revoir lorsque la base SIRENE sera dans le schéma m
insert into m.SegmentCyclable_Proprietaire (IdSegmentCyclable, Siren)
select distinct
    sc.IdSegmentCyclable,
    ul.Siren
from m.SegmentCyclable sc
inner join tmp.SegmentCyclable tsc on sc.SourceGeometrie = tsc.SourceGeometrie and sc.IdGeometrie = tsc.IdGeometrie and ((sc.Fictif and tsc.Fictif = 'oui') or (not(sc.Fictif) and tsc.Fictif = 'non'))
inner join d.Sirene_UniteLegale ul on ul.Siren = any(regexp_split_to_array(tsc.Proprietaires, '[^0-9]+'));

commit;