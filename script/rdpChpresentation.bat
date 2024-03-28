@echo off
set me=%~f0
set mePath=%~dp0

start /min "rdp chpresentation" mstsc /v:192.168.77.31 /shadow:1 /control /noConsentPrompt
