. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\préparer téléversement mapillary"
$dossierSQL = "$PSScriptRoot\..\SQL"

$dossierRapportsVaisala = "$dossierDonnees\Rapports Vaisala"
$dossierImages = "$dossierDonnees\Images"

# nettoyage préalable
Remove-Item "$dossierRapports\*.txt"
Remove-Item "$dossierRapports\*.err"
Remove-Item "$dossierRapports\*.csv"

Remove-Item "$dossierRapportsVaisala\*" -Exclude "*.zip"

SIg-Effacer-Table -table 'tmp.RapportVideoVaisala' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.RapportVideoVaisala.txt"
SIg-Effacer-Table -table 'tmp.RapportVideoVaisalaOrdonne' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.RapportVideoVaisalaOrdonne.txt"
SIg-Effacer-Table -table 'tmp.SequencesVaisala' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.SequencesVaisala.txt"

# extraction des rapports Vaisala (type de rapport attendu : image_dir_5)
foreach ($archive in (Get-ChildItem "$dossierRapportsVaisala\*.zip")) {
    7Z-Decompresser-Ici -archive $archive
}

# création de la table d'import des rapports vaisala
SIg-Creer-Table-Temp `    -table 'tmp.RapportVideoVaisala' `    -colonnes 'IdTroncon', 'NumeroRoute', 'ABS', 'Direction', 'Longitude', 'Latitude' , 'HeureUTC', 'URLImage', 'URLCarto' `    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - création tmp.RapportVideoVaisala.txt"

# import des rapports CSV
foreach ($csv in (Get-ChildItem "$dossierRapportsVaisala\*.csv")) {
    SIg-Importer-CSV `        -csv $csv -delimiteur ',' `        -table 'tmp.RapportVideoVaisala' `        -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - import $([IO.Path]::GetFileName($csv)).txt"
}

# exécution du script de préparation qui crée notamment la table tmp.SequencesVaisala
SIg-Executer-Fichier `
    -fichier "$dossierSQL\préparer téléversement mapillary.sql" `    -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  préparer téléversement mapillary.txt"

# export de la liste des séquences d'au moins 10 images en CSV
SIg-Exporter-CSV -requete 'select "IdSequence" from tmp.SequencesVaisala where "IdImage" = 10' -csv "$dossierRapports\séquences.csv"
$idSequences = Import-Csv "$dossierRapports\séquences.csv" | select -ExpandProperty IdSequence

# paramétrage des jobs (1 par séquence) de téléchargement des images et d'ajout des informations EXIF pour l'import Mapillary
$parametresJobs = [Collections.ArrayList]::new()

