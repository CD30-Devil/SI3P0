# -----------------------------------------------------------------------------
# Fonctions spécifiques à si3p0 (SIg du Gard)
# -----------------------------------------------------------------------------

. ("$PSScriptRoot\constantes_si3p0.ps1")
. ("$PSScriptRoot\fonctions_outils.ps1")
. ("$PSScriptRoot\sig_défaut.ps1")

Add-Type -AssemblyName System.Web

# -----------------------------------------------------------------------------
# Génération d'une page HTML du portail.
# Utilise le modèle présent dans les ressources de l'API.
#
# $titre : Le titre de la page.
# $contenu : Le contenu de la page.
# $sortie : Le chemin de sauvegarde de la page.
# $activerBoutonAccueil : Pour demander l'affichage du bouton de retour à
#                         l'accueil du portail.
# -----------------------------------------------------------------------------
function SI3P0-Generer-Page-Portail {
    param (
        [parameter(Mandatory=$true)] [string] $titre,
        [parameter(Mandatory=$true)] [string] $contenu,
        [parameter(Mandatory=$true)] [string] $sortie,
        [bool] $activerBoutonAccueil = $true
    )

    $html = Get-Content "$PSScriptRoot\..\Ressources\modèle_page.html"
    $html = $html.replace("<!-- inserer titre ici -->", $titre)
    $html = $html.replace("<!-- inserer contenu ici -->", $contenu)

    if ($activerBoutonAccueil) {
        $html = [RegEx]::Replace($html, '<!-- retirer commentaire pour activer bouton accueil (.*)-->', '<$1>')
    }

    $html | Out-File $sortie -Force -Encoding utf8
}

