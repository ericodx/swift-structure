# Infrastructure Documentation

Implementation documentation for SwiftStructure Infrastructure layer.

## Overview

The Infrastructure layer handles external concerns, primarily file system operations. It provides abstractions that isolate the rest of the application from I/O details.

## Structure

```text
Sources/SwiftStructure/Infrastructure/
├── Files/
│   ├── FileIOActor.swift
│   ├── FileReader.swift
│   ├── FileReadingError.swift
│   └── FileWritingError.swift
└── Protocols/
    └── FileReading.swift
```

## Modules

| Module | Description |
|--------|-------------|
| [Files](Files/README.md) | File system operations and error types |
| [Protocols](Protocols/README.md) | Abstractions for dependency injection |

## Layer Responsibilities

- Encapsulate file system access
- Provide async-safe file I/O via actors
- Define error types for I/O failures
- Enable testability through protocol abstractions

## Design Principles

- **Actor isolation**: `FileIOActor` ensures thread-safe file operations
- **Protocol abstraction**: `FileReading` enables mock injection in tests
- **Error specificity**: Dedicated error types with context information
