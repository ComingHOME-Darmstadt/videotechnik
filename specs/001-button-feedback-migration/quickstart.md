# Quickstart: Button Feedback Migration

**Feature Branch**: `001-button-feedback-migration`  
**Date**: 2026-01-25

## Übersicht

Dieses Migrationsskript aktualisiert die Bitfocus Companion Konfiguration:
- Ändert Feedback-Typ von `bank_pushed` zu `bank_current_step`
- Fügt `step: 2` Option hinzu
- Entfernt `latch_compatability` Option

## Voraussetzungen

- Python 3.8 oder höher
- Zugriff auf `config/full.companionconfig`

## Schnellstart

### 1. Migration prüfen (Dry Run)

```bash
cd C:\accso\dev\comingHOME\videotechnik
python migrations/buttonFeedback2step/migrate.py --dry-run
```

### 2. Migration durchführen

```bash
python migrations/buttonFeedback2step/migrate.py
```

### 3. Ergebnis prüfen

Der Migrationsbericht zeigt:
- Anzahl verarbeiteter Buttons
- Anzahl migrierter Feedbacks
- Eventuelle Warnungen

## Erwartetes Verhalten

| Vorher | Nachher |
|--------|---------|
| `type: "bank_pushed"` | `type: "bank_current_step"` |
| `options: { latch_compatability: true }` | `options: { step: 2 }` |

## Rollback

Bei Problemen: Git-Reset auf vorherigen Stand:

```bash
git checkout -- config/full.companionconfig
```

## Weiterführende Dokumentation

- [Vollständige Spezifikation](./spec.md)
- [Implementierungsplan](./plan.md)
- [CLI-Dokumentation](./contracts/cli-contract.md)
- [Datenmodell](./data-model.md)
