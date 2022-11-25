/*==============================================================*/
/* Nom de SGBD :  PostgreSQL SI3P0                              */
/* Date de création :  16/08/2022 14:13:34                      */
/*==============================================================*/


-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;


/*==============================================================*/
/* Table : relevehydro                                          */
/*==============================================================*/
create table relevehydro (
   codestationhydro     VARCHAR              not null,
   date                 TIMESTAMP WITH TIME ZONE not null,
   hauteur              NUMERIC              null,
   debit                NUMERIC              null,
   constraint pkrelevehydro primary key (codestationhydro, date)
);

/*==============================================================*/
/* Index : relevehydro_pk                                       */
/*==============================================================*/
create unique index relevehydro_pk on relevehydro (
codestationhydro,
date
);

/*==============================================================*/
/* Index : relevehydro_stationhydro_fk                          */
/*==============================================================*/
create  index relevehydro_stationhydro_fk on relevehydro (
codestationhydro
);

/*==============================================================*/
/* Table : stationhydro                                         */
/*==============================================================*/
create table stationhydro (
   codestationhydro     VARCHAR              not null,
   codetronconhydro     VARCHAR              null,
   libelle              VARCHAR              null,
   constraint pkstationhydro primary key (codestationhydro)
);

select AddGeometryColumn('stationhydro', 'geom', 2154, 'POINT', 2);
create index stationhydro_geom_idx on stationhydro using gist (geom);

/*==============================================================*/
/* Index : stationhydro_pk                                      */
/*==============================================================*/
create unique index stationhydro_pk on stationhydro (
codestationhydro
);

/*==============================================================*/
/* Index : stationhydro_tronconhydro_fk                         */
/*==============================================================*/
create  index stationhydro_tronconhydro_fk on stationhydro (
codetronconhydro
);

/*==============================================================*/
/* Table : tronconhydro                                         */
/*==============================================================*/
create table tronconhydro (
   codetronconhydro     VARCHAR              not null,
   codevigilancehydro   INT4                 null,
   libelle              VARCHAR              null,
   constraint pktronconhydro primary key (codetronconhydro)
);

/*==============================================================*/
/* Index : tronconhydro_pk                                      */
/*==============================================================*/
create unique index tronconhydro_pk on tronconhydro (
codetronconhydro
);

/*==============================================================*/
/* Index : tronconhydro_vigilancehydro_fk                       */
/*==============================================================*/
create  index tronconhydro_vigilancehydro_fk on tronconhydro (
codevigilancehydro
);

/*==============================================================*/
/* Table : vigilancehydro                                       */
/*==============================================================*/
create table vigilancehydro (
   codevigilancehydro   INT4                 not null,
   libelle              VARCHAR              null,
   constraint pkvigilancehydro primary key (codevigilancehydro)
);

insert into VigilanceHydro (CodeVigilanceHydro, Libelle) values
('1', 'Vert'),
('2', 'Jaune'),
('3', 'Orange'),
('4', 'Rouge');

/*==============================================================*/
/* Index : vigilancehydro_pk                                    */
/*==============================================================*/
create unique index vigilancehydro_pk on vigilancehydro (
codevigilancehydro
);

alter table relevehydro
   add constraint fk_relevehydro_stationhydro foreign key (codestationhydro)
      references stationhydro (codestationhydro)
      on delete restrict on update restrict;

alter table stationhydro
   add constraint fk_stationhydro_tronconhydro foreign key (codetronconhydro)
      references tronconhydro (codetronconhydro)
      on delete restrict on update restrict;

alter table tronconhydro
   add constraint fk_tronconhydro_vigilancehydro foreign key (codevigilancehydro)
      references vigilancehydro (codevigilancehydro)
      on delete restrict on update restrict;

