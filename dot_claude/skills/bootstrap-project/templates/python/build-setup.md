# Python Build Setup

## Instructions

1. Create `pyproject.toml` with:
   - Project name based on the directory name
   - Python version requirement (ask user for minimum version, default `>=3.12`)
   - `[build-system]` using `hatchling`
   - `[project.scripts]` entry point if applicable
   - `[tool.pytest.ini_options]` with `testpaths = ["tests"]`
   - `[tool.ruff]` for linting and formatting configuration

2. Initialize the project with uv:
   - `uv init` (if `pyproject.toml` doesn't already exist) or `uv sync` to create the lockfile
   - `uv sync` to install dependencies and create `uv.lock`

3. Create `.python-version` with the target Python version

4. Set up directory structure:
   - `src/<package_name>/` — application source (use src layout)
   - `src/<package_name>/__init__.py` — package init
   - `src/<package_name>/main.py` — entry point
   - `tests/` — test directory
   - `tests/__init__.py`
   - `tests/conftest.py` — shared fixtures

5. Ask about:
   - Application type (CLI, web service, library, etc.)
   - Web framework preference if applicable (FastAPI, Flask, etc.)
   - Database needs
   - Any key dependencies

## Default dependencies

- ruff (dev) — linting and formatting
- pytest (dev) — testing
- mypy (dev) — type checking

Add dev dependencies with: `uv add --dev ruff pytest mypy`

## Common commands

```
uv sync          — install/sync all dependencies
uv add <pkg>     — add a dependency
uv add --dev <pkg> — add a dev dependency
uv run pytest    — run tests
uv run ruff check . — lint
uv run ruff format . — format
uv run mypy src/ — type check
uv run python -m <package_name>.main — run the application
```
