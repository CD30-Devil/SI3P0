/*==============================================================*/
/* Nom de SGBD :  PostgreSQL SI3P0                              */
/* Date de création :  24/03/2021 10:36:57                      */
/*==============================================================*/


-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;


/*==============================================================*/
/* Table : qpv                                                  */
/*==============================================================*/
create table qpv (
   codeqpv              VARCHAR              not null,
   nom                  VARCHAR              null,
   constraint pkqpv primary key (codeqpv)
);

select AddGeometryColumn('qpv', 'geom', 2154, 'MULTIPOLYGON', 2);
create index qpv_geom_idx on qpv using gist (geom);

/*==============================================================*/
/* Index : qpv_pk                                               */
/*==============================================================*/
create unique index qpv_pk on qpv (
codeqpv
);

/*==============================================================*/
/* Table : qpv_commune                                          */
/*==============================================================*/
create table qpv_commune (
   codeqpv              VARCHAR              not null,
   cogcommune           VARCHAR              not null,
   constraint pkqpv_commune primary key (codeqpv, cogcommune)
);

/*==============================================================*/
/* Index : qpv_commune_pk                                       */
/*==============================================================*/
create unique index qpv_commune_pk on qpv_commune (
codeqpv,
cogcommune
);

/*==============================================================*/
/* Index : commune_qpv_fk                                       */
/*==============================================================*/
create  index commune_qpv_fk on qpv_commune (
codeqpv
);

/*==============================================================*/
/* Index : qpv_commune_fk                                       */
/*==============================================================*/
create  index qpv_commune_fk on qpv_commune (
cogcommune
);

alter table qpv_commune
   add constraint fk_commune_qpv foreign key (codeqpv)
      references qpv (codeqpv)
      on delete restrict on update restrict;

