. ("$PSScriptRoot\TU.ps1")

. ("$PSScriptRoot\..\..\Powershell\fonctions_web.ps1")

# Test de la fonction Telecharger
Assert-CheminExiste -message "Telecharger" -chemin "$bas\google_terms_of_service_fr_fr.pdf" `
-avant {
    Vider-BacASable

    Telecharger -url 'https://www.gstatic.com/policies/terms/pdf/20200331/ba461e2f/google_terms_of_service_fr_fr.pdf' -enregistrerSous "$bas\google_terms_of_service_fr_fr.pdf"
} `
-apres {
    Vider-BacASable
}

# Test de la fonction Envoyer-Mail
Assert-Script -message "Envoyer-Mail | Vérifier manuellement qu'un e-mail est arrivé à $email_contact." -test { $true } `
-avant {
    Envoyer-Mail -de $email_contact -a $email_contact -sujet 'Test unitaire Envoyer-Mail' -corps 'Test unitaire Envoyer-Mail'
}