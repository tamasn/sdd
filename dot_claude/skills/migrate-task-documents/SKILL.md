---
name: migrate-task-documents
description: Convert existing task documents to the new stage-based directory structure, then run a retroactive update-docs + compaction pass on every migrated task.
---

# Migrate Task Documents

Convert old-format task documents to the new stage-based directory structure, then bring them up to the current end-state by running a retroactive `/update-docs`-equivalent pass: extract anything still missing from architecture docs, then compact the stage.

Handles two migration paths:
1. Single `.md` files in `<DOCS_DIR>/tasks/` -> directory with `stage-1-initial/`
2. Flat task directories (files at task root, no `stage-N-*` subdirs) -> wrap into `stage-1-initial/`

After both paths, every migrated task (and any pre-existing stage-based task that has not yet been compacted) goes through the retroactive wrap-up phase.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>` and `<DEFAULT_BRANCH>`.

## Target format (post-migration, pre-compaction)

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

## Final format (post-compaction)

```
<DOCS_DIR>/tasks/<TASK-ID>/
  summary.md                  # Task-level frontmatter + Overview
  stage-1-initial/
    summary.md                # Stage-level summary, including new ## Changes section
    findings.md               # Learnings, patterns, architectural notes
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

### 5. Retroactive update-docs + compaction (per task)

After the structural migration is complete (and after generating `Overview.md`), commit the structural changes with `docs: migrate task documents to stage-based structure`. Then walk every task directory in `<DOCS_DIR>/tasks/` and run a retroactive wrap-up.

**Scope:** every stage that currently has `Status: documented` (or further along, e.g. `pr-created`) and has not yet been compacted. A stage is "compacted" if `summary.md` already contains a `## Changes` section AND `implementation.md` is absent.

**Skip and report:** any stage with status earlier than `documented` (e.g. `created`, `researched`, `planned`, `implemented`, `reviewed`). These are incomplete — leave them alone and tell the user to finish them via the normal stage flow.

**Per-task work — delegate each task to a subagent** (`subagent_type: "general-purpose"`) so the orchestrator's context stays lean. Spawn subagents in batches if there are many tasks.

For each task, the subagent should do the following:

> **Task directory**: `<absolute path to <DOCS_DIR>/tasks/TASK-ID/>`
> **Architecture directory**: `<absolute path to <DOCS_DIR>/architecture/>`
> **Project root**: `<absolute path to project root>`
>
> Run a retroactive `/update-docs`-equivalent pass on every stage of this task that is `documented` (or further) and not yet compacted.
>
> For each such stage:
>
> 1. **Read inputs**: stage `summary.md`, `findings.md` (may be missing or empty), `implementation.md`, `review.md`, and `research.md`/`plan.md` if they exist. Also read `git log -- <stage_files>` if needed to date-anchor the stage relative to architecture docs.
>
> 2. **Synthesize `findings.md` if missing or empty**: pull learnings, patterns, and architectural notes from `implementation.md`, `review.md`, and the diff of files the stage touched. Use the canonical structure (Learnings / Patterns discovered / Architectural notes). Do not invent — if there is genuinely nothing to record, write a one-line "No notable findings." entry rather than a placeholder.
>
> 3. **Reconcile with architecture docs (additive, never destructive)**:
>    - For each candidate fact in `implementation.md`, `review.md`, and `findings.md`, find the matching architecture doc in `<DOCS_DIR>/architecture/`.
>    - **Architecture docs may be newer than the task.** If a doc already covers the fact, leave it alone. If it contradicts the task fact, trust the doc — the code is the source of truth and the doc presumably reflects later changes. Verify by reading the code if uncertain.
>    - Only add to an architecture doc when (a) the fact is missing from the doc, AND (b) the code still confirms the fact. Quick code check: read the cited file/symbol; if it no longer matches, drop the addition silently.
>    - Never delete or overwrite content in architecture docs. Only append or insert into existing structure.
>    - When in doubt, leave the architecture doc alone and rely on `findings.md` to preserve the knowledge in-task.
>
> 4. **Compact the stage** following the procedure in `_shared/stage-workflow.md`:
>    - Append a `## Changes` section to stage `summary.md` with **Summary** (1-3 sentences from `implementation.md` + the original diff if reachable, or a best-effort distillation if not), **Files modified** (bullet list pulled from `implementation.md` or git history), and **Notes** (only if there are real follow-ups/deviations worth keeping).
>    - Delete `research.md`, `plan.md`, `implementation.md`, `review.md` from the stage directory.
>    - Refuse to delete if `findings.md` is still missing or empty after step 2 — synthesize it first.
>
> 5. **Do NOT change** stage or task `Status` values, `Overview.md`, or any other state — the migration just brings older tasks to the current compacted layout. Statuses already reflect the actual progression.
>
> Return for each stage: the path, what (if anything) was added to which architecture doc, what was kept in `findings.md`, and confirmation that compaction succeeded. Flag stages skipped because they are incomplete.

After all subagents return, the orchestrator:

- Aggregates the per-stage reports.
- Reviews architecture doc edits for coherence (each edit was additive, but multiple stages may have touched the same doc — make sure the result reads cleanly; minor wording/dedup fixes are fine, but never remove content).
- Commits the retroactive pass with message: `docs: retroactive update-docs and compaction for migrated tasks`.

### 6. Report

List all migrated documents and any issues encountered (e.g., documents that couldn't be parsed). Then add a retroactive-pass section:
- Stages compacted (with paths)
- Stages skipped because incomplete (with paths and current status)
- Architecture docs that were augmented (with file paths and a one-line note per addition)
- Any conflicts where the architecture doc was newer than the task and the task fact was discarded

## Guidance
- A section is "populated" if it contains content beyond placeholder text like "_To be filled..._"
- Preserve all content exactly during the structural migration (steps 2-3) — do not rewrite or summarize. The retroactive wrap-up (step 5) is the only place rewriting is allowed.
- If a document has an unusual structure, ask the user before migrating it
- Derive stage status from the furthest-progressed file: findings.md -> `documented`, review.md -> `reviewed`, implementation.md -> `implemented`, plan.md -> `planned`, research.md -> `researched`, none -> `created`
- **The retroactive pass is additive only for architecture docs**. Architecture docs may have been updated independently of the tasks (and may even be newer than the code path the task touched). Treat them as authoritative; only fill genuine gaps. When unsure, preserve the existing doc and keep the knowledge in `findings.md` instead.
- Skip incomplete stages in the retroactive pass — compaction destroys the working files, and only `documented` (or further) stages have a stable record (`findings.md` + diff) to compress from.
