. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

# gestion d'un préfixe pour permettre plusieurs exécutions en // avec des critères différents
$prefixe = Read-Host -Prompt "Prefixe pour l'exécution"

$dossierDonnees = "$PSScriptRoot\..\Données\"
$dossierRapports = "$PSScriptRoot\..\Rapports\$prefixe\"

# paramétrage de l'algo
$tempsTotalDisponible = 3600
$nbSautsServeursMax = 13
$tempsSautsServeursMax = 37

# nettoyage préalable
Remove-Item "$dossierRapports\*.txt"
Remove-Item "$dossierRapports\*.err"
Remove-Item "$dossierRapports\*.csv"

SIg-Effacer-Vue -vue "tmp.$($prefixe)_serveur_fichiersnonrecuperes" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  effacement tmp.$($prefixe)_serveur_fichiersnonrecuperes.txt"

SIg-Effacer-Table -table "tmp.$($prefixe)_serveur_fichiers" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  effacement tmp.$($prefixe)_serveur_fichiers.txt"
SIg-Effacer-Table -table "tmp.$($prefixe)_serveur_serveur" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  effacement tmp.$($prefixe)_serveur_serveur.txt"

SIg-Effacer-Table -table "tmp.$($prefixe)_fichier" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  effacement tmp.$($prefixe)_fichier.txt"
SIg-Effacer-Table -table "tmp.$($prefixe)_saut" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  effacement tmp.$($prefixe)_saut.txt"

# création des tables et import des CSV
SIg-Creer-Table-Temp -table "tmp.$($prefixe)_serveur_fichiers" -colonnes 'serveur', 'fichiers' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  création tmp.$($prefixe)_serveur_fichiers.txt"
SIg-Creer-Table-Temp -table "tmp.$($prefixe)_serveur_serveur" -colonnes 'serveur1', 'serveur2', 'temps' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  création tmp.$($prefixe)_serveur_serveur.txt"

SIg-Importer-CSV -table "tmp.$($prefixe)_serveur_fichiers" -csv "$dossierDonnees\Exo4\serveur_fichiers.csv" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  import serveur_fichiers.csv.txt"
SIg-Importer-CSV -table "tmp.$($prefixe)_serveur_serveur" -csv "$dossierDonnees\Exo4\serveur_serveur_temps.csv" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  import serveur_serveur_temps.csv.txt"

# création de la table des fichiers distincts avec pour chacun :
# - le nombre de serveur sur lesquels il se trouve
# - un booléen indiquant s'il a été récupéré
SIg-Executer-Commande -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  création tmp.$($prefixe)_fichier.txt" -commande @"
create table tmp.$($prefixe)_fichier as
with fichier as (
    select distinct(unnest(string_to_array(fichiers, ' '))) as fichier
    from tmp.$($prefixe)_serveur_fichiers
)
select fichier, false as recupere, count(serveur) as nbserveurs
from fichier f
inner join tmp.$($prefixe)_serveur_fichiers sf
on f.fichier =any (string_to_array(sf.fichiers, ' '))
group by f.fichier;

create index $($prefixe)_fichier_fichier_idx on tmp.$($prefixe)_fichier (fichier);
create index $($prefixe)_fichier_recupere_idx on tmp.$($prefixe)_fichier (recupere);
"@

# création de la table des sauts
SIg-Executer-Commande -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -   création tmp.$($prefixe)_saut.txt" -commande @"
create table tmp.$($prefixe)_saut as
select
    serveur1 as source,
    serveur2 as destination,
    min(temps::numeric) as temps
from tmp.$($prefixe)_serveur_serveur
group by serveur1, serveur2

union

select
    serveur2 as source,
    serveur1 as destination,
    min(temps::numeric) as temps
from tmp.$($prefixe)_serveur_serveur
where serveur1 <> '0' -- on ne considère pas le 0 comme destination possible d'un saut
group by serveur1, serveur2;

create index $($prefixe)_saut_source_idx on tmp.$($prefixe)_saut (source);
create index $($prefixe)_saut_destination_idx on tmp.$($prefixe)_saut (destination);
create index $($prefixe)_saut_temps_idx on tmp.$($prefixe)_saut (temps);
"@

# création de la vue serveur <-> fichiers non récupérés
SIg-Executer-Commande -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  création tmp.$($prefixe)_serveur_fichiersnonrecuperes.txt" -commande @"
create view tmp.$($prefixe)_serveur_fichiersnonrecuperes as
select
    sf.serveur,
    array_agg(distinct f.fichier) as fichiersnonrecuperes
from tmp.$($prefixe)_serveur_fichiers sf
inner join tmp.$($prefixe)_fichier f
on not(f.recupere) and
f.fichier =any (string_to_array(sf.fichiers, ' '))
group by sf.serveur
"@

$score = 0

