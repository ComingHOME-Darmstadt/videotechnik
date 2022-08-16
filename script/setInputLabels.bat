@echo off
set me=%~f0
set mePath=%~dp0

set cfgPath=%mePath%..\config\
set cfgFile=%cfgPath%inputLabels.cfg
set cfgFileNew=%cfgPath%inputLabels-new.cfg

setlocal ENABLEDELAYEDEXPANSION

echo.
echo.soll ein Input-Label beibehalten werden, einfach mit Return best„tigen.
echo.
pause
echo.

if NOT EXIST %cfgFile% echo input1=Input 1 > %cfgFile%
if EXIST %cfgFileNew% del %cfgFileNew%

for /F "tokens=1,2 delims==" %%i in (%cfgFile%) do (
  set varName=%%i
  set varValue=%%j

  set newValue=
  set /p newValue="Label fr "!varName!" (bisher: "!varValue!"): "
  if not "!newValue!"=="" set varValue=!newValue!
  if "!varValue!"=="" set varValue=!varName!
  echo !varName!=!varValue!>>%cfgFileNew%
)

move /Y %cfgFileNew% %cfgFile%
