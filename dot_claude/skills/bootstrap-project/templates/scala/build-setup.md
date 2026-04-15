# Scala Build Setup

## Instructions

1. Create `build.sbt` with the project name based on the project directory name
   - Use the most recent Scala version
   - Add the most recent version of Cats Effect as a dependency
   - Include strict compiler flags: `-Werror`, `-Wnonunit-statement`, `-Yexplicit-nulls`

2. Create `project/Dependencies.scala` for dependency management
   - Group dependencies by library into objects
   - Abstract versions into val declarations

3. Create `project/build.properties` with the latest sbt version

4. Set up the standard directory trees:
   - `src/main/scala/<package>/`
   - `src/test/scala/<package>/`

5. Ask about the Scala package name structure and create the package directories

## Default dependencies

- Cats Effect 3 (core dependency)
- ScalaTest with `AnyFreeSpec` (test dependency)

## Compiler flags

Document these in `<DOCS_DIR>/architecture/CompilerFlags.md`:
- `-Werror` — treat warnings as errors
- `-Wnonunit-statement` — warn on non-unit statements
- `-Yexplicit-nulls` — make null explicit in the type system
