-- TODO :
-- Rédiger ici les ordres de corrections des PR à appliquer à la donnée source préalablement à la construction du référentiel routier.
-- Aucune fonction n'est proposée pour aider à la rédaction de ces corrections, il faut donc produire les ordres d'insert ou d'update adaptés aux besoins.

-- exemple update
-- update source_pr set Geom = ST_Force3D(TransformerEnL93(FabriquerPointWGS84(4.1683563, 43.7033362, 11))) where NumeroRoute = 'D12' and PRA = 10000;

-- exemple insert
-- insert into source_pr (NumeroRoute, PRA, Gestionnaire, CumulDist, Geom) select 'D39C', 20000, 'Gard', 2000, FabriquerPointL93(761510.01189, 6334617.34536, 499);