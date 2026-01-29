import ArgumentParser

@main
struct SwiftStructure: AsyncParsableCommand {

    // MARK: - Configuration

    static let configuration = CommandConfiguration(
        commandName: "swift-structure",
        abstract: "Organize the internal structure of Swift types.",
        discussion: """
            Swift Structure reorders members within Swift type declarations based on \
            configurable rules while preserving all comments and formatting.

            EXAMPLES:
              swift-structure check Sources/**/*.swift
              swift-structure fix --dry-run Sources/MyFile.swift
              swift-structure init --force
            """,
        version: "1.0.0",
        subcommands: [InitCommand.self, CheckCommand.self, FixCommand.self]
    )
}
