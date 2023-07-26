-- schémas spécifiques SI3P0 (tmp = temporaire)
set search_path to tmp, public;

drop materialized view if exists D30_3VAvecDoublons_4Layer;
drop view if exists D30_3VSansDoublons_4Layer;
drop view if exists D30_3VSegmentCyclableGard_4Layer;

drop view if exists D30_3VModesDoux_4Layer;

drop view if exists D30_3VPortionUniforme_4Layer;
drop view if exists D30_3VEtiquetageItineraire_4Layer;