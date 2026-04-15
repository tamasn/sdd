# Workflow Configuration

All workflow skills read their configuration from the **project root `CLAUDE.md`** (not `.claude/CLAUDE.md`).

## Settings

| Setting        | Key phrase       | Default   | Examples                    |
| -------------- | ---------------- | --------- | --------------------------- |
| Docs directory | `Docs directory` | `.ai`     | `.ai`, `specs`              |
| Issue tracker  | `Issue tracker`  | `jira`    | `github`, `jira`            |
| Default branch | `Default branch` | `develop` | `main`, `develop`, `master` |

## How to read

1. Read the **project root** `CLAUDE.md` (the one next to `src/`, `package.json`, `build.sbt`, etc.)
2. Find the `## AI Workflow Settings` section
3. Extract each setting value
4. If the section or a setting is missing, use the default from the table above

**Important:** The `.claude/CLAUDE.md` file documents defaults but is NOT the canonical source. The project root `CLAUDE.md` is the single source of truth for these settings.

## Usage in skills

Throughout all skill files, these placeholders are used:
- `<DOCS_DIR>` — the docs directory (e.g. `.ai` or `specs`)
- `<DEFAULT_BRANCH>` — the default/base branch (e.g. `main` or `develop`)

Replace them with the actual configured values when executing.

## Who creates this section?

The `## AI Workflow Settings` section in the project root `CLAUDE.md` is created by:
- `/bootstrap-project` — asks the user for values during project setup
- `/bootstrap-documentation` — adds the section if missing in an existing project

If the section is missing and neither bootstrap skill has been run, skills should use the defaults and continue.
