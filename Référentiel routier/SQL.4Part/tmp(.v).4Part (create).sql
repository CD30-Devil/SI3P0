create view tmp.PerinfoTroncon_4Layer as
with Section as (
    select
        t.NumeroRoute,
        t.Niveau,
        per.CodeStructureRH,
        min(t.CumulDistD) as CumulDistD,
        max(t.CumulDistF) as CumulDistF,
        ST_LineMerge(ST_Collect(ST_Force2D(t.Geom))) as Geom
    from v.TronconReel t
    inner join v.LimiteGestionPER per on ST_Intersects(t.Geom, per.Geom) and not ST_Touches(t.Geom, per.Geom)
    group by t.NumeroRoute, t.Niveau, per.CodeStructureRH
)
select
    s.NumeroRoute as "Troncon",
    s.NumeroRoute as "Route",
    s.Niveau as "Code_categorie",
    1 as "Code_NIVEAU1",
    s.CodeStructureRH as "Code_NIVEAU2",
    CumulDistVersPRA(s.NumeroRoute, s.CumulDistD) / 10000 as "PR_debut",
    CumulDistVersPRA(s.NumeroRoute, s.CumulDistD) % 10000 as "ABSD",
    CumulDistVersPRA(s.NumeroRoute, s.CumulDistF) / 10000 as "PR_fin",
    CumulDistVersPRA(s.NumeroRoute, s.CumulDistF) % 10000 as "ABSF",
    ST_3DLength(s.Geom) as "Longueur",
    string_agg(distinct co.Nom, ', ' order by co.Nom) as "Commune",
    string_agg(distinct ca.Nom, ', ' order by ca.Nom) as "Canton",
    '' as "Agglo",
    ST_Multi(s.Geom) as Geom
from Section s
left join m.Commune co on co.COGDepartement = '30' and ST_Intersects(s.Geom, co.Geom) and not ST_Touches(s.Geom, co.Geom)
left join m.Canton ca on ca.COGCanton like '30%' and ST_Intersects(s.Geom, ca.Geom) and not ST_Touches(s.Geom, ca.Geom)
group by s.NumeroRoute, s.Niveau, s.CodeStructureRH, s.CumulDistD, s.CumulDistF, s.Geom;