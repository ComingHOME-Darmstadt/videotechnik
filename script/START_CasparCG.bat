@echo off
set me=%~f0
set mePath=%~dp0

cd "%ProgramFiles%\obs-studio\bin\64bit\"
start /min obs64.exe --minimize-to-tray --disable-updater

timeout /t 1

cd "%mePath%..\casparcg-client"
start "CasparCG client" "CasparCG Client.exe" -r \comingHOME\videotechnik\config\caspercg-client.xml

timeout /t 1

cd "%mePath%..\casparcg-server"
start /min scanner.exe --caspar.config ..\config\casparcg-server.config

timeout /t 1

start /min %mePath%casparcg_auto_restart.bat

timeout /t 1

cd "%ProgramFiles%\NDI\NDI 5 Tools\Studio Monitor\"
start /min Application.Network.StudioMonitor.x64.exe
