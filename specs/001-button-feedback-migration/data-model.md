# Data Model: Button Feedback Migration Script

**Feature Branch**: `001-button-feedback-migration`  
**Date**: 2026-01-25

## 1. Configuration File Structure

### CompanionConfig (Root)

| Field | Type | Description |
|-------|------|-------------|
| type | string | Config type, always "full" |
| version | number | Config version number |
| pages | dict[string, Page] | Pages indexed by page ID |
| ... | various | Other config sections (not modified) |

### Page

| Field | Type | Description |
|-------|------|-------------|
| name | string | Page display name |
| controls | dict[string, Control] | Controls indexed by position ID |
| gridSize | object | Grid dimensions |

### Control (Button)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| type | string | YES | Control type: "button", "pageup", "pagedown", "text", etc. |
| style | Style | YES | Visual style settings |
| options | ControlOptions | YES | Control behavior options |
| feedbacks | Feedback[] | YES | Array of feedback configurations |
| steps | dict[string, Step] | YES | Action steps |

**Migration Filter**: Only controls with `type == "button"` are processed.

### Style

| Field | Type | Description |
|-------|------|-------------|
| text | string | Button label text |
| textExpression | boolean | Whether text is a dynamic expression |
| size | string | Font size |
| png64 | string\|null | Base64 encoded PNG image |
| alignment | string | Text alignment |
| pngalignment | string | Image alignment |
| color | number | Text color (RGB integer) |
| bgcolor | number | Background color (RGB integer) |
| show_topbar | string | Topbar visibility setting |
| png | string\|null | PNG reference |

### ControlOptions

| Field | Type | Description |
|-------|------|-------------|
| relativeDelay | boolean | Relative delay mode |
| rotaryActions | boolean | Rotary encoder support |
| stepAutoProgress | boolean | Auto-progress through steps |

---

## 2. Feedback Structure (Migration Target)

### Feedback (Before Migration)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | YES | Unique feedback ID |
| type | string | YES | **`"bank_pushed"`** → Target for migration |
| instance_id | string | YES | Instance reference (usually "internal") |
| options | FeedbackOptions | YES | Feedback configuration options |
| style | FeedbackStyle | NO | Style overrides when feedback is active |
| isInverted | boolean | YES | Invert feedback condition |
| children | array | YES | Child feedbacks (usually empty) |

### FeedbackOptions (Before Migration)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| latch_compatability | boolean | NO | **Remove during migration** |
| location_target | string | YES | Target location reference |

### Feedback (After Migration)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | YES | Unchanged |
| type | string | YES | **`"bank_current_step"`** ← Changed |
| instance_id | string | YES | Unchanged |
| options | FeedbackOptions | YES | Modified options |
| style | FeedbackStyle | NO | Unchanged |
| isInverted | boolean | YES | Unchanged |
| children | array | YES | Unchanged |

### FeedbackOptions (After Migration)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| step | number | YES | **Added: value = 2** |
| location_target | string | YES | Unchanged |

**Note**: `latch_compatability` is removed from options.

---

## 3. Migration Transformation Rules

### Rule 1: Feedback Type Change
```
BEFORE: feedback.type = "bank_pushed"
AFTER:  feedback.type = "bank_current_step"
```

### Rule 2: Add Step Option
```
BEFORE: feedback.options = { "location_target": "this", ... }
AFTER:  feedback.options = { "step": 2, "location_target": "this", ... }
```

**Edge Case**: If `step` already exists:
- If `step == 2`: No change, no warning
- If `step != 2`: Overwrite with 2, emit warning with original value

### Rule 3: Remove latch_compatability
```
BEFORE: feedback.options = { "latch_compatability": true, ... }
AFTER:  feedback.options = { ... }  // latch_compatability removed
```

---

## 4. State Transitions

```
┌─────────────────────┐
│  BUTTON CONTROL     │
│  type: "button"     │
├─────────────────────┤
│  feedbacks: [...]   │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────────────────────────────────┐
│              FEEDBACK STATES                      │
├─────────────────────────────────────────────────┤
│                                                   │
│  ┌─────────────────┐    Migration    ┌─────────────────────┐
│  │  bank_pushed    │ ────────────▶  │  bank_current_step  │
│  │                 │                 │  + step: 2          │
│  │  + latch_compat │                 │  - latch_compat     │
│  └─────────────────┘                 └─────────────────────┘
│                                                   │
│  ┌─────────────────┐                             │
│  │  bank_style     │ ────────────▶  (unchanged)  │
│  └─────────────────┘                             │
│                                                   │
│  ┌─────────────────┐                             │
│  │  bank_text      │ ────────────▶  (unchanged)  │
│  └─────────────────┘                             │
│                                                   │
│  ┌─────────────────────────┐                     │
│  │  bank_current_step      │ ───▶  (skip - idem) │
│  │  (already migrated)     │                     │
│  └─────────────────────────┘                     │
│                                                   │
└─────────────────────────────────────────────────┘
```

---

## 5. Validation Rules

### Pre-Migration Validation

| Rule | Check | Error Type |
|------|-------|------------|
| V-001 | File exists at path | FileNotFoundError |
| V-002 | File is valid JSON | JSONDecodeError |
| V-003 | File has write permission | PermissionError |
| V-004 | Root has "pages" key | KeyError |

### Migration Validation (per feedback)

| Rule | Check | Action |
|------|-------|--------|
| V-101 | control.type == "button" | Skip if false |
| V-102 | feedback.type == "bank_pushed" | Skip if false |
| V-103 | feedback.options.step exists and != 2 | Warn and overwrite |
| V-104 | feedback.options.latch_compatability exists | Remove |

---

## 6. Report Data Model

### MigrationReport

| Field | Type | Description |
|-------|------|-------------|
| buttons_processed | int | Total buttons examined |
| feedbacks_migrated | int | Total feedbacks changed |
| types_changed | int | bank_pushed → bank_current_step count |
| steps_added | int | step: 2 options added |
| latch_removed | int | latch_compatability options removed |
| warnings | list[Warning] | List of warning messages |
| success | boolean | True if migration completed |

### Warning

| Field | Type | Description |
|-------|------|-------------|
| button_id | string | Affected button identifier |
| message | string | Warning description |
| original_value | any | Value that was overwritten |

---

## 7. File Path Configuration

| Path | Purpose |
|------|---------|
| `config/full.companionconfig` | Source/target configuration file |
| `migrations/buttonFeedback2step/migrate.py` | Migration script |
| `migrations/buttonFeedback2step/README.md` | Execution documentation |
