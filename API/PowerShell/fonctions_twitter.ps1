#region Fonctions outils pour l'appel à l'API Twitter.

Add-Type -AssemblyName System.Web

# -----------------------------------------------------------------------------
# Encodage d'un chaîne pour appel à Twitter.
#
# Cette fonction complète l'appel à [Uri]::EscapeDataString qui en version 4.0
# du framework n'encodait pas certains caractères.
#
# Fonction modifiée en 4.5 : 
# https://docs.microsoft.com/en-us/dotnet/framework/migration-guide/runtime/4.0-4.5
#
# $chaine : La chaine à encoder.
# -----------------------------------------------------------------------------
function Twitter-Encoder-Chaine {
    param (
        [parameter(Mandatory=$true)] [string] $chaine
    )

    $encode = [Text.StringBuilder]::new([Uri]::EscapeDataString($chaine))

    foreach ($special in @("!", "*", "'", "(", ")")) {
        [void]$encode.Replace($special, [Uri]::HexEscape($special))
    }

    $encode.ToString()
}

# -----------------------------------------------------------------------------
# Création d'un objet porteur des différentes informations d'identification
# nécessaires pour l'appel à l'API Twitter.
#
# $cle : La clé (API key).
# $cleSecrete : La clé secrète (API secret key).
# $jeton : Le jeton d'accés (access token).
# $jetonSecret : Le jeton secret d'accés (access token secret).
# -----------------------------------------------------------------------------
function Twitter-Creer-Identifiants {
    param (
        [parameter(Mandatory=$true)] [string] $cle,
        [parameter(Mandatory=$true)] [string] $cleSecrete,
        [parameter(Mandatory=$true)] [string] $jeton,
        [parameter(Mandatory=$true)] [string] $jetonSecret
    )

    [pscustomobject] @{
        cle = $cle
        cleSecrete = $cleSecrete
        jeton = $jeton
        jetonSecret = $jetonSecret
    }
}

# -----------------------------------------------------------------------------
# Préparation d'un appel à l'API Twitter.
#
# $pointAppel : L'URL de l'API.
# $methodeAppel : La méthode d'appel (GET, POST).
# $typeMIME : Le type MIME (application/x-www-form-urlencoded,
#             multipart/form-data).
# $paramsAppel : Les paramètres de l'API.
# -----------------------------------------------------------------------------
function Twitter-Preparer-Appel {
    param (
        [parameter(Mandatory=$true)] [string] $pointAppel,
        [parameter(Mandatory=$true)] [string] $methodeAppel,
        [string] $typeMIME = 'application/x-www-form-urlencoded',
        [parameter(Mandatory=$true)] [hashtable] $paramsAppel
    )

    [pscustomobject] @{
        pointAppel = $pointAppel
        methodeAppel = $methodeAppel.ToUpperInvariant()
        typeMIME = $typeMIME
        paramsAppel = $paramsAppel
        paramsAuthentification = @{
            'oauth_consumer_key' = $identifiants.cle
            'oauth_nonce' = ((New-Guid).ToString().Replace('-', ''))
            'oauth_signature_method' = 'HMAC-SHA1'
            'oauth_timestamp' = ([string]([Math]::Round(([DateTime]::UtcNow - [DateTime]::new(1970, 1, 1)).TotalSeconds, 0)))
            'oauth_token' = $identifiants.jeton
            'oauth_version' = '1.0'
        }
    }
}

