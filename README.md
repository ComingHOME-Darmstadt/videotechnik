ComingHOME Videotechnik
=======================

Dies ist eine Sammlung von Konfigurations- und Script-Dateien für die Videotechnik bei ComingHOME Darmstadt.

Verzeichnisstruktur
-------------------

Die Skripte und Konfigurationen gehen davon aus, dass im Unterverzeichnis `casparcg-client` das entpackte Client-Programm (siehe `casparcg-client/README.md`) und in `casparcg-server` das Server-Programm (siehe `casparcg-server/README-videotechnik.md`) liegen.

Im Untervezeichnis `config` werden alle Konfigurations-Dateien gesammelt. Hierbei ist jedoch `config/media/Videos` von der Überwachung durch die Versionierung ausgenommen.

Die Programme `OBS Studio 27.2.4`, `Bitfocus Companion 2.3.0` und `NDI 5.5.0.0` werden in den vom Installationsprogramm vorgeschlagenen Ordnern erwartet. `Companion` sollte automatisch starten.

`OBS Studio` benötigt das `obs-websocket` Plugin.

Zwei `NDI Studio Monitor`e müssen mit Web Control auf Port `80` und `81` laufen. Sie sollten automatisch starten.

`casparcg-client` kann z.Z. beim Starten nicht gleichzeitig das Rundown laden, da dann die OSC-Befehle vom `Bitfocus Companion` nicht an den `casparcg-server` weitergegeben werden. Dies bedeutet, das zum Benutzen manuell das Rundown `config/casparcg-client.xml` geladen werden muss.

Hilfe
=====

FritzBox mit WLan verbinden
---------------------------
![Screeenshot Internet->Zugangsdaten](file:///C:\comingHOME\videotechnik\help\fritzBoxMitWLanVerbinden.png)

CasparCG Server
---------------

allgemeine Dokumentation zum Server 2.3.3 LTS: [help\CasparCG-2.3.3LTS_Overview.pdf](help\CasparCG-2.3.3LTS_Overview.pdf)

Introduction to CasparCG's HTML producer: [help\HTMLproducer.html](help\HTMLproducer.html) (Download von [https://www.indr.ch/2018/09/introduction-to-casparcgs-html-producer/](https://www.indr.ch/2018/09/introduction-to-casparcgs-html-producer/))

Creating production-ready HTML templates for CasparCG: [help\production-readyHTMLtemplates.html](help\production-readyHTMLtemplates.html) (Download von [https://www.indr.ch/2019/01/creating-production-ready-html-templates-for-casparcg/](https://www.indr.ch/2019/01/creating-production-ready-html-templates-for-casparcg/))
