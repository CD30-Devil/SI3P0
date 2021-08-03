-- TODO requête à revoir lorsque la base SIRENE sera dans le schéma m

create view tmp.SegmentEtatAvancement_4Map as
select
    ea.Description                                                                    as "Etat d'avancement segment ",
    r.Description                                                                     as "Rev&ecirc;tement segment   ",
    s.Description                                                                     as "Statut segment              ",
    sc.AnneeOuverture                                                                 as "Ann&eacute;e d'ouverture segment ",
    sc.SensUnique                                                                     as "Sens unique                       ",
    sc.SourceGeometrie                                                                as "Source de la g&eacute;om&eacute;trie ",
    sc.IdGeometrie                                                                    as "Identifiant de la g&eacute;om&eacute;trie ",
    sc.Fictif                                                                         as "Fictif                                     ",
    string_agg(distinct ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel, ', ') as "Itin&eacute;raire(s)                        ",
    string_agg(distinct pc.Nom, ', ')                                                 as "Portion(s)                                   ",
    string_agg(distinct gest.Denomination, ', ')                                      as "Gestionnaire(s)                               ",
    string_agg(distinct prop.Denomination, ', ')                                      as "Propri&eacute;taire(s)                         ",
    sc.Geom,
    'Segments cyclables par état d''avancement' as NomCouche,
    ea.Description as Legende,
    case ea.CodeEtatAvancement3V
        when 4 then '#60D701'
        when 3 then '#FFDB01'
        when 2 then '#FF6E0B'
        when 1 then '#FD2100'
        else '#FF0000'
    end as Couleur
from m.SegmentCyclable sc
left join m.EtatAvancement3V ea on ea.CodeEtatAvancement3V = sc.CodeEtatAvancement3V
left join m.Revetement3V r on r.CodeRevetement3V = sc.CodeRevetement3V
left join m.Statut3V s on s.CodeStatut3V = sc.CodeStatut3V
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join m.TypePortionCyclable tpc on tpc.CodeTypePortionCyclable = pc.CodeTypePortionCyclable
left join m.PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
left join m.ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable
left join m.SegmentCyclable_Gestionnaire scg on scg.IdsegmentCyclable = sc.IdSegmentCyclable
left join d.Sirene_UniteLegale gest on gest.Siren = scg.Siren
left join m.SegmentCyclable_Proprietaire scp on scp.IdsegmentCyclable = sc.IdSegmentCyclable
left join d.Sirene_UniteLegale prop on prop.Siren = scp.Siren
group by
    ea.CodeEtatAvancement3V, ea.Description, r.CodeRevetement3V, r.Description, s.CodeStatut3V, s.Description, sc.AnneeOuverture, sc.SensUnique, sc.SourceGeometrie, sc.IdGeometrie, sc.DateSource, sc.Fictif, sc.Geom
order by ea.CodeEtatAvancement3V;

create view tmp.SegmentStatut_4Map as
select
    ea.Description                                                                    as "Etat d'avancement segment ",
    r.Description                                                                     as "Rev&ecirc;tement segment   ",
    s.Description                                                                     as "Statut segment              ",
    sc.AnneeOuverture                                                                 as "Ann&eacute;e d'ouverture segment ",
    sc.SensUnique                                                                     as "Sens unique                       ",
    sc.SourceGeometrie                                                                as "Source de la g&eacute;om&eacute;trie ",
    sc.IdGeometrie                                                                    as "Identifiant de la g&eacute;om&eacute;trie ",
    sc.Fictif                                                                         as "Fictif                                     ",
    string_agg(distinct ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel, ', ') as "Itin&eacute;raire(s)                        ",
    string_agg(distinct pc.Nom, ', ')                                                 as "Portion(s)                                   ",
    string_agg(distinct gest.Denomination, ', ')                                      as "Gestionnaire(s)                               ",
    string_agg(distinct prop.Denomination, ', ')                                      as "Propri&eacute;taire(s)                         ",
    sc.Geom,
    'Segments cyclables par statut' as NomCouche,
    s.Description as Legende,
    case s.CodeStatut3V
        when 'VV' then '#18CF3C'
        when 'PCY' then '#B0D517'
        when 'ASP' then '#C5EF16'
        when 'RTE' then '#FE642E'
        when 'BCY' then '#FEE52E'
        when 'ICA' then '#16EFC8'
        else '#FF0000'
    end as Couleur