while ($score -le 1700) {

    # RAZ des fichiers récupérés
    SIg-Executer-Commande -commande "update tmp.$($prefixe)_fichier set recupere = false"
    $score = 0

    $tempsRestant = $tempsTotalDisponible
    $sb = [Text.StringBuilder]::new()

    do {

        # recherche du meilleur score à réaliser pour l'itération de récupération en fonction du temps restant et du paramètrage
        SIg-Exporter-CSV -csv "$dossierRapports\strategie.csv" -requete @"
        with recursive strategie as (
            select
                1 as nbsauts,
                s.source,
                s.destination,
                concat_ws(' ', s.source, s.destination) as chemin,
                s.temps,
                sfnr.fichiersnonrecuperes
            from tmp.$($prefixe)_saut s
            left join tmp.$($prefixe)_serveur_fichiersnonrecuperes sfnr on s.destination = sfnr.serveur
            where s.source = '0' -- départ du serveur 0
            and s.temps <= $tempsRestant -- il ne faut pas dépasser le temps restant de récupération
            and s.temps <= $tempsSautsServeursMax -- il ne faut pas dépasser le temps max accordé pour une itération de récupération

            union all

            select
                str.nbsauts + 1 as nbsaut,
                str.source,
                s.destination,
                concat_ws(' ', str.chemin, s.destination) as chemin,
                str.temps + s.temps as temps,
                array(select distinct fichier from unnest(str.fichiersnonrecuperes || sfnr.fichiersnonrecuperes) fichier) as fichiersnonrecuperes
            from strategie str
            inner join tmp.$($prefixe)_saut s on str.destination = s.source
            left join tmp.$($prefixe)_serveur_fichiersnonrecuperes sfnr on s.destination = sfnr.serveur
            where str.temps + s.temps <= $tempsRestant -- il ne faut pas dépasser le temps restant de récupération
            and str.temps + s.temps <= $tempsSautsServeursMax -- il ne faut pas dépasser le temps max accordé pour une itération de récupération
            and str.nbsauts < $nbSautsServeursMax -- il ne faut pas dépasser le nombre de sauts max accordé pour une itération de récupération
            and coalesce(array_length(str.fichiersnonrecuperes, 1), 0) < 10 -- on ne peut pas récupérer plus de 10 fichiers par itération
        )
        select
            chemin,
            temps,
            least(coalesce(array_length(fichiersnonrecuperes, 1), 0), 10) as nbfichiers,
            least(coalesce(array_length(fichiersnonrecuperes, 1), 0), 10)::numeric / temps as score
        from strategie
        where coalesce(array_length(fichiersnonrecuperes, 1), 0) > 1 -- il faut que l'itération permette a minima la récupération d'un fichier
        order by
            score desc,
            random()
        limit 5 -- limit à 5 pour voir ce que cela donne dans le fichier de sortie, possibilité de limiter à 1
"@

        $strategie = Import-Csv "$dossierRapports\strategie.csv" -Delimiter ';' -Encoding UTF8

        if ($strategie -ne $null) {
        
            # exécution de la stratégie de plus haut score retournée par la requête
            $etapes = @($strategie)[0].chemin.Split(' ')

            $i = 0
            $nbFichiersRecuperes = 0
        
            # itération sur les serveurs
            while ($i -lt $etapes.Count -and $nbFichiersRecuperes -lt 10) {

                # connexion au serveur
                [void]$sb.Append($etapes[$i])
                [void]$sb.Append(' ')

                # recherche des fichiers récupérables sur le serveur
                SIg-Exporter-CSV -csv "$dossierRapports\fichiers.csv" -requete @"
                with candidat as (
                    select unnest(fichiersnonrecuperes) as fichier from tmp.$($prefixe)_serveur_fichiersnonrecuperes where serveur = '$($etapes[$i])'
                )
                select c.fichier
                from candidat c
                inner join tmp.$($prefixe)_fichier f on c.fichier = f.fichier
                order by nbserveurs -- on privilégie les fichiers rares
"@
                $fichiers = Import-Csv "$dossierRapports\fichiers.csv" -Delimiter ';' -Encoding UTF8

                $j = 0
                $fichiersRecuperes = [Collections.ArrayList]::new()

                # itération sur les fichiers
                while ($fichiers -ne $null -and $j -lt @($fichiers).Count -and $nbFichiersRecuperes -lt 10) {

                    # récupération des fichiers
                    [void]$sb.Append($fichiers[$j].fichier)
                    [void]$sb.Append(' ')
                    $score++

                    [void]$fichiersRecuperes.Add("'$($fichiers[$j].fichier)'")
                    $nbFichiersRecuperes++
                    $j++
                }

                # marquage des fichiers comme récupérés
                SIg-Executer-Commande -commande "update tmp.$($prefixe)_fichier set recupere = true where fichier in ($([string]::Join(', ', $fichiersRecuperes.ToArray())))"

                $i++
            }

            $tempsRestant -= @($strategie)[0].temps
        
        }

    } while ($strategie -ne $null)

    $sb.ToString()
    $sb.ToString() | Out-File "$dossierRapports\resultat.txt"

}

Envoyer-Mail -de $email_generique -a $email_contact -sujet "Victoire" -corps "Score : $score ($prefixe)."

# nettoyage final
SIg-Effacer-Vue -vue "tmp.$($prefixe)_serveur_fichiersnonrecuperes" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  effacement tmp.$($prefixe)_serveur_fichiersnonrecuperes.txt"

SIg-Effacer-Table -table "tmp.$($prefixe)_serveur_fichiers" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  effacement tmp.$($prefixe)_serveur_fichiers.txt"
SIg-Effacer-Table -table "tmp.$($prefixe)_serveur_serveur" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  effacement tmp.$($prefixe)_serveur_serveur.txt"

#SIg-Effacer-Table -table "tmp.$($prefixe)_fichier" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  effacement tmp.$($prefixe)_fichier.txt"
SIg-Effacer-Table -table "tmp.$($prefixe)_saut" -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  effacement tmp.$($prefixe)_saut.txt"