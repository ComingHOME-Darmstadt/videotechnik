# Implementation Checklist: Button Feedback Migration Script

**Feature Branch**: `001-button-feedback-migration`  
**Created**: 2026-01-25  
**Status**: Draft

---

## Pre-Implementation

- [ ] Feature-Spezifikation (`spec.md`) gelesen und verstanden
- [ ] Implementierungsplan (`plan.md`) überprüft
- [ ] Constitution Check bestätigt (JSON-Formatierung, Dateipfade)
- [ ] Ordnerstruktur `migrations/buttonFeedback2step/` angelegt

---

## Core Implementation (FR-001 bis FR-015)

### Dateien erstellen

- [ ] `migrations/buttonFeedback2step/migrate.py` - Hauptskript
- [ ] `migrations/buttonFeedback2step/README.md` - Ausführungsdokumentation

### Button-Identifikation (FR-001, FR-011)

- [ ] Skript identifiziert alle Elemente mit `type="button"`
- [ ] Skript ignoriert Elemente mit anderen Typen (`pageup`, `pagedown`, `text`, etc.)
- [ ] Elemente ohne `type="button"` werden NICHT verarbeitet, auch wenn sie `bank_pushed` Feedbacks haben

### Feedback-Verarbeitung (FR-002, FR-003, FR-010)

- [ ] Skript findet alle Feedbacks mit `type="bank_pushed"` in Buttons
- [ ] Skript ändert NUR `type="bank_pushed"` zu `type="bank_current_step"`
- [ ] Andere Feedback-Typen (`bank_style`, `bank_text`, etc.) bleiben unverändert

### Options-Änderungen (FR-004, FR-004a, FR-005)

- [ ] Skript fügt `"step": 2` zu den Feedback-Options hinzu
- [ ] Falls `step` bereits existiert und ≠ 2: Überschreiben UND Warnung ausgeben
- [ ] Falls `step` bereits existiert und = 2: Still ignorieren (keine Warnung)
- [ ] Skript entfernt `"latch_compatability"` aus den Feedback-Options (sofern vorhanden)

### Konfigurationsdatei (FR-012, FR-015)

- [ ] Skript liest `config/full.companionconfig`
- [ ] Skript schreibt Änderungen zurück in dieselbe Datei
- [ ] JSON-Formatierung wird beibehalten (Tab-Einrückung mit `indent='\t'`)

### Fehlerbehandlung (FR-008)

- [ ] Verständliche Fehlermeldung bei fehlender Konfigurationsdatei
- [ ] Verständliche Fehlermeldung bei ungültigem JSON-Format
- [ ] Verständliche Fehlermeldung bei fehlenden Schreibrechten

### Idempotenz (FR-007)

- [ ] Mehrfache Ausführung verursacht keine zusätzlichen Änderungen
- [ ] Skript erkennt bereits migrierte Feedbacks (`bank_current_step`)
- [ ] Keine Änderung = keine Dateischreibung (optional, aber empfohlen)

### Migrationsbericht (FR-006)

- [ ] Bericht zeigt Anzahl der geänderten Buttons an
- [ ] Bericht zeigt Anzahl der geänderten Feedbacks an
- [ ] Bericht zeigt Warnungen bei überschriebenen `step`-Werten an
- [ ] Meldung bei "keine Änderungen notwendig"

---

## Dokumentation (FR-009, FR-014)

### README.md Inhalt

- [ ] Python-Version dokumentiert (3.8+)
- [ ] Abhängigkeiten dokumentiert (keine externen)
- [ ] Ausführungsbefehl dokumentiert (`python migrate.py`)
- [ ] Optionale CLI-Parameter dokumentiert (z.B. `--dry-run`, `--verbose`)
- [ ] Erwartetes Verhalten beschrieben
- [ ] Beispiel-Ausgabe dokumentiert

---

## User Stories Abnahme

### User Story 1 - Konfigurationsmigration (P1)

- [ ] **Szenario 1**: `bank_pushed` → `bank_current_step` bei Buttons
- [ ] **Szenario 2**: `"step": 2` wird hinzugefügt
- [ ] **Szenario 3**: `"latch_compatability"` wird entfernt
- [ ] **Szenario 4**: Leere Konfiguration bleibt unverändert
- [ ] **Szenario 5**: Nur `bank_pushed` Feedbacks werden geändert, andere bleiben
- [ ] **Szenario 6**: Nicht-Button-Elemente bleiben unverändert
- [ ] **Szenario 7**: Überschreiben von `step` ≠ 2 mit Warnung
- [ ] **Szenario 8**: `step` = 2 wird still ignoriert

### User Story 2 - Migrationsbericht (P2)

- [ ] **Szenario 1**: Bericht mit Anzahl geänderter Buttons
- [ ] **Szenario 2**: Meldung "keine Änderungen" bei leerem Durchlauf

---

## Success Criteria Validierung

- [ ] **SC-001**: Keine `bank_pushed` Feedbacks mehr in Buttons
- [ ] **SC-002**: Alle betroffenen Buttons haben `bank_current_step` Feedback
- [ ] **SC-003**: Alle migrierten Feedbacks haben `"step": 2`
- [ ] **SC-004**: Keine migrierten Feedbacks haben `"latch_compatability"`
- [ ] **SC-005**: Bericht zeigt Anzahl migrierter Feedbacks
- [ ] **SC-005a**: Warnungen bei überschriebenen `step`-Werten im Bericht
- [ ] **SC-006**: Idempotenz-Test bestanden (2. Durchlauf = 0 Änderungen)
- [ ] **SC-007**: README.md existiert und dokumentiert Ausführung

---

## Edge Cases / Negative Tests

- [ ] Konfigurationsdatei nicht gefunden → Fehlermeldung
- [ ] Ungültiges JSON-Format → Fehlermeldung
- [ ] Keine Schreibrechte → Fehlermeldung
- [ ] Bereits migrierter Feedback (`bank_current_step`) → wird ignoriert
- [ ] Button ohne Feedbacks → wird übersprungen
- [ ] Feedback ohne Options → Options werden erstellt
- [ ] Leere Konfigurationsdatei → keine Änderungen

---

## Code Quality

- [ ] Python 3.8+ kompatibel
- [ ] Nur Standard Library verwendet (keine pip install)
- [ ] Type Hints vorhanden (optional, empfohlen)
- [ ] Docstrings für Funktionen (optional, empfohlen)
- [ ] CLI-Argumente über `argparse`
- [ ] Exit-Codes dokumentiert (0 = Erfolg, 1 = Fehler)

---

## Abschluss

- [ ] Skript auf Testkonfiguration ausgeführt
- [ ] Skript auf Produktivkonfiguration ausgeführt
- [ ] Änderungen in Git committed
- [ ] Pull Request erstellt (falls erforderlich)
- [ ] Feature-Branch in main gemergt (falls erforderlich)

---

## Optionale Erweiterungen

- [ ] `--dry-run` Modus implementiert (zeigt Änderungen ohne Schreiben)
- [ ] `--verbose` Modus implementiert (detaillierte Ausgabe)
- [ ] `--backup` Modus implementiert (erstellt Backup vor Änderung)
- [ ] Unit Tests in `migrations/buttonFeedback2step/tests/`
- [ ] Test-Fixtures mit Beispielkonfigurationen
