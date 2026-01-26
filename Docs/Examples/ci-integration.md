# CI Integration

Guide for integrating SwiftStructure into continuous integration pipelines.

## Overview

SwiftStructure's `check` command returns exit code `1` when files need reordering, making it ideal for CI enforcement.

```bash
# Exit 0 = All files correctly ordered
# Exit 1 = Files need reordering
swift-structure check Sources/**/*.swift
```

## GitHub Actions

### Basic Check

```yaml
# .github/workflows/swift-structure.yml
name: SwiftStructure

on:
  pull_request:
    paths:
      - '**.swift'
  push:
    branches: [main]
    paths:
      - '**.swift'

jobs:
  check:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build SwiftStructure
        run: |
          git clone https://github.com/your-org/swift-structure.git /tmp/swift-structure
          cd /tmp/swift-structure
          swift build -c release
          sudo cp .build/release/SwiftStructure /usr/local/bin/swift-structure

      - name: Check member ordering
        run: swift-structure check Sources/**/*.swift
```

### With Caching

```yaml
name: SwiftStructure

on:
  pull_request:
    paths:
      - '**.swift'

jobs:
  check:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - name: Cache SwiftStructure
        id: cache-swift-structure
        uses: actions/cache@v4
        with:
          path: /usr/local/bin/swift-structure
          key: swift-structure-v1.0.0

      - name: Build SwiftStructure
        if: steps.cache-swift-structure.outputs.cache-hit != 'true'
        run: |
          git clone https://github.com/your-org/swift-structure.git /tmp/swift-structure
          cd /tmp/swift-structure
          swift build -c release
          sudo cp .build/release/SwiftStructure /usr/local/bin/swift-structure

      - name: Check member ordering
        run: swift-structure check Sources/**/*.swift
```

### Auto-Fix and Commit

```yaml
name: SwiftStructure Auto-Fix

on:
  pull_request:
    paths:
      - '**.swift'

jobs:
  fix:
    runs-on: macos-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4
        with:
          ref: ${{ github.head_ref }}
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Setup SwiftStructure
        run: |
          git clone https://github.com/your-org/swift-structure.git /tmp/swift-structure
          cd /tmp/swift-structure
          swift build -c release
          sudo cp .build/release/SwiftStructure /usr/local/bin/swift-structure

      - name: Fix member ordering
        run: swift-structure fix Sources/**/*.swift

      - name: Commit changes
        run: |
          git config --local user.email "github-actions[bot]@users.noreply.github.com"
          git config --local user.name "github-actions[bot]"
          git add -A
          git diff --staged --quiet || git commit -m "style: fix member ordering"
          git push
```

### Matrix Build (Multiple Targets)

```yaml
name: SwiftStructure

on:
  pull_request:

jobs:
  check:
    runs-on: macos-latest
    strategy:
      matrix:
        target:
          - Sources/App/**/*.swift
          - Sources/Core/**/*.swift
          - Sources/UI/**/*.swift
    steps:
      - uses: actions/checkout@v4

      - name: Setup SwiftStructure
        run: |
          # ... installation steps ...

      - name: Check ${{ matrix.target }}
        run: swift-structure check ${{ matrix.target }}
```

## GitLab CI

### Basic Check

```yaml
# .gitlab-ci.yml
stages:
  - lint

swift-structure:
  stage: lint
  image: swift:5.9
  before_script:
    - git clone https://github.com/your-org/swift-structure.git /tmp/swift-structure
    - cd /tmp/swift-structure && swift build -c release
    - cp .build/release/SwiftStructure /usr/local/bin/swift-structure
    - cd $CI_PROJECT_DIR
  script:
    - swift-structure check Sources/**/*.swift
  rules:
    - changes:
        - "**/*.swift"
```

### With Cache

