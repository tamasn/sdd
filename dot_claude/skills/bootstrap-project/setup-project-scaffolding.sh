#!/usr/bin/env sh

# Directory the script was started from (working directory)
INVOCATION_DIR="$(pwd -P)"

# Directory where the script lives
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# Docs directory — override via first argument, default to .ai
DOCS_DIR="${1:-.ai}"

cp -f "$SCRIPT_DIR/claude-template.md" "$INVOCATION_DIR/CLAUDE.md"
mkdir -p "$INVOCATION_DIR/$DOCS_DIR"
mkdir -p "$INVOCATION_DIR/$DOCS_DIR/architecture"
mkdir -p "$INVOCATION_DIR/$DOCS_DIR/tasks"
cp -f "$SCRIPT_DIR/docs-template.md" "$INVOCATION_DIR/$DOCS_DIR/CLAUDE.md"
cp -f "$SCRIPT_DIR/docs-architecture-template.md" "$INVOCATION_DIR/$DOCS_DIR/architecture/CLAUDE.md"
cp -f "$SCRIPT_DIR/docs-tasks-template.md" "$INVOCATION_DIR/$DOCS_DIR/tasks/CLAUDE.md"
