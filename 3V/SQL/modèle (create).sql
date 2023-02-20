/*==============================================================*/
/* Nom de SGBD :  PostgreSQL SI3P0                              */
/* Date de création :  13/12/2021 21:51:06                      */
/*==============================================================*/


-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;


/*==============================================================*/
/* Table : etatavancement3v                                     */
/*==============================================================*/
create table etatavancement3v (
   codeetatavancement3v INT4                 not null,
   description          VARCHAR              null,
   constraint pketatavancement3v primary key (codeetatavancement3v)
);

insert into EtatAvancement3V (CodeEtatAvancement3V, Description) values
(1, 'Projet'),
(2, 'Tracé arrêté'),
(3, 'Travaux en cours'),
(4, 'Ouvert');

/*==============================================================*/
/* Index : etatavancement3v_pk                                  */
/*==============================================================*/
create unique index etatavancement3v_pk on etatavancement3v (
codeetatavancement3v
);

/*==============================================================*/
/* Table : itinerairecyclable                                   */
/*==============================================================*/
create table itinerairecyclable (
   numeroitinerairecyclable VARCHAR              not null,
   nomofficiel          VARCHAR              null,
   nomusage             VARCHAR              null,
   depart               VARCHAR              null,
   arrivee              VARCHAR              null,
   estinscrit           BOOL                 null,
   niveauschema         VARCHAR              null
      constraint ckcniveauschema check (niveauschema is null or (niveauschema in ('Infra-communal','Communal','Inter-communal','Départemental','Régional','National','Européen','International'))),
   anneeinscription     INT4                 null,
   siteweb              VARCHAR              null,
   anneeouverture       INT4                 null,
   constraint pkitinerairecyclable primary key (numeroitinerairecyclable)
);

/*==============================================================*/
/* Index : itinerairecyclable_pk                                */
/*==============================================================*/
create unique index itinerairecyclable_pk on itinerairecyclable (
numeroitinerairecyclable
);

/*==============================================================*/
/* Table : portioncyclable                                      */
/*==============================================================*/
create table portioncyclable (
   idportioncyclable    SERIAL not null,
   codetypeportioncyclable VARCHAR              null,
   nom                  VARCHAR              null,
   description          VARCHAR              null,
   constraint pkportioncyclable primary key (idportioncyclable)
);

/*==============================================================*/
/* Index : portioncyclable_pk                                   */
/*==============================================================*/
create unique index portioncyclable_pk on portioncyclable (
idportioncyclable
);

/*==============================================================*/
/* Index : portioncyclable_typeportioncyclable_fk               */
/*==============================================================*/
create  index portioncyclable_typeportioncyclable_fk on portioncyclable (
codetypeportioncyclable
);

/*==============================================================*/
/* Table : portioncyclable_itinerairecyclable                   */
/*==============================================================*/
create table portioncyclable_itinerairecyclable (
   idportioncyclable    INT4                 not null,
   numeroitinerairecyclable VARCHAR              not null,
   ordre                INT4                 null,
   constraint pkportioncyclable_itinerairecyclable primary key (idportioncyclable, numeroitinerairecyclable)
);

/*==============================================================*/
/* Index : portioncyclable_itinerairecyclable_pk                */
/*==============================================================*/
create unique index portioncyclable_itinerairecyclable_pk on portioncyclable_itinerairecyclable (
idportioncyclable,
numeroitinerairecyclable
);

/*==============================================================*/
/* Index : itinerairecyclable_portioncyclable_fk                */
/*==============================================================*/
create  index itinerairecyclable_portioncyclable_fk on portioncyclable_itinerairecyclable (
idportioncyclable
);

/*==============================================================*/
/* Index : portioncyclable_itinerairecyclable_fk                */
/*==============================================================*/
create  index portioncyclable_itinerairecyclable_fk on portioncyclable_itinerairecyclable (
numeroitinerairecyclable
);

/*==============================================================*/
/* Table : prcyclable                                           */
/*==============================================================*/
create table prcyclable (
   idprcyclable         SERIAL not null,
   codetypeprcyclable   VARCHAR              null,
   libelle              VARCHAR              null,
   numeroserie          VARCHAR              null,
   constraint pkprcyclable primary key (idprcyclable)
);

select AddGeometryColumn('prcyclable', 'geom', 2154, 'POINT', 3);
create index prcyclable_geom_idx on prcyclable using gist (geom);

/*==============================================================*/
/* Index : prcyclable_pk                                        */
/*==============================================================*/
create unique index prcyclable_pk on prcyclable (
idprcyclable
);

/*==============================================================*/
/* Index : prcyclable_typeprcyclable_fk                         */
/*==============================================================*/
create  index prcyclable_typeprcyclable_fk on prcyclable (
codetypeprcyclable
);

/*==============================================================*/
/* Table : revetement3v                                         */
/*==============================================================*/
create table revetement3v (
   coderevetement3v     VARCHAR              not null,
   description          VARCHAR              null,
   constraint pkrevetement3v primary key (coderevetement3v)
);