# -----------------------------------------------------------------------------
# Calcul de la signature d'appel.
# La signature calculée est ajoutée aux informations d'appel.
#
# Se référer à la documentation de l'API pour plus de détails :
# https://developer.twitter.com/en/docs/authentication/oauth-1-0a/creating-a-signature
#
# $identifiants : Les identifiants Twitter.
# $infosAppel : Les informations relatives à l'appel API à faire.
# -----------------------------------------------------------------------------
function Twitter-Calculer-Signature {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $identifiants,
        [parameter(Mandatory=$true)] [pscustomobject] $infosAppel
    )

    $hash = @{ }

    # cf. section de la documentation Twitter : Collecting the request method and URL
    $hash['method'] = $infosAppel.methodeAppel
    $hash['url'] = $infosAppel.pointAppel

    # cf. section de la documentation Twitter : Collecting parameters
    # les paramètres passés en formulaire ne sont pas utilisés pour le calcul de la signature
    if ($infosAppel.methodeAppel -eq 'GET' -or $infosAppel.typeMIME -ne 'multipart/form-data') {
        foreach ($param in $infosAppel.paramsAppel.GetEnumerator()) {
            $hash[$param.Key] = $param.Value
        }
    }

    foreach ($param in $infosAppel.paramsAuthentification.GetEnumerator()) {
        $hash[$param.Key] = $param.Value
    }

    # cf. section de la documentation Twitter : Creating the signature base string
    $baseSignature = [Text.StringBuilder]::new()

    [void]$baseSignature.Append($hash['method'])
    [void]$baseSignature.Append('&')

    [void]$baseSignature.Append((Twitter-Encoder-Chaine -chaine $hash['url']))
    [void]$baseSignature.Append('&')

    [void]$baseSignature.Append(
        (Twitter-Encoder-Chaine -chaine (`
            ($hash.GetEnumerator() `
                | sort { [Uri]::EscapeDataString($_.Key) } `                | where { $_.Key -ne 'method' -and $_.Key -ne 'url' } `
                | select @{ label = 'paire'; expression = { "$($_.Key)=$($_.Value)" } } `                | select -ExpandProperty 'paire' `            ) -join '&')
        )
    )

    # cf. section de la documentation Twitter : Getting a signing key
    $cleDeSignature = "$(Twitter-Encoder-Chaine -chaine $identifiants.cleSecrete)&$(Twitter-Encoder-Chaine -chaine $identifiants.jetonSecret)"

    # cf. section de la documentation Twitter : Calculating the signature
    $hmacsha1 = [Security.Cryptography.HMACSHA1]::new([Text.Encoding]::ASCII.GetBytes($cleDeSignature))
    
    $signature = [Convert]::ToBase64String($hmacsha1.ComputeHash([Text.Encoding]::ASCII.GetBytes($baseSignature.ToString())))
    $infosAppel.paramsAuthentification['oauth_signature'] = $signature

    $hmacsha1.Dispose()
    $hmacsha1 = $null
}

