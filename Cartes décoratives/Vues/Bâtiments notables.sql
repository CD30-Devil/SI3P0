create materialized view cartodeco_batimentnotable as
select
    row_number() over () as id,
    geometrie
from batiment
where nature in (
    'Arc de triomphe',
    'Arène ou théâtre antique',
    'Chapelle',
    'Château',
    'Eglise',
    'Fort, blockhaus, casemate',
    'Monument',
    'Tour, donjon'
);