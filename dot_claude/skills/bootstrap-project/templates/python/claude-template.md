# AI Coding Guidelines
CODEBASE IS SOURCE OF TRUTH. If this doc disagrees with code, code wins.

## Stack
**Python application**
- Language: Python (specify version in `.python-version`)
- Package manager: uv
- Project config: `pyproject.toml` + `uv.lock`

### Libraries
**List libraries used by the project here**
- Dependencies defined in `pyproject.toml`
- Key libraries: (framework, ORM, validation, etc.)

### Databases
**List databases used by the service here, whether they are managed by this service or external, and how**

### External Services
**List all external services used by the service, how they are accessed, whether they have a dedicated client, and if it's a dependency or custom built**

## Programming Standards
**REQUIRED:**
- Type hints on all function signatures (parameters and return types)
- Use `dataclasses` or `pydantic` models for structured data — no plain dicts for domain objects
- Prefer immutable structures: `frozen=True` dataclasses, tuples over lists where appropriate
- Typed, context-specific exceptions — avoid bare `except:` or `except Exception:`
- After changes: `uv run mypy src/` to verify type correctness
- After changes: `uv run ruff check .` to verify linting
- Before changing logic: describe current behavior, compare changes, confirm no regression

**AVOID:** `Any` type, `# type: ignore` without justification, mutable global state, `print()` in production code, code duplication

## AI Workflow Settings
<!-- These values are filled in by /bootstrap-project or /bootstrap-documentation -->
- **Docs directory**: `REPLACE_DOCS_DIR`
- **Issue tracker**: `REPLACE_ISSUE_TRACKER`
- **Default branch**: `REPLACE_DEFAULT_BRANCH`

## Documentation

**CRITICAL - Documentation Synchronization:**
- **ALWAYS read relevant documentation BEFORE making code changes**
- **ALWAYS update affected documentation AFTER making code changes**
- **NEVER allow drift between documentation and implementation**

**Documentation Structure:**
- **Architecture**: Service architecture, design decisions, and system logic -> `REPLACE_DOCS_DIR/architecture/`
    - **MUST read** `REPLACE_DOCS_DIR/architecture/CLAUDE.md` before working with architecture docs
    - **MUST follow** documentation-first development process for architectural changes
- **Tasks**: Task descriptions and implementation plans -> `REPLACE_DOCS_DIR/tasks/`

**Guidelines:**
- Each subdirectory has its own `CLAUDE.md` with specific requirements
- Always consult the appropriate `CLAUDE.md` before creating or editing documents in that directory

## Testing

### Critical Constraints
- Use pytest with fixtures
- Tests live in `tests/` directory, mirroring the `src/` structure
- Test file naming: `test_<module_name>.py`
- Test functions: `test_<expected_behavior>()`
- Use `conftest.py` for shared fixtures — avoid duplicating setup across test files
- Use `pytest.raises` for expected exceptions
- Use parametrize for data-driven tests

### Incremental Test Development Loop
When writing tests in this project, follow this workflow:
1. Don't create all tests all at once.
2. When creating a new type of test (new suite / new mock setup / new integration test), start by creating only ONE test.
3. Always check if the tests pass with `uv run pytest tests/<test_file> -x` before creating more.
4. Run `uv run pytest` and confirm the first test passes.
5. Only after the first test passes, create the rest of the tests for that type.
6. If tests are failing for a reason you haven't seen before, update the test documentation with the learnings.
7. Repeat this loop for each type of test.
