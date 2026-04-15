---
name: refresh-documentation
description: Detect and fix all documentation drift, integrate task knowledge into architecture docs, and validate structure against bootstrap-documentation templates. Use when the user wants to sync docs with code, check for drift, audit documentation, or ensure docs are current.
---

# Refresh Documentation

Audit all project documentation against the codebase, integrate knowledge from task documents into architecture docs, validate the documentation structure, then apply fixes. Stale docs are worse than no docs — they mislead both humans and AI agents.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>`.

## Input

No arguments. Runs against the current project root.

## Reads

- `<DOCS_DIR>/architecture/` — current architecture docs
- `<DOCS_DIR>/tasks/*/` — task directories (findings.md, implementation.md, review.md)
- `CLAUDE.md` (root and all subdirectories)
- Source code (via subagents)
- `bootstrap-documentation` skill — structural reference

## Writes

- Updated files in `<DOCS_DIR>/architecture/`
- Updated `CLAUDE.md` files
- New architecture docs (if areas are missing)

## Instructions

### Phase 1: Audit (parallel subagents)

Launch four subagents concurrently using `subagent_type: "Explore"`.

**Subagent 1 — Architecture drift detection:**
> **Project root**: `<absolute path>`
>
> Detect drift between `<DOCS_DIR>/architecture/` docs and the actual codebase.
>
> For each architecture doc in `<DOCS_DIR>/architecture/` (skip CLAUDE.md):
> 1. Read the document
> 2. Identify verifiable claims: file paths, class/function names, interfaces, data models, dependencies, behavior
> 3. Verify each claim against the code using Glob, Grep, and Read
> 4. Flag anything outdated, missing, or incorrect
>
> Return a structured list. For each finding: doc file path, the wrong claim, what the code shows, suggested fix.

**Subagent 2 — Task knowledge integration:**
> **Project root**: `<absolute path>`
>
> Check whether completed task documents contain knowledge that should be in architecture docs but isn't.
>
> 1. Find all task directories in `<DOCS_DIR>/tasks/*/`
> 2. For each task, read `findings.md`, `implementation.md`, and `review.md` (if they exist) — check inside stage directories too
> 3. Identify: architectural decisions, new patterns, structural changes, compiler/test learnings
> 4. Check if these are reflected in the corresponding `<DOCS_DIR>/architecture/` docs
> 5. Flag knowledge that exists only in task docs
>
> Return findings with: task directory, the missing knowledge, which architecture doc should be updated.

**Subagent 3 — CLAUDE.md audit:**
> **Project root**: `<absolute path>`
>
> Verify all CLAUDE.md files in the project are accurate.
>
> 1. Find all CLAUDE.md files in the repository
> 2. For each one, check:
>    - Do referenced file paths still exist?
>    - Are build/test/run commands accurate?
>    - Do coding standards match actual code patterns?
>    - Are mentioned dependencies still in use?
> 3. Flag stale or inaccurate instructions
>
> Return findings with: CLAUDE.md path, stale content, suggested fix.

**Subagent 4 — Structure validation:**
> **Project root**: `<absolute path>`
>
> Validate the project's documentation structure matches the expected standard.
>
> 1. Check the project has:
>    - `CLAUDE.md` at root with all expected sections (Stack, Libraries, Databases, External Services, Programming Standards, AI Workflow Settings, Documentation, Testing)
>    - `<DOCS_DIR>/CLAUDE.md` with routing rules
>    - `<DOCS_DIR>/architecture/CLAUDE.md` with documentation guidelines
>    - `<DOCS_DIR>/tasks/CLAUDE.md` with task directory structure
> 2. For each CLAUDE.md, flag missing sections or outdated structure
> 3. Check which architecture areas exist in the codebase but lack documentation:
>    - Architecture (logical units, components) — always expected
>    - Domain model — if data structures/types/abstractions exist
>    - Integrations — if external service clients exist
>    - Database — if database access code exists
>    - HTTP API — if HTTP server exists
>    - Pipelines — if multi-step data transformations exist
>    - Tech stack — always expected
>    - Compiler flags — if strict compiler settings exist
> 4. Check architecture doc file naming: first letter capitalized, max two words
>
> Return: missing CLAUDE.md sections, structural deviations, missing architecture areas, naming violations.

### Phase 2: Summarize findings

After all subagents return, compile a summary:

```
## Documentation Audit Results

### 1. Architecture drift (N issues)
For each: doc file, what's wrong, proposed fix

### 2. Task knowledge gaps (N gaps)
For each: task directory, missing knowledge, target architecture doc

### 3. CLAUDE.md issues (N issues)
For each: file, stale content, proposed fix

### 4. Structure issues (N issues)
For each: what's missing or misaligned, proposed fix
```

Present this to the user. Be specific about every proposed change.

### Phase 3: Get approval

Ask the user which updates to apply:
- "Apply all"
- "Let me choose by category"
- "Show me more detail first"

If choosing by category, ask about each separately.

**Do NOT make any file changes until the user explicitly approves.**

### Phase 4: Apply updates

For each approved category:

1. **Architecture drift** — Edit docs in `<DOCS_DIR>/architecture/` to match the code
2. **Task knowledge** — Integrate findings/implementation details from task docs into the appropriate architecture docs
3. **CLAUDE.md fixes** — Fix stale instructions, paths, commands
4. **Structure fixes** — Add missing CLAUDE.md sections, create missing architecture docs (explore the codebase for content), rename misnamed files

After applying, review all changed docs for consistency across files.

### Phase 5: Commit

Suggested message: `docs: refresh documentation to match codebase`

## Completion

Show the user a summary of what was changed. If new architecture areas were created, suggest they review the generated content.

## Guidance
- Accuracy over completeness — only propose changes you're confident about. Flag ambiguity for the user.
- Preserve existing style. Fix what's wrong, don't rewrite what's correct.
- Keep CLAUDE.md files concise and actionable for AI agents.
- If `<DOCS_DIR>/` doesn't exist, tell the user to run `/bootstrap-documentation` first.
- If no task documents exist, skip subagent 2 and note it.
- One area per architecture file, cross-reference instead of repeating.
- Architecture doc file names: capitalize first letter, max two words.
