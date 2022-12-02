@echo off
set me=%~f0
set mePath=%~dp0

cd "%mePath%..\dDImageViewer"
start /min "NDI DDImageViewer"  NDIDDImageViewer.exe /force_last
