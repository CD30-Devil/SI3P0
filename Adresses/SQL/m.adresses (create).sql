/*==============================================================*/
/* Nom de SGBD :  PostgreSQL SI3P0                              */
/* Date de création :  24/03/2021 09:16:26                      */
/*==============================================================*/


-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;


/*==============================================================*/
/* Table : adresse                                              */
/*==============================================================*/
create table adresse (
   idadresse            SERIAL not null,
   cogcommune           VARCHAR              not null,
   numero               INT4                 null,
   repetition           VARCHAR              null,
   nomvoie              VARCHAR              null,
   source               VARCHAR              null,
   idsource             VARCHAR              null,
   constraint pkadresse primary key (idadresse)
);

select AddGeometryColumn('adresse', 'geom', 2154, 'POINT', 2);
create index adresse_geom_idx on adresse using gist (geom);

/*==============================================================*/
/* Index : adresse_pk                                           */
/*==============================================================*/
create unique index adresse_pk on adresse (
idadresse
);

/*==============================================================*/
/* Index : adresse_commune_fk                                   */
/*==============================================================*/
create  index adresse_commune_fk on adresse (
cogcommune
);

/*==============================================================*/
/* Index : adresse_repetition_idx                               */
/*==============================================================*/
create  index adresse_repetition_idx on adresse (
repetition
);

