$Env:PGCLIENTENCODING = 'UTF8'
$psql = '<chemin_psql>'

$serveur = '<mon_serveur>'
$port = '<mon_port>'
$bdd = '<ma_bdd>'
$utilisateur = '<mon_utilisateur>'

# drop
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --command='drop materialized view if exists cartodeco_atlas;'
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --command='drop materialized view if exists cartodeco_batimentnotable;'
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --command='drop table if exists batiment;'
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --command='drop table if exists commune;'
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --command='drop table if exists surface_hydrographique;'
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --command='drop table if exists troncon_de_route;'
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --command='drop table if exists zone_d_activite_ou_d_interet;'

# create
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --file="$PSScriptRoot\..\Données\batiment_create.sql"
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --file="$PSScriptRoot\..\Données\commune_create.sql"
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --file="$PSScriptRoot\..\Données\surface_hydrographique_create.sql"
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --file="$PSScriptRoot\..\Données\troncon_de_route_create.sql"
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --file="$PSScriptRoot\..\Données\zone_d_activite_ou_d_interet_create.sql"

# copy
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --file="$PSScriptRoot\..\Données\batiment_copy.sql"
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --file="$PSScriptRoot\..\Données\commune_copy.sql"
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --file="$PSScriptRoot\..\Données\surface_hydrographique_copy.sql"
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --file="$PSScriptRoot\..\Données\troncon_de_route_copy.sql"
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --file="$PSScriptRoot\..\Données\zone_d_activite_ou_d_interet_copy.sql"

# vues matérialisées
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --file="$PSScriptRoot\..\Vues\Atlas.sql"
& $psql --host=$serveur --port=$port --dbname=$bdd --username=$utilisateur --file="$PSScriptRoot\..\Vues\Bâtiments notables.sql"