# SwiftStructure

![Platform](https://img.shields.io/badge/platform-macOS-orange)
![Swift](https://img.shields.io/badge/swift-6.0+-orange)
![License](https://img.shields.io/badge/license-BSD--3--Clause-blue)
![Status](https://img.shields.io/badge/status-early--stage-red)

**Organize the internal structure of Swift types without rewriting code.**

SwiftStructure is an AST-based CLI tool built on SwiftSyntax.

It focuses exclusively on **structural organization** of Swift types — not formatting, not syntax rewriting, and not templates.

---

## What SwiftStructure Does

- Reorders and groups members **within the same declaration scope**
- Reorders members inside individual `extension` blocks only
- Treats `extension` blocks as hard structural boundaries
- Never moves members across extensions or files
- Preserves comments, trivia, and original formatting
- Produces deterministic output

---

## Installation

```bash
git clone https://github.com/deploy-on-friday/swift-structure.git
cd swift-structure
swift build -c release

# Install to user local bin
mkdir -p ~/.local/bin
cp .build/release/SwiftStructure ~/.local/bin/swift-structure

# Add to PATH (add this to your ~/.zshrc)
export PATH="$HOME/.local/bin:$PATH"
```

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

## Integration

### Xcode Build Phase

Add a "Run Script" build phase to enforce ordering during builds:

```bash
if which swift-structure > /dev/null; then
    swift-structure check --quiet $(find "${SRCROOT}/Sources" -name "*.swift")
else
    echo "warning: swift-structure not installed"
fi
```

To auto-fix instead of failing:

```bash
if which swift-structure > /dev/null; then
    swift-structure fix --quiet $(find "${SRCROOT}/Sources" -name "*.swift")
fi
```

### GitHub Actions

```yaml
name: Check Structure
on: [push, pull_request]

jobs:
  structure:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build swift-structure
        run: |
          git clone https://github.com/deploy-on-friday/swift-structure.git /tmp/swift-structure
          cd /tmp/swift-structure
          swift build -c release
          mkdir -p ~/.local/bin
          cp .build/release/SwiftStructure ~/.local/bin/swift-structure
          echo "$HOME/.local/bin" >> $GITHUB_PATH

      - name: Check structure
        run: swift-structure check --quiet $(find Sources -name "*.swift")
```

### pre-commit

Add to `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: local
    hooks:
      - id: swift-structure
        name: Check Swift structure
        entry: swift-structure check --quiet
        language: system
        files: \.swift$
        pass_filenames: true
```

---

## Configuration

SwiftStructure supports explicit configuration via **`.swift-structure.yaml`**.

Configuration is:
- Opt-in
- Declarative
- Deterministic
- Never inferred

If the configuration file is missing, default behavior is applied.
Invalid configuration causes execution to fail.
