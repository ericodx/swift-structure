# CI Integration

Guide for integrating Swift Structure into continuous integration pipelines.

## Overview

Swift Structure's `check` command returns exit code `1` when files need reordering, making it ideal for CI enforcement.

```bash
# Exit 0 = All files correctly ordered
# Exit 1 = Files need reordering
swift-structure check

# Exit 0 = Files were reordered successfully
# Exit 1 = No files needed reordering
swift-structure fix
```

## GitHub Actions

### Basic Workflow

```yaml
# .github/workflows/swift-structure.yml
name: Swift Structure

on:
  pull_request:
    paths:
      - '**.swift'

jobs:
  check:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build Swift Structure
        run: |
          git clone https://github.com/ericodx/swift-structure.git /tmp/swift-structure
          cd /tmp/swift-structure
          swift build -c release
          cp /tmp/swift-structure/.build/release/swift-structure /usr/local/bin/

      - name: Check Swift Structure
        run: |
          swift-structure check
```

### With Caching

```yaml
name: Swift Structure

on:
  pull_request:
    paths:
      - '**.swift'

jobs:
  check:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - name: Cache Swift Structure
        id: cache-swift-structure
        uses: actions/cache@v4
        with:
          path: /usr/local/bin/swift-structure
          key: swift-structure-v1.0.0

      - name: Build Swift Structure
        if: steps.cache-swift-structure.outputs.cache-hit != 'true'
        run: |
          git clone https://github.com/ericodx/swift-structure.git /tmp/swift-structure
          cd /tmp/swift-structure
          swift build -c release
          cp /tmp/swift-structure/.build/release/swift-structure /usr/local/bin/

      - name: Check Swift Structure
        run: |
          swift-structure check
```

### Auto-Fix and Commit

```yaml
name: Swift Structure Auto-Fix

on:
  pull_request:
    paths:
      - '**.swift'

jobs:
  fix:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Setup Swift Structure
        run: |
          git clone https://github.com/ericodx/swift-structure.git /tmp/swift-structure
          cd /tmp/swift-structure
          swift build -c release
          cp /tmp/swift-structure/.build/release/swift-structure /usr/local/bin/

      - name: Fix Swift Structure
        run: |
          swift-structure fix

      - name: Commit Changes
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add -A
          git commit -m "fix: apply swift structure" || exit 0
          git push
```

## Best Practices

### Configuration

Always include your `.swift-structure.yaml` in your repository:

```yaml
# .github/workflows/swift-structure.yml
- name: Check Swift Structure
  run: |
    swift-structure check --config .swift-structure.yaml
```

### Performance

- Use caching to avoid rebuilding Swift Structure
- Run only on Swift file changes
- Consider using `--quiet` flag for cleaner logs

### Integration with Other Tools

Swift Structure works well alongside other code quality tools:

```yaml
- name: Run SwiftLint
  run: swiftlint

- name: Check Swift Structure
  run: swift-structure check

- name: Run Tests
  run: swift test
```
