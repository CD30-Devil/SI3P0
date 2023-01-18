/*==============================================================*/
/* Nom de SGBD :  PostgreSQL SI3P0                              */
/* Date de création :  21/07/2021 22:00:09                      */
/*==============================================================*/


-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;


/*==============================================================*/
/* Table : alertewaze                                           */
/*==============================================================*/
create table alertewaze (
   idalertewaze         VARCHAR              not null,
   idtypealertewaze     VARCHAR              null,
   idsoustypealertewaze VARCHAR              null,
   datecreation         TIMESTAMP WITH TIME ZONE null,
   fiabilite            INT4                 null,
   constraint pkalertewaze primary key (idalertewaze)
);

select AddGeometryColumn('alertewaze', 'geom', 2154, 'POINT', 2);
create index alertewaze_geom_idx on alertewaze using gist (geom);

/*==============================================================*/
/* Index : alertewaze_pk                                        */
/*==============================================================*/
create unique index alertewaze_pk on alertewaze (
idalertewaze
);

/*==============================================================*/
/* Index : alertewaze_typealertewaze_fk                         */
/*==============================================================*/
create  index alertewaze_typealertewaze_fk on alertewaze (
idsoustypealertewaze
);

/*==============================================================*/
/* Index : alertewaze_soustypealertewaze_fk                     */
/*==============================================================*/
create  index alertewaze_soustypealertewaze_fk on alertewaze (
idtypealertewaze
);

/*==============================================================*/
/* Table : histoalertewaze                                      */
/*==============================================================*/
create table histoalertewaze (
   idhistoalertewaze    VARCHAR              not null,
   idtypealertewaze     VARCHAR              null,
   idsoustypealertewaze VARCHAR              null,
   datecreation         TIMESTAMP WITH TIME ZONE null,
   fiabilite            INT4                 null,
   constraint pkhistoalertewaze primary key (idhistoalertewaze)
);

select AddGeometryColumn('histoalertewaze', 'geom', 2154, 'POINT', 2);
create index histoalertewaze_geom_idx on histoalertewaze using gist (geom);

/*==============================================================*/
/* Index : histoalertewaze_pk                                   */
/*==============================================================*/
create unique index histoalertewaze_pk on histoalertewaze (
idhistoalertewaze
);

/*==============================================================*/
/* Index : histoalertewaze_typealertewaze_fk                    */
/*==============================================================*/
create  index histoalertewaze_typealertewaze_fk on histoalertewaze (
idtypealertewaze
);

/*==============================================================*/
/* Index : histoalertewaze_soustypealertewaze_fk                */
/*==============================================================*/
create  index histoalertewaze_soustypealertewaze_fk on histoalertewaze (
idsoustypealertewaze
);

/*==============================================================*/
/* Index : histoalertewaze_datecreation_idx                     */
/*==============================================================*/
create  index histoalertewaze_datecreation_idx on histoalertewaze (
datecreation
);

/*==============================================================*/
/* Table : ralentissementwaze                                   */
/*==============================================================*/
create table ralentissementwaze (
   idralentissementwaze SERIAL               not null,
   datecreation         TIMESTAMP WITH TIME ZONE null,
   niveau               INT4                 null,
   vitessems            NUMERIC              null,
   nature               VARCHAR              null
      constraint ckcnature check (nature is null or (nature in ('Embouteillage','Irrégularité'))),
   constraint pkralentissementwaze primary key (idralentissementwaze)
);

select AddGeometryColumn('ralentissementwaze', 'geom', 2154, 'LINESTRING', 2);
create index ralentissementwaze_geom_idx on ralentissementwaze using gist (geom);

/*==============================================================*/
/* Index : ralentissementwaze_pk                                */
/*==============================================================*/
create unique index ralentissementwaze_pk on ralentissementwaze (
idralentissementwaze
);

/*==============================================================*/
/* Table : typealertewaze                                       */
/*==============================================================*/
create table typealertewaze (
   idtypealertewaze     VARCHAR              not null,
   description          VARCHAR              null,
   constraint pktypealertewaze primary key (idtypealertewaze)
);

