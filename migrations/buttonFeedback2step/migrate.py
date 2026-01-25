#!/usr/bin/env python3
"""
Button Feedback Migration Script

Migrates Bitfocus Companion configuration feedbacks from 'bank_pushed' to
'bank_current_step', adds 'step: 2' option, and removes 'latch_compatability'.

Usage:
    python migrate.py [--config PATH] [--dry-run] [--verbose]

Exit Codes:
    0 - Success (migration completed or no changes needed)
    1 - File not found
    2 - Invalid JSON format
    3 - Permission denied
    4 - Unexpected error
"""

import argparse
import json
import sys
from pathlib import Path
from dataclasses import dataclass, field
from typing import List, Dict, Any, Optional

# Exit codes as per CLI contract
EXIT_SUCCESS = 0
EXIT_FILE_NOT_FOUND = 1
EXIT_JSON_ERROR = 2
EXIT_PERMISSION_ERROR = 3
EXIT_UNEXPECTED_ERROR = 4

# Default configuration file path (relative to repo root)
DEFAULT_CONFIG_PATH = "config/full.companionconfig"

# Migration constants
SOURCE_FEEDBACK_TYPE = "bank_pushed"
TARGET_FEEDBACK_TYPE = "bank_current_step"
TARGET_STEP_VALUE = 2
LATCH_OPTION_KEY = "latch_compatability"


@dataclass
class MigrationWarning:
    """Represents a warning generated during migration."""
    page_id: str
    control_id: str
    message: str
    original_value: Any = None


@dataclass
class MigrationStats:
    """Tracks migration statistics."""
    buttons_processed: int = 0
    feedbacks_migrated: int = 0
    types_changed: int = 0
    steps_added: int = 0
    latch_removed: int = 0
    warnings: List[MigrationWarning] = field(default_factory=list)

    def has_changes(self) -> bool:
        """Check if any changes were made or would be made."""
        return self.feedbacks_migrated > 0


