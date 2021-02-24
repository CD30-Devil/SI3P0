# -----------------------------------------------------------------------------
# Fonctions spécifiques à si3p0 (SIg du Gard)
# -----------------------------------------------------------------------------

. ("$PSScriptRoot\constantes_si3p0.ps1")
. ("$PSScriptRoot\fonctions_outils.ps1")
. ("$PSScriptRoot\sig_défaut.ps1")

Add-Type -AssemblyName System.Web

# -----------------------------------------------------------------------------
# Génération d'un fichier HTML de liens pour l'accès aux pages du portail.
# Utilise le modèle présent dans les ressources de l'API.
# Sauvegarde le fichier HTLM de liens dans le dossier sous le nom index.html.
#
# $dossier : Le dossier pour lequel la fichier HTML doit être générée.
# $titre : Le titre de la page de liens.
# $exclure : La liste des sous-dossiers à exclure de l'analyse.
# -----------------------------------------------------------------------------
function SI3P0-Generer-Page-Liens {
    param (
        [parameter(Mandatory=$true)] [string] $dossier,
        [string] $titre = '',
        [string[]] $exclure
    )

    $divs = New-Object System.Text.StringBuilder

    foreach ($sousDossier in Get-ChildItem -Path "$dossier" -Directory) {

        [void]$divs.AppendLine("<div class=`"cadre_lien_liste`">")
        [void]$divs.AppendLine("<h2>$sousDossier</h2>")
        [void]$divs.AppendLine("<ul>")

        foreach ($fichier in (Get-ChildItem -Path "$dossier\$sousDossier" -Exclude $exclure)) {
            [void]$divs.AppendLine("<li><a href=`"./$sousDossier/$($fichier.Name)`">$($fichier.BaseName)</a></li>")
        }

        [void]$divs.AppendLine("</ul>")
        [void]$divs.AppendLine("</div>")
    }

    # chargement du modèle de page et insertion des divs
    $html = Get-Content "$PSScriptRoot\..\Ressources\modèle_page_liens.html"
    $html = $html.replace("<!-- inserer titre ici -->", $titre)
    $html = $html.replace("<!-- inserer contenu ici -->", $divs.ToString())

    $html | Out-File -LiteralPath "$dossier\index.html" -Force -Encoding utf8
}

