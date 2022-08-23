ComingHOME Videotechnik
=======================

Dies ist eine Sammlung von Konfigurations- und Script-Dateien für die Videotechnik bei ComingHOME Darmstadt.

Verzeichnisstruktur
-------------------

Die Skripte und Konfigurationen gehen davon aus, dass im Unterverzeichnis `casparcg-client` das entpackte Client-Programm (siehe `casparcg-client/README.md`) und in `casparcg-server` das Server-Programm (siehe `casparcg-server/README-videotechnik.md`) liegen.

Im Untervezeichnis `config` werden alle Konfigurations-Dateien gesammelt. Hierbei ist jedoch `config/media/Videos` von der Überwachung durch die Versionierung ausgenommen.

Die Programme `OBS Studio 27.2.4`, `Bitfocus Companion 2.2.3` und `NDI 5.5.0.0` werden in den vom Installationsprogramm vorgeschlagenen Ordnern erwartet.

`OBS Studio` benötigt das `obs-websocket` Plugin.

Zwei `NDI Studio Monitor`e müssen mit Web Control auf Port `80` und `81` laufen.

`casparcg-client` kann z.Z. beim Starten nicht gleichzeitig das Rundown laden, da dann die OSC-Befehle vom `Bitfocus Companion` nicht an den `casparcg-server` weitergegeben werden. Dies bedeutet, das zum Benutzen manuell das Rundown `config/casparcg-client.xml` geladen werden muss.
