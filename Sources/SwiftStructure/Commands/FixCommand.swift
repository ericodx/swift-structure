import ArgumentParser

struct FixCommand: AsyncParsableCommand {

    // MARK: - Configuration

    static let configuration = CommandConfiguration(
        commandName: "fix",
        abstract: "Reorder members in Swift files.",
        discussion: """
            Applies member reordering to Swift files. Use --dry-run to preview \
            changes without modifying files. In dry-run mode, exits with code 1 \
            if any files would be modified.

            EXAMPLES:
              swift-structure fix Sources/*.swift
              swift-structure fix --dry-run Sources/**/*.swift
              swift-structure fix --quiet --config custom.yaml Sources/
            """
    )

    // MARK: - Arguments

    @Argument(help: "Swift source files to fix.")
    var files: [String]

    @Option(name: .shortAndLong, help: "Path to configuration file.")
    var config: String?

    @Flag(name: .long, help: "Show changes without modifying files.")
    var dryRun: Bool = false

    @Flag(name: .shortAndLong, help: "Only show summary.")
    var quiet: Bool = false

    // MARK: - Execution

    func run() async throws {
        let fileIO = FileIOActor()
        let fileReader = FileReader()
        let configService = ConfigurationService(fileReader: fileReader)
        let configuration = try await configService.load(configPath: config)

        let coordinator = PipelineCoordinator(fileIO: fileIO, configuration: configuration)
        let results = try await coordinator.fixFiles(files, dryRun: dryRun)

        var modifiedFiles: [String] = []

        for result in results where result.modified {
            modifiedFiles.append(result.path)

            if !quiet {
                if dryRun {
                    print("Would reorder: \(result.path)")
                } else {
                    print("Reordered: \(result.path)")
                }
            }
        }

        printSummary(
            totalFiles: files.count,
            modifiedFiles: modifiedFiles,
            dryRun: dryRun
        )

        if dryRun && !modifiedFiles.isEmpty {
            throw ExitCode(1)
        }
    }

    // MARK: - Private Helpers

    private func printSummary(totalFiles: Int, modifiedFiles: [String], dryRun: Bool) {
        let count = modifiedFiles.count

        if count == 0 {
            print("✓ All \(totalFiles) \(totalFiles == 1 ? "file" : "files") already correctly ordered")
        } else if dryRun {
            print("⚠ \(count) \(count == 1 ? "file" : "files") would be modified")
        } else {
            print("✓ \(count) \(count == 1 ? "file" : "files") reordered")
        }
    }
}