foreach ($idSequence in $idSequences) {

    [void]$parametresJobs.Add(@{
        
        racineAPI = "$PSScriptRoot\..\..\API\PowerShell"
        idSequence = $idSequence
        dossierRapports = $dossierRapports
        dossierImages = $dossierImages

        # bloc de script réalisé par chaque job : téléchargement des images de la séquence et ajout des informations EXIF pour l'import Mapillary
        script = {
            param (
                [object] $parametres
            )

            . ("$($parametres.racineAPI)\api_complète.ps1")
            Add-Type -AssemblyName PresentationCore
            
            # export des informations concernant la séquence (c-a-d la liste des images et leurs informations associées)
            SIg-Exporter-CSV `                -requete "select * from tmp.SequencesVaisala where `"IdSequence`" = $($parametres.idSequence)" `                -csv "$($parametres.dossierRapports)\seq_$($parametres.idSequence.PadLeft(4, '0')).csv"

            $images = Import-Csv "$($parametres.dossierRapports)\seq_$($parametres.idSequence.PadLeft(4, '0')).csv" -Delimiter ';'

            # supprime, s'il existe, le dossier cible de téléchargement des images de la séquence
            $dossierSequence = "$($parametres.dossierImages)\$($images[0].DebutSequence) - $($images[0].NumeroRoute) - $($images[0].Direction)"
            if (Test-Path $dossierSequence) {
                Remove-Item $dossierSequence -Recurse -Force
            }

            foreach ($image in $images) {

                $chemin = "$dossierSequence\img_$($image.IdImage.PadLeft(4, '0')).jpg"

                 # téléchargement de l'image (en version tmp)
                Telecharger `                    -url $image.URLImage `                    -enregistrerSous "$chemin.tmp"

                # préparation des informations EXIF à lier à l'image
                $metaDonnees = [Windows.Media.Imaging.BitmapMetadata]::new('jpg')

                # heure de prise de vue
                $metaDonnees.DateTaken = $image.DateHeure

                # latitude
                $metaDonnees.SetQuery('/app1/ifd/gps/subifd:{char=1}', [char]$image.LatitudeCard)
                $metaDonnees.SetQuery('/app1/ifd/gps/subifd:{ulong=2}', [uint64[]]@(
                    ([uint64]1 -shl 32) + [int]::Parse($image.LatitudeDeg)
                    ([uint64]1 -shl 32) + [int]::Parse($image.LatitudeMin)
                    ([uint64]10000 -shl 32) + [int]([double]::Parse($image.LatitudeSec, [CultureInfo]::InvariantCulture) * 10000)
                ))

                # longitude
                $metaDonnees.SetQuery('/app1/ifd/gps/subifd:{char=3}', [char]$image.LongitudeCard)
                $metaDonnees.SetQuery('/app1/ifd/gps/subifd:{ulong=4}', [uint64[]]@(
                    ([uint64]1 -shl 32) + [int]::Parse($image.LongitudeDeg)
                    ([uint64]1 -shl 32) + [int]::Parse($image.LongitudeMin)
                    ([uint64]10000 -shl 32) + [int]([double]::Parse($image.LongitudeSec, [CultureInfo]::InvariantCulture) * 10000)
                ))

                # angle
                $metaDonnees.SetQuery('/app1/ifd/gps/subifd:{char=16}', 'T')
                $metaDonnees.SetQuery('/app1/ifd/gps/subifd:{ulong=17}', ([uint64]100 -shl 32) + [int]([double]::Parse($image.Angle, [CultureInfo]::InvariantCulture) * 100))

                # création d'une copie de l'image avec ajout des informations EXIF
                $fluxLecture = [IO.FileStream]::new("$chemin.tmp", [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::Read)
                $fluxEcriture = [IO.FileStream]::new($chemin, [IO.FileMode]::Create, [IO.FileAccess]::ReadWrite, [IO.FileShare]::ReadWrite)
                
                $decodeur = [Windows.Media.Imaging.JpegBitmapDecoder]::new($fluxLecture, [Windows.Media.Imaging.BitmapCreateOptions]::None, [Windows.Media.Imaging.BitmapCacheOption]::Default)
                $encodeur = [Windows.Media.Imaging.JpegBitmapEncoder]::new()
                $encodeur.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($decodeur.Frames[0], $decodeur.Frames[0].Thumbnail, $metaDonnees, $decodeur.Frames[0].ColorContexts))
                $encodeur.Save($fluxEcriture)

                $fluxEcriture.Close()
                $fluxLecture.Close()

                # suppression de l'image temporaire
                Remove-Item "$chemin.tmp"

            }
        }
    })
}

# exécution des jobs de téléchargement des images et d'ajout des informations EXIF pour l'import Mapillary
Executer-Jobs -parametresJobs $parametresJobs

# nettoyage final
Remove-Item "$dossierRapportsVaisala\*" -Exclude "*.zip"

SIg-Effacer-Table -table 'tmp.RapportVideoVaisala' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.RapportVideoVaisala.txt"
SIg-Effacer-Table -table 'tmp.RapportVideoVaisalaOrdonne' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.RapportVideoVaisalaOrdonne.txt"
SIg-Effacer-Table -table 'tmp.SequencesVaisala' -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') - effacement tmp.SequencesVaisala.txt"