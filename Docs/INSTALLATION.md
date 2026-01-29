# Installation

This document describes various ways to install Swift Structure.

---

## 📦 Homebrew (Recommended)

The easiest way to install Swift Structure is via Homebrew:

```bash
brew tap ericodx/homebrew-tap
brew install swift-structure
```

### Update

```bash
brew upgrade swift-structure
```

### Uninstall

```bash
brew uninstall swift-structure
```

---

## 🔧 Manual Installation

### Build from Source

```bash
git clone https://github.com/ericodx/swift-structure.git
cd swift-structure
swift build -c release

# Install to user local bin
mkdir -p ~/.local/bin
cp .build/release/SwiftStructure ~/.local/bin/swift-structure

# Add to PATH (add this to your ~/.zshrc)
export PATH="$HOME/.local/bin:$PATH"
```

### Verify Installation

```bash
swift-structure --version
swift-structure --help
```

---

## 🚀 Direct Download

You can download pre-compiled binaries from [GitHub Releases](https://github.com/ericodx/swift-structure/releases).

1. Download the latest `swift-structure-v*.macos.tar.gz`
2. Extract the binary:
   ```bash
   tar -xzf swift-structure-v*.macos.tar.gz
   ```
3. Move to your PATH:
   ```bash
   mv swift-structure ~/.local/bin/
   ```

---

## 📋 Requirements

- **macOS** 15.0 (Sequoia) or later
- **Swift** 6.0+ (for building from source)
- **Xcode** 15.0+ (for building from source)

---

## 🔍 Verification

After installation, verify that Swift Structure is working:

```bash
# Check version
swift-structure --version

# Check help
swift-structure --help

# Test on a sample file
echo 'struct Test { func b() {} func a() {} }' > test.swift
swift-structure check test.swift
```

---

## 🐛 Troubleshooting

### Command not found

```bash
# Check if binary is in PATH
which swift-structure

# If not found, add to PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Permission denied

```bash
# Make binary executable
chmod +x ~/.local/bin/swift-structure
```

### Build from source fails

```bash
# Clean build cache
rm -rf .build
swift build -c release

# Ensure Xcode command line tools are installed
xcode-select --install
```

---

## 🔄 Updates

### Homebrew

```bash
brew upgrade swift-structure
```

### Manual

```bash
cd swift-structure
git pull origin main
swift build -c release
cp .build/release/SwiftStructure ~/.local/bin/swift-structure
```

---

## 📚 Next Steps

- [Usage Guide](../README.md#usage)
- [Configuration](./CONFIGURATION.md)
- [Examples](./EXAMPLES.md)
