import ArgumentParser

struct CheckCommand: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "check",
        abstract: "Analyze Swift files and report structural order.",
        discussion: """
            Analyzes Swift files and reports which types need member reordering. \
            Exits with code 1 if any files need changes.

            EXAMPLES:
              swift-structure check Sources/*.swift
              swift-structure check --quiet Sources/**/*.swift
              swift-structure check --config .swift-structure.yaml Sources/
            """
    )

    @Argument(help: "Swift source files to analyze.")
    var files: [String]

    @Option(name: .shortAndLong, help: "Path to configuration file.")
    var config: String?

    @Flag(name: .shortAndLong, help: "Only show files that need reordering.")
    var quiet: Bool = false

    func run() async throws {
        let fileIO = FileIOActor()
        let fileReader = FileReader()
        let configService = ConfigurationService(fileReader: fileReader)
        let configuration = try configService.load(configPath: config)

        let coordinator = PipelineCoordinator(fileIO: fileIO, configuration: configuration)
        let results = try await coordinator.checkFiles(files)

        var totalTypes = 0
        var typesNeedingReorder = 0
        var filesNeedingReorder: [String] = []

        for result in results {
            totalTypes += result.results.count

            if result.needsReorder {
                filesNeedingReorder.append(result.path)
                typesNeedingReorder += result.results.filter(\.needsReordering).count
            }

            if !quiet {
                let reportStage = ReorderReportStage()
                let reorderOutput = ReorderOutput(path: result.path, results: result.results)
                let reportOutput = try reportStage.process(reorderOutput)
                print(reportOutput.text)
                print()
            }
        }

        printSummary(
            totalFiles: files.count,
            totalTypes: totalTypes,
            filesNeedingReorder: filesNeedingReorder,
            typesNeedingReorder: typesNeedingReorder
        )

        if !filesNeedingReorder.isEmpty {
            throw ExitCode(1)
        }
    }

    private func printSummary(
        totalFiles: Int,
        totalTypes: Int,
        filesNeedingReorder: [String],
        typesNeedingReorder: Int
    ) {
        if filesNeedingReorder.isEmpty {
            print(
                "✓ All \(totalTypes) types in \(totalFiles) \(totalFiles == 1 ? "file" : "files") are correctly ordered"
            )
        } else {
            if quiet {
                for file in filesNeedingReorder {
                    print("\(file)")
                }
                print()
            }
            let typeWord = typesNeedingReorder == 1 ? "type" : "types"
            let fileWord = filesNeedingReorder.count == 1 ? "file needs" : "files need"
            print("✗ \(typesNeedingReorder) \(typeWord) in \(filesNeedingReorder.count) \(fileWord) reordering")
            print("  Run 'swift-structure fix' to apply changes")
        }
    }
}
