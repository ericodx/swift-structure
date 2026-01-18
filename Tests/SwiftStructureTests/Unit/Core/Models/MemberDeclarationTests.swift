import Testing

@testable import SwiftStructure

@Suite("MemberDeclaration Tests")
struct MemberDeclarationTests {

    @Test("Stores name correctly")
    func storesName() {
        let member = MemberDeclaration(name: "myProperty", kind: .instanceProperty, line: 1)
        #expect(member.name == "myProperty")
    }

    @Test("Stores kind correctly")
    func storesKind() {
        let member = MemberDeclaration(name: "test", kind: .instanceMethod, line: 1)
        #expect(member.kind == .instanceMethod)
    }

    @Test("Stores line correctly")
    func storesLine() {
        let member = MemberDeclaration(name: "test", kind: .initializer, line: 42)
        #expect(member.line == 42)
    }

    @Test("Is Sendable")
    func isSendable() {
        let member = MemberDeclaration(name: "test", kind: .typeProperty, line: 1)
        let sendable: any Sendable = member

        #expect(sendable is MemberDeclaration)
    }
}
