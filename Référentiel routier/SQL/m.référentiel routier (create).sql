/*==============================================================*/
/* Nom de SGBD :  PostgreSQL SI3P0                              */
/* Date de création :  01/12/2021 08:44:04                      */
/*==============================================================*/


-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;


/*==============================================================*/
/* Table : giratoire                                            */
/*==============================================================*/
create table giratoire (
   idgiratoire          VARCHAR              not null,
   numeroroute          VARCHAR              not null,
   constraint pkgiratoire primary key (idgiratoire)
);

select AddGeometryColumn('giratoire', 'geom', 2154, 'MULTILINESTRING', 3);
create index giratoire_geom_idx on giratoire using gist (geom);

/*==============================================================*/
/* Index : giratoire_pk                                         */
/*==============================================================*/
create unique index giratoire_pk on giratoire (
idgiratoire
);

/*==============================================================*/
/* Index : giratoire_route_fk                                   */
/*==============================================================*/
create  index giratoire_route_fk on giratoire (
numeroroute
);

/*==============================================================*/
/* Table : pr                                                   */
/*==============================================================*/
create table pr (
   idpr                 SERIAL not null,
   numeroroute          VARCHAR              not null,
   pra                  INT4                 null,
   cumuldist            NUMERIC(10,2)        null,
   constraint pkpr primary key (idpr)
);

select AddGeometryColumn('pr', 'geom', 2154, 'POINT', 3);
create index pr_geom_idx on pr using gist (geom);

/*==============================================================*/
/* Index : pr_pk                                                */
/*==============================================================*/
create unique index pr_pk on pr (
idpr
);

/*==============================================================*/
/* Index : pr_route_fk                                          */
/*==============================================================*/
create  index pr_route_fk on pr (
numeroroute
);

/*==============================================================*/
/* Table : route                                                */
/*==============================================================*/
create table route (
   numeroroute          VARCHAR              not null,
   classeadmin          VARCHAR              null,
   constraint pkroute primary key (numeroroute)
);

/*==============================================================*/
/* Index : route_pk                                             */
/*==============================================================*/
create unique index route_pk on route (
numeroroute
);

/*==============================================================*/
/* Table : troncon                                              */
/*==============================================================*/
create table troncon (
   idtroncon            SERIAL not null,
   numeroroute          VARCHAR              not null,
   idgiratoire          VARCHAR              null,
   codeinseegauche      VARCHAR              null,
   codeinseedroite      VARCHAR              null,
   cumuldistd           NUMERIC(10,2)        null,
   cumuldistf           NUMERIC(10,2)        null,
   idign                VARCHAR              null,
   idignprec            VARCHAR              null,
   etat                 VARCHAR              null,
   niveau               INT4                 null,
   rgc                  BOOL                 null,
   rrir                 VARCHAR              null,
   itinerairevert       BOOL                 null,
   fictif               BOOL                 null,
   nature               VARCHAR              null,
   nbvoies              INT4                 null,
   senscirculation      INT4                 null,
   gauche               BOOL                 null,
   largeur              NUMERIC              null,
   positionsol          INT4                 null,
   accesvl              VARCHAR              null,
   reservebus           VARCHAR              null,
   bandecyclable        VARCHAR              null,
   accespieton          VARCHAR              null,
   prive                BOOL                 null,
   urbain               BOOL                 null,
   vitessemoyennevl     INT4                 null,
   precisionplani       DECIMAL              null,
   precisionalti        DECIMAL              null,
   constraint pktroncon primary key (idtroncon)
);

select AddGeometryColumn('troncon', 'geom', 2154, 'LINESTRING', 4);
create index troncon_geom_idx on troncon using gist (geom);

/*==============================================================*/
/* Index : troncon_pk                                           */
/*==============================================================*/
create unique index troncon_pk on troncon (
idtroncon
);

/*==============================================================*/
/* Index : troncon_route_fk                                     */
/*==============================================================*/
create  index troncon_route_fk on troncon (
numeroroute
);

/*==============================================================*/
/* Index : troncon_commune_gauche_fk                            */
/*==============================================================*/
create  index troncon_commune_gauche_fk on troncon (
codeinseedroite
);

/*==============================================================*/
/* Index : troncon_commune_droite_fk                            */
/*==============================================================*/
create  index troncon_commune_droite_fk on troncon (
codeinseegauche
);

/*==============================================================*/
/* Index : troncon_giratoire_fk                                 */
/*==============================================================*/
create  index troncon_giratoire_fk on troncon (
idgiratoire
);

/*==============================================================*/
/* Index : troncon_idign_idx                                    */
/*==============================================================*/
create  index troncon_idign_idx on troncon (
idign
);

alter table giratoire
   add constraint fk_giratoire_route foreign key (numeroroute)
      references route (numeroroute)
      on delete restrict on update restrict;

alter table pr
   add constraint fk_pr_route foreign key (numeroroute)
      references route (numeroroute)
      on delete restrict on update restrict;

alter table troncon
   add constraint fk_troncon_giratoire foreign key (idgiratoire)
      references giratoire (idgiratoire)
      on delete restrict on update restrict;

alter table troncon
   add constraint fk_troncon_route foreign key (numeroroute)
      references route (numeroroute)
      on delete restrict on update restrict;

