-- schémas spécifiques SI3P0 (tmp = temporaire)
set search_path to tmp, public;

drop view if exists D30_VetT_3VSegment_4Layer;
drop view if exists D30_VetT_3VRTronconSegment_4Sheet;
drop view if exists D30_VetT_3VPortion_4Layer;
drop view if exists D30_VetT_3VRElementPortion_4Sheet;
drop view if exists D30_VetT_3VItineraire_4Sheet;
drop view if exists D30_VetT_3VBoucleCyclo_4Layer;

drop view if exists D30_OpenData_3V_4Part;