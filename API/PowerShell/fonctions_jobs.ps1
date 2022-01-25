. ("$PSScriptRoot\fonctions_outils.ps1")

# -----------------------------------------------------------------------------
# Exécution en parrallèle de plusieurs jobs.
#
# Le délai induit par le lancement et l'attente d'un job n'est pas neutre.
# Pour optimiser, il convient donc de trouver un équilibre entre le nombre de
# jobs et le travail réalisé par chacun. Ainsi, si 32000 éléments sont à
# traiter, il peut être plus optimal de faire traiter 1000 éléments à 32 jobs
# que de lancer 32000 jobs unitaires.
#
# $parametresJobs : Les paramètres des jobs.
#                   Un job est lancé pour chaque élément de ce tableau.
#                   Chaque paramètre doit a minima contenir un attribut .script
#                   correspondant au code à exécuter.
# $nombreJobs : Le nombre maximal de jobs en parrallèle, par défaut égal au
#               nombre de coeurs - 1.
# afficherSortieJobs : Pour demander l'affichage des sorties des jobs.
# -----------------------------------------------------------------------------
function Executer-Jobs {
    param (
        [parameter(Mandatory=$true)] [object[]] $parametresJobs,
        [int] $nombreJobs = $env:NUMBER_OF_PROCESSORS - 1,
        [bool] $afficherSortieJobs = $true
    )

    Afficher-Message-Date -message "Execution de $($parametresJobs.Count) jobs en $nombreJobs lancements parrallèles."

    $jobsEnCours = [Collections.ArrayList]::new($nombreJobs)

    foreach ($parametresJob in $parametresJobs) {
        
        # lancement de jobs en parralèle jusqu'à atteindre le seuil max
        $job = Start-Job $parametresJob.script -ArgumentList $parametresJob
        [void]$jobsEnCours.Add($job)

        # lorsque le seuil est atteint, attente de la fin d'un job avant de lancer le suivant
        if ($jobsEnCours.Count -ge $nombreJobs) {
            $job = Wait-Job -Job $jobsEnCours -Any
            [void]$jobsEnCours.Remove($job)

            if ($afficherSortieJobs) { $job | Receive-Job }
            $job | Remove-Job
            $job = $null
        }
    }

    # attente des jobs restants
    while ($jobsEnCours.Count -gt 0) {
        $job = Wait-Job -Job $jobsEnCours -Any
        [void]$jobsEnCours.Remove($job)

        if ($afficherSortieJobs) { $job | Receive-Job }
        $job | Remove-Job
        $job = $null
    }

    Afficher-Message-Date -message "Execution des $($parametresJobs.Count) jobs terminée."
}

# -----------------------------------------------------------------------------
# Fragmentation d'une liste en X sous-listes.
#
# La fonction utilise un modulo pour répartir les éléments de la liste dans les
# fragments.
#
# $liste : La liste à fragmenter.
# $nombreFragments : Le nombre maximum de fragments.
# -----------------------------------------------------------------------------
function Fragmenter-Liste {
    param (
        [parameter(Mandatory=$true)] [object[]] $liste,
        [parameter(Mandatory=$true)] [int] $nombreFragments
    )

    $fragments = [Collections.ArrayList]::new()
    $numeroElement = -1

    foreach ($element in $liste) {

        $numeroElement++
        $modulo = $numeroElement % $nombreFragments

        # si besoin, ajout d'un fragment
        if ($modulo + 1 -gt $fragments.Count) {
            [void]$fragments.Add(([Collections.ArrayList]::new()))
        }

        # ajout de l'élément de la liste au fragment
        [void]$fragments[$modulo].Add($element)
    }

    $fragments
}