create index if not exists BDTopo_Troncon_De_Route_CleAbs on d.BDTopo_Troncon_De_Route (cleabs);
create index if not exists BDTopo_Troncon_De_Route_Nature on d.BDTopo_Troncon_De_Route (nature);
create index if not exists BDTopo_Troncon_De_Route_CPX_Numero on d.BDTopo_Troncon_De_Route (cpx_numero);
create index if not exists BDTopo_Troncon_De_Route_CPX_Cl_Admin on d.BDTopo_Troncon_De_Route (cpx_classement_administratif);

create index if not exists BDTopo_Troncon_De_Voie_Ferree_CleAbs on d.BDTopo_Troncon_De_Voie_Ferree (cleabs);