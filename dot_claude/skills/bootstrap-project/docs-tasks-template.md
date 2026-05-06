This directory contains descriptions of tasks. A task is a set of instructions to update the codebase and the documentation. A task can have one stage or multiple stages. If there are multiple stages, always focus on a single stage.

# **IMPORTANT** Document handling
- always compare the task document with the code to avoid drift
- when code changes always update the task document so the changes are described in the task document

# Document Structure

## Properties
Properties are defined following the YAML frontmatter spec
- **ID**: A unique ID for the task (e.g. `GH-0123` for GitHub issues, `AP-12345` for JIRA, or `AUTH-0001` for custom IDs), always refer to the changes using this ID
- **Type**: It should be `Bug` if it contains the description of an error, `Feature` if it's a description of something new, or `Refactor` for restructuring
- **Author**: Name of the user who originally created the document, don't change it
- **Created**: The date the task document was created
- **Status**: Tracks the current pipeline stage. Values: `created` -> `researched` -> `planned` -> `implemented` -> `reviewed` -> `documented`
- **CurrentStage**: The current stage number

# Task directory structure

While a stage is in progress:

```
tasks/<TASK-ID>/
  summary.md                      # Task-level: ID, Type, Author, Created, Status, CurrentStage
  stage-1-<slug>/
    summary.md                    # Stage-level: Stage, Slug, Status, Created, Goal
    research.md                   # /research-stage output
    plan.md                       # /plan-stage output
    implementation.md             # /implement-stage output
    review.md                     # /review-stage output
    findings.md                   # /update-docs output
  stage-2-<slug>/
    ...
```

After `/update-docs` completes, the stage is automatically compacted:

```
tasks/<TASK-ID>/
  summary.md
  stage-1-<slug>/
    summary.md                    # Now also contains a ## Changes section (Summary, Files modified, optional Notes)
    findings.md                   # Learnings, patterns, architectural notes
  stage-2-<slug>/
    ...
```

`research.md`, `plan.md`, `implementation.md`, and `review.md` are deleted by the compaction step. Only the stage `summary.md` (with `## Goal` + `## Changes`) and `findings.md` survive long-term.

# Stages
Each stage is a full cycle of research, plan, implement, review, update-docs. The compaction at the end of `/update-docs` is one-way — once a stage has been compacted, it cannot be re-documented; the user must add a new stage if more work is needed.

**IMPORTANT:**
- Always check the whole task directory for context but focus on one stage at a time.
- If any stage has a `findings.md`, consider it part of the context.
- For compacted stages, the `## Changes` section in `summary.md` plus `findings.md` is the full context — `research.md`/`plan.md`/`implementation.md`/`review.md` will not be present.
- If it's not clear what stage changes apply to, ALWAYS ask.
