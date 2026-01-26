# FileReading

**Source**: `Sources/SwiftStructure/Infrastructure/Protocols/FileReading.swift`

Protocol for file reading abstraction.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `protocol FileReading` |

## Required Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `read(at:)` | `path: String` | `String` | Read file contents |

## Implementations

| Type | Description |
|------|-------------|
| `FileReader` | Production implementation |
| (Mock) | Test doubles in unit tests |

## Usage

Injected into `ConfigurationService` to enable:
- Real file reading in production
- Mock file content in tests

## Design Decisions

- **Minimal interface**: Single method for single responsibility
- **Throws**: Allows implementations to signal failures
- **No async**: Configuration loading is synchronous at startup

## Related

- [FileReader](../Files/FileReader.md) - Production implementation
