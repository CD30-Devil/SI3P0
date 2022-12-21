﻿# -----------------------------------------------------------------------------
# Appel à l'API IGN de calcul d'isochrone.
# Retourne le GeoJSON résultat, une chaîne vide en cas d'échec.
#
# $x : La coordonnée X WGS84 du point initial.
# $y : La coordonnée Y WGS84 du point initial.
# $duree : La durée maximale de parcours.
# $unite : L'unité de temps (hour | minute | second).
# $direction : Pour indiquer s'il faut partir du (departure) ou atteindre le
#              point initial (arrival).
# $profil : Le mode de déplacement (car | pedestrian).
# $contraintes : Les contraintes à prendre en compte pour le parcours (cf.
#                documentation IGN du service).
# -----------------------------------------------------------------------------
function Calculer-Isochrone {
    param (
        [parameter(Mandatory=$true)] [double] $x,
        [parameter(Mandatory=$true)] [double] $y,
        [parameter(Mandatory=$true)] [int] $duree,
        [string] $unite = 'minute', 
        [string] $direction = 'departure',
        [string] $profil = 'car',
        [string] $contraintes = $null
    )

    $url = "https://wxs.ign.fr/calcul/geoportail/isochrone/rest/1.0.0/isochrone?point=$x,$y&resource=bdtopo-iso&costType=time&timeUnit=$unite&costValue=$duree&profile=$profil&direction=$direction"
    if ($contraintes) {
        $url += "&constraints=$contraintes"
    }
    
    Afficher-Message-Date -message "Calcul d'un isochrone autour de $x, $y" -couleur green
    Afficher-Message-Date -message $url -couleur gray

    $reponse = Invoke-WebRequest -Uri $url

    $geom = ''

    if ($reponse.StatusCode -eq 200) {
        # isole du résultat la géométrie
        $match = [Regex]::Match($reponse.Content, '"geometry"\s*:\s*({[^}]+})')

        if ($match.Success) {
            $geom = $match.Groups[1].Value
        }
    }
    
    $geom
}

# -----------------------------------------------------------------------------
# Appel à l'API IGN de calcul d'isodistance.
# Retourne le GeoJSON résultat, une chaîne vide en cas d'échec.
#
# $x : La coordonnée X WGS84 du point initial.
# $y : La coordonnée Y WGS84 du point initial.
# $distance : La distance maximale de parcours.
# $unite : L'unité de distance (meter | kilometer).
# $direction : Pour indiquer s'il faut partir du (departure) ou atteindre le
#              point initial (arrival).
# $profil : Le mode de déplacement (car | pedestrian).
# $contraintes : Les contraintes à prendre en compte pour le parcours (cf.
#                documentation IGN du service).
# -----------------------------------------------------------------------------
function Calculer-Isodistance {
    param (
        [parameter(Mandatory=$true)] [double] $x,
        [parameter(Mandatory=$true)] [double] $y,
        [parameter(Mandatory=$true)] [int] $distance,
        [string] $unite = 'meter',
        [string] $direction = 'departure',
        [string] $profil = 'car',
        [string] $contraintes = $null
    )

    $url = "https://wxs.ign.fr/calcul/geoportail/isochrone/rest/1.0.0/isochrone?point=$x,$y&resource=bdtopo-iso&costType=distance&distanceUnit=$unite&costValue=$distance&profile=$profil&direction=$direction"
    if ($contraintes) {
        $url += "&constraints=$contraintes"
    }

    Afficher-Message-Date -message "Calcul d'une isodistance autour de $x, $y" -couleur green
    Afficher-Message-Date -message $url -couleur gray
    
    $reponse = Invoke-WebRequest -Uri $url

    $geom = ''

    if ($reponse.StatusCode -eq 200) {
        # isole du résultat la géométrie
        $match = [Regex]::Match($reponse.Content, '"geometry"\s*:\s*({[^}]+})')

        if ($match.Success) {
            $geom = $match.Groups[1].Value
        }
    }
    
    $geom
}

# -----------------------------------------------------------------------------
# Appel à l'API IGN de calcul d'itinéraire.
# Retourne le GeoJSON résultat, une chaîne vide en cas d'échec.
#
# $xDepart : La coordonnée X WGS84 du point de départ.
# $yDepart : La coordonnée Y WGS84 du point de départ.
# $xArrivee : La coordonnée X WGS84 du point d'arrivée.
# $yArrivee : La coordonnée Y WGS84 du point d'arrivée.
# $ressource : La ressource utilisée pour le calcul (bdtopo-osrm | bdtopo-pgr).
# $profil : Le mode de déplacement (car | pedestrian).
# $parcours : Le type de parcours à calculer (fastest | shortest)
# -----------------------------------------------------------------------------
function Calculer-Itineraire {
    param (
        [parameter(Mandatory=$true)] [double] $xDepart,
        [parameter(Mandatory=$true)] [double] $yDepart,
        [parameter(Mandatory=$true)] [double] $xArrivee,
        [parameter(Mandatory=$true)] [double] $yArrivee,
        [string] $ressource = 'bdtopo-osrm',
        [string] $profil = 'car',
        [string] $parcours = 'fastest'
    )

    $url = "https://wxs.ign.fr/calcul/geoportail/itineraire/rest/1.0.0/route?resource=$ressource&start=$xDepart,$yDepart&end=$xArrivee,$yArrivee&profile=$profil&optimization=$parcours&getSteps=false"

    Afficher-Message-Date -message "Calcul d'une itinéraire entre $xDepart, $yDepart et $xArrivee, $yArrivee" -couleur green
    Afficher-Message-Date -message $url -couleur gray
    
    $reponse = Invoke-WebRequest -Uri $url

    $geom = ''

    if ($reponse.StatusCode -eq 200) {
        # isole du résultat la géométrie
        $match = [Regex]::Match($reponse.Content, '"geometry"\s*:\s*({[^}]+})')

        if ($match.Success) {
            $geom = $match.Groups[1].Value
        }
    }
    
    $geom
}