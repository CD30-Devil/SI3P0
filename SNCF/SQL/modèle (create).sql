/*==============================================================*/
/* Nom de SGBD :  PostgreSQL SI3P0                              */
/* Date de création :  01/12/2022 15:31:42                      */
/*==============================================================*/


-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;


/*==============================================================*/
/* Table : classepn                                             */
/*==============================================================*/
create table classepn (
   numclassepn          INT4                 not null,
   description          VARCHAR              null,
   constraint pkclassepn primary key (numclassepn)
);

insert into ClassePN (NumClassePN, Description) values
(10, 'PN public pour voitures sans barrières protection assurée par un agent'),
(11, 'PN public pour voitures avec barrières gardé sans passage piétons accolé manoeuvré à pied d''oeuvre'),
(12, 'PN public pour voitures avec barrières gardé sans passage piétons accolé manoeuvré à distance'),
(13, 'PN public pour voitures avec barrières gardé sans passage piétons accolé manoeuvré à pied d''oeuvre et distance'),
(14, 'PN public pour voitures avec barrières gardé avec passage piétons accolé manoeuvré à pied d''oeuvre'),
(15, 'PN public pour voitures avec barrières gardé avec passage piétons accolé manoeuvré à distance'),
(16, 'PN public pour voitures avec barrières gardé avec passage piétons accolé manoeuvré à pied d''oeuvre distance'),
(17, 'PN public pour voitures avec barrières ou 1/2 barrières non gardé à SAL 2 et SAL 2B'),
(18, 'PN public pour voitures avec barrières ou 1/2 barrières non gardé à SAL 2 + ilot séparateur'),
(19, 'PN public pour voitures avec barrières ou 1/2 barrières non gardé à SAL 4'),
(20, 'PN public pour voitures sans barrières sans SAL'),
(21, 'PN public pour voitures sans barrières avec SAL 0'),
(31, 'PN public isolé pour piétons sans portillons'),
(32, 'PN public isolé pour piétons avec portillons'),
(41, 'PN privé pour voitures sans barrières'),
(42, 'PN privé pour voitures avec barrières sans passage piétons accolé'),
(43, 'PN privé pour voitures avec barrières avec passage piétons accolé public'),
(44, 'PN privé pour voitures avec barrières avec passage piétons accolé privé'),
(45, 'PN privé isolé pour piétons sans portillons'),
(46, 'PN privé isolé pour piétons avec portillons'),
(0, 'PN secondaire');

/*==============================================================*/
/* Index : classepn_pk                                          */
/*==============================================================*/
create unique index classepn_pk on classepn (
numclassepn
);

/*==============================================================*/
/* Table : lignesncf                                            */
/*==============================================================*/
create table lignesncf (
   codelignesncf        VARCHAR              not null,
   libelle              VARCHAR              null,
   constraint pklignesncf primary key (codelignesncf)
);

select AddGeometryColumn('lignesncf', 'geom', 2154, 'MULTILINESTRING', 2);
create index lignesncf_geom_idx on lignesncf using gist (geom);

/*==============================================================*/
/* Index : lignesncf_pk                                         */
/*==============================================================*/
create unique index lignesncf_pk on lignesncf (
codelignesncf
);

/*==============================================================*/
/* Table : pn                                                   */
/*==============================================================*/
create table pn (
   idpn                 SERIAL not null,
   numclassepn          INT4                 null,
   codelignesncf        VARCHAR              null,
   libelle              VARCHAR              null,
   obstacle             VARCHAR              null,
   pk                   VARCHAR              null,
   constraint pkpn primary key (idpn)
);

select AddGeometryColumn('pn', 'geom', 2154, 'POINT', 2);
create index pn_geom_idx on pn using gist (geom);

/*==============================================================*/
/* Index : pn_pk                                                */
/*==============================================================*/
create unique index pn_pk on pn (
idpn
);

/*==============================================================*/
/* Index : pn_lignesncf_fk                                      */
/*==============================================================*/
create  index pn_lignesncf_fk on pn (
codelignesncf
);

/*==============================================================*/
/* Index : pn_classepn_fk                                       */
/*==============================================================*/
create  index pn_classepn_fk on pn (
numclassepn
);

/*==============================================================*/
/* Table : portionlignesncf                                     */
/*==============================================================*/
create table portionlignesncf (
   idgaia               VARCHAR              not null,
   codelignesncf        VARCHAR              not null,
   pkd                  VARCHAR              null,
   pkf                  VARCHAR              null,
   statut               VARCHAR              null,
   constraint pkportionlignesncf primary key (idgaia)
);

select AddGeometryColumn('portionlignesncf', 'geom', 2154, 'MULTILINESTRING', 2);
create index portionlignesncf_geom_idx on portionlignesncf using gist (geom);

/*==============================================================*/
/* Index : portionlignesncf_pk                                  */
/*==============================================================*/
create unique index portionlignesncf_pk on portionlignesncf (
idgaia
);

/*==============================================================*/
/* Index : portionlignesncf_lignesncf_fk                        */
/*==============================================================*/
create  index portionlignesncf_lignesncf_fk on portionlignesncf (
codelignesncf
);

alter table pn
   add constraint fk_pn_classepn foreign key (numclassepn)
      references classepn (numclassepn)
      on delete restrict on update restrict;

alter table pn
   add constraint fk_pn_lignesncf foreign key (codelignesncf)
      references lignesncf (codelignesncf)
      on delete restrict on update restrict;

alter table portionlignesncf
   add constraint fk_portionlignesncf_lignesncf foreign key (codelignesncf)
      references lignesncf (codelignesncf)
      on delete restrict on update restrict;