insert into Revetement3V (CodeRevetement3V, Description) values
('LIS', 'Lisse'),
('RUG', 'Rugueux'),
('MEU', 'Meuble');

/*==============================================================*/
/* Index : revetement3v_pk                                      */
/*==============================================================*/
create unique index revetement3v_pk on revetement3v (
coderevetement3v
);

/*==============================================================*/
/* Table : segmentcyclable                                      */
/*==============================================================*/
create table segmentcyclable (
   idsegmentcyclable    SERIAL not null,
   codeetatavancement3v INT4                 null,
   codestatut3v         VARCHAR              null,
   coderevetement3v     VARCHAR              null,
   anneeouverture       INT4                 null,
   sensunique           BOOL                 null,
   datesaisie           DATE                 null,
   precisionestimee     VARCHAR              null,
   sourcegeometrie      VARCHAR              null,
   idgeometrie          VARCHAR              null,
   datesource           DATE                 null,
   fictif               BOOL                 null,
   constraint pksegmentcyclable primary key (idsegmentcyclable)
);

select AddGeometryColumn('segmentcyclable', 'geom', 2154, 'LINESTRING', 3);
create index segmentcyclable_geom_idx on segmentcyclable using gist (geom);

/*==============================================================*/
/* Index : segmentcyclable_pk                                   */
/*==============================================================*/
create unique index segmentcyclable_pk on segmentcyclable (
idsegmentcyclable
);

/*==============================================================*/
/* Index : segmentcyclable_etatavancement3v_fk                  */
/*==============================================================*/
create  index segmentcyclable_etatavancement3v_fk on segmentcyclable (
codeetatavancement3v
);

/*==============================================================*/
/* Index : segmentcyclable_revetement3v_fk                      */
/*==============================================================*/
create  index segmentcyclable_revetement3v_fk on segmentcyclable (
coderevetement3v
);

/*==============================================================*/
/* Index : segmentcyclable_statut3v_fk                          */
/*==============================================================*/
create  index segmentcyclable_statut3v_fk on segmentcyclable (
codestatut3v
);

/*==============================================================*/
/* Table : segmentcyclable_gestionnaire                         */
/*==============================================================*/
create table segmentcyclable_gestionnaire (
   idsegmentcyclable    INT4                 not null,
   siren                VARCHAR              not null,
   constraint pksegmentcyclable_gestionnaire primary key (idsegmentcyclable, siren)
);

/*==============================================================*/
/* Index : segmentcyclable_gestionnaire_pk                      */
/*==============================================================*/
create unique index segmentcyclable_gestionnaire_pk on segmentcyclable_gestionnaire (
idsegmentcyclable,
siren
);

/*==============================================================*/
/* Index : gestionnaire_segmentcyclable_fk                      */
/*==============================================================*/
create  index gestionnaire_segmentcyclable_fk on segmentcyclable_gestionnaire (
idsegmentcyclable
);

/*==============================================================*/
/* Index : segmentcyclable_gestionnaire_fk                      */
/*==============================================================*/
create  index segmentcyclable_gestionnaire_fk on segmentcyclable_gestionnaire (
siren
);

/*==============================================================*/
/* Table : segmentcyclable_portioncyclable                      */
/*==============================================================*/
create table segmentcyclable_portioncyclable (
   idsegmentcyclable    INT4                 not null,
   idportioncyclable    INT4                 not null,
   constraint pksegmentcyclable_portioncyclable primary key (idsegmentcyclable, idportioncyclable)
);

/*==============================================================*/
/* Index : segmentcyclable_portioncyclable_pk                   */
/*==============================================================*/
create unique index segmentcyclable_portioncyclable_pk on segmentcyclable_portioncyclable (
idsegmentcyclable,
idportioncyclable
);

/*==============================================================*/
/* Index : portioncyclable_segmentcyclable_fk                   */
/*==============================================================*/
create  index portioncyclable_segmentcyclable_fk on segmentcyclable_portioncyclable (
idsegmentcyclable
);

/*==============================================================*/
/* Index : segmentcyclable_portioncyclable_fk                   */
/*==============================================================*/
create  index segmentcyclable_portioncyclable_fk on segmentcyclable_portioncyclable (
idportioncyclable
);

/*==============================================================*/
/* Table : segmentcyclable_proprietaire                         */
/*==============================================================*/
create table segmentcyclable_proprietaire (
   idsegmentcyclable    INT4                 not null,
   siren                VARCHAR              not null,
   constraint pksegmentcyclable_proprietaire primary key (idsegmentcyclable, siren)
);

/*==============================================================*/
/* Index : segmentcyclable_proprietaire_pk                      */
/*==============================================================*/
create unique index segmentcyclable_proprietaire_pk on segmentcyclable_proprietaire (
idsegmentcyclable,
siren
);

/*==============================================================*/
/* Index : proprietaire_segmentcyclable_fk                      */
/*==============================================================*/
create  index proprietaire_segmentcyclable_fk on segmentcyclable_proprietaire (
idsegmentcyclable
);

