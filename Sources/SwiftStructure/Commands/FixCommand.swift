import ArgumentParser

struct FixCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "fix",
        abstract: "Reorder members in Swift files."
    )

    @Argument(help: "Swift source files to fix.")
    var files: [String]

    @Flag(name: .long, help: "Show changes without modifying files.")
    var dryRun: Bool = false

    @Flag(name: .shortAndLong, help: "Only show summary.")
    var quiet: Bool = false

    func run() throws {
        let fileReader = FileReader()
        let fileWriter = FileWriter()
        let configService = ConfigurationService(fileReader: fileReader)
        let config = try configService.load()

        let pipeline = ParseStage()
            .then(SyntaxClassifyStage())
            .then(RewritePlanStage(configuration: config))
            .then(ApplyRewriteStage())

        var modifiedFiles: [String] = []

        for file in files {
            let source = try fileReader.read(at: file)
            let input = ParseInput(path: file, source: source)
            let output = try pipeline.process(input)

            if output.modified {
                modifiedFiles.append(file)

                if !dryRun {
                    try fileWriter.write(output.source, to: file)
                }

                if !quiet {
                    if dryRun {
                        print("Would reorder: \(file)")
                    } else {
                        print("Reordered: \(file)")
                    }
                }
            }
        }

        printSummary(
            totalFiles: files.count,
            modifiedFiles: modifiedFiles,
            dryRun: dryRun
        )
    }

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
