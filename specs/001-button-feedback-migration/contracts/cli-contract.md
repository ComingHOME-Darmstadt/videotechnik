# CLI Contract: Button Feedback Migration Script

**Feature Branch**: `001-button-feedback-migration`  
**Date**: 2026-01-25

## Command Interface

### Basic Usage

```bash
python migrations/buttonFeedback2step/migrate.py
```

### Full Interface

```bash
python migrations/buttonFeedback2step/migrate.py [OPTIONS]
```

## Options

| Option | Short | Type | Default | Description |
|--------|-------|------|---------|-------------|
| `--config` | `-c` | PATH | `config/full.companionconfig` | Path to configuration file |
| `--dry-run` | `-n` | FLAG | false | Preview changes without modifying file |
| `--verbose` | `-v` | FLAG | false | Show detailed processing information |
| `--help` | `-h` | FLAG | - | Show help message |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success - migration completed (or no changes needed) |
| 1 | Error - file not found |
| 2 | Error - invalid JSON format |
| 3 | Error - permission denied |
| 4 | Error - unexpected error |

## Output Format

### Standard Output (Success)

```
=== Button Feedback Migration Report ===
Configuration: config/full.companionconfig
Mode: Migration (--dry-run not set)

Processing...

Results:
  Buttons processed:        42
  Feedbacks migrated:       23
  - Type changed:           23 (bank_pushed → bank_current_step)
  - Step option added:      23
  - latch_compatability removed: 21

Warnings: 0

✓ Migration completed successfully.
```

### Standard Output (No Changes)

```
=== Button Feedback Migration Report ===
Configuration: config/full.companionconfig
Mode: Migration (--dry-run not set)

Processing...

Results:
  Buttons processed:        42
  Feedbacks migrated:       0

No changes were necessary.
```

### Standard Output (Dry Run)

```
=== Button Feedback Migration Report ===
Configuration: config/full.companionconfig
Mode: DRY RUN (no changes will be written)

Processing...

Results (preview):
  Buttons that would be processed: 42
  Feedbacks that would be migrated: 23
  - Type changes:           23
  - Step options to add:    23
  - latch_compatability to remove: 21

Dry run complete - no changes were made.
```

### Standard Output (with Warnings)

```
=== Button Feedback Migration Report ===
Configuration: config/full.companionconfig
Mode: Migration (--dry-run not set)

Processing...

Results:
  Buttons processed:        42
  Feedbacks migrated:       23
  - Type changed:           23
  - Step option added:      23
  - latch_compatability removed: 21

Warnings: 2
  ⚠ Button [page:1, control:5]: Existing step value 1 was overwritten with 2
  ⚠ Button [page:3, control:12]: Existing step value 3 was overwritten with 2

✓ Migration completed successfully (with warnings).
```

### Standard Error (File Not Found)

```
ERROR: Configuration file not found: config/full.companionconfig
Please ensure the file exists or specify a different path with --config
```

### Standard Error (Invalid JSON)

```
ERROR: Invalid JSON format in configuration file
Details: Expecting ',' delimiter: line 1234 column 45
```

### Standard Error (Permission Denied)

```
ERROR: No write permission for configuration file: config/full.companionconfig
Please check file permissions or run with appropriate privileges
```

## Verbose Mode Output

When `--verbose` is set, additional processing details are shown:

```
=== Button Feedback Migration Report ===
Configuration: config/full.companionconfig
Mode: Migration (--dry-run not set)

Processing...
  [Page 1] Processing 8 controls...
    [Control 0] type=button, feedbacks=3
      - Feedback f1: bank_pushed → bank_current_step ✓
    [Control 1] type=button, feedbacks=1
      - Feedback f2: bank_style (skipped)
    [Control 2] type=pageup (skipped - not a button)
    ...

Results:
  ...
```

## Examples

### Example 1: Standard Migration
```bash
# Run from repository root
python migrations/buttonFeedback2step/migrate.py
```

### Example 2: Custom Config Path
```bash
python migrations/buttonFeedback2step/migrate.py --config /path/to/config.json
```

### Example 3: Preview Changes (Dry Run)
```bash
python migrations/buttonFeedback2step/migrate.py --dry-run
```

### Example 4: Verbose Dry Run
```bash
python migrations/buttonFeedback2step/migrate.py --dry-run --verbose
```

## Idempotency Contract

Running the script multiple times produces the same result:

```bash
# First run - performs migration
$ python migrations/buttonFeedback2step/migrate.py
Feedbacks migrated: 23
✓ Migration completed successfully.

# Second run - no changes (already migrated)
$ python migrations/buttonFeedback2step/migrate.py
Feedbacks migrated: 0
No changes were necessary.
```

## File Modification Contract

### Input File Requirements
- Valid JSON format
- Contains `pages` object with controls structure
- UTF-8 encoded

### Output File Guarantees
- Valid JSON format preserved
- Tab indentation (per Constitution Principle III)
- UTF-8 encoding preserved
- Non-ASCII characters preserved
- Only `bank_pushed` feedbacks in `type: "button"` controls are modified
- All other content remains unchanged
