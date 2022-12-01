-- schémas spécifiques SI3P0 (tmp = temporaire)
set search_path to tmp, public;

drop view if exists LigneSNCF_4SHP;
drop view if exists LigneSNCF_4Layer;

drop view if exists PN_4SHP;
drop view if exists PN_4Layer;

drop view if exists PNSurRD_4SHP;
drop view if exists PNSurRD_4Layer;