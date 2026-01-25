# Feature Specification: Button Feedback Migration Script

**Feature Branch**: `001-button-feedback-migration`  
**Created**: 2026-01-25  
**Status**: Draft  
**Input**: User description: "Migrationsskript zur Änderung von Button-Feedbacks von 'bank_pushed' zu 'bank_current_step' mit entsprechenden Options-Anpassungen"

## Übersicht

Dieses Feature beschreibt ein einmaliges Migrationsskript, das Konfigurationsdateien für Buttons modifiziert. Das Skript ändert spezifische Feedback-Typen und passt zugehörige Button-Optionen an.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Einmalige Konfigurationsmigration ausführen (Priority: P1)

Als Administrator möchte ich ein Migrationsskript ausführen, das alle betroffenen Button-Konfigurationen automatisch aktualisiert, damit ich die Konfiguration nicht manuell ändern muss.

**Why this priority**: Dies ist die Kernfunktionalität des Features - ohne die erfolgreiche Migration ist das Feature wertlos.

**Independent Test**: Kann vollständig getestet werden, indem das Skript auf eine Testkonfiguration angewendet wird und die Ergebnisse geprüft werden.

**Acceptance Scenarios**:

1. **Given** eine Konfigurationsdatei mit Buttons (type="button") die Feedbacks mit type="bank_pushed" enthalten, **When** das Migrationsskript ausgeführt wird, **Then** werden ausschließlich die Feedbacks vom Typ "bank_pushed" auf "bank_current_step" geändert, während alle anderen Feedback-Typen unverändert bleiben.

2. **Given** ein Button mit einem Feedback vom Typ "bank_pushed", **When** das Migrationsskript diesen Button verarbeitet, **Then** wird bei den zugehörigen Button "options" die Eigenschaft "step" mit Wert 2 hinzugefügt.

3. **Given** ein Button mit einem Feedback vom Typ "bank_pushed" dessen Options die Eigenschaft "latch_compatability" enthalten, **When** das Migrationsskript diesen Button verarbeitet, **Then** wird die Eigenschaft "latch_compatability" aus den Options entfernt.

4. **Given** eine Konfigurationsdatei ohne betroffene Buttons (keine mit type="button" und feedback type="bank_pushed"), **When** das Migrationsskript ausgeführt wird, **Then** bleibt die Konfiguration unverändert.

5. **Given** ein Button mit mehreren Feedbacks (z.B. type="bank_pushed", type="bank_style", type="bank_text"), **When** das Migrationsskript diesen Button verarbeitet, **Then** wird nur der Feedback mit type="bank_pushed" auf "bank_current_step" geändert und alle anderen Feedbacks bleiben unverändert.

6. **Given** ein Element mit einem anderen Typ als "button" (z.B. type="pageup" oder type="text") das Feedbacks mit type="bank_pushed" enthält, **When** das Migrationsskript ausgeführt wird, **Then** bleibt dieses Element vollständig unverändert.

---

### User Story 2 - Backup vor Migration erstellen (Priority: P2)

Als Administrator möchte ich, dass vor der Migration ein Backup der Original-Konfiguration erstellt wird, damit ich bei Problemen den ursprünglichen Zustand wiederherstellen kann.

**Why this priority**: Ein Backup schützt vor Datenverlust und ermöglicht Rollback bei unerwarteten Problemen.

**Independent Test**: Kann getestet werden, indem geprüft wird ob nach Skript-Ausführung eine Backup-Datei existiert.

**Acceptance Scenarios**:

1. **Given** eine Konfigurationsdatei, **When** das Migrationsskript ausgeführt wird, **Then** wird vor der Änderung ein Backup der Originaldatei erstellt.

2. **Given** das Backup wurde erstellt, **When** der Administrator das Backup prüft, **Then** entspricht der Inhalt exakt dem Original vor der Migration.

---

### User Story 3 - Migrationsbericht erhalten (Priority: P3)

Als Administrator möchte ich nach der Migration einen Bericht über die durchgeführten Änderungen erhalten, damit ich nachvollziehen kann, welche Buttons modifiziert wurden.

**Why this priority**: Transparenz über die durchgeführten Änderungen ist wichtig, aber nicht kritisch für die Kernfunktionalität.

**Independent Test**: Kann getestet werden, indem nach Skript-Ausführung die Ausgabe/der Bericht auf Vollständigkeit geprüft wird.

**Acceptance Scenarios**:

1. **Given** das Migrationsskript wird ausgeführt und Änderungen werden vorgenommen, **When** die Migration abgeschlossen ist, **Then** wird ein Bericht mit der Anzahl der geänderten Buttons ausgegeben.

2. **Given** das Migrationsskript wird ausgeführt aber keine Änderungen sind notwendig, **When** die Migration abgeschlossen ist, **Then** wird eine Meldung ausgegeben, dass keine Änderungen notwendig waren.

---

### Edge Cases