# -----------------------------------------------------------------------------
# Ajout un texte d'information utilisable dans les cartes HTML.
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
# Génération d'une carte Leaflet sur la base de 1 à 5 vues/tables
# géographiques.
#
# $sources : Les vues/tables (5 maxi) décrivant les couches de la cartes.
#            Si un couche ligne ou polygone existe, la mettre en premier pour
#            que le zoom fonctionne.
# $carte : Le chemin de sauvegarde de la carte.
# $titre : Le titre de la carte.
# $daterTitre : Pour demander l'ajout de la date de génération dans le titre.
# $descriptionCouches : La description des couches dans l'ordre de $sources.
# $fondDePlan : Le fond de plan à afficher par défaut.
# $idInfo : L'identifiant du texte d'information à afficher sur le bouton
#           d'aide.
# $activerInfosBulles : Pour activer l'affichage des informations au survol.
# $replierBoiteControle : Pour replier la boîte de contrôle en haut à droite.
# $activerZoomClic : Pour activer le zoom auto lors du clic sur un élément
#                    d'une couche.
# $activerPermaliens : Pour activer la gestion des permaliens.
# $afficherNbEntites : Pour demander l'affichage du nombre d'entités de la
#                      couche à côté de sa description.
# $utilisateur : L'utilisateur pour la connexion à la base de données.
# -----------------------------------------------------------------------------
function SI3P0-Generer-Carte {
    param (
        [parameter(Mandatory=$true)] [string[]] $sources,
        [parameter(Mandatory=$true)] [string] $carte,
        [string] $titre = 'Carte DGAML',
        [bool] $daterTitre = $false,
        [string[]] $descriptionCouches,
        [string] $fondDePlan = 'cartoDB',
        [string] $idInfo = 'vue_defaut',
        [bool] $activerInfosBulles = $true,
        [bool] $replierBoiteControle = $false,
        [bool] $activerZoomClic = $true,
        [bool] $activerPermaliens = $false,
        [bool] $afficherNbEntites = $true,
        [string] $utilisateur = $sigUtilisateur
    )

    Afficher-Message-Date "Génération de la carte HTML issue de ($sources) vers $carte."

    $tableauSources = "array[$([string]::Join(', ', ($sources | select -First 5 | foreach {"'$($_.ToLower())'"})))]"
    $descrEncodeeCouches = New-Object System.Collections.ArrayList

    # encode les descriptions et aligne leur nombre sur celui des couches
    for ($i = 0; $i -lt 5; $i++) {
        if ($i -le $descriptionCouches.Count - 1) {
            [void]$descrEncodeeCouches.Add("'$([System.Web.HttpUtility]::HtmlEncode($descriptionCouches[$i]))'")
        }
        else {
            [void]$descrEncodeeCouches.Add("'Couche $($i + 1)'")
        }
    }

    # pour ajouter le nombre d'entités, génération d'une requête sql de comptage des données de la table/vue
    if ($afficherNbEntites) {
        for ($i = 0; $i -lt 5 -and $i -lt $sources.Count; $i++) {
            $descrEncodeeCouches[$i] = "$($descrEncodeeCouches[$i]) || ' (' || (select count(*) from $($sources[$i])) || ')'"
        }
    }

    $commande = `@"
        select vershtml_n(
            $tableauSources,
            (
                select count(*)::integer
                from pg_catalog.pg_class c
                inner join pg_catalog.pg_attribute a on a.attrelid = c.oid
                where c.relname = any($tableauSources)
                and a.attname = 'geom'
                and (pg_catalog.format_type(a.atttypid, a.atttypmod) ilike '%line%' or pg_catalog.format_type(a.atttypid, a.atttypmod) ilike '%polygon%')
            ),
            '$([System.Web.HttpUtility]::HtmlEncode($titre))',
            $($descrEncodeeCouches[0]),
            $($descrEncodeeCouches[1]),
            $($descrEncodeeCouches[2]),
            $($descrEncodeeCouches[3]),
            $($descrEncodeeCouches[4]),
            '$fondDePlan',
            $activerInfosBulles,
            $daterTitre,
            $replierBoiteControle,
            $activerZoomClic,
            $activerPermaliens,
            '$idInfo')
"@

    # passe par un fichier temporaire pour que la carte reste disponible à l'utilisateur le temps de la génération
    New-Item -ItemType Directory -Force -Path "$dossierTravailTemp\SI3P0-Generer-Carte\"
    $carteTemp = "$dossierTravailTemp\SI3P0-Generer-Carte\$(New-Guid).html"

    SIg-Executer-Commande -commande $commande -utilisateur $utilisateur -autresParams '--tuples-only', '--no-align' -sortie $carteTemp -erreur $false

    New-Item -ItemType Directory -Force -Path (Split-Path -Path $carte)
    Move-Item $carteTemp $carte -Force
}

# -----------------------------------------------------------------------------
# Conversion d'un fichier CSV en page HTML.
#
# $csv : Le chemin du fichier CSV source.
# $urlCsv : L'URL de téléchargement du fichier CSV.
# $html : Le chemin du HTML de sortie.
# $titre : Le titre du tableau.
# $delimiteur : Le délimiteur utilisé dans le CSV source.
# -----------------------------------------------------------------------------
function SI3P0-Convertir-CSV-Vers-HTML {
    param (
        [parameter(Mandatory=$true)] [string] $csv,
        [parameter(Mandatory=$true)] [string] $urlCsv,
        [parameter(Mandatory=$true)] [string] $html,
        [string] $titre = '',
        [string] $delimiteur = (Get-Culture).TextInfo.ListSeparator
    )

    $contenuCSV = Import-Csv $csv -Delimiter $delimiteur

    if ($contenuCSV.Count -ge 0) {

        $sb = New-Object System.Text.StringBuilder
        [void]$sb.AppendLine('<table class="csv2html">')
    
        [void]$sb.AppendLine('<thread>')
    
        # ajout du lien de téléchargement des données
        [void]$sb.AppendLine('<tr>')
        [void]$sb.AppendLine("<td colspan=""$($entetes.Length + 2)"">")
        [void]$sb.AppendLine("<a href=""$urlCsv"">Télécharger les données au format CSV...</a>")
        [void]$sb.AppendLine('</td>')
        [void]$sb.AppendLine('</tr>')

        # génération de la ligne d'entête du tableau
        [void]$sb.AppendLine('<tr>')
        [void]$sb.AppendLine('<th>#</th>')
        $contenuCSV[0].PSObject.Properties | foreach {
            [void]$sb.AppendLine("<th>$($_.Name)</th>")
        }
        [void]$sb.AppendLine('</tr>')

        [void]$sb.AppendLine('</thread>')

        # génération du corps du tableau
        [void]$sb.AppendLine('<tbody class="csv2html">')

        # ligne à ligne
        $numLig = 0
        $contenuCSV | foreach {

            $numLig++

            [void]$sb.AppendLine('<tr>')
            [void]$sb.AppendLine("<th>$numLig</th>")

            # colonne à colonne
            $_.PSObject.Properties | foreach {
                [void]$sb.Append("<td title=""#$numLig-$($_.Name)"">")
                
                if ($_.Name.StartsWith('Lien')) {
                    [void]$sb.Append("<a href=""$($_.Value)"" target=""_blank"">Accéder au lien</a>")
                }
                else {
                    [void]$sb.Append($_.Value)
                }

                [void]$sb.AppendLine('</td>')
            }

            [void]$sb.AppendLine('</tr>')
        }

        [void]$sb.AppendLine('</tbody>')
        [void]$sb.AppendLine('</table>')

        $code = Get-Content "$PSScriptRoot\..\Ressources\modèle_page_tableau.html"
        $code = $code.replace("<!-- inserer titre ici -->", $titre)
        $code = $code.replace("<!-- inserer contenu ici -->", $sb.ToString())

        $code | Out-File -LiteralPath $html -Force -Encoding utf8
    }
}