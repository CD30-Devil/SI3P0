﻿# -----------------------------------------------------------------------------
# Appel à Overpass.
#
# $requete : La requête à transmettre à Overpass.
# -----------------------------------------------------------------------------
function Overpass-Appeler {
    param(
        [parameter(Mandatory=$true)] [string] $requete
    )

    Afficher-Message-Date -message @"
Envoi à Overpass de la requête :
$requete
"@

    Invoke-WebRequest `
}