/*==============================================================*/
/* Index : segmentcyclable_proprietaire_fk                      */
/*==============================================================*/
create  index segmentcyclable_proprietaire_fk on segmentcyclable_proprietaire (
siren
);

/*==============================================================*/
/* Table : statut3v                                             */
/*==============================================================*/
create table statut3v (
   codestatut3v         VARCHAR              not null,
   description          VARCHAR              null,
   constraint pkstatut3v primary key (codestatut3v)
);

insert into Statut3V (CodeStatut3V, Description) values
('VV', 'Voie verte'),
('PCY', 'Piste cyclable'),
('ASP', 'Autre site propre'),
('RTE', 'Route'),
('BCY', 'Bande cyclable'),
('ICA', 'Itinéraire à circulation apaisée');

/*==============================================================*/
/* Index : statut3v_pk                                          */
/*==============================================================*/
create unique index statut3v_pk on statut3v (
codestatut3v
);

/*==============================================================*/
/* Table : typeportioncyclable                                  */
/*==============================================================*/
create table typeportioncyclable (
   codetypeportioncyclable VARCHAR              not null,
   description          VARCHAR              null,
   constraint pktypeportioncyclable primary key (codetypeportioncyclable)
);

insert into TypePortionCyclable (CodeTypePortionCyclable, Description) values
('ETP', 'Etape'),
('VAR', 'Variante'),
('PRV', 'Portion provisoire'),
('OBS', 'Portion observée');

/*==============================================================*/
/* Index : typeportioncyclable_pk                               */
/*==============================================================*/
create unique index typeportioncyclable_pk on typeportioncyclable (
codetypeportioncyclable
);

/*==============================================================*/
/* Table : typeprcyclable                                       */
/*==============================================================*/
create table typeprcyclable (
   codetypeprcyclable   VARCHAR              not null,
   description          VARCHAR              null,
   constraint pktypeprcyclable primary key (codetypeprcyclable)
);

insert into TypePRCyclable (CodeTypePRCyclable, Description) values
('DFE', 'Début/fin d''étape'),
('INT', 'Intersection d''itinéraires'),
('BIF', 'Bifurcation'),
('APO', 'Accès POI'),
('CPT', 'Compteur'),
('PDL', 'Passage délicat'),
('PCT', 'Point de connexion transfrontalier');

/*==============================================================*/
/* Index : typeprcyclable_pk                                    */
/*==============================================================*/
create unique index typeprcyclable_pk on typeprcyclable (
codetypeprcyclable
);

alter table portioncyclable
   add constraint fk_portioncyclable_typeportioncyclable foreign key (codetypeportioncyclable)
      references typeportioncyclable (codetypeportioncyclable)
      on delete restrict on update restrict;

alter table portioncyclable_itinerairecyclable
   add constraint fk_itinerairecyclable_portioncyclable foreign key (idportioncyclable)
      references portioncyclable (idportioncyclable)
      on delete restrict on update restrict;

alter table portioncyclable_itinerairecyclable
   add constraint fk_portioncyclable_itinerairecyclable foreign key (numeroitinerairecyclable)
      references itinerairecyclable (numeroitinerairecyclable)
      on delete restrict on update restrict;

alter table prcyclable
   add constraint fk_prcyclable_typeprcyclable foreign key (codetypeprcyclable)
      references typeprcyclable (codetypeprcyclable)
      on delete restrict on update restrict;

alter table segmentcyclable
   add constraint fk_segmentcyclable_etatavancement3v foreign key (codeetatavancement3v)
      references etatavancement3v (codeetatavancement3v)
      on delete restrict on update restrict;

alter table segmentcyclable
   add constraint fk_segmentcyclable_revetement3v foreign key (coderevetement3v)
      references revetement3v (coderevetement3v)
      on delete restrict on update restrict;

alter table segmentcyclable
   add constraint fk_segmentcyclable_statut3v foreign key (codestatut3v)
      references statut3v (codestatut3v)
      on delete restrict on update restrict;

alter table segmentcyclable_gestionnaire
   add constraint fk_gestionnaire_segmentcyclable foreign key (idsegmentcyclable)
      references segmentcyclable (idsegmentcyclable)
      on delete restrict on update restrict;

alter table segmentcyclable_portioncyclable
   add constraint fk_portioncyclable_segmentcyclable foreign key (idsegmentcyclable)
      references segmentcyclable (idsegmentcyclable)
      on delete restrict on update restrict;

alter table segmentcyclable_portioncyclable
   add constraint fk_segmentcyclable_portioncyclable foreign key (idportioncyclable)
      references portioncyclable (idportioncyclable)
      on delete restrict on update restrict;

alter table segmentcyclable_proprietaire
   add constraint fk_proprietaire_segmentcyclable foreign key (idsegmentcyclable)
      references segmentcyclable (idsegmentcyclable)
      on delete restrict on update restrict;

