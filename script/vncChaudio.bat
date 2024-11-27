@echo off
set me=%~f0
set mePath=%~dp0

call %mePath%setVars4Connection.bat

start /min "uvnc chaudio" "C:\Program Files\uvnc bvba\UltraVNC\vncviewer.exe" /autoscaling /password %vncPw% -connect 192.168.77.33:5900
