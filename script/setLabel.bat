@echo off
set me=%~f0
set mePath=%~dp0

set cfgFile=%mePath%labels.cfg
set cfgFileNew=%mePath%labels-new.cfg

setlocal ENABLEDELAYEDEXPANSION

echo.
echo.soll ein Label beibehalten werden, einfach mit Return best„tigen.
echo.
pause
echo.

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
