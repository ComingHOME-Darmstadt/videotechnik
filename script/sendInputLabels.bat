@echo off
set me=%~f0
set mePath=%~dp0

set cfgPath=%mePath%..\config\
set cfgFile=%cfgPath%inputLabels.cfg

setlocal ENABLEDELAYEDEXPANSION

if NOT EXIST %cfgFile% echo input1=Input 1 > %cfgFile%

for /F "tokens=1,2 delims==" %%i in (%cfgFile%) do (
  set varName=%%i
  set varValue=%%j

  set varValue=!varValue: =%%20!

  curl -s --request POST http://127.0.0.1:8888/api/custom-variable/!varName!label/value?value=!varValue!
)
