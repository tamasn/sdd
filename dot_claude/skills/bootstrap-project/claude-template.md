# AI Coding Guidelines
CODEBASE IS SOURCE OF TRUTH. If this doc disagrees with code, code wins.

## Stack
**Add language version and major dependencies here**

### Libraries
**List libraries used by the project here**

### Databases
**List databases used by the project here, whether they are managed by this project or external, and how**

### External Services
**List all external services used by the project, how they are accessed, whether they have a dedicated client, and if it's a dependency or custom built**

## Programming Standards
**REQUIRED:**
- Follow the language's idiomatic style and conventions
- Prefer immutable data structures where possible
- Use typed, context-specific errors over generic exceptions
- After changes: verify the code compiles/builds
- Before changing logic: describe current behavior, compare changes, confirm no regression

**AVOID:** `null` references, unsafe type casts, code duplication

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
- Tests should mirror the main source structure
- Test class/file naming: `<ComponentName>Test` or `<ComponentName>Spec`
- Test groups: Describe the feature/component being tested
- Test cases: Describe expected behavior clearly
- Use fixtures instead of repeating setup steps

### Incremental Test Development Loop
When writing tests in this project, follow this workflow:
1. Don't create all tests all at once.
2. When creating a new type of test (new suite / new setup / new category), start by creating only ONE test.
3. Always check if the tests compile before you try to run them.
4. Run the test and confirm it passes.
5. Only after the first test passes, create the rest of the tests for that type.
6. If tests are failing for a reason you haven't seen before, update the test documentation with the learnings.
7. Repeat this loop for each type of test.
