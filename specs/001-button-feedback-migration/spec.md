# Feature Specification: Button Feedback Migration Script

**Feature Branch**: `001-button-feedback-migration`  
**Created**: 2026-01-25  
**Status**: Draft  
**Input**: User description: "Migrationsskript zur Änderung von Button-Feedbacks von 'bank_pushed' zu 'bank_current_step' mit entsprechenden Options-Anpassungen"

## Übersicht

Dieses Feature beschreibt ein einmaliges Migrationsskript, das die Konfigurationsdatei `config/full.companionconfig` modifiziert. Das Skript ändert spezifische Feedback-Typen und passt zugehörige Feedback-Optionen an.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Einmalige Konfigurationsmigration ausführen (Priority: P1)

Als Administrator möchte ich ein Migrationsskript ausführen, das alle betroffenen Button-Konfigurationen automatisch aktualisiert, damit ich die Konfiguration nicht manuell ändern muss.

**Why this priority**: Dies ist die Kernfunktionalität des Features - ohne die erfolgreiche Migration ist das Feature wertlos.

**Independent Test**: Kann vollständig getestet werden, indem das Skript auf eine Testkonfiguration angewendet wird und die Ergebnisse geprüft werden.

**Acceptance Scenarios**:

1. **Given** eine Konfigurationsdatei mit Buttons (type="button") die Feedbacks mit type="bank_pushed" enthalten, **When** das Migrationsskript ausgeführt wird, **Then** werden ausschließlich die Feedbacks vom Typ "bank_pushed" auf "bank_current_step" geändert, während alle anderen Feedback-Typen unverändert bleiben.

2. **Given** ein Button mit einem Feedback vom Typ "bank_pushed", **When** das Migrationsskript diesen Button verarbeitet, **Then** wird bei den "options" des betroffenen Feedbacks die Eigenschaft "step" mit Wert 2 hinzugefügt.

3. **Given** ein Button mit einem Feedback vom Typ "bank_pushed" dessen Feedback-Options die Eigenschaft "latch_compatability" enthalten, **When** das Migrationsskript diesen Button verarbeitet, **Then** wird die Eigenschaft "latch_compatability" aus den Feedback-Options entfernt.

4. **Given** eine Konfigurationsdatei ohne betroffene Buttons (keine mit type="button" und feedback type="bank_pushed"), **When** das Migrationsskript ausgeführt wird, **Then** bleibt die Konfiguration unverändert.

5. **Given** ein Button mit mehreren Feedbacks (z.B. type="bank_pushed", type="bank_style", type="bank_text"), **When** das Migrationsskript diesen Button verarbeitet, **Then** wird nur der Feedback mit type="bank_pushed" auf "bank_current_step" geändert und alle anderen Feedbacks bleiben unverändert.

6. **Given** ein Element mit einem anderen Typ als "button" (z.B. type="pageup" oder type="text") das Feedbacks mit type="bank_pushed" enthält, **When** das Migrationsskript ausgeführt wird, **Then** bleibt dieses Element vollständig unverändert.

7. **Given** ein Button mit einem Feedback vom Typ "bank_pushed" dessen Feedback-Options bereits eine Eigenschaft "step" mit einem Wert ungleich 2 enthält, **When** das Migrationsskript diesen Button verarbeitet, **Then** wird der vorhandene "step"-Wert mit 2 überschrieben UND eine Warnung ausgegeben, die den ursprünglichen Wert dokumentiert.

8. **Given** ein Button mit einem Feedback vom Typ "bank_pushed" dessen Feedback-Options bereits eine Eigenschaft "step" mit dem Wert 2 enthält, **When** das Migrationsskript diesen Button verarbeitet, **Then** wird dies still ignoriert und keine Warnung ausgegeben.

---

