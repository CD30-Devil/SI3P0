/*==============================================================*/
/* Nom de SGBD :  PostgreSQL SI3P0                              */
/* Date de création :  20/12/2021 13:54:56                      */
/*==============================================================*/


-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;


/*==============================================================*/
/* Table : conseillermunicipal                                  */
/*==============================================================*/
create table conseillermunicipal (
   idconseillermunicipal SERIAL               not null,
   cogcommune           VARCHAR              null,
   sexe                 VARCHAR              null,
   nom                  VARCHAR              null,
   prenom               VARCHAR              null,
   fonction             VARCHAR              null,
   constraint pkconseillermunicipal primary key (idconseillermunicipal)
);

/*==============================================================*/
/* Index : conseillermunicipal_pk                               */
/*==============================================================*/
create unique index conseillermunicipal_pk on conseillermunicipal (
idconseillermunicipal
);

/*==============================================================*/
/* Index : conseillermunicipal_commune_fk                       */
/*==============================================================*/
create  index conseillermunicipal_commune_fk on conseillermunicipal (
cogcommune
);

