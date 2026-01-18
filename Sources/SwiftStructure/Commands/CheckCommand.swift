import ArgumentParser

struct CheckCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "check",
        abstract: "Analyze Swift files and report structural order."
    )

    @Argument(help: "Swift source files to analyze.")
    var files: [String]

    @Flag(name: .shortAndLong, help: "Only show files that need reordering.")
    var quiet: Bool = false

    func run() throws {
        let fileReader = FileReader()
        let configService = ConfigurationService(fileReader: fileReader)
        let config = try configService.load()

        let analysisPipeline = ParseStage()
            .then(ClassifyStage())
            .then(ReorderStage(configuration: config))

        var totalTypes = 0
        var typesNeedingReorder = 0
        var filesNeedingReorder: [String] = []

        for file in files {
            let source = try fileReader.read(at: file)
            let input = ParseInput(path: file, source: source)
            let reorderOutput = try analysisPipeline.process(input)

            totalTypes += reorderOutput.results.count
            let fileNeedsReorder = reorderOutput.results.contains { $0.needsReordering }

            if fileNeedsReorder {
                filesNeedingReorder.append(file)
                typesNeedingReorder += reorderOutput.results.filter(\.needsReordering).count
            }

            if !quiet {
                let reportStage = ReorderReportStage()
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
