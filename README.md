# sdd

Spec-Driven Development skills for Claude Code — a stage-based workflow that turns issues into researched, planned, implemented, reviewed, and documented pull requests.

## Installation

The skills in this repo are designed to run as **global skills** under `~/.claude/skills/` so they are available in every project.

### Option 1: Symlink the whole skills directory (recommended)

```bash
git clone <this-repo> ~/dev/sdd

mkdir -p ~/.claude/skills
for dir in ~/dev/sdd/dot_claude/skills/*/; do
  ln -sfn "$dir" ~/.claude/skills/"$(basename "$dir")"
done
```

Updating the repo (`git pull`) will immediately update the skills Claude sees.

### Option 2: Symlink individual skills

If you only want a subset:

```bash
ln -sfn ~/dev/sdd/dot_claude/skills/start-task ~/.claude/skills/start-task
ln -sfn ~/dev/sdd/dot_claude/skills/run-stage  ~/.claude/skills/run-stage
# ...etc
```

### Option 3: Merge user-global `CLAUDE.md` preferences

`dot_claude/CLAUDE.md` contains default workflow preferences (docs dir, issue tracker, default branch). Copy its `## AI Workflow Settings` block into `~/.claude/CLAUDE.md` if you want those as global defaults. Individual projects can override them by adding the same section to their own root `CLAUDE.md`.

### Verifying

After linking, invoke any skill (e.g. `/start-task`) in Claude Code. It should appear in the available skills list.

## Configuration

All workflow skills read three settings from the **project root `CLAUDE.md`** (not `~/.claude/CLAUDE.md` and not `.claude/CLAUDE.md`). If the section is missing, defaults are used.

Add this section to your project's `CLAUDE.md`:

```markdown
## AI Workflow Settings

- Docs directory: `.ai`        # where architecture docs and tasks live
- Issue tracker: `jira`        # `jira` or `github`
- Default branch: `develop`    # `main`, `develop`, `master`, ...
```

Defaults (when unset): `.ai`, `jira`, `develop`.

See [dot_claude/skills/_shared/config.md](dot_claude/skills/_shared/config.md) for the exact resolution rules.

## The Workflow

The skills implement a **task → stage → PR** pipeline. A *task* corresponds to an issue/ticket; each task contains one or more *stages*, and each stage passes through five tracked statuses:

```
created → researched → planned → implemented → reviewed → documented
```

### Canonical pipeline

```
/bootstrap-project         (new repo, once)
/bootstrap-documentation   (existing repo, once)
         │
         ▼
/start-task <issue-id>     ← creates task dir, stage 1, and feature branch
         │
         ▼
  ┌──────────────────────── per stage ────────────────────────┐
  │ /research-stage    → writes research.md                   │
  │ /plan-stage        → writes plan.md     (USER APPROVES)   │
  │ /implement-stage   → writes code + implementation.md      │
  │ /review-stage      → writes review.md, minor fixes        │
  │ /update-docs       → updates architecture/, findings.md   │
  └───────────────────────────────────────────────────────────┘
         │
         ▼  (more scope? → /start-stage and repeat)
         │
         ▼
/create-pr                 ← validates, pushes, opens a draft PR
```

Or run a whole stage end-to-end, each phase in an isolated subagent, with one command:

```
/run-stage <task-id> [stage-number]
```

`/run-stage` spawns fresh Explore / general-purpose agents for each phase so the orchestrator's own context stays lean. It still pauses for plan approval before coding.

### Directory layout produced

```
project-root/
├── CLAUDE.md                     ← workflow settings live here
└── <DOCS_DIR>/                   ← default .ai
    ├── architecture/             ← one doc per area (Architecture, Domain-Model, …)
    └── tasks/
        ├── Overview.md           ← all tasks + stages at a glance
        └── <TASK-ID>/
            ├── summary.md        ← Status, CurrentStage
            └── stage-1-<slug>/
                ├── summary.md        ← Stage, Slug, Status, Created, Goal
                ├── research.md       ← /research-stage
                ├── plan.md           ← /plan-stage
                ├── implementation.md ← /implement-stage
                ├── review.md         ← /review-stage
                └── findings.md       ← /update-docs
```

## Skills reference

### Bootstrapping (one-time setup)

