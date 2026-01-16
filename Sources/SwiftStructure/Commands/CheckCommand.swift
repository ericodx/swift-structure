import ArgumentParser

struct CheckCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "check",
        abstract: "Analyze Swift files and report type declarations."
    )

    @Argument(help: "Swift source files to analyze.")
    var files: [String]

    func run() throws {
        let fileReader = FileReader()
        let pipeline = ParseStage()
            .then(ClassifyStage())
            .then(ReportStage())

        var totalCount = 0

        for file in files {
            let source = try fileReader.read(at: file)
            let input = ParseInput(path: file, source: source)
            let output = try pipeline.process(input)

            print(output.text)
            print()

            totalCount += output.declarationCount
        }

        let fileWord = files.count == 1 ? "file" : "files"
        let declWord = totalCount == 1 ? "declaration" : "declarations"
        print("Summary: \(totalCount) type \(declWord) in \(files.count) \(fileWord)")
    }
}
