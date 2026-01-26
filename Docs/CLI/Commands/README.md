# Commands Documentation

Implementation documentation for SwiftStructure CLI commands.

## Source Structure

```text
Sources/SwiftStructure/
├── SwiftStructure.swift
└── Commands/
    ├── CheckCommand.swift
    ├── FixCommand.swift
    ├── InitCommand.swift
    └── InitError.swift
```

## Documents

| Document | Source File | Description |
|----------|-------------|-------------|
| [SwiftStructure](../SwiftStructure.md) | `SwiftStructure.swift` | CLI entry point |
| [InitCommand](InitCommand.md) | `Commands/InitCommand.swift` | Configuration initialization |
| [CheckCommand](CheckCommand.md) | `Commands/CheckCommand.swift` | File analysis |
| [FixCommand](FixCommand.md) | `Commands/FixCommand.swift` | File reordering |
| [InitError](InitError.md) | `Commands/InitError.swift` | Error types |
| [Usage](Usage.md) | - | User-facing documentation |

## Dependency Diagrams

### Command Hierarchy

```mermaid
graph LR
    SW[SwiftStructure] --> Init[InitCommand]
    SW --> Check[CheckCommand]
    SW --> Fix[FixCommand]
    Init -.-> IE[InitError]
```

### CheckCommand Dependencies

```mermaid
graph LR
    subgraph Infrastructure
        FIO[FileIOActor]
        FR[FileReader]
    end

    subgraph Core
        CS[ConfigurationService]
    end

    subgraph Pipeline
        PC[PipelineCoordinator]
        RRS[ReorderReportStage]
    end

    CC[CheckCommand] --> FIO
    CC --> FR
    FR --> CS
    CS --> PC
    PC --> RRS
```

### FixCommand Dependencies

```mermaid
graph LR
    subgraph Infrastructure
        FIO[FileIOActor]
        FR[FileReader]
    end

    subgraph Core
        CS[ConfigurationService]
    end

    subgraph Pipeline
        PC[PipelineCoordinator]
    end

    FC[FixCommand] --> FIO
    FC --> FR
    FR --> CS
    CS --> PC
```

## Shared Patterns

All async commands (`CheckCommand`, `FixCommand`) follow the same initialization pattern:

1. Create `FileIOActor` instance
2. Create `FileReader` instance
3. Create `ConfigurationService` with `FileReader`
4. Load configuration
5. Create `PipelineCoordinator` with `FileIOActor` and `Configuration`
6. Execute operation
7. Process results
8. Return exit code