insert into TypeAlerteWaze (IdTypeAlerteWaze, Description) values
('ACCIDENT', 'Accident'),
('ACCIDENT_MINOR', 'Accident léger'),
('ACCIDENT_MAJOR', 'Accident grave'),
('JAM', 'Embouteillages'),
('JAM_MODERATE_TRAFFIC', 'Trafic modéré'),
('JAM_HEAVY_TRAFFIC', 'Trafic chargé'),
('JAM_STAND_STILL_TRAFFIC', 'Trafic à l''arrêt'),
('JAM_LIGHT_TRAFFIC', 'Ralentissements'),
('WEATHERHAZARD', 'Danger  - Intempéries'),
('HAZARD', 'Danger'),
('HAZARD_ON_ROAD', 'Danger sur la route'),
('HAZARD_ON_SHOULDER', 'Danger sur le bas-côté'),
('HAZARD_WEATHER', 'Danger météorologique'),
('HAZARD_ON_ROAD_OBJECT', 'Objet sur la route'),
('HAZARD_ON_ROAD_POT_HOLE', 'Nid-de-poule'),
('HAZARD_ON_ROAD_ROAD_KILL', 'Animal mort sur la route'),
('HAZARD_ON_SHOULDER_CAR_STOPPED', 'Véhicule arrêté sur le bas-côté'),
('HAZARD_ON_SHOULDER_ANIMALS', 'Animaux sur le bas-côté'),
('HAZARD_ON_SHOULDER_MISSING_SIGN', 'Signalisation manquante'),
('HAZARD_WEATHER_FOG', 'Brouillard'),
('HAZARD_WEATHER_HAIL', 'Grêle'),
('HAZARD_WEATHER_HEAVY_RAIN', 'Pluie importante'),
('HAZARD_WEATHER_HEAVY_SNOW', 'Fortes chutes de neige'),
('HAZARD_WEATHER_FLOOD', 'Inondations'),
('HAZARD_WEATHER_MONSOON', 'Mousson'),
('HAZARD_WEATHER_TORNADO', 'Tornade'),
('HAZARD_WEATHER_HEAT_WAVE', 'Vagues de chauleur'),
('HAZARD_WEATHER_HURRICANE', 'Ouragan'),
('HAZARD_WEATHER_FREEZING_RAIN', 'Pluie verglaçante'),
('HAZARD_ON_ROAD_LANE_CLOSED', 'Voie fermée'),
('HAZARD_ON_ROAD_OIL', 'Présence d''hydrocarbure sur la route'),
('HAZARD_ON_ROAD_ICE', 'Présence de verglas sur la route'),
('HAZARD_ON_ROAD_CONSTRUCTION', 'Travaux sur la route'),
('HAZARD_ON_ROAD_CAR_STOPPED', 'Véhicule arrêté sur la route'),
('HAZARD_ON_ROAD_TRAFFIC_LIGHT_FAULT', 'Feu tricolore hors-service'),
('MISC', 'Autres'),
('CONSTRUCTION', 'Travaux'),
('ROAD_CLOSED', 'Route fermée'),
('ROAD_CLOSED_HAZARD', 'Route fermée - danger'),
('ROAD_CLOSED_CONSTRUCTION', 'Route fermée - travaux'),
('ROAD_CLOSED_EVENT', 'Route fermée - évènement'),
('', 'Non défini'),
('NO_SUBTYPE', 'Sous-type non défini');

/*==============================================================*/
/* Index : typealertewaze_pk                                    */
/*==============================================================*/
create unique index typealertewaze_pk on typealertewaze (
idtypealertewaze
);

alter table alertewaze
   add constraint fk_alertewaze_soustypealertewaze foreign key (idtypealertewaze)
      references typealertewaze (idtypealertewaze)
      on delete restrict on update restrict;

alter table alertewaze
   add constraint fk_alertewaze_typealertewaze foreign key (idsoustypealertewaze)
      references typealertewaze (idtypealertewaze)
      on delete restrict on update restrict;

alter table histoalertewaze
   add constraint fk_histoalertewaze_soustypealertewaze foreign key (idsoustypealertewaze)
      references typealertewaze (idtypealertewaze)
      on delete restrict on update restrict;

alter table histoalertewaze
   add constraint fk_histoalertewaze_typealertewaze foreign key (idtypealertewaze)
      references typealertewaze (idtypealertewaze)
      on delete restrict on update restrict;

