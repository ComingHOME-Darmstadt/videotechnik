# Tasks: Button Feedback Migration Script

**Input**: Design documents from `/specs/001-button-feedback-migration/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, contracts/cli-contract.md ✅

**Tests**: Tests are OPTIONAL for this feature. Test tasks are not included unless explicitly requested.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Include exact file paths in descriptions

## Path Conventions

This feature uses: `migrations/buttonFeedback2step/` at repository root

---

## Phase 1: Setup (Project Infrastructure)

**Purpose**: Create migration script folder structure and documentation

- [ ] T001 Create migration directory structure at `migrations/buttonFeedback2step/`
- [ ] T002 [P] Create README.md documentation at `migrations/buttonFeedback2step/README.md`
- [ ] T003 [P] Create migrate.py script skeleton with CLI interface at `migrations/buttonFeedback2step/migrate.py`

---

## Phase 2: Foundational (Core Script Structure)

**Purpose**: Implement core script infrastructure that ALL functionality depends on

**⚠️ CRITICAL**: User story implementation requires these foundations to be complete

- [ ] T004 Implement argparse CLI parsing with --config, --dry-run, --verbose, --help options in `migrations/buttonFeedback2step/migrate.py`
- [ ] T005 Implement configuration file loading with JSON parsing in `migrations/buttonFeedback2step/migrate.py`
- [ ] T006 Implement error handling for FileNotFoundError (exit code 1), JSONDecodeError (exit code 2), PermissionError (exit code 3) in `migrations/buttonFeedback2step/migrate.py`
- [ ] T007 Implement JSON writing with tab indentation (`indent='\t'`, `ensure_ascii=False`) in `migrations/buttonFeedback2step/migrate.py`

**Checkpoint**: Foundation ready - user story implementation can now begin

---

## Phase 3: User Story 1 - Einmalige Konfigurationsmigration ausführen (Priority: P1) 🎯 MVP

**Goal**: Automatische Migration aller Button-Feedbacks von `bank_pushed` zu `bank_current_step` mit Options-Anpassungen

**Independent Test**: Skript auf `config/full.companionconfig` ausführen und prüfen:
1. Alle `bank_pushed` → `bank_current_step` geändert
2. Alle migrierten Feedbacks haben `"step": 2`
3. Keine `latch_compatability` mehr vorhanden
4. Nur Buttons (type="button") wurden verarbeitet
5. Bei erneuter Ausführung: keine weiteren Änderungen (Idempotenz)

### Implementation for User Story 1

- [ ] T008 [US1] Implement page and control iteration logic (navigate pages → controls) in `migrations/buttonFeedback2step/migrate.py`
- [ ] T009 [US1] Implement button type filter (only process controls with type="button") in `migrations/buttonFeedback2step/migrate.py`
- [ ] T010 [US1] Implement feedback iteration and bank_pushed detection in `migrations/buttonFeedback2step/migrate.py`
- [ ] T011 [US1] Implement feedback type change from "bank_pushed" to "bank_current_step" in `migrations/buttonFeedback2step/migrate.py`
- [ ] T012 [US1] Implement "step": 2 option addition to feedback options in `migrations/buttonFeedback2step/migrate.py`
- [ ] T013 [US1] Implement "latch_compatability" option removal from feedback options in `migrations/buttonFeedback2step/migrate.py`
- [ ] T014 [US1] Implement warning for existing "step" values being overwritten (only if value != 2) in `migrations/buttonFeedback2step/migrate.py`
- [ ] T015 [US1] Implement dry-run mode (preview changes without writing) in `migrations/buttonFeedback2step/migrate.py`
- [ ] T016 [US1] Implement idempotency check (skip already migrated feedbacks) in `migrations/buttonFeedback2step/migrate.py`

**Checkpoint**: User Story 1 (Migration) is fully functional and testable

---

## Phase 4: User Story 2 - Migrationsbericht erhalten (Priority: P2)

**Goal**: Nach der Migration einen detaillierten Bericht über alle durchgeführten Änderungen erhalten

**Independent Test**: Skript ausführen und Bericht-Ausgabe prüfen:
1. Anzahl verarbeiteter Buttons wird angezeigt
2. Anzahl migrierter Feedbacks wird angezeigt
3. Warnungen für überschriebene Step-Werte werden angezeigt
4. Bei keinen Änderungen: "No changes were necessary" Meldung

### Implementation for User Story 2

- [ ] T017 [US2] Implement migration statistics tracking (buttons processed, feedbacks migrated, options changed) in `migrations/buttonFeedback2step/migrate.py`
- [ ] T018 [US2] Implement warning collection for overwritten step values in `migrations/buttonFeedback2step/migrate.py`
- [ ] T019 [US2] Implement standard migration report output format in `migrations/buttonFeedback2step/migrate.py`
- [ ] T020 [US2] Implement "no changes necessary" message for empty migrations in `migrations/buttonFeedback2step/migrate.py`
- [ ] T021 [US2] Implement verbose mode output with detailed processing information in `migrations/buttonFeedback2step/migrate.py`
- [ ] T022 [US2] Implement dry-run specific report format ("would be migrated" vs "migrated") in `migrations/buttonFeedback2step/migrate.py`

**Checkpoint**: User Stories 1 AND 2 are fully functional

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Documentation finalization and validation

- [ ] T023 [P] Complete README.md with full usage instructions, examples, and rollback information in `migrations/buttonFeedback2step/README.md`
- [ ] T024 [P] Add docstrings and inline comments to migrate.py in `migrations/buttonFeedback2step/migrate.py`
- [ ] T025 Run migration in dry-run mode on actual `config/full.companionconfig` to validate
- [ ] T026 Execute quickstart.md validation steps from `specs/001-button-feedback-migration/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Story 1 (Phase 3)**: Depends on Foundational phase completion
- **User Story 2 (Phase 4)**: Depends on Foundational phase completion, integrates with US1 statistics
- **Polish (Phase 5)**: Depends on all user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - This is the core migration logic
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - Adds reporting on top of US1 migration stats

