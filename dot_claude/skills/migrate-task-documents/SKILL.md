---
name: migrate-task-documents
description: Convert existing task documents to the new stage-based directory structure.
---

# Migrate Task Documents

Convert old-format task documents to the new stage-based directory structure. Handles two migration paths:
1. Single `.md` files in `<DOCS_DIR>/tasks/` -> directory with `stage-1-initial/`
2. Flat task directories (files at task root, no `stage-N-*` subdirs) -> wrap into `stage-1-initial/`

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>`.

## Target format

```
<DOCS_DIR>/tasks/<TASK-ID>/
  summary.md                  # Task-level frontmatter + Overview
  stage-1-initial/
    summary.md                # Stage-level summary
    research.md               # (if populated)
    plan.md                   # (if populated)
    implementation.md         # (if populated)
    review.md                 # (if populated)
    findings.md               # (if populated)
```

## Instructions

### 1. Find documents to migrate

**Path A — Single-file tasks:** Look for `.md` files directly in `<DOCS_DIR>/tasks/` (not inside subdirectories).

**Path B — Flat directory tasks:** Look for task directories in `<DOCS_DIR>/tasks/` that contain `.md` files at the root but have no `stage-N-*` subdirectories.

### 2. Migrate single-file tasks (Path A)

For each `.md` file at the top level of `<DOCS_DIR>/tasks/`:

1. Read the file and parse the frontmatter and sections
2. Create the task directory: `<DOCS_DIR>/tasks/<TASK-ID>/`
3. Create task-level `summary.md`:
   - Keep the full frontmatter block, add `CurrentStage: 1`
   - Keep the `# <TASK-ID> - <title>` heading
   - Keep the `## Goal` section content
4. Create `stage-1-initial/summary.md` with stage frontmatter (`Stage: 1`, `Slug: initial`, `Status` derived from the original document's status)
5. Move section content into `stage-1-initial/`:
   - `research.md` — from `## Research` (if populated)
   - `plan.md` — from `## Implementation Plan` (if populated)
   - `implementation.md` — from `## Implementation Notes` (if populated)
   - `findings.md` — from `## Findings` (if populated)
6. Delete the original file

### 3. Migrate flat directory tasks (Path B)

For each task directory with no `stage-N-*` subdirectories:

1. Read `summary.md` frontmatter, add `CurrentStage: 1`
2. Create `stage-1-initial/` subdirectory
3. Create `stage-1-initial/summary.md` with stage frontmatter (`Stage: 1`, `Slug: initial`, `Status` derived from the furthest-progressed file present)
4. Move stage files into `stage-1-initial/`: `research.md`, `plan.md`, `implementation.md`, `review.md`, `findings.md`
5. Keep task-level `summary.md` at the root (update frontmatter only)

### 4. Generate Overview.md

After all migrations are complete, generate `<DOCS_DIR>/tasks/Overview.md` from scratch:

1. Scan all task directories in `<DOCS_DIR>/tasks/`
2. For each task, read `summary.md` for ID, title, author, created date, and status
3. For each `stage-N-*` directory, read `summary.md` for slug and status
4. Write the file in reverse chronological order (newest task first):

```markdown
# Tasks Overview

## <TASK-ID> - <Brief Summary>
**Author:** <author> | **Created:** <YYYY-MM-DD> | **Status:** `<task-status>`
- [Stage 1: <slug>](<TASK-ID>/stage-1-<slug>/summary.md) — `<stage-status>`
```

### 5. Report

List all migrated documents and any issues encountered (e.g., documents that couldn't be parsed).

### 6. Commit

Commit with message: `docs: migrate task documents to stage-based structure`

## Guidance
- A section is "populated" if it contains content beyond placeholder text like "_To be filled..._"
- Preserve all content exactly — do not rewrite or summarize
- If a document has an unusual structure, ask the user before migrating it
- Derive stage status from the furthest-progressed file: findings.md -> `documented`, review.md -> `reviewed`, implementation.md -> `implemented`, plan.md -> `planned`, research.md -> `researched`, none -> `created`