# -----------------------------------------------------------------------------
# Calcul de l'entête d'authentification.
#
# Se référer à la documentation de l'API pour plus de détails :
# https://developer.twitter.com/en/docs/authentication/oauth-1-0a/authorizing-a-request
#
# $identifiants : Les identifiants Twitter.
# $infosAppel : Les informations relatives à l'appel API à faire.
# -----------------------------------------------------------------------------
function Twitter-Calculer-Authentification {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $infosAppel
    )

    $entete = 'OAuth '

    $entete += (        $infosAppel.paramsAuthentification.GetEnumerator() `            | sort -Property { $_.Key } `            | select @{label = 'paire'; expression = { "$($_.Key)=`"$(Twitter-Encoder-Chaine -chaine $_.Value)`"" } } `
            | select -ExpandProperty 'paire'
    ) -join ', '
    
    $entete
}

# -----------------------------------------------------------------------------
# Appel de l'API Twitter.
#
# $infosAppel : Les informations relatives à l'appel API à faire.
# -----------------------------------------------------------------------------
function Twitter-Appeler {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $infosAppel
    )


    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls13 -bor [System.Net.SecurityProtocolType]::Ssl3


    # les paramètres sont passées en fonction de la nature de l'appel

    # GET -> paramètres sur l'URL sous la forme clé=valeur
    if ($infosAppel.methodeAppel -eq 'GET') {
        
        $paramsAppel = (            $infosAppel.paramsAppel.GetEnumerator() `                | select @{label = 'paire'; expression = { "$($_.Key)=$($_.Value)" } } `
                | select -ExpandProperty 'paire'
        ) -join '&'

        Invoke-RestMethod `            -UseBasicParsing `            -Method $infosAppel.methodeAppel `            -Uri "$($infosAppel.pointAppel)?$paramsAppel" `            -Headers @{ 'Authorization' = $(Twitter-Calculer-Authentification -infosAppel $infosAppel) } `            -ContentType $infosAppel.typeMIME `

    }

    # POST - x-www-form-urlencoded -> paramètres dans le corps de la requête sous la forme clé=valeur
    elseif ($infosAppel.methodeAppel -eq 'POST' -and $infosAppel.typeMIME -eq 'application/x-www-form-urlencoded') {
        
        $paramsAppel = (            $infosAppel.paramsAppel.GetEnumerator() `                | select @{label = 'paire'; expression = { "$($_.Key)=$($_.Value)" } } `
                | select -ExpandProperty 'paire'
        ) -join '&'

        Invoke-RestMethod `            -UseBasicParsing `            -Method $infosAppel.methodeAppel `            -Uri $infosAppel.pointAppel `            -Headers @{ 'Authorization' = $(Twitter-Calculer-Authentification -infosAppel $infosAppel) } `            -ContentType $infosAppel.typeMIME `            -Body $paramsAppel

    }

    # POST - form-data -> paramètres dans le corps de la requête sous la forme d'un formulaire
    elseif ($infosAppel.methodeAppel -eq 'POST' -and $infosAppel.typeMIME -eq 'multipart/form-data') {
        
        $demarcation = [Guid]::NewGuid().ToString()
        $paramsAppel = ""

        foreach ($param in $infosAppel.paramsAppel.GetEnumerator()) {
            $paramsAppel += "--$demarcation`r`n"
            $paramsAppel += "Content-Disposition: form-data; name=`"$($param.Key)`"`r`n"
            $paramsAppel += "`r`n$($param.Value)`r`n"
        }
        $paramsAppel += "--$demarcation--"

        # -ContentType "multipart/form-data; boundary=`"$demarcation`"" `
        Invoke-RestMethod `            -UseBasicParsing `            -Method $infosAppel.methodeAppel `            -Uri $infosAppel.pointAppel `            -Headers @{ 'Authorization' = $(Twitter-Calculer-Authentification -infosAppel $infosAppel) } `            -ContentType "multipart/form-data; boundary=`"$demarcation`"" `            -Body $paramsAppel

    }

    else {
        throw 'Paramètrage d''appel à Twitter non géré.'
    }
}

#endregion

#region Fonctions de le section "Tweets / Post, retrieve, and engage with Tweets"
# https://developer.twitter.com/en/docs/twitter-api/v1/tweets/post-and-engage/overview

# -----------------------------------------------------------------------------
# Mise à jour du statut de l'utilisateur courant (Tweeter).
#
# Se référer à la documentation de l'API pour plus de détails :
# https://developer.twitter.com/en/docs/twitter-api/v1/tweets/post-and-engage/api-reference/post-statuses-update
# -----------------------------------------------------------------------------
function Twitter-Modifier-Statut {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $identifiants,
        [parameter(Mandatory=$true)] [string] $statut, # status
        [uint64] $enReponseA = $null, # in_reply_to_status_id
        [bool] $mentionsAutomatique = $false, # auto_populate_reply_metadata
        [string[]] $exclureMentions = $null, # exclude_reply_user_ids
        [string] $urlAttachee = $null, # attachment_url
        [uint64[]] $idMedias = $null, # media_ids
        [bool] $sensible = $false, # possibly_sensitive
        [double] $lat = $null, # lat
        [double] $long = $null, # long
        [string] $idEmplacement = $null, # place_id
        [bool] $afficherCoord = $false, # display_coordinates
        [bool] $reduireUtilisateur = $false, # trim_user
        [bool] $activerCommandesDM = $false, # enable_dmcommands
        [bool] $echecCommandesDM = $false, # fail_dmcommands
        [string] $uriCarte = $null # card_uri
    )

    $paramsAppel = @{
        'status' = (Twitter-Encoder-Chaine -chaine $statut)
    }

    if ($enReponseA) { $paramsAppel['in_reply_to_status_id'] = $enReponseA }
    if ($mentionsAutomatique) { $paramsAppel['auto_populate_reply_metadata'] = 'true' }
    if ($exclureMentions) { $paramsAppel['exclude_reply_user_ids'] = (Twitter-Encoder-Chaine -chaine ($exclureMentions -join ',')) }
    if ($idMedias) { $paramsAppel['media_ids'] = (Twitter-Encoder-Chaine -chaine (($idMedias | select -first 4) -join ',')) }
    if ($urlAttachee) { $paramsAppel['attachment_url'] = (Twitter-Encoder-Chaine -chaine $urlAttachee) }
    if ($sensible) { $paramsAppel['possibly_sensitive'] = 'true' }
    if ($lat) { $paramsAppel['lat'] = $lat }
    if ($long) { $paramsAppel['long'] = $long }
    if ($idEmplacement) { $paramsAppel['place_id'] = $idEmplacement }
    if ($afficherCoord) { $paramsAppel['display_coordinates'] = 'true' }
    if ($reduireUtilisateur) { $paramsAppel['trim_user'] = 'true' }
    if ($activerCommandesDM) { $paramsAppel['enable_dmcommands'] = 'true' }
    if ($echecCommandesDM) { $paramsAppel['fail_dmcommands'] = 'true' }
    if ($uriCarte) { $paramsAppel['card_uri'] = (Twitter-Encoder-Chaine -chaine $uriCarte) }

    $infosAppel = Twitter-Preparer-Appel `        -pointAppel 'https://api.twitter.com/1.1/statuses/update.json' `        -methodeAppel 'POST' `        -paramsAppel $paramsAppel

    Twitter-Calculer-Signature -identifiants $identifiants -infosAppel $infosAppel
    Twitter-Appeler -infosAppel $infosAppel
}

# -----------------------------------------------------------------------------
# Effacement d'un statut.
#
# Se référer à la documentation de l'API pour plus de détails :
# https://developer.twitter.com/en/docs/twitter-api/v1/tweets/post-and-engage/api-reference/post-statuses-destroy-id
# -----------------------------------------------------------------------------
function Twitter-Effacer-Statut {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $identifiants,
        [parameter(Mandatory=$true)] [uint64] $id, # id
        [bool] $reduireUtilisateur = $false # trim_user
    )

    $paramsAppel = @{
        'id' = $id
    }

    if ($reduireUtilisateur) { $paramsAppel['trim_user'] = 'true' }

    $infosAppel = Twitter-Preparer-Appel `        -pointAppel "https://api.twitter.com/1.1/statuses/destroy/$id.json" `        -methodeAppel 'POST' `        -paramsAppel $paramsAppel

    Twitter-Calculer-Signature -identifiants $identifiants -infosAppel $infosAppel
    Twitter-Appeler -infosAppel $infosAppel
}

