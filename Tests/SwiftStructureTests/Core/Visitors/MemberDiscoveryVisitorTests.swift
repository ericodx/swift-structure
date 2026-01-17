import SwiftParser
import SwiftSyntax
import Testing

@testable import SwiftStructure

@Suite("MemberDiscoveryVisitor Tests")
struct MemberDiscoveryVisitorTests {

    @Test("Discovers stored property")
    func discoversStoredProperty() {
        let members = discoverMembers(in: "var name: String")

        #expect(members.count == 1)
        #expect(members[0].name == "name")
        #expect(members[0].kind == .storedProperty)
    }

    @Test("Discovers computed property")
    func discoversComputedProperty() {
        let members = discoverMembers(in: "var computed: Int { return 42 }")

        #expect(members.count == 1)
        #expect(members[0].name == "computed")
        #expect(members[0].kind == .computedProperty)
    }

    @Test("Discovers static property")
    func discoversStaticProperty() {
        let members = discoverMembers(in: "static var shared: Self")

        #expect(members.count == 1)
        #expect(members[0].name == "shared")
        #expect(members[0].kind == .staticProperty)
    }

    @Test("Discovers initializer")
    func discoversInitializer() {
        let members = discoverMembers(in: "init() {}")

        #expect(members.count == 1)
        #expect(members[0].name == "init")
        #expect(members[0].kind == .initializer)
    }

    @Test("Discovers method")
    func discoversMethod() {
        let members = discoverMembers(in: "func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].name == "doSomething")
        #expect(members[0].kind == .method)
    }

    @Test("Discovers static method")
    func discoversStaticMethod() {
        let members = discoverMembers(in: "static func create() -> Self { fatalError() }")

        #expect(members.count == 1)
        #expect(members[0].name == "create")
        #expect(members[0].kind == .staticMethod)
    }

    @Test("Discovers subscript")
    func discoversSubscript() {
        let members = discoverMembers(in: "subscript(index: Int) -> Int { return index }")

        #expect(members.count == 1)
        #expect(members[0].name == "subscript")
        #expect(members[0].kind == .subscript)
    }

    @Test("Discovers type alias")
    func discoversTypeAlias() {
        let members = discoverMembers(in: "typealias ID = String")

        #expect(members.count == 1)
        #expect(members[0].name == "ID")
        #expect(members[0].kind == .typeAlias)
    }

    @Test("Discovers nested type")
    func discoversNestedType() {
        let members = discoverMembers(in: "struct Inner {}")

        #expect(members.count == 1)
        #expect(members[0].name == "Inner")
        #expect(members[0].kind == .nestedType)
    }

    @Test("Discovers multiple members")
    func discoversMultipleMembers() {
        let source = """
            var name: String
            init() {}
            func greet() {}
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 3)
        #expect(members[0].kind == .storedProperty)
        #expect(members[1].kind == .initializer)
        #expect(members[2].kind == .method)
    }

    @Test("Ignores members in nested types")
    func ignoresNestedTypeMembers() {
        let source = """
            struct Inner {
                var nestedProperty: Int
                func nestedMethod() {}
            }
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 1)
        #expect(members[0].name == "Inner")
        #expect(members[0].kind == .nestedType)
    }

    @Test("Records correct line numbers")
    func recordsLineNumbers() {
        let source = """
            var first: Int
            var second: Int
            var third: Int
            """
        let members = discoverMembers(in: source)

        // Line numbers are offset by 1 due to wrapper struct on line 1
        #expect(members[0].line == 2)
        #expect(members[1].line == 3)
        #expect(members[2].line == 4)
    }

    // MARK: - Helper

    private func discoverMembers(in source: String) -> [MemberDeclaration] {
        let wrappedSource = "struct Test {\n\(source)\n}"
        let syntax = Parser.parse(source: wrappedSource)
        let converter = SourceLocationConverter(fileName: "Test.swift", tree: syntax)

        guard let structDecl = syntax.statements.first?.item.as(StructDeclSyntax.self) else {
            return []
        }

        let visitor = MemberDiscoveryVisitor(sourceLocationConverter: converter)
        visitor.walk(structDecl.memberBlock)
        return visitor.members
    }
}
