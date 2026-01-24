import Testing

@testable import SwiftStructure

@Suite("TypeDeclaration Tests")
struct TypeDeclarationTests {

    @Test("Given a TypeDeclaration with a name, when creating the instance, then stores name correctly")
    func storesName() {
        let decl = TypeDeclaration(name: "MyType", kind: .struct, line: 1)
        #expect(decl.name == "MyType")
    }

    @Test("Given a TypeDeclaration with a specific kind, when creating the instance, then stores kind correctly")
    func storesKind() {
        let decl = TypeDeclaration(name: "Test", kind: .class, line: 1)
        #expect(decl.kind == .class)
    }

    @Test("Given a TypeDeclaration with a line number, when creating the instance, then stores line correctly")
    func storesLine() {
        let decl = TypeDeclaration(name: "Test", kind: .enum, line: 42)
        #expect(decl.line == 42)
    }

    @Test("Given TypeDeclaration, when stored as Sendable, then can be recovered with same name")
    func isSendable() {
        let original = TypeDeclaration(name: "Test", kind: .actor, line: 1)
        let sendable: any Sendable = original

        #expect((sendable as? TypeDeclaration)?.name == original.name)
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
