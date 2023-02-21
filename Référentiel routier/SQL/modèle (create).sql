/*==============================================================*/
/* Nom de SGBD :  PostgreSQL SI3P0                              */
/* Date de création :  02/02/2023 17:02:40                      */
/*==============================================================*/


-- NDLR : schémas spécifiques SI3P0 (m = modèle)
-- TODO : adapter le search_path en fonction de la structure de la BDD cible
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
   cogcommunegauche     VARCHAR              null,
   cogcommunedroite     VARCHAR              null,
   sirenproprietaire    VARCHAR              null,
   sirengestioncourante VARCHAR              null,
   sirenvh              VARCHAR              null,
   idign                VARCHAR              null,
   idignprec            VARCHAR              null,
   idignroute           VARCHAR              null,
   cumuldistd           NUMERIC(10,2)        null,
   cumuldistf           NUMERIC(10,2)        null,
   fictif               BOOL                 null,
   niveau               INT4                 null,
   importance           VARCHAR              null,
   nature               VARCHAR              null,
   nbvoies              INT4                 null,
   largeur              NUMERIC              null,
   positionsol          INT4                 null,
   gueouradier          BOOL                 null,
   urbain               BOOL                 null,
   prive                BOOL                 null,
   senscirculation      INT4                 null,
   gauche               BOOL                 null,
   rgc                  BOOL                 null,
   rrir                 VARCHAR              null,
   rte                  INT4                 null,
   itinerairevert       BOOL                 null,
   delestage            BOOL                 null,
   matdangereusesinterdites BOOL                 null,
   restrictionlongueur  NUMERIC              null,
   restrictionlargeur   NUMERIC              null,
   restrictionpoidsparessieu NUMERIC              null,
   restrictionpoidstotal NUMERIC              null,
   restrictionhauteur   NUMERIC              null,
   naturerestriction    VARCHAR              null,
   periodefermeture     VARCHAR              null,
   accespieton          VARCHAR              null,
   accesvl              VARCHAR              null,
   vitessemoyennevl     INT4                 null,
   reservebus           VARCHAR              null,
   sensamngtcyclablegauche VARCHAR              null,
   sensamngtcyclabledroit VARCHAR              null,
   amngtcyclablegauche  VARCHAR              null,
   amngtcyclabledroit   VARCHAR              null,
   precisionplani       NUMERIC              null,
   precisionalti        NUMERIC              null,
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
cogcommunedroite
);

/*==============================================================*/
/* Index : troncon_commune_droite_fk                            */
/*==============================================================*/
create  index troncon_commune_droite_fk on troncon (
cogcommunegauche
);

/*==============================================================*/
/* Index : troncon_giratoire_fk                                 */
/*==============================================================*/
create  index troncon_giratoire_fk on troncon (
idgiratoire
);

/*==============================================================*/
/* Index : troncon_proprietaire_fk                              */
/*==============================================================*/
create  index troncon_proprietaire_fk on troncon (
sirenproprietaire
);

/*==============================================================*/
/* Index : troncon_gestionnaire_fk                              */
/*==============================================================*/
create  index troncon_gestionnaire_fk on troncon (
sirengestioncourante
);

/*==============================================================*/
/* Index : troncon_vh_fk                                        */
/*==============================================================*/
create  index troncon_vh_fk on troncon (
sirenvh
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

alter table troncon
   add constraint fk_troncon_vh foreign key (sirenvh)
      references unitelegale (siren)
      on delete restrict on update restrict;

