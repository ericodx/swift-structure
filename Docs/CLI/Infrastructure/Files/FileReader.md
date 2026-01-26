# FileReader

**Source**: `Sources/SwiftStructure/Infrastructure/Files/FileReader.swift`

Synchronous file reader conforming to `FileReading` protocol.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct FileReader` |
| **Protocols** | `FileReading` |

## Methods

| Method | Parameters | Returns | Throws | Description |
|--------|------------|---------|--------|-------------|
| `read(at:)` | `path: String` | `String` | `FileReadingError` | Read file contents |

## Read Operation

1. Create URL from path
2. Check file existence via `FileManager`
3. If not found, throw `FileReadingError.fileNotFound`
4. Read contents as UTF-8 string
5. If read fails, throw `FileReadingError.readError`

## Protocol Conformance

Conforms to `FileReading`, enabling:
- Dependency injection in `ConfigurationService`
- Mock substitution in unit tests

## Usage

Used by `ConfigurationService` for loading configuration files synchronously during command startup.

## Related

- [FileReading](../Protocols/FileReading.md) - Protocol definition
- [FileIOActor](FileIOActor.md) - Async alternative
- [FileReadingError](FileReadingError.md) - Error type
