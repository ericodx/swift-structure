import Testing

@testable import SwiftStructure

@Suite("ClassifyStage Tests")
struct ClassifyStageTests {

    @Test("Classifies struct declaration")
    func classifiesStruct() throws {
        let output = try classify("struct Foo {}")

        #expect(output.declarations.count == 1)
        #expect(output.declarations[0].kind == .struct)
        #expect(output.declarations[0].name == "Foo")
    }

    @Test("Classifies class declaration")
    func classifiesClass() throws {
        let output = try classify("class Bar {}")

        #expect(output.declarations.count == 1)
        #expect(output.declarations[0].kind == .class)
        #expect(output.declarations[0].name == "Bar")
    }

    @Test("Classifies enum declaration")
    func classifiesEnum() throws {
        let output = try classify("enum Status {}")

        #expect(output.declarations.count == 1)
        #expect(output.declarations[0].kind == .enum)
        #expect(output.declarations[0].name == "Status")
    }

    @Test("Classifies actor declaration")
    func classifiesActor() throws {
        let output = try classify("actor Worker {}")

        #expect(output.declarations.count == 1)
        #expect(output.declarations[0].kind == .actor)
        #expect(output.declarations[0].name == "Worker")
    }

    @Test("Classifies protocol declaration")
    func classifiesProtocol() throws {
        let output = try classify("protocol Runnable {}")

        #expect(output.declarations.count == 1)
        #expect(output.declarations[0].kind == .protocol)
        #expect(output.declarations[0].name == "Runnable")
    }

    @Test("Classifies multiple declarations")
    func classifiesMultiple() throws {
        let source = """
            struct A {}
            class B {}
            enum C {}
            """
        let output = try classify(source)

        #expect(output.declarations.count == 3)
        #expect(output.declarations[0].name == "A")
        #expect(output.declarations[1].name == "B")
        #expect(output.declarations[2].name == "C")
    }

    @Test("Classifies nested types")
    func classifiesNestedTypes() throws {
        let source = """
            struct Outer {
                struct Inner {}
            }
            """
        let output = try classify(source)

        #expect(output.declarations.count == 2)
        #expect(output.declarations[0].name == "Outer")
        #expect(output.declarations[1].name == "Inner")
    }

    @Test("Preserves path in output")
    func preservesPath() throws {
        let parseOutput = makeParseOutput(source: "struct X {}", path: "/test/path.swift")
        let stage = ClassifyStage()

        let output = try stage.process(parseOutput)

        #expect(output.path == "/test/path.swift")
    }
}
