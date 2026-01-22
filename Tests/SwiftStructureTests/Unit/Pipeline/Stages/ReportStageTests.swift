import Testing

@testable import SwiftStructure

@Suite("ReportStage Tests")
struct ReportStageTests {

    @Test("Given a single declaration input, when generating report with ReportStage, then reports single declaration")
    func reportsSingleDeclaration() throws {
        let input = ClassifyOutput(
            path: "Test.swift",
            declarations: [
                TypeDeclaration(name: "Foo", kind: .struct, line: 1)
            ]
        )
        let stage = ReportStage()

        let output = try stage.process(input)

        #expect(output.text.contains("Test.swift:"))
        #expect(output.text.contains("struct Foo (line 1)"))
        #expect(output.declarationCount == 1)
    }

    @Test(
        "Given multiple declarations input, when generating report with ReportStage, then reports multiple declarations"
    )
    func reportsMultipleDeclarations() throws {
        let input = ClassifyOutput(
            path: "Multi.swift",
            declarations: [
                TypeDeclaration(name: "A", kind: .class, line: 1),
                TypeDeclaration(name: "B", kind: .enum, line: 5),
            ]
        )
        let stage = ReportStage()

        let output = try stage.process(input)

        #expect(output.text.contains("class A (line 1)"))
        #expect(output.text.contains("enum B (line 5)"))
        #expect(output.declarationCount == 2)
    }

    @Test("Given an empty file input, when generating report with ReportStage, then reports empty file")
    func reportsEmptyFile() throws {
        let input = ClassifyOutput(path: "Empty.swift", declarations: [])
        let stage = ReportStage()

        let output = try stage.process(input)

        #expect(output.text.contains("Empty.swift:"))
        #expect(output.text.contains("(no type declarations)"))
        #expect(output.declarationCount == 0)
    }

    @Test("Given an input with specific path, when generating report with ReportStage, then preserves path in output")
    func preservesPath() throws {
        let input = ClassifyOutput(path: "/some/path.swift", declarations: [])
        let stage = ReportStage()

        let output = try stage.process(input)

        #expect(output.path == "/some/path.swift")
    }

    @Test(
        "Given declarations of all type kinds, when generating report with ReportStage, then reports all type kinds correctly"
    )
    func reportsAllTypeKinds() throws {
        let input = ClassifyOutput(
            path: "All.swift",
            declarations: [
                TypeDeclaration(name: "S", kind: .struct, line: 1),
                TypeDeclaration(name: "C", kind: .class, line: 2),
                TypeDeclaration(name: "E", kind: .enum, line: 3),
                TypeDeclaration(name: "A", kind: .actor, line: 4),
                TypeDeclaration(name: "P", kind: .protocol, line: 5),
            ]
        )
        let stage = ReportStage()

        let output = try stage.process(input)

        #expect(output.text.contains("struct S"))
        #expect(output.text.contains("class C"))
        #expect(output.text.contains("enum E"))
        #expect(output.text.contains("actor A"))
        #expect(output.text.contains("protocol P"))
    }
}
