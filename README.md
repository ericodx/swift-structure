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

## Configuration

SwiftStructure supports explicit configuration via **`.swift-structure.yaml`**.

Configuration is:
- Opt-in
- Declarative
- Deterministic
- Never inferred

If the configuration file is missing, default behavior is applied.
Invalid configuration causes execution to fail.
