select
    uuid,
    ts,
    type,
    subtype,
    reliability,
    ST_X(geo) as x,
    ST_Y(geo) as y,
from waze-public-dataset.partner_ConseildpartementalduGard.view_alerts_clustered
where timestamp_diff(current_timestamp() , ts, day) < 200 -- pour ne récupèrer que les 100 derniers jours
order by ts desc;