import Testing

@testable import SwiftStructure

@Suite("TypeDiscoveryVisitor Tests")
struct TypeDiscoveryVisitorTests {

    @Test("Discovers struct")
    func discoversStruct() {
        let declarations = discoverTypes(in: "struct Foo {}")

        #expect(declarations.count == 1)
        #expect(declarations[0].name == "Foo")
        #expect(declarations[0].kind == .struct)
    }

    @Test("Discovers class")
    func discoversClass() {
        let declarations = discoverTypes(in: "class Bar {}")

        #expect(declarations.count == 1)
        #expect(declarations[0].name == "Bar")
        #expect(declarations[0].kind == .class)
    }

    @Test("Discovers enum")
    func discoversEnum() {
        let declarations = discoverTypes(in: "enum Status { case active }")

        #expect(declarations.count == 1)
        #expect(declarations[0].name == "Status")
        #expect(declarations[0].kind == .enum)
    }

    @Test("Discovers actor")
    func discoversActor() {
        let declarations = discoverTypes(in: "actor Worker {}")

        #expect(declarations.count == 1)
        #expect(declarations[0].name == "Worker")
        #expect(declarations[0].kind == .actor)
    }

    @Test("Discovers protocol")
    func discoversProtocol() {
        let declarations = discoverTypes(in: "protocol Runnable {}")

        #expect(declarations.count == 1)
        #expect(declarations[0].name == "Runnable")
        #expect(declarations[0].kind == .protocol)
    }

    @Test("Discovers nested types")
    func discoversNestedTypes() {
        let source = """
            struct Outer {
                class Inner {}
            }
            """
        let declarations = discoverTypes(in: source)

        #expect(declarations.count == 2)
        #expect(declarations[0].name == "Outer")
        #expect(declarations[1].name == "Inner")
    }

    @Test("Records correct line numbers")
    func recordsLineNumbers() {
        let source = """
            struct First {}

            struct Second {}
            """
        let declarations = discoverTypes(in: source)

        #expect(declarations[0].line == 1)
        #expect(declarations[1].line == 3)
    }

    @Test("Ignores non-type declarations")
    func ignoresNonTypes() {
        let source = """
            let x = 1
            func foo() {}
            var y = 2
            """
        let declarations = discoverTypes(in: source)

        #expect(declarations.isEmpty)
    }

    @Test("Handles empty source")
    func handlesEmptySource() {
        let declarations = discoverTypes(in: "")
        #expect(declarations.isEmpty)
    }
}
