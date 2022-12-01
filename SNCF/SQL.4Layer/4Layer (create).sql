-- schémas spécifiques SI3P0 (tmp = temporaire, m = modèle, f = fonctions)
set search_path to tmp, m, f, public;

create view LigneSNCF_4Layer as
select
    l.CodeLigneSNCF as "CodeLigne",
    l.Libelle as "LibelleLigne",
    pl.PKD as "PKDebut",
    pl.PKF as "PKFin",
    pl.Statut as "StatutLigne",
    pl.Geom
from PortionLigneSNCF pl
inner join LigneSNCF l on pl.CodeLigneSNCF = l.CodeLigneSNCF;

create view LigneSNCF_4SHP as
select
    "CodeLigne" as "CodLig",
    "LibelleLigne" as "LibLig",
    "PKDebut",
    "PKFin",
    "StatutLigne" as "StatutLig",
    Geom
from LigneSNCF_4Layer;

create view PN_4Layer as
select
    pn.Libelle as "LibellePN",
    c.Description as "ClassePN",
    pn.PK as "PK",
    l.CodeLigneSNCF as "CodeLigne",
    l.Libelle as "LibelleLigne",
    pl.Statut as "StatutLigne",
    pn.Geom
from PN pn
left join PortionLigneSNCF pl on pn.CodeLigneSNCF = pl.CodeLigneSNCF and pn.PK between pl.PKD and pl.PKF
left join LigneSNCF l on pn.CodeLigneSNCF = l.CodeLigneSNCF
left join ClassePN c on pn.NumClassePN = c.NumClassePN;

create view PN_4SHP as
select
    "LibellePN" as "LibPN",
    "ClassePN",
    "PK",
    "CodeLigne" as "CodLig",
    "LibelleLigne" as "LibLig",
    "StatutLigne" as "StatutLig",
    Geom
from PN_4Layer;

create view PNSurRD_4Layer as
select
    pn.Libelle as "LibellePN",
    c.Description as "ClassePN",
    pn.PK as "PK",
    l.CodeLigneSNCF as "CodeLigne",
    l.Libelle as "LibelleLigne",
    pl.Statut as "StatutLigne",
    pra._NumeroRoute as "RD",
    PRAEnTexte(pra._PRA) as "PRAbs",
    pn.Geom
from PN pn
left join PortionLigneSNCF pl on pn.CodeLigneSNCF = pl.CodeLigneSNCF and pn.PK between pl.PKD and pl.PKF
left join LigneSNCF l on pn.CodeLigneSNCF = l.CodeLigneSNCF
left join ClassePN c on pn.NumClassePN = c.NumClassePN
inner join PointVersPRA(pn.Geom, 10) pra on true;

create view PNSurRD_4SHP as
select
    "LibellePN" as "LibPN",
    "ClassePN",
    "PK",
    "CodeLigne" as "CodLig",
    "LibelleLigne" as "LibLig",
    "StatutLigne" as "StatutLig",
    "RD",
    "PRAbs",
    Geom
from PNSurRD_4Layer;