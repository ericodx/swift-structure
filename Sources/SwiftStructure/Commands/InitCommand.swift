import ArgumentParser
import Foundation

struct InitCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "init",
        abstract: "Create a default .swift-structure.yaml configuration file.",
        discussion: """
            Creates a .swift-structure.yaml configuration file in the current \
            directory with default member ordering rules.

            EXAMPLES:
              swift-structure init
              swift-structure init --force
            """
    )

    @Flag(name: .long, help: "Overwrite existing configuration file.")
    var force: Bool = false

    private static let configFileName = ".swift-structure.yaml"

    func run() throws {
        let configPath = FileManager.default.currentDirectoryPath + "/" + Self.configFileName

        if FileManager.default.fileExists(atPath: configPath) && !force {
            throw InitError.configAlreadyExists(configPath)
        }

        try defaultConfigContent.write(toFile: configPath, atomically: true, encoding: .utf8)
        print("Created \(Self.configFileName)")
    }

    private var defaultConfigContent: String {
        """
        version: 1

        ordering:
          members:
            - typealias
            - associatedtype
            - initializer
            - type_property
            - instance_property
            - subtype
            - type_method
            - instance_method
            - subscript
            - deinitializer

        extensions:
          strategy: separate
          respect_boundaries: true
        """
    }
}

enum InitError: Error, LocalizedError {
    case configAlreadyExists(String)

    var errorDescription: String? {
        switch self {
        case .configAlreadyExists(let path):
            return "Configuration file already exists at \(path). Use --force to overwrite."
        }
    }
}
