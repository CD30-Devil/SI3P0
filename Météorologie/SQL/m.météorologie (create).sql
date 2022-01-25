/*==============================================================*/
/* Nom de SGBD :  PostgreSQL SI3P0                              */
/* Date de création :  24/01/2022 17:38:55                      */
/*==============================================================*/


-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;


/*==============================================================*/
/* Table : relevemeteo                                          */
/*==============================================================*/
create table relevemeteo (
   source               VARCHAR              not null,
   idsource             VARCHAR              not null,
   datereleve           TIMESTAMP WITH TIME ZONE not null,
   temperature          DECIMAL              null,
   pression             DECIMAL              null,
   humidite             INT4                 null,
   pointrosee           DECIMAL              null,
   ventmoyen            DECIMAL              null,
   ventrafales          DECIMAL              null,
   directionvent        INT4                 null,
   pluie1h              INT4                 null,
   constraint pkrelevemeteo primary key (source, idsource, datereleve)
);

/*==============================================================*/
/* Index : relevemeteo_pk                                       */
/*==============================================================*/
create unique index relevemeteo_pk on relevemeteo (
source,
idsource,
datereleve
);

/*==============================================================*/
/* Index : relevemeteo_stationmeteo_fk                          */
/*==============================================================*/
create  index relevemeteo_stationmeteo_fk on relevemeteo (
source,
idsource
);

/*==============================================================*/
/* Table : stationmeteo                                         */
/*==============================================================*/
create table stationmeteo (
   source               VARCHAR              not null,
   idsource             VARCHAR              not null,
   nom                  VARCHAR              null,
   constraint pkstationmeteo primary key (source, idsource)
);

select AddGeometryColumn('stationmeteo', 'geom', 2154, 'POINT', 2);
create index stationmeteo_geom_idx on stationmeteo using gist (geom);

/*==============================================================*/
/* Index : stationmeteo_pk                                      */
/*==============================================================*/
create unique index stationmeteo_pk on stationmeteo (
source,
idsource
);

alter table relevemeteo
   add constraint fk_relevemeteo_stationmeteo foreign key (source, idsource)
      references stationmeteo (source, idsource)
      on delete restrict on update restrict;

