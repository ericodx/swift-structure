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

    func run() throws {
        let fileReader = FileReader()
        let fileWriter = FileWriter()

        let pipeline = ParseStage()
            .then(SyntaxClassifyStage())
            .then(RewritePlanStage())
            .then(ApplyRewriteStage())

        var modifiedCount = 0

        for file in files {
            let source = try fileReader.read(at: file)
            let input = ParseInput(path: file, source: source)
            let output = try pipeline.process(input)

            if output.modified {
                modifiedCount += 1

                if dryRun {
                    print("Would reorder: \(file)")
                } else {
                    try fileWriter.write(output.source, to: file)
                    print("Reordered: \(file)")
                }
            }
        }

        let fileWord = files.count == 1 ? "file" : "files"
        let modifiedWord = modifiedCount == 1 ? "file" : "files"

        if dryRun {
            print("\n\(modifiedCount) \(modifiedWord) would be modified out of \(files.count) \(fileWord)")
        } else {
            print("\n\(modifiedCount) \(modifiedWord) modified out of \(files.count) \(fileWord)")
        }
    }
}
