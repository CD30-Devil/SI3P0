-- schémas spécifiques SI3P0 (m = modèle, tmp = temporaire)
set search_path to m, tmp, public;

start transaction;

set constraints all deferred;

delete from EtablissementSirene;
delete from UniteLegale;

insert into UniteLegale (
    Siren,
    Sigle,
    Denomination,
    DenominationUsuelle,
    Nom,
    Prenom,
    CategorieJuridique,
    ActivitePrincipale,
    Nomemclature,
    Employeur,
    TrancheEffectifs,
    EconomieSocialeSolidaire,
    EtatAdministratif,
    DateDernierTraitement
)
select
    siren,
    sigleunitelegale,
    denominationunitelegale,
    coalesce(denominationusuelle1unitelegale, denominationusuelle2unitelegale, denominationusuelle3unitelegale),
    nomusageunitelegale,
    concat_ws(', ', prenom1unitelegale, prenom2unitelegale, prenom3unitelegale, prenom4unitelegale),
    categoriejuridiqueunitelegale,
    activiteprincipaleunitelegale,
    nomenclatureactiviteprincipaleunitelegale,
    (caractereemployeurunitelegale is not null and caractereemployeurunitelegale = 'O'),
    trancheeffectifsunitelegale,
    (economiesocialesolidaireunitelegale is not null and economiesocialesolidaireunitelegale = 'O'),
    etatadministratifunitelegale,
    case
        when datederniertraitementunitelegale ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' then to_date(datederniertraitementunitelegale, 'YYYY-MM-DD')::date
        else null::date
    end
from source_unitelegale;

insert into EtablissementSirene (
    Siret,
    Siren,
    Nic,
    COGCommune,
    Siege,
    DenominationUsuelle,
    ActivitePrincipale,
    Nomenclature,
    Employeur,
    TrancheEffectifs,
    EtatAdministratif,
    DateDernierTraitement
)
select
    siret,
    ul.Siren,
    nic,
    coalesce(codecommuneetablissement, codecommune2etablissement),
    (etablissementsiege is not null and etablissementsiege = 'true'),
    denominationusuelleetablissement,
    activiteprincipaleetablissement,
    nomenclatureactiviteprincipaleetablissement,
    (caractereemployeuretablissement is not null and caractereemployeuretablissement = 'O'),
    trancheeffectifsetablissement,
    etatadministratifetablissement,
    case
        when datederniertraitementetablissement ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' then to_date(datederniertraitementetablissement, 'YYYY-MM-DD')::date
        else null::date
    end
from tmp.source_etablissementsirene se
left join UniteLegale ul on ul.Siren = se.siren
where substring(coalesce(codecommuneetablissement, codecommune2etablissement) for 2) in (
    '07', -- Ardèche
    '12', -- Aveyron
    '13', -- Bouches-du-Rhône
    '26', -- Drôme
    '30', -- Gard
    '34', -- Hérault
    '48', -- Lozère
    '84' -- Vaucluse
);

commit;