. ("$PSScriptRoot\TU.ps1")

. ("$PSScriptRoot\..\..\Powershell\fonctions_twitter.ps1")


# Test de la fonction Twitter-Encoder-Chaine
Assert-Script -message "Twitter-Encoder-Chaine" `
-test {
    (Twitter-Encoder-Chaine -chaine @'
abcde ABCDE
0123456789
- . _ ~
! * ( ) & ? [ ]
'@) -eq 'abcde%20ABCDE%0D%0A0123456789%0D%0A-%20.%20_%20~%0D%0A%21%20%2A%20%28%20%29%20%26%20%3F%20%5B%20%5D'
}