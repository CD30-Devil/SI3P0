/*==============================================================*/
/* Nom de SGBD :  PostgreSQL SI3P0                              */
/* Date de création :  12/09/2022 11:55:02                      */
/*==============================================================*/


-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;


/*==============================================================*/
/* Table : etablissementsirene                                  */
/*==============================================================*/
create table etablissementsirene (
   siren                VARCHAR              not null,
   nic                  VARCHAR              not null,
   cogcommune           VARCHAR              null,
   siege                BOOL                 null,
   denominationusuelle  VARCHAR              null,
   activiteprincipale   VARCHAR              null,
   nomenclature         VARCHAR              null,
   employeur            BOOL                 null,
   trancheeffectifs     VARCHAR              null,
   etatadministratif    VARCHAR              null,
   datederniertraitement DATE                 null,
   constraint pketablissementsirene primary key (siren, nic)
);

/*==============================================================*/
/* Index : etablissementsirene_pk                               */
/*==============================================================*/
create unique index etablissementsirene_pk on etablissementsirene (
siren,
nic
);

/*==============================================================*/
/* Index : etablissementsirene_unitelegale_fk                   */
/*==============================================================*/
create  index etablissementsirene_unitelegale_fk on etablissementsirene (
siren
);

/*==============================================================*/
/* Index : etablissementsirene_commune_fk                       */
/*==============================================================*/
create  index etablissementsirene_commune_fk on etablissementsirene (
cogcommune
);

/*==============================================================*/
/* Table : unitelegale                                          */
/*==============================================================*/
create table unitelegale (
   siren                VARCHAR              not null,
   sigle                VARCHAR              null,
   denomination         VARCHAR              null,
   denominationusuelle  VARCHAR              null,
   nom                  VARCHAR              null,
   prenom               VARCHAR              null,
   categoriejuridique   VARCHAR              null,
   activiteprincipale   VARCHAR              null,
   nomemclature         VARCHAR              null,
   employeur            BOOL                 null,
   trancheeffectifs     VARCHAR              null,
   economiesocialesolidaire BOOL                 null,
   etatadministratif    VARCHAR              null,
   datederniertraitement DATE                 null,
   constraint pkunitelegale primary key (siren)
);

/*==============================================================*/
/* Index : unitelegale_pk                                       */
/*==============================================================*/
create unique index unitelegale_pk on unitelegale (
siren
);

alter table etablissementsirene
   add constraint fk_etablissementsirene_unitelegale foreign key (siren)
      references unitelegale (siren)
      on delete restrict on update restrict;

