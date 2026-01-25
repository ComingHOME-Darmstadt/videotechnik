# Research: Button Feedback Migration Script

**Feature Branch**: `001-button-feedback-migration`  
**Date**: 2026-01-25

## 1. JSON Structure Analysis

### Decision: Bitfocus Companion Configuration Format

**What was chosen**: The configuration file `config/full.companionconfig` uses a nested JSON structure with the following hierarchy:

```json
{
  "type": "full",
  "version": ...,
  "pages": {
    "<page_id>": {
      "controls": {
        "<control_id>": {
          "type": "button",       // <-- Filter criterion
          "feedbacks": [
            {
              "id": "<feedback_id>",
              "type": "bank_pushed",  // <-- Target for migration
              "instance_id": "internal",
              "options": {
                "latch_compatability": true,  // <-- Remove
                "location_target": "this"
              },
              "style": { ... },
              "isInverted": false,
              "children": []
            }
          ],
          "steps": { ... },
          "style": { ... },
          "options": { ... }
        }
      }
    }
  }
}
```

**Rationale**: Direct analysis of the actual `config/full.companionconfig` file confirms this structure. The migration must navigate through `pages` → `controls` → filter by `type: "button"` → iterate `feedbacks` array → find `type: "bank_pushed"`.

**Alternatives considered**:
- Regex-based transformation: Rejected - too fragile for nested JSON structures
- XPATH-style queries: Not applicable to JSON without additional libraries

---

## 2. JSON Formatting Preservation

### Decision: Use `json.dumps(indent='\t')` with sort_keys=False

**What was chosen**: Python's standard `json` library with tab indentation:

```python
json.dumps(data, indent='\t', ensure_ascii=False)
```

**Rationale**: 
- Constitution Principle III mandates tab indentation
- `ensure_ascii=False` preserves German characters in text labels
- `sort_keys=False` (default) maintains original key order for cleaner diffs

**Alternatives considered**:
- Using `indent=4` (spaces): Rejected - violates Constitution Principle III
- Using orjson/ujson: Rejected - adds external dependency, stdlib sufficient

---

## 3. Idempotency Strategy

### Decision: Check feedback type before modification

**What was chosen**: The script checks if `feedback["type"] == "bank_pushed"` before making any changes. After migration, the type becomes `"bank_current_step"`, so subsequent runs will skip these feedbacks.

**Rationale**: 
- Simple and reliable approach
- No need for external state tracking (e.g., log files, database)
- Natural idempotency through state inspection

**Alternatives considered**:
- Lock file or migration log: Rejected - over-engineering for single file migration
- Version marker in config: Rejected - pollutes config with non-Companion data

---

## 4. Error Handling Strategy

### Decision: Fail-fast with descriptive messages

**What was chosen**: 
- FileNotFoundError → "Configuration file not found: {path}"
- json.JSONDecodeError → "Invalid JSON format in configuration file"
- PermissionError → "No write permission for configuration file"

**Rationale**: Migration scripts should halt on errors rather than partially modify data. Git provides rollback capability as per spec assumptions.

**Alternatives considered**:
- Partial migration with error collection: Rejected - risk of inconsistent state
- Automatic backup before modification: Rejected - out of scope, Git provides this

---

## 5. Report Format

### Decision: Plain text console output with summary

**What was chosen**:
```
=== Button Feedback Migration Report ===
Buttons processed: 15
Feedbacks migrated: 20
- bank_pushed → bank_current_step: 20
- step option added: 20
- latch_compatability removed: 18

Warnings:
- Button "xyz" had existing step value 1, overwritten with 2

Migration completed successfully.
```

**Rationale**: Simple, readable output for console. No external log file needed (console can be redirected if needed).

**Alternatives considered**:
- JSON report: Rejected - overkill for human consumption
- Log file: Rejected - adds complexity, console redirect sufficient

---

## 6. Element Type Filtering

### Decision: Strict type="button" filtering at control level

**What was chosen**: Only process elements where `control["type"] == "button"`. Elements with other types (`pageup`, `pagedown`, `text`, etc.) are completely ignored.

**Rationale**: FR-011 explicitly requires that non-button elements remain untouched even if they contain `bank_pushed` feedbacks. This is a safety measure to prevent unintended modifications.

**Alternatives considered**:
- Process all elements with bank_pushed: Rejected - violates FR-011
- Warning for non-button bank_pushed: Could be added but not required

---

## 7. Python Version Compatibility

### Decision: Python 3.8+ (stdlib only)

**What was chosen**: Target Python 3.8 as minimum version with no external dependencies.

**Rationale**:
- Python 3.8 is widely available and provides f-strings, walrus operator, and other modern features
- Using only stdlib avoids dependency management
- `json`, `argparse`, `pathlib` modules available since Python 3.4+

**Alternatives considered**:
- Python 3.6: Rejected - reaching end of life, f-strings less convenient
- Python 3.11+: Rejected - may not be available on all target systems

---

## 8. Configuration Path Handling

### Decision: Relative path from repository root

**What was chosen**: Default path is `config/full.companionconfig` relative to where the script is executed. Script assumes execution from repository root or provides `--config` flag for custom path.

**Rationale**: Standard location per Constitution Principle II.

**Alternatives considered**:
- Hardcoded absolute path: Rejected - not portable
- Environment variable: Rejected - over-engineering

---

## Summary: All NEEDS CLARIFICATION Resolved

| Item | Resolution |
|------|------------|
| JSON Structure | Nested: pages → controls → feedbacks |
| Formatting | Tab indentation via `json.dumps(indent='\t')` |
| Idempotency | Check feedback type before modification |
| Error Handling | Fail-fast with descriptive messages |
| Report Format | Plain text console output |
| Type Filtering | Strict `type: "button"` at control level |
| Python Version | 3.8+ with stdlib only |
| Config Path | Relative from repo root, configurable via CLI |
