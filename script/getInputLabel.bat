@echo off
set me=%~f0
set mePath=%~dp0

set cfgPath=%mePath%..\config\
set cfgFile=%cfgPath%inputLabels.cfg

setlocal ENABLEDELAYEDEXPANSION

if NOT EXIST %cfgFile% echo input01=Input 1 > %cfgFile%

for /F "delims=" %%i in (%cfgFile%) do set %%i

set name=!%1!
if "%name%"=="" set name=%1

echo %name%