from m.SegmentCyclable sc
left join m.EtatAvancement3V ea on ea.CodeEtatAvancement3V = sc.CodeEtatAvancement3V
left join m.Revetement3V r on r.CodeRevetement3V = sc.CodeRevetement3V
left join m.Statut3V s on s.CodeStatut3V = sc.CodeStatut3V
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join m.TypePortionCyclable tpc on tpc.CodeTypePortionCyclable = pc.CodeTypePortionCyclable
left join m.PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
left join m.ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable
left join m.SegmentCyclable_Gestionnaire scg on scg.IdsegmentCyclable = sc.IdSegmentCyclable
left join d.Sirene_UniteLegale gest on gest.Siren = scg.Siren
left join m.SegmentCyclable_Proprietaire scp on scp.IdsegmentCyclable = sc.IdSegmentCyclable
left join d.Sirene_UniteLegale prop on prop.Siren = scp.Siren
group by
    ea.CodeEtatAvancement3V, ea.Description, r.CodeRevetement3V, r.Description, s.CodeStatut3V, s.Description, sc.AnneeOuverture, sc.SensUnique, sc.SourceGeometrie, sc.IdGeometrie, sc.DateSource, sc.Fictif, sc.Geom
order by s.CodeStatut3V;

create view tmp.VVVInventaireD30Agrege_4Map as
with SegmentOuvertD30 as (
    select distinct sc.*
    from m.SegmentCyclable sc
    inner join m.SegmentCyclable_Proprietaire sp on sp.Siren = '223000019' and sc.IdSegmentCyclable = sp.IdSegmentCyclable
    where sc.CodeEtatAvancement3V = 4
),
SegmentACompter as (
    select *
    from SegmentOuvertD30
    where CodeStatut3V <> 'RTE'
    and (AnneeOuverture is null or AnneeOuverture < extract(year from current_date))
    union
    select *
    from SegmentOuvertD30
    where CodeStatut3V = 'RTE'
    and (AnneeOuverture is null or AnneeOuverture < extract(year from current_date))
    and IdGeometrie not in (select IdIGN from m.Troncon)
)
select
    r.Description                                                                               as "Rev&ecirc;tement segments ",
    s.Description                                                                               as "Statut segments            ",
    round(ST_Length(ST_CollectionExtract(unnest(ST_ClusterWithin(sc.Geom, 1)), 2))::numeric, 2) as "Longueur segments           ",
    ST_CollectionExtract(unnest(ST_ClusterWithin(sc.Geom, 1)), 2) as Geom,
    'Inventaire agrégé' as NomCouche,
    s.Description as Legende,
    case s.CodeStatut3V
        when 'VV' then '#18CF3C'
        when 'PCY' then '#B0D517'
        when 'ASP' then '#C5EF16'
        when 'RTE' then '#FE642E'
        when 'BCY' then '#FEE52E'
        when 'ICA' then '#16EFC8'
        else '#FF0000'
    end as Couleur
from SegmentACompter sc
left join m.Revetement3V r on r.CodeRevetement3V = sc.CodeRevetement3V
left join m.Statut3V s on s.CodeStatut3V = sc.CodeStatut3V
group by r.Description, s.CodeStatut3V, s.Description
order by Legende;

