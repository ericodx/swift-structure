# ConfigurationService

**Source**: `Sources/SwiftStructure/Core/Configuration/ConfigurationService.swift`

High-level facade for loading configuration files.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct ConfigurationService` |

## Dependencies

| Dependency | Type | Description |
|------------|------|-------------|
| `fileReader` | `FileReading` | Reads file contents |
| `loader` | `ConfigurationLoader` | Parses YAML content |
| `mapper` | `ConfigurationMapper` | Maps raw to validated config |

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `configFileName` | `String` | Fixed: `.swift-structure.yaml` |

## Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `load(from:)` | `directory: String?` | `Configuration` | Load from directory, searching upward |
| `load(configFile:)` | `String` | `Configuration` | Load from specific file path |
| `load(configPath:)` | `String?` | `Configuration` | Load from path or search |

## Private Methods

| Method | Description |
|--------|-------------|
| `loadFromFile(at:)` | Read, parse, and map a config file |
| `findConfigFile(startingFrom:)` | Search directory tree for config file |

## Search Algorithm

When no explicit path is provided:

1. Start from current directory (or specified directory)
2. Check for `.swift-structure.yaml`
3. If not found, move to parent directory
4. Repeat until root is reached
5. If not found anywhere, return `Configuration.default`

## Design Decisions

- **Facade pattern**: Hides complexity of loader/mapper chain
- **Dependency injection**: All dependencies injectable for testing
- **Upward search**: Supports monorepo structures with config at root
- **Graceful fallback**: Returns default config if none found

## Related

- [ConfigurationLoader](ConfigurationLoader.md) - YAML parsing
- [ConfigurationMapper](ConfigurationMapper.md) - Validation and mapping
