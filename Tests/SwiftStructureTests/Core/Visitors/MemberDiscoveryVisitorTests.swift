import Testing

@testable import SwiftStructure

@Suite("MemberDiscoveryVisitor Tests")
struct MemberDiscoveryVisitorTests {

    @Test("Discovers instance property")
    func discoversInstanceProperty() {
        let members = discoverMembers(in: "var name: String")

        #expect(members.count == 1)
        #expect(members[0].name == "name")
        #expect(members[0].kind == .instanceProperty)
    }

    @Test("Discovers computed property as instance property")
    func discoversComputedProperty() {
        let members = discoverMembers(in: "var computed: Int { return 42 }")

        #expect(members.count == 1)
        #expect(members[0].name == "computed")
        #expect(members[0].kind == .instanceProperty)
    }

    @Test("Discovers type property")
    func discoversTypeProperty() {
        let members = discoverMembers(in: "static var shared: Self")

        #expect(members.count == 1)
        #expect(members[0].name == "shared")
        #expect(members[0].kind == .typeProperty)
    }

    @Test("Discovers initializer")
    func discoversInitializer() {
        let members = discoverMembers(in: "init() {}")

        #expect(members.count == 1)
        #expect(members[0].name == "init")
        #expect(members[0].kind == .initializer)
    }

    @Test("Discovers deinitializer")
    func discoversDeinitializer() {
        let members = discoverMembers(in: "deinit {}")

        #expect(members.count == 1)
        #expect(members[0].name == "deinit")
        #expect(members[0].kind == .deinitializer)
    }

    @Test("Discovers instance method")
    func discoversInstanceMethod() {
        let members = discoverMembers(in: "func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].name == "doSomething")
        #expect(members[0].kind == .instanceMethod)
    }

    @Test("Discovers type method")
    func discoversTypeMethod() {
        let members = discoverMembers(in: "static func create() -> Self { fatalError() }")

        #expect(members.count == 1)
        #expect(members[0].name == "create")
        #expect(members[0].kind == .typeMethod)
    }

    @Test("Discovers subscript")
    func discoversSubscript() {
        let members = discoverMembers(in: "subscript(index: Int) -> Int { return index }")

        #expect(members.count == 1)
        #expect(members[0].name == "subscript")
        #expect(members[0].kind == .subscript)
    }

    @Test("Discovers typealias")
    func discoversTypealias() {
        let members = discoverMembers(in: "typealias ID = String")

        #expect(members.count == 1)
        #expect(members[0].name == "ID")
        #expect(members[0].kind == .typealias)
    }

    @Test("Discovers associatedtype")
    func discoversAssociatedtype() {
        let members = discoverMembersInProtocol(in: "associatedtype Element")

        #expect(members.count == 1)
        #expect(members[0].name == "Element")
        #expect(members[0].kind == .associatedtype)
    }

    @Test("Discovers subtype")
    func discoversSubtype() {
        let members = discoverMembers(in: "struct Inner {}")

        #expect(members.count == 1)
        #expect(members[0].name == "Inner")
        #expect(members[0].kind == .subtype)
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
        #expect(members[0].kind == .instanceProperty)
        #expect(members[1].kind == .initializer)
        #expect(members[2].kind == .instanceMethod)
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
        #expect(members[0].kind == .subtype)
    }

    @Test("Records correct line numbers")
    func recordsLineNumbers() {
        let source = """
            var first: Int
            var second: Int
            var third: Int
            """
        let members = discoverMembers(in: source)

        #expect(members[0].line == 2)
        #expect(members[1].line == 3)
        #expect(members[2].line == 4)
    }
}
