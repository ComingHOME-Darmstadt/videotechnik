@echo off
set me=%~f0
set mePath=%~dp0

call %mePath%setVars4Connection.bat

start /min "uvnc chpresentation" "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe" /autoscaling /password %vncPw% -connect chpresentation:5900
