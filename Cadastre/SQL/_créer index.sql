create index if not exists cadastre_batiment_commune_idx on d.cadastre_batiment (commune);
create index if not exists cadastre_batiment_geom_idx on d.cadastre_batiment using gist (geom);

create index if not exists cadastre_lieudit_commune_idx on d.cadastre_lieudit (commune);
create index if not exists cadastre_lieudit_geom_idx on d.cadastre_lieudit using gist (geom);

create index if not exists cadastre_parcelle_commune_idx on d.cadastre_parcelle (commune);
create index if not exists cadastre_parcelle_geom_idx on d.cadastre_parcelle using gist (geom);