# Implementation Plan: Button Feedback Migration Script

**Branch**: `001-button-feedback-migration` | **Date**: 2026-01-25 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-button-feedback-migration/spec.md`

## Summary

Ein einmaliges Python-Migrationsskript, das die Bitfocus Companion Konfigurationsdatei `config/full.companionconfig` modifiziert. Das Skript ändert bei Buttons (type="button") alle Feedbacks vom Typ "bank_pushed" zu "bank_current_step", fügt die Option "step": 2 hinzu und entfernt "latch_compatability". Das Skript ist idempotent und erzeugt einen Migrationsbericht.

## Technical Context

**Language/Version**: Python 3.8+ (Standard Library only - no external dependencies)  
**Primary Dependencies**: json (stdlib), argparse (stdlib), pathlib (stdlib)  
**Storage**: JSON file (`config/full.companionconfig`)  
**Testing**: pytest with manual test fixtures  
**Target Platform**: Windows (primary), cross-platform compatible  
**Project Type**: Single CLI script (migration utility)  
**Performance Goals**: N/A (one-time migration, file typically <10MB)  
**Constraints**: Must preserve JSON formatting (tab indentation), must be idempotent  
**Scale/Scope**: Single configuration file, ~20+ buttons with bank_pushed feedbacks

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] **Documentation**: Installation prerequisites documented in README.md? → Migration README.md will be created in `migrations/buttonFeedback2step/`
- [x] **Configuration Storage**: Companion config in `config/full.companionconfig`? → YES, script reads/writes this file
- [x] **JSON Formatting**: Tab indentation and line breaks preserved? → YES, script will use `json.dumps(indent='\t')`
- [ ] **CasparCG Config**: Server config in `config/casparcg-server.config`? → N/A (not modified by this feature)
- [ ] **Channel/Layer Docs**: Changes documented in `help/CasparCG-Kanalbelegung.md`? → N/A (not modified by this feature)
- [ ] **Media Files**: Media stored in `config/media/`? → N/A (not applicable)
- [ ] **Templates**: Templates stored in `config/template/`? → N/A (not applicable)

**Constitution Check Status**: ✅ PASSED - All applicable principles satisfied

## Project Structure

### Documentation (this feature)

```text
specs/001-button-feedback-migration/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output (CLI contract)
│   └── cli-contract.md
└── tasks.md             # Phase 2 output (created by /speckit.tasks)
```

### Source Code (repository root)

```text
migrations/buttonFeedback2step/
├── migrate.py           # Main migration script
├── README.md            # Execution documentation
└── tests/               # Optional: test fixtures
    ├── test_migrate.py
    └── fixtures/
        └── sample_config.json
```

**Structure Decision**: Flat single-script structure in dedicated migration folder. No complex architecture needed for a one-time migration utility. Tests optional but recommended for validation.

## Complexity Tracking

> No Constitution Check violations requiring justification.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| N/A | N/A | N/A |
