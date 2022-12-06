@echo off
set me=%~f0
set mePath=%~dp0

call %mePath%setVars4Shutdown.bat
net use /PERSISTENT:NO \\chaudio\IPC$ %chaudioSdpw% %chaudioSduser%
shutdown /s /m \\chaudio /t 1 /c "ComingHome-Video/STOP_CasparCG.bat fährt diesen PC herunter" /f

rem shutdown /s /t 1 /c "STOP_CasparCG.bat fährt diesen PC herunter" /f
