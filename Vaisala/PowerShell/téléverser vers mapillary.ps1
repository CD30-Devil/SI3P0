. ("$PSScriptRoot\..\..\API\PowerShell\api_complète.ps1")
. ("$PSScriptRoot\..\..\API\PowerShell\constantes_privées.ps1")

$dossierDonnees = "$PSScriptRoot\..\Données"
$dossierRapports = "$PSScriptRoot\..\Rapports\téléverser vers mapillary"

$dossierImages = "$dossierDonnees\Images"

# nettoyage préalable
Remove-Item "$dossierRapports\*.txt"
Remove-Item "$dossierRapports\*.err"

# connexion
MapillaryTools-Connecter -utilisateur $mapillaryUtilisateur -email $mapillaryEmail -mdp $mapillaryMDP -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  connexion.txt"

# traitement et téléversement des dossiers
foreach ($dossier in (Get-ChildItem $dossierImages -Directory)) {

    MapillaryTools-Traiter-Images -dossier $dossier.FullName -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  traitement $($dossier.Name).txt"
    MapillaryTools-Televerser-Images -utilisateur $mapillaryUtilisateur -organisation $mapillaryOrganisation -dossier $dossier.FullName -sortie "$dossierRapports\$(Get-Date -Format 'yyyy-MM-dd HH-mm-ss') -  téléversement $($dossier.Name).txt" -modeTest $false

}