# SwiftStructure (Entry Point)

**Source**: `Sources/SwiftStructure/SwiftStructure.swift`

The root command that serves as the CLI entry point.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct SwiftStructure` |
| **Protocol** | `AsyncParsableCommand` |
| **Attribute** | `@main` (application entry point) |

## Configuration

| Property | Value |
|----------|-------|
| `commandName` | `"swift-structure"` |
| `abstract` | Short description for help |
| `discussion` | Extended help with examples |
| `version` | Semantic version string |
| `subcommands` | Array of command types |

## Responsibilities

- Defines the CLI name and version
- Registers all subcommands
- Provides root-level help text
- Delegates execution to subcommands

## Notes

- Uses `AsyncParsableCommand` to support async subcommands
- Does not implement `run()` - only serves as command container