# -----------------------------------------------------------------------------
# Génération de la page d'accueil du portail.
#
# Itère sur les dossiers présents dans Thématiques pour déterminer les tuiles
# à afficher.
#
# $exclure : Le thématiques à exclure de la génération.
# -----------------------------------------------------------------------------
function SI3P0-Generer-Accueil-Portail {
    param (
        [string[]] $exclure = $null
    )

    $contenu = [Text.StringBuilder]::new()

    # génération d'une tuile par thématique
    if ($exclure) {
        $dossiersThematiques = (Get-ChildItem $si3p0ThematiquesPortailWeb -Directory -Exclude $exclure).Name
    }
    else {
        $dossiersThematiques = (Get-ChildItem $si3p0ThematiquesPortailWeb -Directory).Name
    }

    foreach ($dossierThematique in $dossiersThematiques) {

        [void]$contenu.AppendLine("<div class=`"cadre_thematique`">")
        [void]$contenu.AppendLine("<a href=`"/Thématiques/$dossierThematique/`">")

        [void]$contenu.AppendLine("<div class=`"illustration_thematique`">")
        # /!\ placer une image "illustration.png" la thématique de taille 250px * 250px
        [void]$contenu.AppendLine("<img class=`"ajuste`" src=`"/Thématiques/$dossierThematique/illustration.png`" title=`"$dossierThematique`" alt=`"$dossierThematique`" />")
        [void]$contenu.AppendLine("</div>")

        [void]$contenu.AppendLine("<div class=`"titre_thematique`">$dossierThematique</div>")

        [void]$contenu.AppendLine("</a>")
        [void]$contenu.AppendLine("</div>")
    }

    SI3P0-Generer-Page-Portail -titre 'si3p0' -contenu $contenu.ToString() -activerBoutonAccueil $false -sortie "$si3p0PortailWeb\index.html"
}

# -----------------------------------------------------------------------------
# Génération de la page d'index d'une thématique du portail.
#
# $dossierThematique : Le dossier contenant les ressources de la thématique.
# $sortie : Le chemin de sauvegarde de la page.
# -----------------------------------------------------------------------------
function SI3P0-Generer-Thematique-Portail {
    param (
        [parameter(Mandatory=$true)] [string] $dossierThematique,
        [parameter(Mandatory=$true)] [string] $sortie
    )

    $contenu = [Text.StringBuilder]::new()

    [void]$contenu.AppendLine("<div class=`"cadre_arborescence`">")

    # parcours des sous-dossiers
    foreach ($dossier in Get-ChildItem $dossierThematique -Directory) {

        # cas 1 : le sous-dossier contient une page index.html
        if (Test-Path "$($dossier.FullName)\index.html") {

            # --> ajout d'un hyperlien vers le dossier
            [void]$contenu.AppendLine("<ul class=`"arborescence`">")
            [void]$contenu.AppendLine("<li class=`"arborescence_pliee`"><a href=`"./$dossier/`">$dossier</a></li>")
            [void]$contenu.AppendLine("</ul>")

        }
        # cas 2 : le sous-dossier ne contient par une page index.html mais contient des pages HTML ou des fichiers PDF
        elseif (Test-Path "$($dossier.FullName)\*" -Include '*.html', '*.pdf') {
            
            [void]$contenu.AppendLine("<ul class=`"arborescence`">")
            [void]$contenu.AppendLine("<li class=`"arborescence_depliee`">$dossier</li>")
            [void]$contenu.AppendLine("<ul class=`"arborescence`">")
            
            # --> ajout d'un hyperlien vers les fichiers .html, .htm et .pdf
            foreach ($fichier in Get-ChildItem "$($dossier.FullName)\*" -Include '*.html', '*.pdf') {
                [void]$contenu.AppendLine("<li class=`"arborescence_feuille`"><a href=`"./$($dossier.Name)/$($fichier.Name)`">$([IO.Path]::GetFileNameWithoutExtension($fichier))</a></li>")
            }

            [void]$contenu.AppendLine("</ul>")
            [void]$contenu.AppendLine("</ul>")
        }
    }

    [void]$contenu.AppendLine("</div>")

    SI3P0-Generer-Page-Portail -titre ([IO.Path]::GetFileName($dossierThematique)) -contenu $contenu.ToString() -sortie $sortie
}

# -----------------------------------------------------------------------------
# Génération de la page d'index des thématiques du portail.
#
# Itère sur les dossiers présents dans Thématiques pour déterminer les pages
# à générer.
# -----------------------------------------------------------------------------
function SI3P0-Generer-Thematiques-Portail {

    foreach ($dossierThematique in Get-ChildItem $si3p0ThematiquesPortailWeb -Directory) {
        SI3P0-Generer-Thematique-Portail -dossierThematique $dossierThematique.FullName -sortie "$($dossierThematique.FullName)/index.html"
    }
}

# -----------------------------------------------------------------------------
# Génération d'une page HTML du portail pour l'affichage du contenu d'un CSV.
#
# $csv : Le chemin vers le fichier CSV.
# $urlCsv : L'URL de téléchargement du fichier CSV.
# $sortie : Le chemin de sauvegarde de la page.
# $titre : Le titre de la page.
# $delimiteur : Le délimiteur utilisé dans le CSV.
# -----------------------------------------------------------------------------
function SI3P0-Generer-Tableau-Portail {
    param (
        [parameter(Mandatory=$true)] [string] $csv,
        [parameter(Mandatory=$true)] [string] $urlCsv,
        [parameter(Mandatory=$true)] [string] $sortie,
        [string] $titre = [IO.Path]::GetFileNameWithoutExtension($csv),
        [string] $delimiteur = (Get-Culture).TextInfo.ListSeparator
    )
    
    $contenuCSV = @(Import-Csv $csv -Delimiter $delimiteur)
    
    if ($contenuCSV.Count -ge 0) {

        $contenu = [Text.StringBuilder]::new()
        [void]$contenu.AppendLine('<table class="csv2html">')
    
        [void]$contenu.AppendLine('<thread>')
    
        # ajout du lien de téléchargement des données
        [void]$contenu.AppendLine('<tr>')
        [void]$contenu.AppendLine("<td colspan=""$($entetes.Length + 2)"">")
        [void]$contenu.AppendLine("<a href=""$urlCsv"">Télécharger les données au format CSV...</a>")
        [void]$contenu.AppendLine('</td>')
        [void]$contenu.AppendLine('</tr>')

        # génération de la ligne d'entête du tableau
        [void]$contenu.AppendLine('<tr>')
        [void]$contenu.AppendLine('<th>#</th>')
        $contenuCSV[0].PSObject.Properties | foreach {
            [void]$contenu.AppendLine("<th>$($_.Name)</th>")
        }
        [void]$contenu.AppendLine('</tr>')

        [void]$contenu.AppendLine('</thread>')

        # génération du corps du tableau
        [void]$contenu.AppendLine('<tbody class="csv2html">')

        # ligne à ligne
        $numLig = 0
        $contenuCSV | foreach {

            $numLig++

            [void]$contenu.AppendLine('<tr>')
            [void]$contenu.AppendLine("<th>$numLig</th>")

            # colonne à colonne
            $_.PSObject.Properties | foreach {
                [void]$contenu.Append("<td title=""#$numLig-$($_.Name)"">")
                
                if ($_.Name.StartsWith('Lien')) {
                    [void]$contenu.Append("<a href=""$($_.Value)"" target=""_blank"">Accéder au lien</a>")
                }
                else {
                    [void]$contenu.Append($_.Value)
                }

                [void]$contenu.AppendLine('</td>')
            }

            [void]$contenu.AppendLine('</tr>')
        }

        [void]$contenu.AppendLine('</tbody>')
        [void]$contenu.AppendLine('</table>')

        SI3P0-Generer-Page-Portail -titre $titre -contenu $contenu.ToString() -sortie $sortie
    }
}

# -----------------------------------------------------------------------------
# Génération d'une page HTML du portail pour l'affichage du contenu de chaque
# CSV présent dans un dossier donné.
#
# $dossier : Le chemin vers le dossier contenant les CSV.
# $urlCsv : L'URL du dossier contenant les CSV.
# $sortie : Le chemin de sauvegarde des pages.
# $delimiteur : Le délimiteur utilisé dans les CSV.
# -----------------------------------------------------------------------------
function SI3P0-Generer-Tableaux-Portail {
    param (
        [parameter(Mandatory=$true)] [string] $dossier,
        [parameter(Mandatory=$true)] [string] $urlDossier,
        [parameter(Mandatory=$true)] [string] $sortie,
        [string] $delimiteur = (Get-Culture).TextInfo.ListSeparator
    )

    foreach ($csv in Get-ChildItem "$dossier\*.csv") {
        SI3P0-Generer-Tableau-Portail -csv $csv -urlCsv "$urlDossier/$($csv.BaseName).csv" -sortie "$sortie\$($csv.BaseName).html"
    }
}

# -----------------------------------------------------------------------------
# Ajout un texte d'information utilisable dans les cartes HTML.
# Le texte d'information est encodé avant l'ajout.
#
# $identifiant : L'identifiant unique du texte d'information.
# $texte : Le texte d'information.
# -----------------------------------------------------------------------------
function SI3P0-Ajouter-Information-Carte {
    param (
        [parameter(Mandatory=$true)] [string] $identifiant,
        [parameter(Mandatory=$true)] [string] $texte
    )

    SIg-Executer-Commande -commande @"
delete from m.infos_carte where id = '$identifiant';
insert into m.infos_carte (id, texte_info) values ('$identifiant', '$([System.Web.HttpUtility]::HtmlEncode($texte).Replace([System.Environment]::NewLine, '<br>'))');
"@
}

# -----------------------------------------------------------------------------
# Ajout un texte d'information utilisable dans les cartes HTML.
# Le texte d'information doit être encodé avant l'appel.
#
# $identifiant : L'identifiant unique du texte d'information.
# $texte : Le texte d'information.
# -----------------------------------------------------------------------------
function SI3P0-Ajouter-Information-Encodee-Carte {
    param (
        [parameter(Mandatory=$true)] [string] $identifiant,
        [parameter(Mandatory=$true)] [string] $texte
    )

    SIg-Executer-Commande -commande @"
delete from m.infos_carte where id = '$identifiant';
insert into m.infos_carte (id, texte_info) values ('$identifiant', '$($texte.Replace([System.Environment]::NewLine, ''))');
"@
}

# -----------------------------------------------------------------------------
# Génération d'une carte Leaflet sur la base de vues/tables géographiques.
#
# $sources : Les vues/tables décrivant les couches de la cartes.
# $carte : Le chemin de sauvegarde de la carte.
# $titre : Le titre de la carte.
# $daterTitre : Pour demander l'ajout de la date de génération dans le titre.
# $fondDePlan : Le fond de plan à afficher par défaut.
# $idInfo : L'identifiant du texte d'information à afficher sur le bouton
#           d'aide.
# $nbCouchesActives : Nombre de couches actives par défaut.
# $activerInfosBulles : Pour activer l'affichage des informations au survol.
# $replierBoiteControle : Pour replier la boîte de contrôle en haut à droite.
# $activerZoomClic : Pour activer le zoom auto lors du clic sur un élément
#                    d'une couche.
# $activerPermaliens : Pour activer la gestion des permaliens.
# $activerPegman : Pour activer "Pegman", le bonhomme d'accès aux sites
#                  externes dont StreetView. Les valeurs possibles sont :
#                  - 0 : Désactivé
#                  - 1 : Street View uniquement
#                  - 2 : Sites 2D
#                  - 3 : Sites 3D
#                  - 4 : Sites 2D+3D
# $actualisationAuto : Délai pour l'actualisation automatique de la carte, 0
#                      pour désactiver.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# -----------------------------------------------------------------------------
function SI3P0-Generer-Carte {
    param (
        [parameter(Mandatory=$true)] [string[]] $sources,
        [parameter(Mandatory=$true)] [string] $carte,
        [string] $titre = 'Carte DGAML',
        [bool] $daterTitre = $false,
        [string] $fondDePlan = 'cartoDB',
        [string] $idInfo = 'vue_defaut',
        [int] $nbCouchesActives = $null,
        [bool] $activerInfosBulles = $true,
        [bool] $replierBoiteControle = $false,
        [bool] $activerZoomClic = $true,
        [bool] $activerPermaliens = $false,
        [int] $activerPegman = 4,
        [int] $actualisationAuto = 0,
        [string] $utilisateur = $sigUtilisateur
    )

    Afficher-Message-Date "Génération de la carte HTML issue de ($sources) vers $carte."

    $tableauSources = "array[$([string]::Join(', ', ($sources | foreach {"'$($_.ToLower())'"})))]"

    if (!$nbCouchesActives) {
        $nbCouchesActives = $sources.Count
    }

    $commande = `@"
        select vershtml_n(
            $tableauSources,
            '$([System.Web.HttpUtility]::HtmlEncode($titre))',
            '$fondDePlan',
            $activerInfosBulles,
            $daterTitre,
            $replierBoiteControle,
            $activerZoomClic,
            $activerPermaliens,
            '$idInfo',
            $actualisationAuto,
            $activerPegman,
            $nbCouchesActives)
"@

    # passe par un fichier temporaire pour que la carte reste disponible à l'utilisateur le temps de la génération
    New-Item -ItemType Directory -Force -Path "$dossierTravailTemp\SI3P0-Generer-Carte\"
    $carteTemp = "$dossierTravailTemp\SI3P0-Generer-Carte\$(New-Guid).html"

    SIg-Executer-Commande -commande $commande -utilisateur $utilisateur -autresParams '--tuples-only', '--no-align' -sortie $carteTemp -erreur $false

    New-Item -ItemType Directory -Force -Path (Split-Path -Path $carte)
    Move-Item $carteTemp $carte -Force
}