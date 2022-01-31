. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dateVersion = Read-Host -Prompt 'Merci d''indiquer la date de la version courante pour le nommage des archives (format : AAAAMM)'

# création des archives
SIg-Executer-Commande -commande "create table archive.pr_v$dateVersion as select * from m.pr"
SIg-Executer-Commande -commande "create table archive.troncon_v$dateVersion as select * from m.troncon"
SIg-Executer-Commande -commande "create table archive.giratoire_v$dateVersion as select * from m.giratoire"

# suppression des vues sur l'ancienne version la plus récente des archives
SIg-Effacer-Vue -vue 'archive.pr_vmax'
SIg-Effacer-Vue -vue 'archive.troncon_vmax'
SIg-Effacer-Vue -vue 'archive.giratoire_vmax'

# création des vues sur les archives nouvellement construites
SIg-Executer-Commande -commande "create view archive.pr_vmax as select * from archive.pr_v$dateVersion"
SIg-Executer-Commande -commande "create view archive.troncon_vmax as select * from archive.troncon_v$dateVersion"
SIg-Executer-Commande -commande "create view archive.giratoire_vmax as select * from archive.giratoire_v$dateVersion"