### Within Each User Story

- Core data processing before specialized logic
- Migration logic before dry-run handling
- Processing before reporting

### Parallel Opportunities

- T002 and T003 can run in parallel (README and script skeleton)
- T023 and T024 can run in parallel (documentation tasks)

---

## Parallel Example: Setup Phase

```bash
# Launch Setup tasks in parallel:
Task T002: "Create README.md documentation at migrations/buttonFeedback2step/README.md"
Task T003: "Create migrate.py script skeleton at migrations/buttonFeedback2step/migrate.py"
```

---

## Parallel Example: Polish Phase

```bash
# Launch documentation tasks in parallel:
Task T023: "Complete README.md with full usage instructions"
Task T024: "Add docstrings and inline comments to migrate.py"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001-T003)
2. Complete Phase 2: Foundational (T004-T007)
3. Complete Phase 3: User Story 1 (T008-T016)
4. **STOP and VALIDATE**: Test migration on actual config file with --dry-run
5. Deploy/use if ready - migration functional without reporting

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test with --dry-run → Core migration works (MVP!)
3. Add User Story 2 → Test report output → Full feature complete
4. Polish phase → Documentation complete

### Single Developer Strategy

Recommended execution order:

1. T001 → T002, T003 (parallel)
2. T004 → T005 → T006 → T007 (sequential, building on each other)
3. T008 → T009 → T010 → T011 → T012 → T013 → T014 → T015 → T016
4. T017 → T018 → T019 → T020 → T021 → T022
5. T023, T024 (parallel) → T025 → T026

---

## Notes

- [P] tasks = different files or independent sections, no dependencies
- [Story] label maps task to specific user story for traceability
- All tasks target `migrations/buttonFeedback2step/migrate.py` or `migrations/buttonFeedback2step/README.md`
- Python 3.8+ required, Standard Library only (json, argparse, pathlib)
- JSON formatting MUST use tab indentation as per Constitution Principle III
- Verify idempotency by running migration twice
- Git provides rollback capability - no backup functionality needed
