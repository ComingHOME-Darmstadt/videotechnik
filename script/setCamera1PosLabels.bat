@echo off
set me=%~f0
set mePath=%~dp0

set cfgPath=%mePath%..\config\
set cfgFile=%cfgPath%camera1Labels.cfg
set cfgFileNew=%cfgPath%camera1Labels-new.cfg

setlocal ENABLEDELAYEDEXPANSION

echo.
echo.soll ein Positions-Label fr Kamera 1 beibehalten werden, einfach mit Return best„tigen.
echo.
pause
echo.

if NOT EXIST %cfgFile% echo pos1=Recall 1 > %cfgFile%
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

for /F "tokens=1,2 delims==" %%i in (%cfgFile%) do (
  set varName=%%i
  set varValue=%%j

  set varValue=!varValue: =%%20!

  curl -s http://127.0.0.1:8888/set/custom-variable/cam1!varName!label?value=!varValue!
)
