@echo off

curl -f -s 127.0.0.1:80/v1/configuration
IF NOT %ERRORLEVEL%==0 (
  start "NDI-Monitor 1" /min "%ProgramFiles%\NDI\NDI 6 Tools\Studio Monitor\Application.Network.StudioMonitor.x64.exe" Multiview
)
