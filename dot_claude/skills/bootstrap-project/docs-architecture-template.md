# Architecture Documentation Guidelines

## **CRITICAL**: Documentation-First Development

When working with architecture documentation in this directory, you **MUST** follow this process:

### Before Making Code Changes

1. **Read ALL relevant architecture documentation** that relates to the code you're about to modify
2. **Understand the documented design** before proposing or implementing changes
3. **Validate your approach** against the documented architecture to ensure consistency
4. **Identify documentation gaps** — if the area you're working on lacks documentation, note this

### After Making Code Changes

1. **Update ALL affected architecture documentation** immediately after modifying code
2. **Ensure zero drift** between the documentation and the actual implementation
3. **Add new documentation** if you've introduced new architectural components, patterns, or decisions
4. **Update references** to code locations (file paths and line numbers) if files or structures moved
5. **Verify consistency** — review updated docs to ensure they accurately reflect the new implementation

## Scope of Architecture Documentation

Architecture documents should describe:

- **System design**: High-level component structure and responsibilities
- **Component interactions**: How modules/services communicate and depend on each other
- **Key architectural decisions**: Rationale for technology choices, patterns, and trade-offs
- **Data flow**: How data moves through the system, including persistence and transformation
- **Integration points**: External services, APIs, databases, and their contracts
- **State management**: How application state is handled and persisted
- **Error handling patterns**: Common error handling strategies and recovery mechanisms
- **Configuration architecture**: How the system is configured and what affects behavior
- **Testing patterns**: Strategies for writing tests
- **Coding guidelines**: A list of learnings about how to write code for this project

## Documentation Requirements

Each architecture document **MUST**:

- Include **precise code references** (file paths with line numbers where applicable)
- Explain **rationale** for architectural choices, not just "what" but "why"
- Document **assumptions and constraints** that influenced the design
- Note **future considerations** or known limitations when relevant
- Use **concrete examples** from the actual codebase

## When to Create New Architecture Documents

Create a new architecture document when:

- Adding a new major component or subsystem
- Introducing a new integration with external services
- Implementing a new data persistence pattern
- Establishing a new architectural pattern or convention
- Making decisions that affect multiple parts of the system

## Synchronization Rules

**NEVER** allow documentation to drift from code:

- **Added/removed/renamed a module?** -> Update architecture docs
- **Changed interfaces or APIs?** -> Update architecture docs
- **Modified data models or schemas?** -> Update architecture docs
- **Altered component responsibilities?** -> Update architecture docs
- **Introduced new patterns or conventions?** -> Document them
- **Changed external service integrations?** -> Update integration docs
- **Modified configuration structure?** -> Update configuration docs
