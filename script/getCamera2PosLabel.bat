@echo off
set me=%~f0
set mePath=%~dp0

set cfgPath=%mePath%..\config\
set cfgFile=%cfgPath%camera2Labels.cfg

setlocal ENABLEDELAYEDEXPANSION

if NOT EXIST %cfgFile% echo pos1=Recall 1 > %cfgFile%

for /F "delims=" %%i in (%cfgFile%) do set %%i

set name=!%1!
if "%name%"=="" set name=%1

echo %name%
