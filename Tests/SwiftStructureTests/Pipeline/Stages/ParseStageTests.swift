import Testing

@testable import SwiftStructure

@Suite("ParseStage Tests")
struct ParseStageTests {

    @Test("Parses valid Swift source")
    func parsesValidSource() throws {
        let stage = ParseStage()
        let input = ParseInput(
            path: "Test.swift",
            source: "struct Foo {}"
        )

        let output = try stage.process(input)

        #expect(output.path == "Test.swift")
        #expect(output.syntax.statements.count == 1)
    }

    @Test("Parses empty source")
    func parsesEmptySource() throws {
        let stage = ParseStage()
        let input = ParseInput(path: "Empty.swift", source: "")

        let output = try stage.process(input)

        #expect(output.path == "Empty.swift")
        #expect(output.syntax.statements.isEmpty)
    }

    @Test("Preserves file path in output")
    func preservesFilePath() throws {
        let stage = ParseStage()
        let input = ParseInput(
            path: "/some/path/File.swift",
            source: "let x = 1"
        )

        let output = try stage.process(input)

        #expect(output.path == "/some/path/File.swift")
    }

    @Test("Creates valid location converter")
    func createsLocationConverter() throws {
        let stage = ParseStage()
        let source = """
            struct First {}
            struct Second {}
            """
        let input = ParseInput(path: "Multi.swift", source: source)

        let output = try stage.process(input)
        let location = output.locationConverter.location(for: output.syntax.position)

        #expect(location.line == 1)
    }
}
