/*==============================================================*/
/* Nom de SGBD :  PostgreSQL SI3P0                              */
/* Date de création :  13/12/2021 23:48:31                      */
/*==============================================================*/


-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;


/*==============================================================*/
/* Table : droitcadastral                                       */
/*==============================================================*/
create table droitcadastral (
   codedroitcadastral   VARCHAR              not null,
   libelle              VARCHAR              null,
   constraint pkdroitcadastral primary key (codedroitcadastral)
);

insert into DroitCadastral (CodeDroitCadastral, Libelle) values
('P', 'Propriétaire'),
('U', 'Usufruitier'),
('N', 'Nu-propriétaire'),
('B', 'Bailleur à construction'),
('R', 'Preneur à construction'),
('F', 'Foncier'),
('T', 'Ténuyer'),
('D', 'Domanier'),
('V', 'Bailleur d’un bail à réhabilitation'),
('W', 'Preneur d’un bail à réhabilitation'),
('A', 'Locataire-Attributaire'),
('E', 'Emphytéote'),
('K', 'Antichrésiste'),
('L', 'Fonctionnaire logé'),
('G', 'Gérant, mandataire, gestionnaire'),
('S', 'Syndic de copropriété'),
('H', 'Associé dans une société en transparence fiscale'),
('O', 'Autorisation d’occupation temporaire'),
('J', 'Jeune agriculteur'),
('Q', 'Gestionnaire taxe sur les bureaux'),
('X', 'La Poste - Occupant et propriétaire'),
('Y', 'La Poste - Occupant et non propriétaire'),
('C', 'Fiduciaire'),
('M', 'Occupant d’une parcelle appartenant au département de Mayotte ou à l’Etat'),
('Z', 'Gestionnaire d’un bien de l’Etat');

/*==============================================================*/
/* Index : droitcadastral_pk                                    */
/*==============================================================*/
create unique index droitcadastral_pk on droitcadastral (
codedroitcadastral
);

/*==============================================================*/
/* Table : lieudit                                              */
/*==============================================================*/
create table lieudit (
   idlieudit            SERIAL               not null,
   cogcommune           VARCHAR              not null,
   nom                  VARCHAR              null,
   constraint pklieudit primary key (idlieudit)
);

select AddGeometryColumn('lieudit', 'geom', 2154, 'MULTIPOLYGON', 2);
create index lieudit_geom_idx on lieudit using gist (geom);

/*==============================================================*/
/* Index : lieudit_pk                                           */
/*==============================================================*/
create unique index lieudit_pk on lieudit (
idlieudit
);

/*==============================================================*/
/* Index : lieudit_commune_fk                                   */
/*==============================================================*/
create  index lieudit_commune_fk on lieudit (
cogcommune
);

/*==============================================================*/
/* Table : parcellecadastrale                                   */
/*==============================================================*/
create table parcellecadastrale (
   idparcellecadastrale VARCHAR              not null,
   idsectioncadastrale  VARCHAR              not null,
   numero               VARCHAR              null,
   contenance           INT4                 null,
   constraint pkparcellecadastrale primary key (idparcellecadastrale)
);

select AddGeometryColumn('parcellecadastrale', 'geom', 2154, 'MULTIPOLYGON', 2);
create index parcellecadastrale_geom_idx on parcellecadastrale using gist (geom);

/*==============================================================*/
/* Index : parcellecadastrale_pk                                */
/*==============================================================*/
create unique index parcellecadastrale_pk on parcellecadastrale (
idparcellecadastrale
);

/*==============================================================*/
/* Index : parcellecadastrale_sectioncadastrale_fk              */
/*==============================================================*/
create  index parcellecadastrale_sectioncadastrale_fk on parcellecadastrale (
idsectioncadastrale
);

/*==============================================================*/
/* Table : parcellecadastrale_unitelegale                       */
/*==============================================================*/
create table parcellecadastrale_unitelegale (
   idparcellecadastrale VARCHAR              not null,
   siren                VARCHAR              not null,
   codedroitcadastral   VARCHAR              not null,
   constraint pkparcellecadastrale_unitelegale primary key (idparcellecadastrale, siren, codedroitcadastral)
);

/*==============================================================*/
/* Index : parcellecadastrale_unitelegale_pk                    */
/*==============================================================*/
create unique index parcellecadastrale_unitelegale_pk on parcellecadastrale_unitelegale (
idparcellecadastrale,
siren,
codedroitcadastral
);

/*==============================================================*/
/* Index : ayantdroit_unitelegale_fk                            */
/*==============================================================*/
create  index ayantdroit_unitelegale_fk on parcellecadastrale_unitelegale (
siren
);

/*==============================================================*/
/* Index : ayantdroit_parcellecadastrale_fk                     */
/*==============================================================*/
create  index ayantdroit_parcellecadastrale_fk on parcellecadastrale_unitelegale (
idparcellecadastrale
);

/*==============================================================*/
/* Index : ayantdroit_droitcadastral_fk                         */
/*==============================================================*/
create  index ayantdroit_droitcadastral_fk on parcellecadastrale_unitelegale (
codedroitcadastral
);

/*==============================================================*/
/* Table : sectioncadastrale                                    */
/*==============================================================*/
create table sectioncadastrale (
   idsectioncadastrale  VARCHAR              not null,
   cogcommune           VARCHAR              not null,
   prefixe              VARCHAR              null,
   code                 VARCHAR              null,
   constraint pksectioncadastrale primary key (idsectioncadastrale)
);

/*==============================================================*/
/* Index : sectioncadastrale_pk                                 */
/*==============================================================*/
create unique index sectioncadastrale_pk on sectioncadastrale (
idsectioncadastrale
);

/*==============================================================*/
/* Index : sectioncadastrale_commune_fk                         */
/*==============================================================*/
create  index sectioncadastrale_commune_fk on sectioncadastrale (
cogcommune
);

alter table parcellecadastrale
   add constraint fk_parcellecadastrale_sectioncadastrale foreign key (idsectioncadastrale)
      references sectioncadastrale (idsectioncadastrale)
      on delete restrict on update restrict;

alter table parcellecadastrale_unitelegale
   add constraint fk_ayantdroit_droitcadastral foreign key (codedroitcadastral)
      references droitcadastral (codedroitcadastral)
      on delete restrict on update restrict;

alter table parcellecadastrale_unitelegale
   add constraint fk_ayantdroit_parcellecadastrale foreign key (idparcellecadastrale)
      references parcellecadastrale (idparcellecadastrale)
      on delete restrict on update restrict;

