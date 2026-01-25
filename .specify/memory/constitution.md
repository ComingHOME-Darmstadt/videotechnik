<!--

================================================================================
SYNC IMPACT REPORT
================================================================================
Version change: 0.0.0 → 1.0.0 (Initial creation)

Modified principles: N/A (Initial creation)

Added sections:
  - Core Principles (7 principles total)
  - File Locations (new section replacing Section 2)
  - Workflow Guidelines (new section replacing Section 3)
  - Governance

Removed sections: N/A (Initial creation)

Templates requiring updates:
  - .specify/templates/plan-template.md - ✅ updated (Constitution Check section now references project principles)
  - .specify/templates/spec-template.md - ✅ no changes needed
  - .specify/templates/tasks-template.md - ✅ no changes needed

Follow-up TODOs: None
================================================================================
-->

# ComingHOME Videotechnik Constitution

## Core Principles

### I. Documentation

All basic installation prerequisites and setup instructions MUST be documented in the README.md file at the repository root.

**Rationale**: New team members and contributors need a clear entry point to understand system requirements and initial setup steps without searching through multiple files.

### II. Configuration Storage

Configurations for the Bitfocus Companion control system MUST be stored in the file `config/full.companionconfig` in JSON format.

**Rationale**: Centralized configuration storage ensures version control of control system settings and enables reproducible setups across different machines.

### III. JSON Formatting Standards

The `config/full.companionconfig` file MUST be saved as a nicely formatted JSON file with tab indentation.

**Rules**:
- Use tab characters for indentation (not spaces)
- Preserve line breaks for readability
- When exporting configurations from Bitfocus Companion, verify formatting before committing
- Manual changes MUST maintain consistent formatting

**Rationale**: Consistent JSON formatting enables meaningful diff comparisons in version control and makes manual editing more manageable.

### IV. CasparCG Server Configuration

The CasparCG server configuration MUST be stored in the file `config/casparcg-server.config`.

**Rationale**: Separating server configuration from Companion control configuration allows independent versioning and easier troubleshooting of server-specific issues.

### V. Channel and Layer Documentation

All channels and layers used in the CasparCG server MUST be documented in `help/CasparCG-Kanalbelegung.md`.

**Rules**:
- Document channel purpose and NDI output name
- Document layer assignments with their input sources
- Update documentation when channel/layer assignments change

**Rationale**: Clear channel/layer documentation is essential for operators to understand the video routing and for troubleshooting signal flow issues.

### VI. Media Files

Media files (especially videos) for the CasparCG server MUST be stored in the `config/media` folder.

**Notes**:
- The subfolder `config/media/Videos` is excluded from version control
- Only reference media and essential files should be committed

**Rationale**: Centralized media storage enables consistent path references in configurations while allowing large video files to be excluded from version control.

### VII. Templates

Templates for the CasparCG server MUST be stored in the `config/template` folder.

**Rationale**: Separating templates from media files and configurations maintains a clear organizational structure and allows template-specific versioning.

## File Locations

This section provides a quick reference for key file locations in the project:

| Purpose | Path |
|---------|------|
| Installation documentation | `README.md` |
| Companion configuration | `config/full.companionconfig` |
| CasparCG server config | `config/casparcg-server.config` |
| Channel/Layer documentation | `help/CasparCG-Kanalbelegung.md` |
| Media files | `config/media/` |
| Templates | `config/template/` |
| CasparCG Server executable | `casparcg-server/` |
| CasparCG Client | `casparcg-client/` |

## Workflow Guidelines

### Configuration Changes

1. **Exporting from Bitfocus Companion**: After exporting `full.companionconfig`, verify JSON formatting (tab indentation, line breaks) before committing
2. **Manual JSON edits**: Use a JSON-aware editor that respects the formatting conventions
3. **CasparCG Server changes**: Document any channel/layer modifications in `help/CasparCG-Kanalbelegung.md`

### Version Control

- Configurations in `config/` MUST be committed to version control (except `config/media/Videos`)
- Use meaningful commit messages describing configuration changes
- Test configurations before committing

## Governance

This Constitution serves as the authoritative source for project conventions and standards. All contributors MUST follow these principles.

### Amendment Procedure

1. Propose changes via discussion or pull request
2. Document rationale for changes
3. Update affected documentation and templates
4. Increment version according to semantic versioning

### Versioning Policy

- **MAJOR**: Backward-incompatible principle changes or removals
- **MINOR**: New principles added or existing guidance materially expanded
- **PATCH**: Clarifications, wording improvements, typo fixes

### Compliance Review

Configuration changes SHOULD be reviewed against these principles before merging.

**Version**: 1.0.0 | **Ratified**: 2026-01-25 | **Last Amended**: 2026-01-25