create view tmp.VVVInventaireD30Detail_4Map as
with SegmentOuvertD30 as (
    select distinct sc.*
    from m.SegmentCyclable sc
    inner join m.SegmentCyclable_Proprietaire sp on sp.Siren = '223000019' and sc.IdSegmentCyclable = sp.IdSegmentCyclable
    where sc.CodeEtatAvancement3V = 4
),
SegmentACompter as (
    select *
    from SegmentOuvertD30
    where CodeStatut3V <> 'RTE'
    and (AnneeOuverture is null or AnneeOuverture < extract(year from current_date))
    union
    select *
    from SegmentOuvertD30
    where CodeStatut3V = 'RTE'
    and (AnneeOuverture is null or AnneeOuverture < extract(year from current_date))
    and IdGeometrie not in (select IdIGN from m.Troncon)
)
select
    ea.Description                                                                    as "Etat d'avancement segment ",
    r.Description                                                                     as "Rev&ecirc;tement segment   ",
    s.Description                                                                     as "Statut segment              ",
    sc.AnneeOuverture                                                                 as "Ann&eacute;e d'ouverture segment ",
    sc.SensUnique                                                                     as "Sens unique                       ",
    sc.SourceGeometrie                                                                as "Source de la g&eacute;om&eacute;trie ",
    sc.IdGeometrie                                                                    as "Identifiant de la g&eacute;om&eacute;trie ",
    sc.Fictif                                                                         as "Fictif                                     ",
    round(ST_Length(sc.Geom)::numeric, 2)                                             as "Longueur                                    ",
    string_agg(distinct ic.NumeroItineraireCyclable || ' - ' || ic.NomOfficiel, ', ') as "Itin&eacute;raire(s)                         ",
    string_agg(distinct pc.Nom, ', ')                                                 as "Portion(s)                                    ",
    string_agg(distinct gest.Denomination, ', ')                                      as "Gestionnaire(s)                                ",
    string_agg(distinct prop.Denomination, ', ')                                      as "Propri&eacute;taire(s)                          ",
    sc.Geom,
    'Inventaire détaillé' as NomCouche,
    s.Description as Legende,
    case s.CodeStatut3V
        when 'VV' then '#18CF3C'
        when 'PCY' then '#B0D517'
        when 'ASP' then '#C5EF16'
        when 'RTE' then '#FE642E'
        when 'BCY' then '#FEE52E'
        when 'ICA' then '#16EFC8'
        else '#FF0000'
    end as Couleur
from SegmentACompter sc
left join m.EtatAvancement3V ea on ea.CodeEtatAvancement3V = sc.CodeEtatAvancement3V
left join m.Revetement3V r on r.CodeRevetement3V = sc.CodeRevetement3V
left join m.Statut3V s on s.CodeStatut3V = sc.CodeStatut3V
left join m.SegmentCyclable_PortionCyclable sp on sp.IdSegmentCyclable = sc.IdSegmentCyclable
left join m.PortionCyclable pc on pc.IdPortionCyclable = sp.IdPortionCyclable
left join m.TypePortionCyclable tpc on tpc.CodeTypePortionCyclable = pc.CodeTypePortionCyclable
left join m.PortionCyclable_ItineraireCyclable pi on pi.IdPortionCyclable = pc.IdPortionCyclable
left join m.ItineraireCyclable ic on ic.NumeroItineraireCyclable = pi.NumeroItineraireCyclable
left join m.SegmentCyclable_Gestionnaire scg on scg.IdsegmentCyclable = sc.IdSegmentCyclable
left join d.Sirene_UniteLegale gest on gest.Siren = scg.Siren
left join m.SegmentCyclable_Proprietaire scp on scp.IdsegmentCyclable = sc.IdSegmentCyclable
left join d.Sirene_UniteLegale prop on prop.Siren = scp.Siren
group by
    ea.CodeEtatAvancement3V, ea.Description, r.CodeRevetement3V, r.Description, s.CodeStatut3V, s.Description, sc.AnneeOuverture, sc.SensUnique, sc.SourceGeometrie, sc.IdGeometrie, sc.DateSource, sc.Fictif, sc.Geom
order by Legende;