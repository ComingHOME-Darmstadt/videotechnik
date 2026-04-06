@echo off
set me=%~f0
set mePath=%~p0
set meDrive=%~d0

%meDrive%

call %mePath%START_Multiview_Monitor.bat

curl -f -s 127.0.0.1:81/v1/configuration
IF NOT %ERRORLEVEL%==0 (
  start "NDI-Monitor 2" /min "%ProgramFiles%\NDI\NDI 6 Tools\Studio Monitor\Application.Network.StudioMonitor.x64.exe" Controlview
)
