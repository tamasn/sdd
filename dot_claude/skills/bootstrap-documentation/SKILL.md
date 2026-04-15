---
name: bootstrap-documentation
description: Create comprehensive project documentation for AI-assisted development by analyzing codebase structure.
---

# Bootstrap Project Documentation

Create structured documentation for an existing project to enable effective AI-assisted development.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>`.

## Prerequisites

- Existing codebase
- Write access to documentation directory

## Overview

This skill analyzes the codebase and creates documentation organized by technical domains. The documentation helps Claude understand the project architecture and make informed code changes.

## Instructions

### 1. Gather workflow settings

Before doing anything, ask the user for:
- **Docs directory**: where to store architecture docs and tasks (default: `.ai`, alternatives: `specs`, etc.)
- **Issue tracker**: `github` or `jira`
- **Default branch**: `main`, `develop`, or other

These values will be used throughout this skill and written into `CLAUDE.md`.

### 2. Create or update CLAUDE.md

**If `CLAUDE.md` doesn't exist** in the project root:
- Create it from the generic template in `bootstrap-project/claude-template.md`
- Fill in project-specific details by examining the codebase (language, dependencies, build commands, test commands)
- Replace all `REPLACE_DOCS_DIR`, `REPLACE_ISSUE_TRACKER`, `REPLACE_DEFAULT_BRANCH` placeholders with the user's chosen values

**If `CLAUDE.md` already exists** but has no `## AI Workflow Settings` section:
- Add the section with the user's chosen values:
  ```
  ## AI Workflow Settings
  - **Docs directory**: `<value>`
  - **Issue tracker**: `<value>`
  - **Default branch**: `<value>`
  ```

**If `CLAUDE.md` already exists with the settings section**: Read the values from it and use them. Ask the user if they want to change anything.

### 3. Create docs directory structure (using the configured docs directory)

If `<DOCS_DIR>/` doesn't exist, create:
- `<DOCS_DIR>/CLAUDE.md` — from `bootstrap-project/docs-template.md`
- `<DOCS_DIR>/architecture/CLAUDE.md` — from `bootstrap-project/docs-architecture-template.md`
- `<DOCS_DIR>/tasks/CLAUDE.md` — from `bootstrap-project/docs-tasks-template.md`

### 4. Generate architecture documentation

Read `<DOCS_DIR>/architecture/CLAUDE.md` for guidelines. Explore the codebase and create one file per area in `<DOCS_DIR>/architecture/`. Only create docs for areas that exist in the code — skip areas that don't apply.

**Areas to check:**

| Area | Create when... |
|------|---------------|
| Architecture | Always — logical units, components, responsibilities |
| Domain model | Data structures, types, abstractions exist |
| Integrations | External service clients or wrappers exist |
| Database | Database access code exists |
| HTTP API | HTTP server with endpoints exists |
| Pipelines | Multi-step data transformation logic exists |
| Tech stack | Always — language, dependencies, build/test/run commands |
| Compiler flags | Strict compiler settings that affect development |

### 5. Review

Review all generated docs for:
- Inconsistencies or duplicate information across files
- Missing cross-references between related docs
- Vague descriptions — prefer specific file paths and code references

## Completion

Tell the user the documentation is ready. Suggest committing with `docs: bootstrap project documentation`.

## Guidance
- One area per file, cross-reference instead of repeating
- File names: capitalize first letter, max two words (e.g. `Architecture.md`, `Domain-Model.md`)
- Use fully qualified names when entities could be ambiguous
- Each file starts with a brief overview of its purpose
- Keep docs compact — optimized for AI agent consumption, not prose
- Be specific: reference actual file names, function names, class names
