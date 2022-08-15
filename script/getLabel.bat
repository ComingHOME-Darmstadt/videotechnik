@echo off
set me=%~f0
set mePath=%~dp0

set cfgFile=%mePath%labels.cfg

setlocal ENABLEDELAYEDEXPANSION

for /F "delims=" %%i in (%cfgFile%) do set %%i

set name=!%1!
if "%name%"=="" set name=%1

echo %name%
