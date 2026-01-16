import Testing

@testable import SwiftStructure

@Suite("TypeDeclaration Tests")
struct TypeDeclarationTests {

    @Test("Stores name correctly")
    func storesName() {
        let decl = TypeDeclaration(name: "MyType", kind: .struct, line: 1)
        #expect(decl.name == "MyType")
    }

    @Test("Stores kind correctly")
    func storesKind() {
        let decl = TypeDeclaration(name: "Test", kind: .class, line: 1)
        #expect(decl.kind == .class)
    }

    @Test("Stores line correctly")
    func storesLine() {
        let decl = TypeDeclaration(name: "Test", kind: .enum, line: 42)
        #expect(decl.line == 42)
    }

    @Test("Is Sendable")
    func isSendable() {
        let decl = TypeDeclaration(name: "Test", kind: .actor, line: 1)
        let sendable: any Sendable = decl

        #expect(sendable is TypeDeclaration)
    }

    @Test("Supports all type kinds")
    func supportsAllKinds() {
        let kinds: [TypeKind] = [.class, .struct, .enum, .actor, .protocol]

        for kind in kinds {
            let decl = TypeDeclaration(name: "Test", kind: kind, line: 1)
            #expect(decl.kind == kind)
        }
    }
}
