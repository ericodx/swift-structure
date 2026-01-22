import Testing

@testable import SwiftStructure

@Suite("MemberDiscoveryVisitor Tests")
struct MemberDiscoveryVisitorTests {

    @Test("Given a stored property declaration, when analyzing the source, then identifies it as instanceProperty")
    func discoversInstanceProperty() {
        let members = discoverMembers(in: "var name: String")

        #expect(members.count == 1)
        #expect(members[0].name == "name")
        #expect(members[0].kind == .instanceProperty)
    }

    @Test("Given a computed property declaration, when analyzing the source, then identifies it as instanceProperty")
    func discoversComputedProperty() {
        let members = discoverMembers(in: "var computed: Int { return 42 }")

        #expect(members.count == 1)
        #expect(members[0].name == "computed")
        #expect(members[0].kind == .instanceProperty)
    }

    @Test("Given a static property declaration, when analyzing the source, then identifies it as typeProperty")
    func discoversTypeProperty() {
        let members = discoverMembers(in: "static var shared: Self")

        #expect(members.count == 1)
        #expect(members[0].name == "shared")
        #expect(members[0].kind == .typeProperty)
    }

    @Test("Given an init declaration, when analyzing the source, then identifies it as initializer")
    func discoversInitializer() {
        let members = discoverMembers(in: "init() {}")

        #expect(members.count == 1)
        #expect(members[0].name == "init")
        #expect(members[0].kind == .initializer)
    }

    @Test("Given a deinit declaration, when analyzing the source, then identifies it as deinitializer")
    func discoversDeinitializer() {
        let members = discoverMembers(in: "deinit {}")

        #expect(members.count == 1)
        #expect(members[0].name == "deinit")
        #expect(members[0].kind == .deinitializer)
    }

    @Test("Given a method declaration, when analyzing the source, then identifies it as instanceMethod")
    func discoversInstanceMethod() {
        let members = discoverMembers(in: "func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].name == "doSomething")
        #expect(members[0].kind == .instanceMethod)
    }

    @Test("Given a static func declaration, when analyzing the source, then identifies it as typeMethod")
    func discoversTypeMethod() {
        let members = discoverMembers(in: "static func create() -> Self { fatalError() }")

        #expect(members.count == 1)
        #expect(members[0].name == "create")
        #expect(members[0].kind == .typeMethod)
    }

    @Test("Given a subscript declaration, when analyzing the source, then identifies it as subscript")
    func discoversSubscript() {
        let members = discoverMembers(in: "subscript(index: Int) -> Int { return index }")

        #expect(members.count == 1)
        #expect(members[0].name == "subscript")
        #expect(members[0].kind == .subscript)
    }

    @Test("Given a typealias declaration, when analyzing the source, then identifies it as typealias")
    func discoversTypealias() {
        let members = discoverMembers(in: "typealias ID = String")

        #expect(members.count == 1)
        #expect(members[0].name == "ID")
        #expect(members[0].kind == .typealias)
    }

    @Test(
        "Given an associatedtype declaration in a protocol, when analyzing the source, then identifies it as associatedtype"
    )
    func discoversAssociatedtype() {
        let members = discoverMembersInProtocol(in: "associatedtype Element")

        #expect(members.count == 1)
        #expect(members[0].name == "Element")
        #expect(members[0].kind == .associatedtype)
    }

    @Test("Given a nested struct declaration, when analyzing the source, then identifies it as subtype")
    func discoversSubtype() {
        let members = discoverMembers(in: "struct Inner {}")

        #expect(members.count == 1)
        #expect(members[0].name == "Inner")
        #expect(members[0].kind == .subtype)
    }

    @Test(
        "Given source with property, initializer, and method, when analyzing the source, then identifies all three members"
    )
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

    @Test(
        "Given a nested type containing members, when analyzing the source, then only the nested type itself is discovered"
    )
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

    @Test(
        "Given source with members on different lines, when analyzing the source, then each member has its start line recorded"
    )
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
