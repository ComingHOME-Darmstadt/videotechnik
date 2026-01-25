# Button Feedback Migration Script

Migrationsskript zur Aktualisierung der Bitfocus Companion Konfiguration.

## Übersicht

Dieses Skript migriert Button-Feedbacks von `bank_pushed` zu `bank_current_step` mit folgenden Änderungen:

- Feedback-Typ: `bank_pushed` → `bank_current_step`
- Neue Option: `"step": 2` hinzufügen
- Entfernen: `latch_compatability` Option

## Voraussetzungen

- Python 3.8 oder höher
- Zugriff auf `config/full.companionconfig`

## Installation

Keine Installation erforderlich - das Skript verwendet nur die Python Standard Library.

## Verwendung

### Basis-Befehl

Vom Repository-Root ausführen:

```bash
python migrations/buttonFeedback2step/migrate.py
```

### Verfügbare Optionen

| Option | Kurz | Beschreibung |
|--------|------|--------------|
| `--config PATH` | `-c` | Pfad zur Konfigurationsdatei (Standard: `config/full.companionconfig`) |
| `--dry-run` | `-n` | Vorschau der Änderungen ohne Schreibzugriff |
| `--verbose` | `-v` | Detaillierte Verarbeitungsinformationen |
| `--help` | `-h` | Hilfe anzeigen |

### Beispiele

```bash
# Dry-Run: Änderungen vorab prüfen (empfohlen als erster Schritt)
python migrations/buttonFeedback2step/migrate.py --dry-run

# Migration durchführen
python migrations/buttonFeedback2step/migrate.py

# Verbose-Modus für Details
python migrations/buttonFeedback2step/migrate.py --verbose

# Verbose Dry-Run für maximale Transparenz
python migrations/buttonFeedback2step/migrate.py --dry-run --verbose

# Alternative Konfigurationsdatei
python migrations/buttonFeedback2step/migrate.py --config /pfad/zur/config.json
```

## Exit-Codes

| Code | Bedeutung |
|------|-----------|
| 0 | Erfolg - Migration abgeschlossen (oder keine Änderungen nötig) |
| 1 | Fehler - Datei nicht gefunden |
| 2 | Fehler - Ungültiges JSON-Format |
| 3 | Fehler - Keine Schreibberechtigung |
| 4 | Fehler - Unerwarteter Fehler |

## Idempotenz

Das Skript ist idempotent - mehrfache Ausführung führt zum gleichen Ergebnis:

```bash
# Erste Ausführung - führt Migration durch
$ python migrations/buttonFeedback2step/migrate.py
Feedbacks migrated: 23
✓ Migration completed successfully.

# Zweite Ausführung - keine Änderungen
$ python migrations/buttonFeedback2step/migrate.py
Feedbacks migrated: 0
No changes were necessary.
```

## Rollback

Bei Problemen können Sie die Änderungen über Git rückgängig machen:

```bash
git checkout -- config/full.companionconfig
```

**Hinweis**: Stellen Sie sicher, dass Sie vor der Migration alle lokalen Änderungen committed haben.

## Technische Details

### Verarbeitungslogik

1. Konfigurationsdatei laden und JSON parsen
2. Alle Pages durchlaufen
3. Nur Controls mit `type="button"` verarbeiten
4. Feedbacks mit `type="bank_pushed"` migrieren:
   - Typ ändern zu `bank_current_step`
   - `step: 2` Option hinzufügen
   - `latch_compatability` entfernen
5. Datei mit Tab-Einrückung speichern

### JSON-Formatierung

Die Ausgabedatei verwendet Tab-Einrückung (`\t`) gemäß den Projektkonventionen.

### Migrationsbericht

Nach der Ausführung zeigt das Skript einen Bericht mit:

- Anzahl verarbeiteter Buttons
- Anzahl migrierter Feedbacks
- Details zu Typ-Änderungen, Step-Additions und latch_compatability-Entfernungen
- Warnungen (z.B. wenn ein existierender `step`-Wert überschrieben wurde)

### Warnungen

Das Skript gibt eine Warnung aus, wenn ein Feedback bereits einen `step`-Wert hatte, der nicht `2` war. Der Wert wird trotzdem auf `2` überschrieben, aber die Warnung wird im Bericht angezeigt.

## Fehlerbehandlung

| Fehler | Ursache | Lösung |
|--------|---------|--------|
| File not found (Exit 1) | Konfigurationsdatei existiert nicht | Pfad prüfen oder --config verwenden |
| Invalid JSON (Exit 2) | Konfigurationsdatei ist kein gültiges JSON | Datei auf Syntax-Fehler prüfen |
| Permission denied (Exit 3) | Keine Schreibrechte | Berechtigungen anpassen |
| Unexpected error (Exit 4) | Unvorhergesehener Fehler | Fehlermeldung prüfen |

## Weiterführende Dokumentation

- [Spezifikation](../../specs/001-button-feedback-migration/spec.md)
- [Implementierungsplan](../../specs/001-button-feedback-migration/plan.md)
- [CLI-Contract](../../specs/001-button-feedback-migration/contracts/cli-contract.md)
- [Datenmodell](../../specs/001-button-feedback-migration/data-model.md)
- [Quickstart](../../specs/001-button-feedback-migration/quickstart.md)
