@echo off
set me=%~f0
set mePath=%~dp0

curl -f -s 127.0.0.1:80/v1/configuration
IF NOT %ERRORLEVEL%==0 (
  start "NDI-Monitor 1" /min "%ProgramFiles%\NDI\NDI 5 Tools\Studio Monitor\Application.Network.StudioMonitor.x64.exe" Multiview
)

curl -f -s 127.0.0.1:81/v1/configuration
IF NOT %ERRORLEVEL%==0 (
  start "NDI-Monitor 2" /min "%ProgramFiles%\NDI\NDI 5 Tools\Studio Monitor\Application.Network.StudioMonitor.x64.exe" Beamer
)

curl -f -s 127.0.0.1:82/v1/configuration
IF NOT %ERRORLEVEL%==0 (
  start "NDI-Monitor 3" /min "%ProgramFiles%\NDI\NDI 5 Tools\Studio Monitor\Application.Network.StudioMonitor.x64.exe" STAGE
)

if not exist "%mePath%..\temp" mkdir "%mePath%..\temp"
cd "%mePath%..\temp"
start /min ..\casparcg-server\scanner.exe --caspar.config ..\config\casparcg-server.config --paths.ffmpeg ..\casparcg-server\ffmpeg.exe --paths.ffprobe ..\casparcg-server\ffprobe.exe

timeout /t 1

start /min %mePath%casparcg_auto_restart.bat

timeout /t 1

start /min "videoMonitor" "%ProgramFiles%\nodejs\node.exe" "%mePath%videoMonitor\index.js"

timeout /t 1

call %mePath%sendInputLabels.bat
