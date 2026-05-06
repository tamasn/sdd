---
name: bootstrap-project
description: Set up a new project with documentation structure, build configuration, and git repository. Supports language-specific templates.
---

# Bootstrap Project

Set up a new project with build configuration, documentation structure, and version control.

## Configuration

Read [config.md](../_shared/config.md) to resolve `<DOCS_DIR>` and `<DEFAULT_BRANCH>`.

## Prerequisites

- Project directory created
- Relevant build tools installed
- Git installed

## Available templates

Check `${CLAUDE_SKILL_DIR}/templates/` for language-specific templates. Each template directory contains:
- `claude-template.md` — language-specific CLAUDE.md with coding standards, compiler flags, test conventions
- `build-setup.md` — instructions for creating the build configuration

Current templates:
- `scala` — Scala with sbt, Cats Effect, ScalaTest
- `node-service` — Node.js backend service with TypeScript, Express/Fastify
- `react-typescript` — React frontend with TypeScript, Vite
- `python` — Python with uv, pytest, mypy, ruff

If the user's language/framework matches a template, use it. Otherwise, fall back to the generic templates.

## Instructions

### 1. Gather project requirements

Ask about:
- Project name (default: directory name)
- Programming language and version
- Package/module structure
- Description of what the project will do
- Key dependencies
- Build tool preference
- Testing framework preference
- **Docs directory**: where to store architecture docs and tasks (default: `.ai`, alternatives: `specs`, etc.)
- **Issue tracker**: `github` or `jira`
- **Default branch**: `main`, `develop`, or other

### 2. Select template

If a matching template exists in `${CLAUDE_SKILL_DIR}/templates/<language>/`:
- Read `claude-template.md` — use as the base for CLAUDE.md
- Read `build-setup.md` — follow its instructions for build configuration

If no template matches, use the generic `${CLAUDE_SKILL_DIR}/claude-template.md`.

### 3. Create CLAUDE.md

Copy the selected template to the project root as `CLAUDE.md`. Then:
1. Fill in project-specific details (language, dependencies, etc.)
2. Replace all `REPLACE_DOCS_DIR` placeholders with the user's chosen docs directory value
3. Replace `REPLACE_ISSUE_TRACKER` with the user's chosen issue tracker
4. Replace `REPLACE_DEFAULT_BRANCH` with the user's chosen default branch

The `## AI Workflow Settings` section in the project root `CLAUDE.md` is the **canonical source** of these settings for all workflow skills.

### 4. Create documentation structure

Create the docs directory structure using the user's chosen docs directory:
- `mkdir -p <DOCS_DIR>/architecture <DOCS_DIR>/tasks`
- Copy `${CLAUDE_SKILL_DIR}/docs-template.md` to `<DOCS_DIR>/CLAUDE.md`
- Copy `${CLAUDE_SKILL_DIR}/docs-architecture-template.md` to `<DOCS_DIR>/architecture/CLAUDE.md`
- Copy `${CLAUDE_SKILL_DIR}/docs-tasks-template.md` to `<DOCS_DIR>/tasks/CLAUDE.md`

### 5. Create build configuration

**If using a language template**: Follow `build-setup.md` instructions.

**If generic**: Create the appropriate build file for the chosen language/tool with project name, dependencies, and compiler/linter settings.

### 6. Create project structure

- Standard directory layout for the chosen language
- Entry point / main file
- Test directory with a sample test

### 7. Initialize Git repository

- Run `git init` if not already initialized
- Create `.gitignore` appropriate for the language/build tool
- Set default branch: `git branch -M <DEFAULT_BRANCH>`

### 8. Create initial commit

- Stage all files
- Commit: `chore: initial project setup`

### 9. Document setup

Fill out `Tech-Stack.md` in `<DOCS_DIR>/architecture/` with:
- Language and version
- Key dependencies
- Build, test, and run commands

## Decision Points

**Always ask about**:
- Programming language and version
- Package/module structure
- Key dependencies
- Testing framework preference
- Build tool preference (if multiple options exist)
- Docs directory (default `.ai`)
- Issue tracker (`github` or `jira`)
- Default branch (default `main`)

**Use sensible defaults for**:
- Compiler flags (standard warnings for the language)
- Directory structure (standard layout for the language)

## Guidance
- Ask when ambiguous — don't guess at project structure or naming
- Document decisions — record why specific versions/libraries were chosen
- Start minimal, add dependencies as needed
- Some sections in `CLAUDE.md` may not be filled during initial setup — retain the structure so they can be completed later
