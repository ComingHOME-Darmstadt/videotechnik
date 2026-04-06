@echo off
set me=%~f0
set mePath=%~p0
set meDrive=%~d0

%meDrive%

call %mePath%START_Controlview_Monitor.bat

if not exist "%mePath%..\temp" mkdir "%mePath%..\temp"
pushd "%mePath%..\temp"
start /min %mePath%..\casparcg-server\scanner.exe --caspar.config ..\config\casparcg-server.config --paths.ffmpeg ..\casparcg-server\ffmpeg.exe --paths.ffprobe ..\casparcg-server\ffprobe.exe

timeout /t 1

start /min %mePath%casparcg_auto_restart.bat

timeout /t 1

call %mePath%startVideoMonitor.bat

popd