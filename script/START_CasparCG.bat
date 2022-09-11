@echo off
set me=%~f0
set mePath=%~dp0

cd "%ProgramFiles%\obs-studio\bin\64bit\"
start /min obs64.exe --minimize-to-tray --disable-updater

timeout /t 1

if not exist "%mePath%..\temp" mkdir "%mePath%..\temp"
cd "%mePath%..\temp"
start /min ..\casparcg-server\scanner.exe --caspar.config ..\config\casparcg-server.config --paths.ffmpeg ..\casparcg-server\ffmpeg.exe --paths.ffprobe ..\casparcg-server\ffprobe.exe

timeout /t 1

start /min %mePath%casparcg_auto_restart.bat

timeout /t 1

cd "%mePath%..\casparcg-client"
start "CasparCG client" "CasparCG Client.exe" -t ..\config\casparcg-client.s3db

timeout /t 1

call %mePath%sendInputLabels.bat
