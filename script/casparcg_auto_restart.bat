@echo off
set me=%~f0
set mePath=%~dp0

cd "%mePath%..\casparcg-server"

:Start
SET ERRORLEVEL 0

casparcg.exe ..\config\casparcg-server.config

if ERRORLEVEL 5 goto :Start

exit
