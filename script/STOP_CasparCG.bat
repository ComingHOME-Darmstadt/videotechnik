@echo off
set me=%~f0
set mePath=%~dp0

if exist %mePath%setVars4Connection.bat (
	call %mePath%setVars4Connection.bat
)
if [%defaultUser%] == [] (
	set /p defaultUser="Benutzername fÅr Anmeldung: "
)
if [%defaultPw%] == [] (
	set /p defaultPw="Passwort fÅr Anmeldung: "
)

if not exist \\chaudio\IPC$ (
	net use /PERSISTENT:NO \\chaudio\IPC$ %defaultPw% /USER:%defaultUser%
)
shutdown /s /m \\chaudio /t 1 /c "ComingHome-Video/STOP_CasparCG.bat f‰hrt diesen PC herunter" /f

rem shutdown /s /t 1 /c "STOP_CasparCG.bat f‰hrt diesen PC herunter" /f
