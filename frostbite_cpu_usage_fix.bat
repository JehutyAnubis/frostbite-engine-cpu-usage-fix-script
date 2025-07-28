@echo off
REM Détection de la langue de l'utilisateur
for /f "tokens=2 delims==" %%A in ('"wmic os get locale /value"') do set "LOCALE=%%A"
set "LANG=%LOCALE:~0,4%"

if "%LANG%"=="040c" (
    set "QUESTION=Entrez le nombre maximum de FPS souhaité dans le jeu (laisser vide pour ne pas forcer, testé sur BF4, BF1 et BF5)"
    set "CONCLUSION=Le fichier user.cfg a été créé avec succès dans :"
) else (
    set "QUESTION=Enter the maximum desired FPS in the game (leave blank to not force, tested on BF4, BF1 and BF5)"
    set "CONCLUSION=The user.cfg file has been successfully created at:"
)

REM Récupération du nombre de cœurs physiques
for /f "tokens=*" %%A in ('powershell -Command "Get-CimInstance -ClassName Win32_Processor | Select-Object -ExpandProperty NumberOfCores"') do set "CORES=%%A"
REM Récupération du nombre de threads logiques
for /f "tokens=*" %%A in ('powershell -Command "Get-CimInstance -ClassName Win32_Processor | Select-Object -ExpandProperty NumberOfLogicalProcessors"') do set "THREADS=%%A"
REM Demande à l'utilisateur le nombre max de FPS
set /p FPSMAX="%QUESTION% : "

REM Préparation du contenu du fichier user.cfg
echo Thread.ProcessorCount %CORES% >> user.cfg
echo Thread.MaxProcessorCount %CORES% >> user.cfg
echo Thread.MinFreeProcessorCount 0 >> user.cfg
echo Thread.JobThreadPriority 0 >> user.cfg
echo GstRender.Thread.MaxProcessorCount %THREADS% >> user.cfg

REM Ajout de la ligne GameTime.MaxVariableFps seulement si FPSMAX n'est pas vide et n'est pas 0
if not "%FPSMAX%"=="" if not "%FPSMAX%"=="0" (
    echo GameTime.MaxVariableFps %FPSMAX% >> user.cfg
)

REM Affichage du message de conclusion
set "CURDIR=%CD%"
echo %CONCLUSION% %CURDIR%\user.cfg 