### User Story 2 - Migrationsbericht erhalten (Priority: P2)

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
- Was passiert, wenn ein Feedback bereits die Option "step" mit einem anderen Wert hat? → Überschreiben mit 2 und Warnung ausgeben (siehe FR-004a)
- Was passiert, wenn ein Feedback bereits die Option "step" mit dem Wert 2 hat? → Still ignorieren, keine Warnung (siehe FR-004a)
- Was passiert, wenn das Skript keine Schreibrechte auf die Konfigurationsdatei hat?
- Was passiert, wenn das Skript mehrfach ausgeführt wird (Idempotenz)?
- Was passiert mit Elementen, die NICHT vom Typ "button" sind, aber trotzdem Feedbacks mit type="bank_pushed" haben? (Diese MÜSSEN unverändert bleiben)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Das Skript MUSS alle Buttons mit dem Attribut type="button" in der Konfiguration identifizieren.
- **FR-002**: Das Skript MUSS bei identifizierten Buttons alle Feedbacks mit type="bank_pushed" finden.
- **FR-003**: Das Skript MUSS NUR den Feedback-Typ von "bank_pushed" auf "bank_current_step" ändern. Alle anderen Feedback-Typen MÜSSEN unverändert bleiben.
- **FR-004**: Das Skript MUSS bei betroffenen Feedbacks die Eigenschaft "step" mit Wert 2 zu den Feedback-"options" hinzufügen. Falls bereits ein "step"-Wert existiert, MUSS dieser mit 2 überschrieben werden.
- **FR-004a**: Falls ein vorhandener "step"-Wert überschrieben wird und dieser ungleich 2 war, MUSS das Skript eine Warnung ausgeben, die den ursprünglichen Wert dokumentiert. Falls der vorhandene Wert bereits 2 ist, wird dies still ignoriert (keine Warnung).
- **FR-005**: Das Skript MUSS bei betroffenen Feedbacks die Eigenschaft "latch_compatability" aus den Feedback-"options" entfernen, sofern vorhanden.
- **FR-006**: Das Skript MUSS nach Abschluss einen Bericht über die durchgeführten Änderungen ausgeben.
- **FR-007**: Das Skript MUSS idempotent sein - mehrfache Ausführung darf keine zusätzlichen Änderungen verursachen.
- **FR-008**: Das Skript MUSS bei fehlender oder ungültiger Konfigurationsdatei eine verständliche Fehlermeldung ausgeben.
- **FR-009**: Alle für die Migration notwendigen Dateien MÜSSEN im Ordner `migrations/buttonFeedback2step` abgelegt werden.
- **FR-010**: Das Skript MUSS alle Feedbacks mit anderen Typen als "bank_pushed" (z.B. "bank_style", "bank_text", etc.) unverändert lassen.
- **FR-011**: Das Skript DARF NUR Feedbacks von Elementen verarbeiten, die den Typ "button" haben. Elemente mit anderen Typen (z.B. "pageup", "pagedown", "text", etc.) MÜSSEN vollständig ignoriert werden, auch wenn sie Feedbacks mit type="bank_pushed" enthalten.
- **FR-012**: Das Skript MUSS die Konfigurationsdatei `config/full.companionconfig` verarbeiten.
- **FR-013**: Das Skript MUSS in Python geschrieben sein.
- **FR-014**: Im Ordner `migrations/buttonFeedback2step` MUSS eine README.md-Datei enthalten sein, die dokumentiert, wie das Skript ausgeführt wird (inkl. Python-Version, ggf. benötigte Abhängigkeiten, Ausführungsbefehl).
- **FR-015**: Das Skript MUSS die JSON-Formatierung der Originaldatei beibehalten (Tab-Einrückung).

### Key Entities

- **Button**: Ein Konfigurationselement mit type="button", enthält "feedbacks"
- **Feedback**: Ein Unter-Element eines Buttons mit einem "type"-Attribut (z.B. "bank_pushed", "bank_current_step") und eigenen "options"
- **Feedback-Options**: Die Konfigurationsoptionen eines Feedbacks, können Eigenschaften wie "step" und "latch_compatability" enthalten
- **Migrationsskript**: Python-Skript im Ordner `migrations/buttonFeedback2step`
- **README.md**: Dokumentation zur Ausführung des Skripts

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Nach Ausführung des Skripts existieren keine Buttons mehr mit Feedbacks vom Typ "bank_pushed".
- **SC-002**: Alle ursprünglich betroffenen Buttons haben nach der Migration einen Feedback vom Typ "bank_current_step".
- **SC-003**: Alle migrierten Feedbacks haben die Option "step" mit Wert 2 in ihren Feedback-Options.
- **SC-004**: Keine migrierten Feedbacks enthalten mehr die Option "latch_compatability" in ihren Feedback-Options.
- **SC-005**: Das Skript gibt einen Bericht aus, der die Anzahl der migrierten Feedbacks anzeigt.
- **SC-005a**: Falls "step"-Werte überschrieben wurden, enthält der Bericht Warnungen mit den ursprünglichen Werten.
- **SC-006**: Bei erneuter Ausführung des Skripts werden keine weiteren Änderungen vorgenommen (Idempotenz-Prüfung bestanden).
- **SC-007**: Eine README.md-Datei im Ordner `migrations/buttonFeedback2step` dokumentiert die Ausführung des Skripts.

## Assumptions

- Die Konfigurationsdatei `config/full.companionconfig` liegt im JSON-Format vor
- Das Skript hat Lese- und Schreibrechte auf die Konfigurationsdatei
- Die Button-Struktur enthält die beschriebenen Eigenschaften ("type", "feedbacks", "options")
- Die Konfigurationsdatei ist versioniert (Git), daher ist kein separates Backup erforderlich
- Python 3.x ist auf dem System installiert und verfügbar

## Out of Scope

- Automatische Rollback-Funktionalität (Rollback erfolgt über Git-Versionierung)
- Backup-Erstellung (Konfigurationsdatei ist versioniert)
- Migration mehrerer Konfigurationsdateien gleichzeitig
- Interaktive Benutzeroberfläche - das Skript läuft kommandozeilenbasiert
- Dauerhafte/wiederkehrende Ausführung - dies ist ein einmaliges Migrationsskript
