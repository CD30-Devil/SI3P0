/*==============================================================*/
/* Nom de SGBD :  PostgreSQL SI3P0                              */
/* Date de création :  13/01/2021 15:34:23                      */
/*==============================================================*/


/*==============================================================*/
/* Table : adresse                                              */
/*==============================================================*/
set search_path to m, public;
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

select AddGeometryColumn('m', 'adresse', 'geom', 2154, 'POINT', 2);
create index adresse_geom on m.adresse using gist (geom);

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

