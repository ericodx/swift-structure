import ArgumentParser

struct CheckCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "check",
        abstract: "Analyze Swift files and report structural order."
    )

    @Argument(help: "Swift source files to analyze.")
    var files: [String]

    func run() throws {
        let fileReader = FileReader()
        let analysisPipeline = ParseStage()
            .then(ClassifyStage())
            .then(ReorderStage())

        let reportStage = ReorderReportStage()

        var totalCount = 0
        var needsReordering = false

        for file in files {
            let source = try fileReader.read(at: file)
            let input = ParseInput(path: file, source: source)
            let reorderOutput = try analysisPipeline.process(input)
            let reportOutput = try reportStage.process(reorderOutput)

            print(reportOutput.text)
            print()

            totalCount += reportOutput.declarationCount

            if reorderOutput.results.contains(where: { $0.needsReordering }) {
                needsReordering = true
            }
        }

        let fileWord = files.count == 1 ? "file" : "files"
        let declWord = totalCount == 1 ? "declaration" : "declarations"
        print("Total: \(totalCount) type \(declWord) in \(files.count) \(fileWord)")

        if needsReordering {
            throw ExitCode(1)
        }
    }
}
