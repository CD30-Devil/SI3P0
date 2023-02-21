. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dateVersion = Read-Host -Prompt 'Merci d''indiquer la date de la version courante pour le nommage des archives (format : AAAAMM)'
$datePrecVersion = Read-Host -Prompt 'Merci d''indiquer la date de la précédente version qui doit logiquement être antérieure de 3 mois à la version courante (format : AAAAMM)'

# création des archives
SIg-Executer-Commande -commande "create table archive.pr_v$dateVersion as select * from m.pr"
SIg-Executer-Commande -commande "create table archive.troncon_v$dateVersion as select * from m.troncon"
SIg-Executer-Commande -commande "create table archive.giratoire_v$dateVersion as select * from m.giratoire"

# suppression des vues sur l'archive courante et précédente
SIg-Effacer-Vue -vue 'archive.pr_vprec'
SIg-Effacer-Vue -vue 'archive.troncon_vprec'
SIg-Effacer-Vue -vue 'archive.giratoire_vprec'

SIg-Effacer-Vue -vue 'archive.pr_vmax'
SIg-Effacer-Vue -vue 'archive.troncon_vmax'
SIg-Effacer-Vue -vue 'archive.giratoire_vmax'

# création des vues sur l'archive courante et précédente
SIg-Executer-Commande -commande "create view archive.pr_vprec as select * from archive.pr_v$datePrecVersion"
SIg-Executer-Commande -commande "create view archive.troncon_vprec as select * from archive.troncon_v$datePrecVersion"
SIg-Executer-Commande -commande "create view archive.giratoire_vprec as select * from archive.giratoire_v$datePrecVersion"

SIg-Executer-Commande -commande "create view archive.pr_vmax as select * from archive.pr_v$dateVersion"
SIg-Executer-Commande -commande "create view archive.troncon_vmax as select * from archive.troncon_v$dateVersion"
SIg-Executer-Commande -commande "create view archive.giratoire_vmax as select * from archive.giratoire_v$dateVersion"