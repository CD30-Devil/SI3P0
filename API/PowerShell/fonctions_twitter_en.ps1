. ("$PSScriptRoot\fonctions_twitter.ps1")

#region Tools functions for Twitter API call

function Twitter-Create-Identifiers {
    param (
        [parameter(Mandatory=$true)] [string] $apiKey,
        [parameter(Mandatory=$true)] [string] $apiSecretKey,
        [parameter(Mandatory=$true)] [string] $accessToken,
        [parameter(Mandatory=$true)] [string] $accessTokenSecret
    )

    Twitter-Creer-Identifiants -cle $apiKey -cleSecrete $apiSecretKey -jeton $accessToken -jetonSecret $accessTokenSecret
}

function Twitter-Escape-String {
    param (
        [parameter(Mandatory=$true)] [string] $string
    )

    Twitter-Encoder-Chaine -chaine $string
}

function Twitter-Prepare-Call {
    param (
        [parameter(Mandatory=$true)] [string] $endpoint,
        [parameter(Mandatory=$true)] [string] $method,
        [string] $contentType = 'application/x-www-form-urlencoded',
        [parameter(Mandatory=$true)] [hashtable] $callParams
    )

    Twitter-Preparer-Appel -pointAppel $endpoint -methodeAppel $method -typeMIME $contentType -paramsAppel $callParams
}

function Twitter-Compute-Signature {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $identifiers,
        [parameter(Mandatory=$true)] [pscustomobject] $callInfos
    )

    Twitter-Calculer-Signature -identifiants $identifiers -infosAppel $callInfos
}

function Twitter-Compute-Authentification {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $callInfos
    )

    Twitter-Calculer-Authentification -infosAppel $callInfos
}

function Twitter-Call {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $callInfos
    )

    Twitter-Appeler -infosAppel $callInfos
}

#endregion

#region "Tweets / Post, retrieve, and engage with Tweets"

function Twitter-Update-Status {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $identifiers,
        [parameter(Mandatory=$true)] [string] $status,
        [uint64] $in_reply_to_status_id = $null,
        [bool] $auto_populate_reply_metadata = $false,
        [string[]] $exclude_reply_user_ids = $null,
        [string] $attachment_url = $null,
        [uint64[]] $media_ids = $null,
        [bool] $possibly_sensitive = $false,
        [double] $lat = $null,
        [double] $long = $null,
        [string] $place_id = $null,
        [bool] $display_coordinates = $false,
        [bool] $trim_user = $false,
        [bool] $enable_dmcommands = $false,
        [bool] $fail_dmcommands = $false,
        [string] $card_uri = $null
    )

    Twitter-Modifier-Statut `        -identifiants $identifiers `        -statut $status `        -enReponseA $in_reply_to_status_id `        -mentionsAutomatique $auto_populate_reply_metadata `        -exclureMentions $exclude_reply_user_ids `        -urlAttachee $attachment_url `        -idMedias $media_ids `        -sensible $possibly_sensitive `        -lat $lat `        -long $long `        -idEmplacement $place_id `        -afficherCoord $display_coordinates `        -reduireUtilisateur $trim_user `        -activerCommandesDM $enable_dmcommands `        -echecCommandesDM $fail_dmcommands `        -uriCarte $card_uri
}

function Twitter-Destroy-Status {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $identifiers,
        [parameter(Mandatory=$true)] [uint64] $id,
        [bool] $trim_user = $false
    )

    Twitter-Effacer-Statut -identifiants $identifiers -id $id -reduireUtilisateur $trim_user
}

#endregion

#region "Tweets / Get Tweet timelines"

function Twitter-Home-Timeline {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $identifiers,
        [int] $count = $null,
        [uint64] $since_id = $null,
        [uint64] $max_id = $null,
        [bool] $trim_user = $false,
        [bool] $exclude_replies = $false,
        [bool] $include_entities = $false
    )

    Twitter-Obtenir-Statuts `        -identifiants $identifiers `        -nombre $count `        -apres $since_id `        -avant $max_id `
        -reduireUtilisateur $trim_user `        -exclureReponses $exclude_replies `        -inclureEntites $include_entities
}

#endregion

#region "Media / Upload media"

function Twitter-Upload-Media {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $identifiers,
        [parameter(Mandatory=$true)] [string] $mediaPath,
        [uint64[]] $additional_owners = $null
    )

    Twitter-Televerser-Media -identifiants $identifiers -cheminMedia $mediaPath -autresProprietaires $additional_owners
}

function Twitter-Upload-Media-Simple {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $identifiers,
        [parameter(Mandatory=$true)] [string] $mediaPath,
        [uint64[]] $additional_owners = $null
    )

    Twitter-Televerser-Media-Simple -identifiants $identifiers -cheminMedia $mediaPath -autresProprietaires $additional_owners
}

#endregion