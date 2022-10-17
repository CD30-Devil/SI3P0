/*==============================================================*/
/* Nom de SGBD :  PostgreSQL SI3P0                              */
/* Date de création :  31/01/2022 09:24:11                      */
/*==============================================================*/


-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;


/*==============================================================*/
/* Table : canton                                               */
/*==============================================================*/
create table canton (
   cogcanton            VARCHAR              not null,
   nom                  VARCHAR              null,
   constraint pkcanton primary key (cogcanton)
);

select AddGeometryColumn('canton', 'geom', 2154, 'MULTIPOLYGON', 2);
create index canton_geom on canton using gist (geom);

/*==============================================================*/
/* Index : canton_pk                                            */
/*==============================================================*/
create unique index canton_pk on canton (
cogcanton
);

/*==============================================================*/
/* Table : commune                                              */
/*==============================================================*/
create table commune (
   cogcommune           VARCHAR              not null,
   siren                VARCHAR              null,
   cogdepartement       VARCHAR              null,
   sirenepci            VARCHAR              null,
   nom                  VARCHAR              null,
   codepostal           VARCHAR              null,
   population           INT4                 null,
   zonemontagne         BOOL                 null,
   constraint pkcommune primary key (cogcommune)
);

select AddGeometryColumn('commune', 'geom', 2154, 'MULTIPOLYGON', 2);
create index commune_geom_idx on commune using gist (geom);

/*==============================================================*/
/* Index : commune_pk                                           */
/*==============================================================*/
create unique index commune_pk on commune (
cogcommune
);

/*==============================================================*/
/* Index : commune_departement_fk                               */
/*==============================================================*/
create  index commune_departement_fk on commune (
cogdepartement
);

/*==============================================================*/
/* Index : commune_epcifederative_fk                            */
/*==============================================================*/
create  index commune_epcifederative_fk on commune (
sirenepci
);

/*==============================================================*/
/* Index : commune_unitelegale_fk                               */
/*==============================================================*/
create  index commune_unitelegale_fk on commune (
siren
);

/*==============================================================*/
/* Table : commune_canton                                       */
/*==============================================================*/
create table commune_canton (
   cogcommune           VARCHAR              not null,
   cogcanton            VARCHAR              not null,
   cheflieu             BOOL                 null,
   constraint pkcommune_canton primary key (cogcommune, cogcanton)
);

/*==============================================================*/
/* Index : commune_canton_pk                                    */
/*==============================================================*/
create unique index commune_canton_pk on commune_canton (
cogcommune,
cogcanton
);

/*==============================================================*/
/* Index : canton_commune_fk                                    */
/*==============================================================*/
create  index canton_commune_fk on commune_canton (
cogcommune
);

/*==============================================================*/
/* Index : commune_canton_fk                                    */
/*==============================================================*/
create  index commune_canton_fk on commune_canton (
cogcanton
);

/*==============================================================*/
/* Table : departement                                          */
/*==============================================================*/
create table departement (
   cogdepartement       VARCHAR              not null,
   siren                VARCHAR              null,
   cogregion            VARCHAR              null,
   nom                  VARCHAR              null,
   constraint pkdepartement primary key (cogdepartement)
);

select AddGeometryColumn('departement', 'geom', 2154, 'MULTIPOLYGON', 2);
create index departement_geom_idx on departement using gist (geom);

/*==============================================================*/
/* Index : departement_pk                                       */
/*==============================================================*/
create unique index departement_pk on departement (
cogdepartement
);

/*==============================================================*/
/* Index : departement_region_fk                                */
/*==============================================================*/
create  index departement_region_fk on departement (
cogregion
);

/*==============================================================*/
/* Index : departement_unitelegale_fk                           */
/*==============================================================*/
create  index departement_unitelegale_fk on departement (
siren
);

/*==============================================================*/
/* Table : epcifederative                                       */
/*==============================================================*/
create table epcifederative (
   siren                VARCHAR              not null,
   nom                  VARCHAR              null,
   nature               VARCHAR              null,
   constraint pkepcifederative primary key (siren)
);

select AddGeometryColumn('epcifederative', 'geom', 2154, 'MULTIPOLYGON', 2);
create index epcifederative_geom_idx on epcifederative using gist (geom);

/*==============================================================*/
/* Index : epcifederative_pk                                    */
/*==============================================================*/
create unique index epcifederative_pk on epcifederative (
siren
);

/*==============================================================*/
/* Table : region                                               */
/*==============================================================*/
create table region (
   cogregion            VARCHAR              not null,
   siren                VARCHAR              null,
   nom                  VARCHAR              null,
   constraint pkregion primary key (cogregion)
);

select AddGeometryColumn('region', 'geom', 2154, 'MULTIPOLYGON', 2);
create index region_geom_idx on region using gist (geom);

/*==============================================================*/
/* Index : region_pk                                            */
/*==============================================================*/
create unique index region_pk on region (
cogregion
);

/*==============================================================*/
/* Index : region_unitelegale_fk                                */
/*==============================================================*/
create  index region_unitelegale_fk on region (
siren
);

alter table commune
   add constraint fk_commune_departement foreign key (cogdepartement)
      references departement (cogdepartement)
      on delete restrict on update restrict;

alter table commune
   add constraint fk_commune_epcifederative foreign key (sirenepci)
      references epcifederative (siren)
      on delete restrict on update restrict;

alter table commune_canton
   add constraint fk_canton_commune foreign key (cogcommune)
      references commune (cogcommune)
      on delete restrict on update restrict;

alter table commune_canton
   add constraint fk_commune_canton foreign key (cogcanton)
      references canton (cogcanton)
      on delete restrict on update restrict;

alter table departement
   add constraint fk_departement_region foreign key (cogregion)
      references region (cogregion)
      on delete restrict on update restrict;

