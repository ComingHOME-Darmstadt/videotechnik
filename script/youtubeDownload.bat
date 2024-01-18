@echo off
set me=%~f0
set mePath=%~dp0

setlocal ENABLEDELAYEDEXPANSION


set targetPath=%HOMEDRIVE%%HOMEPATH%\Downloads\youtube
mkdir %targetPath%
cd %targetPath%

echo.
echo.Datei wird unter [%targetPath%] abgelegt.
echo.

set url=
set /p url="YouTube URL (https://...): "

%mePath%yt-dlp.exe %url%

pause

explorer.exe /e, %targetPath%
