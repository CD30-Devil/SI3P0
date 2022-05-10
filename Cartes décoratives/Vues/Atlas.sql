create materialized view cartodeco_atlas as
select
    row_number() over () as id,
    c.code_insee,
    c.nom_officiel,
    row_number() over (partition by c.code_insee) as num_mairie,
    ST_AsLatLonText(ST_Transform(ST_Centroid(zai.geometrie), 4326), 'D° M'' S.SSS" C') as coordonnees,
    c.population,
    ST_Centroid(zai.geometrie) as geometrie
from zone_d_activite_ou_d_interet zai
inner join commune c on ST_Intersects(c.geometrie, zai.geometrie)
where nature_detaillee = 'Hôtel de ville' or (nature = 'Mairie' and nature_detaillee is null)
order by 1;