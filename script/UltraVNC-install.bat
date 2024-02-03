@echo off
set me=%~f0
set mePath=%~dp0

call %mePath%setVars4Connection.bat

%mePath%UltraVNC_1436_X64_Setup.exe /silent /loadinf="%mePath%ultravnc.inf" PASSWORD="%vncPw%"