| Skill | Arguments | Purpose |
|---|---|---|
| `/bootstrap-project` | interactive | Scaffold a **new** project: `CLAUDE.md`, docs tree, build config, `.gitignore`, initial commit. Language templates: `scala`, `node-service`, `react-typescript`, generic. |
| `/bootstrap-documentation` | — | For an **existing** codebase: analyses the repo and generates `CLAUDE.md` + `<DOCS_DIR>/architecture/*.md` + task infrastructure without overwriting existing files. |
| `/migrate-task-documents` | — | Convert legacy task docs (flat `.md` files or stage-less task directories) into the current stage-based layout. |

### Task lifecycle

| Skill | Arguments | Writes | Reads |
|---|---|---|---|
| `/start-task` | `[issue-id \| task-id]` (optional) | `tasks/<TASK-ID>/summary.md`, `stage-1-<slug>/summary.md`, `Overview.md`; creates feature branch | issue tracker |
| `/start-stage` | `<task-id>` | new `stage-<N>-<slug>/summary.md`, updates task `summary.md` + `Overview.md` | previous stage |
| `/create-branch` | — (invoked by `/start-task`) | new git branch `<prefix>/<ticket>-<slug>` | current base branch |
| `/read-issue` | `<issue-id>` (e.g. `123`, `#123`, `AP-20564`) | — (returns issue details) | GitHub Issues or JIRA |

### Stage lifecycle (run in order, or use `/run-stage`)

All stage skills take `<task-id> [stage-number]`. Stage number is auto-detected from the task's `CurrentStage` if omitted.

| Skill | Writes | Requires status | Ends at status |
|---|---|---|---|
| `/research-stage`   | `research.md`             | `created`     | `researched`  |
| `/plan-stage`       | `plan.md`                 | `researched`  | `planned`     |
| `/implement-stage`  | code + `implementation.md` | `planned`     | `implemented` |
| `/review-stage`     | `review.md` (+ minor fixes) | `implemented` | `reviewed`   |
| `/update-docs`      | `findings.md`, updates `<DOCS_DIR>/architecture/` | `reviewed` | `documented` |
| `/run-stage`        | all of the above, via subagents | `created` | `documented` |

`/plan-stage` **does not read source code** — it works from `research.md` only. This keeps the planning context small and forces research to surface everything the plan needs.

### PR & maintenance

| Skill                    | Arguments | Purpose                                                                                                                                       |
| ------------------------ | --------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| `/create-pr`             | —         | Validate build, push branch, open/update a draft PR via `gh`. PR body is assembled from each stage's summary.                                 |
| `/refresh-documentation` | —         | Parallel audit of architecture drift, task-knowledge integration, `CLAUDE.md` accuracy, and structural validation; offers fixes for approval. |

## Inputs you provide manually

Most skills are interactive, but a few inputs are worth having ready:

- **Issue identifier** for `/start-task` and `/read-issue`:
  - GitHub: `123` or `#123`
  - JIRA: full key, e.g. `AP-20564`
- **Task goal / scope / non-goals** when `/start-task` runs without an issue ID — you'll be prompted for a short description and any explicit exclusions; they land in `tasks/<TASK-ID>/summary.md`.
- **Stage slug + goal** when `/start-stage` creates a follow-up stage, e.g. `add-validation`, `fix-edge-cases`.
- **Plan approval**: `/plan-stage` and `/run-stage` both pause after writing `plan.md` and wait for explicit approval before implementing.
- **Issue-tracker access**: for GitHub, the `gh` CLI must be authenticated; for JIRA, configure [`dot_claude/skills/read-issue/read-jira.sh`](dot_claude/skills/read-issue/read-jira.sh) before running `/read-issue` or `/start-task` with a ticket ID.

## File format expectations

- **`summary.md` frontmatter** (task): `ID`, `Type`, `Author`, `Created`, `Status`, `CurrentStage`.
- **`summary.md` frontmatter** (stage): `Stage`, `Slug`, `Status`, `Created`, `Goal`.
- **Stage directories** follow the exact pattern `stage-<N>-<kebab-slug>/`. Stage skills detect stages by scanning for this pattern.
- **Commits** made by the skills use `docs(<TASK-ID>): <description>` for documentation writes and conventional commits for code changes.

See [dot_claude/skills/_shared/stage-workflow.md](dot_claude/skills/_shared/stage-workflow.md) for the exact conventions every stage skill obeys (status transitions, overview updates, commit format).
