# Détection de la langue de l'utilisateur
$language = $PSUICulture.TwoLetterISOLanguageName

if ($language -eq "fr") {
    $question = "Entrez le nombre maximum de FPS souhaité dans le jeu (laisser vide pour ne pas forcer)"
    $conclusion = "Le fichier user.cfg a été créé avec succès dans :"
} else {
    $question = "Enter the maximum desired FPS in the game (leave blank to not force)"
    $conclusion = "The user.cfg file has been successfully created at:"
}

# Récupération du nombre de cœurs physiques
$CoresCount = (Get-CimInstance -ClassName Win32_Processor | Measure-Object -Property NumberOfCores -Sum).Sum
# Récupération du nombre de threads logiques
$ThreadsCount = (Get-CimInstance -ClassName Win32_Processor | Measure-Object -Property NumberOfLogicalProcessors -Sum).Sum

# Demande à l'utilisateur le nombre max de FPS
$FPSMax = Read-Host $question

# Préparation du contenu du fichier user.cfg
$userCfgContent = @()
$userCfgContent += "Thread.ProcessorCount $CoresCount"
$userCfgContent += "Thread.MaxProcessorCount $CoresCount"
$userCfgContent += "Thread.MinFreeProcessorCount 0"
$userCfgContent += "Thread.JobThreadPriority 0"
$userCfgContent += "GstRender.Thread.MaxProcessorCount $ThreadsCount"
if ($FPSMax -and $FPSMax -ne "0") {
    $userCfgContent += "GameTime.MaxVariableFps $FPSMax"
}

# Création du fichier user.cfg dans le dossier courant
$userCfgPath = Join-Path -Path (Get-Location) -ChildPath "user.cfg"
Set-Content -Path $userCfgPath -Value $userCfgContent -Encoding UTF8

Write-Host "$conclusion $userCfgPath" -ForegroundColor Green
