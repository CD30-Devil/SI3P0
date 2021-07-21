/*==============================================================*/
/* Nom de SGBD :  PostgreSQL SI3P0                              */
/* Date de création :  21/07/2021 22:16:39                      */
/*==============================================================*/


-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;


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
/* Table : sectioncadastrale                                    */
/*==============================================================*/
create table sectioncadastrale (
   idsectioncadastrale  VARCHAR              not null,
   cogcommune           VARCHAR              not null,
   prefixe              VARCHAR              null,
   code                 VARCHAR              null,
   constraint pksectioncadastrale primary key (idsectioncadastrale)
);

select AddGeometryColumn('sectioncadastrale', 'geom', 2154, 'MULTIPOLYGON', 2);
create index sectioncadastrale_geom_idx on sectioncadastrale using gist (geom);

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

