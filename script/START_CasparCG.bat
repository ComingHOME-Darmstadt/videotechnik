@echo OFF

cd "C:\Program Files\obs-studio\bin\64bit\"
start /min obs64.exe

timeout /t 1

cd "C:\Users\ComingHome\Documents\CasparCG_Client\casparcg-client\"
start CasparCG-Client.exe -r C:\Users\ComingHome\Documents\20ch_companion.xml

timeout /t 1

cd "C:\Users\ComingHome\Documents\CasparCG_Server\"
start /min scanner.exe

timeout /t 1

cd "C:\Users\ComingHome\Documents\CasparCG_Server\"
start /min casparcg.exe

timeout /t 1

REM cd "C:\Users\ComingHome\Documents\CasparCG_Server\"
REM start /min caspar-bitc.exe --output.channel 19

REM timeout /t 1

cd "C:\Program Files\NDI\NDI 5 Tools\Studio Monitor\"
start Application.Network.StudioMonitor.x64.exe