#endregion

#region Fonctions de le section "Tweets / Get Tweet timelines"
# https://developer.twitter.com/en/docs/twitter-api/v1/tweets/timelines/overview

# -----------------------------------------------------------------------------
# Récupération des statuts de l'utilisateur courant.
#
# Se référer à la documentation de l'API pour plus de détails :
# https://developer.twitter.com/en/docs/twitter-api/v1/tweets/timelines/api-reference/get-statuses-home_timeline
# -----------------------------------------------------------------------------
function Twitter-Obtenir-Statuts {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $identifiants,
        [int] $nombre = $null, # count
        [uint64] $apres = $null, # since_id
        [uint64] $avant = $null, # max_id
        [bool] $reduireUtilisateur = $false, # trim_user
        [bool] $exclureReponses = $false, # exclude_replies
        [bool] $inclureEntites = $false # include_entities
    )

    $paramsAppel = @{ }

    if ($nombre) { $paramsAppel['count'] = $nombre }
    if ($apres) { $paramsAppel['since_id'] = $apres }
    if ($avant) { $paramsAppel['max_id'] = $avant }
    if ($reduireUtilisateur) { $paramsAppel['trim_user'] = 'true' }
    if ($exclureReponses) { $paramsAppel['exclude_replies'] = 'true' }
    if ($inclureEntites) { $paramsAppel['include_entities'] = 'true' }

    $infosAppel = Twitter-Preparer-Appel `                -pointAppel 'https://api.twitter.com/1.1/statuses/home_timeline.json' `                -methodeAppel 'GET' `                -paramsAppel $paramsAppel

    Twitter-Calculer-Signature -identifiants $identifiants -infosAppel $infosAppel
    Twitter-Appeler -infosAppel $infosAppel
}

#endregion

#region Fonctions de la section "Media / Upload media"
# https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/overview

# -----------------------------------------------------------------------------
# Téléversement d'un média par partie.
#
# Se référer à la documentation de l'API pour plus de détails :
# https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload-init
# https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload-append
# https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload-finalize
# -----------------------------------------------------------------------------
function Twitter-Televerser-Media {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $identifiants,
        [parameter(Mandatory=$true)] [string] $cheminMedia,
        [uint64[]] $autresProprietaires = $null
    )
    
    # Phase INIT
    $paramsAppel = @{
        'command' = 'INIT'
        'total_bytes' = (Get-ChildItem $cheminMedia).Length
        'media_type' = [Web.MimeMapping]::GetMimeMapping($cheminMedia)
    }

    if ($autresProprietaires) { $paramsAppel['additional_owners'] = (Twitter-Encoder-Chaine -chaine ($autresProprietaires -join ',')) }

    $infosAppel = Twitter-Preparer-Appel `        -pointAppel 'https://upload.twitter.com/1.1/media/upload.json' `        -methodeAppel 'POST' `        -paramsAppel $paramsAppel

    Twitter-Calculer-Signature -identifiants $identifiants -infosAppel $infosAppel
    $reponseInit = Twitter-Appeler -infosAppel $infosAppel

    # récupération de l'id du média pour les phases suivantes
    $idMedia = $reponseInit.media_id
    
    # Phase APPEND
    $segment = 0
    $flux = [IO.File]::OpenRead($cheminMedia)
    $buffer = [byte[]]::new(2 * 1024 * 1024)

    # transfert du fichier par partie de 2 Mo
    while (($nbOctets = $flux.Read($buffer, 0, 2 * 1024 * 1024)) -ne 0) {
        
        $media = [Text.StringBuilder]::new()

        for ($n = 0; $n -lt $nbOctets; $n++) {
            [void]$media.Append([Convert]::ToChar($buffer[$n]))
        }

        $infosAppel = Twitter-Preparer-Appel `            -pointAppel 'https://upload.twitter.com/1.1/media/upload.json' `            -methodeAppel 'POST' `            -typeMIME 'multipart/form-data' `            -paramsAppel @{
                'command' = "APPEND"
                'media_id' = "$idMedia"
                'media' = $media.ToString()
                'segment_index' = "$segment"
            }

        Twitter-Calculer-Signature -identifiants $identifiants -infosAppel $infosAppel
        Twitter-Appeler -infosAppel $infosAppel | Out-Null

        $segment++
    }

    $flux.Close()
    $flux = $null
    
    # Phase FINALIZE
    $infosAppel = Twitter-Preparer-Appel `        -pointAppel 'https://upload.twitter.com/1.1/media/upload.json' `        -methodeAppel 'POST' `        -paramsAppel @{
            'command' = 'FINALIZE'
            'media_id' = $idMedia
        }

    Twitter-Calculer-Signature -identifiants $identifiants -infosAppel $infosAppel
    Twitter-Appeler -infosAppel $infosAppel
}

# -----------------------------------------------------------------------------
# Téléversement simple d'un média.
#
# Se référer à la documentation de l'API pour plus de détails :
# https://developer.twitter.com/en/docs/twitter-api/v1/media/upload-media/api-reference/post-media-upload
# -----------------------------------------------------------------------------
function Twitter-Televerser-Media-Simple {
    param (
        [parameter(Mandatory=$true)] [pscustomobject] $identifiants,
        [Parameter(Mandatory)] [string]$cheminMedia,
        [uint64[]] $autresProprietaires = $null
    )

    $octetsMedia  = Get-Content $cheminMedia -Encoding Byte
    $media = [Text.StringBuilder]::new()
    foreach ($octet in $octetsMedia) {
        [void]$media.Append([Convert]::ToChar($octet))
    }

    $paramsAppel = @{
        'media' = $media.ToString()
    }

    if ($autresProprietaires) { $paramsAppel['additional_owners'] = (Twitter-Encoder-Chaine -chaine ($autresProprietaires -join ',')) }

    $infosAppel = Twitter-Preparer-Appel `        -pointAppel 'https://upload.twitter.com/1.1/media/upload.json' `        -methodeAppel 'POST' `        -typeMIME 'multipart/form-data' `        -paramsAppel @{
            'media' = $media.ToString()
        }

    Twitter-Calculer-Signature -identifiants $identifiants -infosAppel $infosAppel
    Twitter-Appeler -infosAppel $infosAppel
}

#endregion