def parse_arguments():
    """
    Parse command line arguments.

    Returns:
        argparse.Namespace: Parsed arguments with config, dry_run, and verbose flags.
    """
    parser = argparse.ArgumentParser(
        prog="migrate.py",
        description="Migrate button feedbacks from bank_pushed to bank_current_step",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python migrate.py                     Run migration with default config
  python migrate.py --dry-run           Preview changes without writing
  python migrate.py --config path.json  Use custom config file
  python migrate.py -v --dry-run        Verbose dry-run

Exit Codes:
  0 - Success
  1 - File not found
  2 - Invalid JSON
  3 - Permission denied
  4 - Unexpected error
"""
    )

    parser.add_argument(
        "-c", "--config",
        type=str,
        default=DEFAULT_CONFIG_PATH,
        help=f"Path to configuration file (default: {DEFAULT_CONFIG_PATH})"
    )

    parser.add_argument(
        "-n", "--dry-run",
        action="store_true",
        help="Preview changes without modifying the file"
    )

    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Show detailed processing information"
    )

    return parser.parse_args()


def load_config(config_path: str) -> Dict[str, Any]:
    """
    Load and parse the configuration file.

    Args:
        config_path: Path to the JSON configuration file.

    Returns:
        dict: Parsed configuration data.

    Raises:
        FileNotFoundError: If file does not exist.
        json.JSONDecodeError: If file contains invalid JSON.
        PermissionError: If file cannot be read.
    """
    path = Path(config_path)

    if not path.exists():
        raise FileNotFoundError(f"Configuration file not found: {config_path}")

    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def save_config(config_path: str, data: Dict[str, Any]) -> None:
    """
    Save configuration data to file with tab indentation.

    Args:
        config_path: Path to save the configuration file.
        data: Configuration data to save.

    Raises:
        PermissionError: If file cannot be written.
    """
    path = Path(config_path)

    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent="\t", ensure_ascii=False)
        f.write("\n")  # Ensure file ends with newline


def is_button_control(control: Dict[str, Any]) -> bool:
    """
    Check if a control is a button type.

    Args:
        control: Control configuration dictionary.

    Returns:
        bool: True if control type is "button".
    """
    return control.get("type") == "button"


def needs_migration(feedback: Dict[str, Any]) -> bool:
    """
    Check if a feedback needs to be migrated.

    A feedback needs migration if:
    - Its type is "bank_pushed"

    Args:
        feedback: Feedback configuration dictionary.

    Returns:
        bool: True if feedback should be migrated.
    """
    return feedback.get("type") == SOURCE_FEEDBACK_TYPE


def is_already_migrated(feedback: Dict[str, Any]) -> bool:
    """
    Check if a feedback has already been migrated (idempotency check).

    A feedback is considered already migrated if:
    - Its type is "bank_current_step"
    - It has step option set to 2

    Args:
        feedback: Feedback configuration dictionary.

    Returns:
        bool: True if feedback is already migrated.
    """
    if feedback.get("type") != TARGET_FEEDBACK_TYPE:
        return False

    options = feedback.get("options", {})
    return options.get("step") == TARGET_STEP_VALUE


def migrate_feedback(
    feedback: Dict[str, Any],
    page_id: str,
    control_id: str,
    stats: MigrationStats,
    verbose: bool = False
) -> bool:
    """
    Migrate a single feedback from bank_pushed to bank_current_step.

    Args:
        feedback: Feedback configuration dictionary (modified in place).
        page_id: Page ID for warning messages.
        control_id: Control ID for warning messages.
        stats: Statistics tracker to update.
        verbose: Whether to print verbose output.

    Returns:
        bool: True if feedback was migrated, False if skipped.
    """
    # Skip if already migrated (idempotency)
    if is_already_migrated(feedback):
        if verbose:
            print(f"      - Feedback {feedback.get('id', 'unknown')}: already migrated (skipped)")
        return False

    # Skip if not a bank_pushed feedback
    if not needs_migration(feedback):
        if verbose:
            print(f"      - Feedback {feedback.get('id', 'unknown')}: {feedback.get('type', 'unknown')} (skipped)")
        return False

    # Change feedback type
    feedback["type"] = TARGET_FEEDBACK_TYPE
    stats.types_changed += 1

    # Ensure options dict exists
    if "options" not in feedback:
        feedback["options"] = {}

    options = feedback["options"]

    # Check for existing step value
    if "step" in options:
        existing_step = options["step"]
        if existing_step != TARGET_STEP_VALUE:
            # Warn about overwriting non-2 step value
            warning = MigrationWarning(
                page_id=page_id,
                control_id=control_id,
                message=f"Existing step value {existing_step} was overwritten with {TARGET_STEP_VALUE}",
                original_value=existing_step
            )
            stats.warnings.append(warning)
        # Note: If step is already 2, we don't count it as "added"
    else:
        stats.steps_added += 1

    # Set step option to 2
    options["step"] = TARGET_STEP_VALUE

    # Remove latch_compatability if present
    if LATCH_OPTION_KEY in options:
        del options[LATCH_OPTION_KEY]
        stats.latch_removed += 1

    stats.feedbacks_migrated += 1

    if verbose:
        print(f"      - Feedback {feedback.get('id', 'unknown')}: {SOURCE_FEEDBACK_TYPE} → {TARGET_FEEDBACK_TYPE} ✓")

    return True


def process_control(
    control: Dict[str, Any],
    page_id: str,
    control_id: str,
    stats: MigrationStats,
    verbose: bool = False
) -> None:
    """
    Process a single control and migrate its feedbacks.

    Args:
        control: Control configuration dictionary.
        page_id: Page ID for context.
        control_id: Control ID for context.
        stats: Statistics tracker to update.
        verbose: Whether to print verbose output.
    """
    # Skip non-button controls
    if not is_button_control(control):
        if verbose:
            print(f"    [Control {control_id}] type={control.get('type', 'unknown')} (skipped - not a button)")
        return

    feedbacks = control.get("feedbacks", [])
    stats.buttons_processed += 1

    if verbose:
        print(f"    [Control {control_id}] type=button, feedbacks={len(feedbacks)}")

    # Process each feedback
    for feedback in feedbacks:
        migrate_feedback(feedback, page_id, control_id, stats, verbose)


def process_page(
    page: Dict[str, Any],
    page_id: str,
    stats: MigrationStats,
    verbose: bool = False
) -> None:
    """
    Process a single page and its controls.

    The controls structure is a grid: controls[row_id][column_id] = control
    So we need to iterate through rows, then columns, to reach the actual controls.

    Args:
        page: Page configuration dictionary.
        page_id: Page ID for context.
        stats: Statistics tracker to update.
        verbose: Whether to print verbose output.
    """
    controls = page.get("controls", {})

    if verbose:
        print(f"  [Page {page_id}] Processing {len(controls)} rows...")

    # Iterate through rows
    for row_id, row in controls.items():
        if not isinstance(row, dict):
            continue

        # Iterate through columns in this row
        for col_id, control in row.items():
            if not isinstance(control, dict):
                continue

            control_location = f"{row_id}/{col_id}"
            process_control(control, page_id, control_location, stats, verbose)


def migrate_config(
    config: Dict[str, Any],
    verbose: bool = False
) -> MigrationStats:
    """
    Migrate all bank_pushed feedbacks in the configuration.

    Args:
        config: Configuration dictionary (modified in place).
        verbose: Whether to print verbose output.

    Returns:
        MigrationStats: Statistics about the migration.
    """
    stats = MigrationStats()
    pages = config.get("pages", {})

    for page_id, page in pages.items():
        process_page(page, page_id, stats, verbose)

    return stats


def print_report(
    config_path: str,
    stats: MigrationStats,
    dry_run: bool = False
) -> None:
    """
    Print the migration report.

    Args:
        config_path: Path to the configuration file.
        stats: Migration statistics.
        dry_run: Whether this was a dry run.
    """
    print("=== Button Feedback Migration Report ===")
    print(f"Configuration: {config_path}")

    if dry_run:
        print("Mode: DRY RUN (no changes will be written)")
    else:
        print("Mode: Migration (--dry-run not set)")

    print()
    print("Processing...")
    print()

    if dry_run:
        print("Results (preview):")
        print(f"  Buttons that would be processed: {stats.buttons_processed}")
        print(f"  Feedbacks that would be migrated: {stats.feedbacks_migrated}")
        if stats.feedbacks_migrated > 0:
            print(f"  - Type changes:           {stats.types_changed}")
            print(f"  - Step options to add:    {stats.steps_added}")
            print(f"  - latch_compatability to remove: {stats.latch_removed}")
    else:
        print("Results:")
        print(f"  Buttons processed:        {stats.buttons_processed}")
        print(f"  Feedbacks migrated:       {stats.feedbacks_migrated}")
        if stats.feedbacks_migrated > 0:
            print(f"  - Type changed:           {stats.types_changed} ({SOURCE_FEEDBACK_TYPE} → {TARGET_FEEDBACK_TYPE})")
            print(f"  - Step option added:      {stats.steps_added}")
            print(f"  - latch_compatability removed: {stats.latch_removed}")

    print()

    # Print warnings
    if stats.warnings:
        print(f"Warnings: {len(stats.warnings)}")
        for warning in stats.warnings:
            print(f"  ⚠ Button [page:{warning.page_id}, control:{warning.control_id}]: {warning.message}")
        print()

    # Print final status
    if dry_run:
        if stats.has_changes():
            print("Dry run complete - no changes were made.")
        else:
            print("No changes would be necessary.")
    else:
        if stats.has_changes():
            if stats.warnings:
                print("✓ Migration completed successfully (with warnings).")
            else:
                print("✓ Migration completed successfully.")
        else:
            print("No changes were necessary.")


def handle_error(error: Exception, config_path: Optional[str] = None) -> int:
    """
    Handle errors and print appropriate error messages.

    Args:
        error: The exception that occurred.
        config_path: Optional path to configuration file for error messages.

    Returns:
        int: Appropriate exit code for the error type.
    """
    if isinstance(error, FileNotFoundError):
        print(f"ERROR: Configuration file not found: {config_path}", file=sys.stderr)
        print("Please ensure the file exists or specify a different path with --config", file=sys.stderr)
        return EXIT_FILE_NOT_FOUND

    elif isinstance(error, json.JSONDecodeError):
        print("ERROR: Invalid JSON format in configuration file", file=sys.stderr)
        print(f"Details: {error.msg}: line {error.lineno} column {error.colno}", file=sys.stderr)
        return EXIT_JSON_ERROR

    elif isinstance(error, PermissionError):
        print(f"ERROR: No write permission for configuration file: {config_path}", file=sys.stderr)
        print("Please check file permissions or run with appropriate privileges", file=sys.stderr)
        return EXIT_PERMISSION_ERROR

    else:
        print(f"ERROR: Unexpected error occurred: {error}", file=sys.stderr)
        return EXIT_UNEXPECTED_ERROR


def main() -> int:
    """Main entry point for the migration script."""
    args = parse_arguments()

    try:
        # Load configuration
        config = load_config(args.config)

        # Perform migration (modifies config in place)
        stats = migrate_config(config, verbose=args.verbose)

        # Save configuration if not dry-run and changes were made
        if not args.dry_run and stats.has_changes():
            save_config(args.config, config)

        # Print report
        print_report(args.config, stats, dry_run=args.dry_run)

        return EXIT_SUCCESS

    except (FileNotFoundError, json.JSONDecodeError, PermissionError) as e:
        return handle_error(e, args.config)
    except Exception as e:
        return handle_error(e, args.config)


if __name__ == "__main__":
    sys.exit(main())
