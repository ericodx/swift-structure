import ArgumentParser

@main
struct SwiftStructure: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "swift-structure",
        abstract: "Organize the internal structure of Swift types.",
        version: "0.4.0",
        subcommands: [CheckCommand.self, FixCommand.self]
    )
}
