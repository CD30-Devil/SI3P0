-- schémas spécifiques SI3P0 (m = modèle)
set search_path to m, public;

drop table if exists SegmentCyclable_Gestionnaire;
drop table if exists SegmentCyclable_Proprietaire;
drop table if exists PortionCyclable_Itinerairecyclable;
drop table if exists SegmentCyclable_PortionCyclable;
drop table if exists ItineraireCyclable;
drop table if exists PortionCyclable;
drop table if exists SegmentCyclable;
drop table if exists TypePortionCyclable;
drop table if exists Statut3v;
drop table if exists Revetement3v;
drop table if exists EtatAvancement3v;
drop table if exists PRCyclable;
drop table if exists TypePRCyclable;