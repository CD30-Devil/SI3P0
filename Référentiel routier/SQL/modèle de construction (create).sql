-- Cette table, utile pendant la phase de construction, permet le stockage des tronçons qui participent à un giratoire.
-- Elle peut être supprimée en fin de la procédure vu que les informations se retrouvent dans les tables Troncon et Giratoire.
create table TronconGiratoire (
    IdGiratoire character varying,
    IdIGN character varying,
    NumeroRoute character varying
);

select AddGeometryColumn('troncongiratoire', 'geom', 2154, 'LINESTRING', 3);

create unique index TronconGiratoire_IdIGN on TronconGiratoire (IdIGN);