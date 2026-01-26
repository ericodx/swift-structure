# CLI Documentation

Documentation for the SwiftStructure command-line interface.

## Source Structure

```text
Sources/SwiftStructure/
├── SwiftStructure.swift       # Entry point (@main)
├── Commands/                  # CLI commands
├── Core/                      # Domain models and logic
├── Infrastructure/            # File I/O abstractions
└── Pipeline/                  # Processing pipeline
```

## Documentation Modules

| Module | Description |
|--------|-------------|
| [SwiftStructure](SwiftStructure.md) | CLI entry point (`@main`) |
| [Commands](Commands/README.md) | CLI commands |
| [Core](Core/README.md) | Configuration, models, visitors |
| [Infrastructure](Infrastructure/README.md) | File reading and writing |
| [Pipeline](Pipeline/README.md) | Stage-based processing |

## Quick Links

| Audience | Document |
|----------|----------|
| **Users** | [Commands/Usage.md](Commands/Usage.md) |
| **Developers** | Module READMEs above |

## Architecture Overview

### Layer Dependencies

```mermaid
flowchart LR
    Commands --> Pipeline
    Commands --> Infrastructure
    Pipeline --> Core
    Pipeline --> Infrastructure
```

### Command Structure

```mermaid
flowchart LR
    SS[SwiftStructure] --> IC[InitCommand]
    SS --> CC[CheckCommand]
    SS --> FC[FixCommand]
```

### Check Pipeline

```mermaid
flowchart LR
    CC[CheckCommand] --> PC[PipelineCoordinator]
    PC --> FIO[FileIOActor]

    subgraph Stages
        PS[ParseStage] --> CS[ClassifyStage]
        CS --> RS[ReorderStage]
    end

    PC --> PS
    RS --> RE[ReorderEngine]
    CS --> V[Visitors]
```

### Fix Pipeline

```mermaid
flowchart LR
    FC[FixCommand] --> PC[PipelineCoordinator]
    PC --> FIO[FileIOActor]

    subgraph Stages
        PS[ParseStage] --> SCS[SyntaxClassifyStage]
        SCS --> RPS[RewritePlanStage]
        RPS --> ARS[ApplyRewriteStage]
    end

    PC --> PS
    RPS --> RE[ReorderEngine]
    SCS --> V[Visitors]
```
