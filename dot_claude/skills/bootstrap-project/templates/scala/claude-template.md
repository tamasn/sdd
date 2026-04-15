# AI Coding Guidelines
CODEBASE IS SOURCE OF TRUTH. If this doc disagrees with code, code wins.

## Stack
**Add Scala version and major dependencies**
- the project should be defined in build.sbt

### Libraries
**List Libraries used by the service here**
- the dependencies should be defined in `project/Dependencies.scala`
- grouped by libraries into objects, the versions abstracted into versions

### Databases
** List databases used by the service here, are they managed by this service or they are external, if they are managed then how.**

### External Services
**List all external services used by the service, how they are accessed, do they have a dedicated client, is it a dependency or custom built?**

## Programming Standards
**REQUIRED:**
- NO side effects; all effectful code in Cats Effect 3 (IO / F[_] with Async/Sync)
- NO breaking referential transparency
- ALL variables immutable
- Typed, context-specific errors
- Domain types: No primitives—use wrapper `case class ... extends AnyVal`
- After changes: `sbt compile` to verify
- Before changing logic: describe current behavior, compare changes, confirm no regression

**AVOID:** `null`, `asInstanceOf`, `isInstanceOf`, code duplication

**Compiler strictness**: This project uses `-Werror`, `-Wnonunit-statement`, `-Yexplicit-nulls`. See `REPLACE_DOCS_DIR/architecture/CompilerFlags.md` for details.

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
- Always use ScalaTest with `AnyFreeSpec`
- Tests should mirror the main source structure
- Always use `should` style `Matchers` from Scalatest for assertions
- Test class: `<ComponentName>Spec.scala`
- Test groups: Describe the feature/component being tested
- Test cases: Start with "should" and describe expected behavior
- Use fixtures instead of repeating setup steps

#### Incremental Test Development Loop
When writing tests in this project, follow this workflow:
1. Don't create all tests all at once.
2. When creating a new type of test (new suite / new in-memory HTTP setup / new endpoint category), start by creating only ONE test.
3. Always check if the tests compile with `sbt Test / compile` before you try to run them.
4. Run `sbt test` (or `sbt testOnly <SpecName>`) and confirm the first test is working correctly.
5. Only after the first test passes, create the rest of the tests for that type.
6. If tests are failing for a reason you haven't seen before, update this document (`REPLACE_DOCS_DIR/architecture/Tests.md`) with the learnings.
7. Repeat this loop for each type of test.
