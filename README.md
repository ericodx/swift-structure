# Swift Structure

![Platform](https://img.shields.io/badge/platform-macOS-orange?logo=apple&logoColor=white)
![Swift](https://img.shields.io/badge/swift-6.0+-orange?logo=swift&logoColor=white)
[![CI](https://github.com/ericodx/swift-structure/actions/workflows/main-analysis.yml/badge.svg)](https://github.com/ericodx/swift-structure/actions/workflows/main-analysis.yml)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=deploy-on-friday-swift-structure&metric=alert_status)](https://sonarcloud.io/dashboard?id=deploy-on-friday-swift-structure)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=deploy-on-friday-swift-structure&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=deploy-on-friday-swift-structure)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=deploy-on-friday-swift-structure&metric=coverage)](https://sonarcloud.io/dashboard?id=deploy-on-friday-swift-structure)

**Organize the internal structure of Swift types without rewriting code.**

Swift Structure is an AST-based CLI tool built on SwiftSyntax.

It focuses exclusively on **structural organization** of Swift types — not formatting, not syntax rewriting, and not templates.

---

## What Swift Structure Does

- Reorders and groups members **within the same declaration scope**
- Reorders members inside individual `extension` blocks only
- Treats `extension` blocks as hard structural boundaries
- Never moves members across extensions or files
- Preserves comments, trivia, and original formatting
- Produces deterministic output

---

## Installation

The recommended way to install Swift Structure is via Homebrew:

```bash
brew tap ericodx/homebrew-tap
brew install swift-structure
```

### Other Installation Methods

**[View Complete Installation Guide](Docs/INSTALLATION.md)**

- Manual build from source
- Direct download of pre-compiled binaries
- Troubleshooting and updates

---

## Usage

### Check files for ordering issues

```bash
# Single file
swift-structure check Sources/App/MyFile.swift

# All .swift files recursively (zsh)
swift-structure check Sources/**/*.swift

# All .swift files recursively (bash/portable)
swift-structure check $(find Sources -name "*.swift")

# Quiet mode (CI-friendly, only shows files needing changes)
swift-structure check --quiet $(find Sources -name "*.swift")
```

Exit codes:
- `0` - All files are correctly ordered
- `1` - One or more files need reordering

### Fix files

```bash
# Single file
swift-structure fix Sources/App/MyFile.swift

# All .swift files recursively
swift-structure fix $(find Sources -name "*.swift")

# Preview changes without modifying files
swift-structure fix --dry-run $(find Sources -name "*.swift")

# Quiet mode (only show summary)
swift-structure fix --quiet $(find Sources -name "*.swift")
```

---

## Quick Integration

### Xcode Build Phase

```bash
if which swift-structure > /dev/null; then
    swift-structure check --quiet $(find "${SRCROOT}/Sources" -name "*.swift")
fi
```

### GitHub Actions

```yaml
- name: Check structure
  run: swift-structure check Sources/**/*.swift
```

### pre-commit

```yaml
hooks:
  - id: swift-structure
    entry: swift-structure check --quiet
    files: \.swift$
```

See [Xcode Integration](Docs/Examples/xcode-integration.md) and [CI Integration](Docs/Examples/ci-integration.md) for complete guides.

---

## Configuration

Swift Structure uses **`.swift-structure.yaml`** for configuration.

```bash
# Initialize configuration file
swift-structure init
```

See [Configuration Reference](Docs/CONFIGURATION.md) for complete documentation.

### Example Configurations

| Example | Use Case |
|---------|----------|
| [minimal.yaml](Docs/Examples/minimal.yaml) | Basic ordering |
| [swiftui.yaml](Docs/Examples/swiftui.yaml) | SwiftUI with property wrappers |
| [uikit.yaml](Docs/Examples/uikit.yaml) | UIKit with lifecycle methods |
| [visibility-focused.yaml](Docs/Examples/visibility-focused.yaml) | Libraries and frameworks |

---

## Documentation

| Document | Description |
|----------|-------------|
| [Architecture](Docs/Architecture/README.md) | System design and patterns |
| [CI/CD](Docs/CI/README.md) | GitHub Actions workflows and automation |
| [CLI Reference](Docs/CLI/README.md) | Commands and implementation |
| [Configuration](Docs/CONFIGURATION.md) | YAML schema and options |
| [Examples](Docs/Examples/README.md) | Configuration examples |

### Integration Guides

| Guide | Description |
|-------|-------------|
| [Xcode Integration](Docs/Examples/xcode-integration.md) | Build phases, hooks, behaviors |
| [CI Integration](Docs/Examples/ci-integration.md) | GitHub Actions, GitLab CI, etc. |