```yaml
swift-structure:
  stage: lint
  image: swift:5.9
  cache:
    key: swift-structure-v1
    paths:
      - .swift-structure-bin/
  before_script:
    - |
      if [ ! -f .swift-structure-bin/swift-structure ]; then
        git clone https://github.com/your-org/swift-structure.git /tmp/swift-structure
        cd /tmp/swift-structure && swift build -c release
        mkdir -p $CI_PROJECT_DIR/.swift-structure-bin
        cp .build/release/SwiftStructure $CI_PROJECT_DIR/.swift-structure-bin/swift-structure
        cd $CI_PROJECT_DIR
      fi
    - export PATH="$PATH:$CI_PROJECT_DIR/.swift-structure-bin"
  script:
    - swift-structure check Sources/**/*.swift
```

## Bitrise

### bitrise.yml

```yaml
workflows:
  primary:
    steps:
      - git-clone@8: {}

      - script@1:
          title: Install SwiftStructure
          inputs:
            - content: |
                #!/bin/bash
                set -e
                git clone https://github.com/your-org/swift-structure.git /tmp/swift-structure
                cd /tmp/swift-structure
                swift build -c release
                cp .build/release/SwiftStructure /usr/local/bin/swift-structure

      - script@1:
          title: Check member ordering
          inputs:
            - content: |
                #!/bin/bash
                set -e
                swift-structure check Sources/**/*.swift
```

## CircleCI

### .circleci/config.yml

```yaml
version: 2.1

jobs:
  swift-structure:
    macos:
      xcode: "15.0"
    steps:
      - checkout

      - restore_cache:
          keys:
            - swift-structure-v1

      - run:
          name: Install SwiftStructure
          command: |
            if [ ! -f ~/bin/swift-structure ]; then
              git clone https://github.com/your-org/swift-structure.git /tmp/swift-structure
              cd /tmp/swift-structure
              swift build -c release
              mkdir -p ~/bin
              cp .build/release/SwiftStructure ~/bin/swift-structure
            fi

      - save_cache:
          key: swift-structure-v1
          paths:
            - ~/bin/swift-structure

      - run:
          name: Check member ordering
          command: |
            export PATH="$PATH:$HOME/bin"
            swift-structure check Sources/**/*.swift

workflows:
  lint:
    jobs:
      - swift-structure
```

## Azure Pipelines

### azure-pipelines.yml

```yaml
trigger:
  paths:
    include:
      - '**/*.swift'

pool:
  vmImage: 'macos-latest'

steps:
  - task: Bash@3
    displayName: 'Install SwiftStructure'
    inputs:
      targetType: 'inline'
      script: |
        git clone https://github.com/your-org/swift-structure.git /tmp/swift-structure
        cd /tmp/swift-structure
        swift build -c release
        sudo cp .build/release/SwiftStructure /usr/local/bin/swift-structure

  - task: Bash@3
    displayName: 'Check member ordering'
    inputs:
      targetType: 'inline'
      script: swift-structure check Sources/**/*.swift
```

## Best Practices

### 1. Run Only on Changed Files

```bash
# GitHub Actions example
CHANGED_FILES=$(git diff --name-only origin/main...HEAD -- '*.swift')
if [ -n "$CHANGED_FILES" ]; then
    swift-structure check $CHANGED_FILES
fi
```

### 2. Fail Fast

Place SwiftStructure check early in your pipeline to fail fast on style issues.

### 3. Cache the Binary

Always cache the built binary to speed up CI runs.

### 4. Use Consistent Versions

Pin to a specific version/tag to ensure consistent behavior:

```bash
git clone --branch v1.0.0 https://github.com/your-org/swift-structure.git
```

### 5. Separate Check and Build Jobs

Run SwiftStructure in parallel with your build for faster feedback:

```yaml
jobs:
  lint:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - run: swift-structure check Sources/**/*.swift

  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - run: swift build

  test:
    needs: build
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - run: swift test
```

## Exit Codes

| Code | Meaning |
|------|---------|
| `0` | All files correctly ordered |
| `1` | Files need reordering |
| `>1` | Error (configuration, file not found, etc.) |

## Troubleshooting

### "Configuration file not found"

Ensure `.swift-structure.yaml` is committed to your repository.

### Glob patterns not matching

Different shells handle globs differently. Use explicit paths or `find`:

```bash
find Sources -name "*.swift" -exec swift-structure check {} +
```

### Permission denied

Ensure the binary is executable:

```bash
chmod +x /usr/local/bin/swift-structure
```