- Was passiert, wenn die Konfigurationsdatei nicht gefunden wird?
- Was passiert, wenn die Konfigurationsdatei kein gültiges Format hat?
- Was passiert, wenn ein Button bereits den Feedback-Typ "bank_current_step" hat?
- Was passiert, wenn ein Button bereits die Option "step" mit einem anderen Wert hat?
- Was passiert, wenn das Skript keine Schreibrechte auf die Konfigurationsdatei hat?
- Was passiert, wenn das Skript mehrfach ausgeführt wird (Idempotenz)?
- Was passiert mit Elementen, die NICHT vom Typ "button" sind, aber trotzdem Feedbacks mit type="bank_pushed" haben? (Diese MÜSSEN unverändert bleiben)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Das Skript MUSS alle Buttons mit dem Attribut type="button" in der Konfiguration identifizieren.
- **FR-002**: Das Skript MUSS bei identifizierten Buttons alle Feedbacks mit type="bank_pushed" finden.
- **FR-003**: Das Skript MUSS NUR den Feedback-Typ von "bank_pushed" auf "bank_current_step" ändern. Alle anderen Feedback-Typen MÜSSEN unverändert bleiben.
- **FR-004**: Das Skript MUSS bei betroffenen Buttons die Eigenschaft "step" mit Wert 2 zu den "options" hinzufügen.
- **FR-005**: Das Skript MUSS bei betroffenen Buttons die Eigenschaft "latch_compatability" aus den "options" entfernen, sofern vorhanden.
- **FR-006**: Das Skript MUSS vor der Migration ein Backup der Original-Konfiguration erstellen.
- **FR-007**: Das Skript MUSS nach Abschluss einen Bericht über die durchgeführten Änderungen ausgeben.
- **FR-008**: Das Skript MUSS idempotent sein - mehrfache Ausführung darf keine zusätzlichen Änderungen verursachen.
- **FR-009**: Das Skript MUSS bei fehlender oder ungültiger Konfigurationsdatei eine verständliche Fehlermeldung ausgeben.
- **FR-010**: Alle für die Migration notwendigen Dateien MÜSSEN im Ordner `migrations/buttonFeedback2step` abgelegt werden.
- **FR-011**: Das Skript MUSS alle Feedbacks mit anderen Typen als "bank_pushed" (z.B. "bank_style", "bank_text", etc.) unverändert lassen.
- **FR-012**: Das Skript DARF NUR Feedbacks von Elementen verarbeiten, die den Typ "button" haben. Elemente mit anderen Typen (z.B. "pageup", "pagedown", "text", etc.) MÜSSEN vollständig ignoriert werden, auch wenn sie Feedbacks mit type="bank_pushed" enthalten.

### Key Entities

- **Button**: Ein Konfigurationselement mit type="button", enthält "feedbacks" und "options"
- **Feedback**: Ein Unter-Element eines Buttons mit einem "type"-Attribut (z.B. "bank_pushed", "bank_current_step")
- **Options**: Die Konfigurationsoptionen eines Buttons, können Eigenschaften wie "step" und "latch_compatability" enthalten
- **Backup**: Eine Sicherungskopie der Original-Konfigurationsdatei vor der Migration

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Nach Ausführung des Skripts existieren keine Buttons mehr mit Feedbacks vom Typ "bank_pushed".
- **SC-002**: Alle ursprünglich betroffenen Buttons haben nach der Migration einen Feedback vom Typ "bank_current_step".
- **SC-003**: Alle migrierten Buttons haben die Option "step" mit Wert 2.
- **SC-004**: Keine migrierten Buttons enthalten mehr die Option "latch_compatability".
- **SC-005**: Ein Backup der Original-Konfiguration existiert nach der Migration.
- **SC-006**: Das Skript gibt einen Bericht aus, der die Anzahl der migrierten Buttons anzeigt.
- **SC-007**: Bei erneuter Ausführung des Skripts werden keine weiteren Änderungen vorgenommen (Idempotenz-Prüfung bestanden).

## Assumptions

- Die Konfigurationsdatei liegt in einem standardmäßigen Format vor (JSON oder ähnliches strukturiertes Format)
- Das Skript hat Lese- und Schreibrechte auf die Konfigurationsdatei und den Backup-Ordner
- Es existiert nur eine relevante Konfigurationsdatei, die migriert werden muss
- Die Button-Struktur enthält die beschriebenen Eigenschaften ("type", "feedbacks", "options")
- Das Backup wird im selben Verzeichnis wie das Skript oder in einem konfigurierbaren Backup-Ordner gespeichert

## Out of Scope

- Automatische Rollback-Funktionalität (nur manuelles Rollback via Backup)
- Migration mehrerer Konfigurationsdateien gleichzeitig
- Interaktive Benutzeroberfläche - das Skript läuft kommandozeilenbasiert
- Dauerhafte/wiederkehrende Ausführung - dies ist ein einmaliges Migrationsskript
