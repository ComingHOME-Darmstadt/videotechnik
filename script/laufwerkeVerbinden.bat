@echo off
set me=%~f0
set mePath=%~dp0

if exist %mePath%setVars4Connection.bat (
	call %mePath%setVars4Connection.bat
)
if [%defaultUser%] == [] (
	set /p defaultUser="Benutzername fr Anmeldung: "
)
if [%defaultPw%] == [] (
	set /p defaultPw="Passwort fr Anmeldung: "
)

if not [%1] == [cominghome-video] (
	if not exist v:\ (
		net use /PERSISTENT:NO v: \\cominghome-video\c %defaultPw% /USER:%defaultUser%
	)
	if exist v:\ (
		echo Laufwerk V: cominghome-video
	)
)

if not [%1] == [chaudio] (
	if exist \\chaudio\c (
		if not exist u:\ (
			net use /PERSISTENT:NO u: \\chaudio\c %defaultPw% /USER:%defaultUser%
		)
		if exist u:\ (
			echo Laufwerk U: chaudio
		)
	) else (
		echo chaudio nicht da
	)
)

if not [%1] == [chpresentation] (
	if exist \\chpresentation\c (
		if not exist p:\ (
			net use /PERSISTENT:NO p: \\chpresentation\c %defaultPw% /USER:%defaultUser%
		)
		if exist p:\ (
			echo Laufwerk P: chpresentation
		)
	) else (
		echo chpresentation nicht da
	)
)

if not [%1] == [chzoom] (
	if exist \\chzoom\c (
		if not exist z:\ (
			net use /PERSISTENT:NO z: \\chzoom\c %defaultPw% /USER:%defaultUser%
		)
		if exist z:\ (
			echo Laufwerk Z: chzoom
		)
	) else (
		echo chzoom nicht da
	)
)
