import Testing

@testable import SwiftStructure

@Suite("TypeKind Tests")
struct TypeKindTests {

    @Test("Given TypeKind raw values, when checking the enum, then raw values match Swift keywords")
    func rawValuesMatchKeywords() {
        #expect(TypeKind.class.rawValue == "class")
        #expect(TypeKind.struct.rawValue == "struct")
        #expect(TypeKind.enum.rawValue == "enum")
        #expect(TypeKind.actor.rawValue == "actor")
        #expect(TypeKind.protocol.rawValue == "protocol")
    }

    @Test("Given all TypeKind cases, when checking the enum, then all cases are defined")
    func allCasesDefined() {
        let allCases: [TypeKind] = [.class, .struct, .enum, .actor, .protocol]
        #expect(allCases.count == 5)
    }

    @Test("Given a TypeKind instance, when checking conformance, then it is Sendable")
    func isSendable() {
        let kind: TypeKind = .struct
        let sendable: any Sendable = kind

        #expect(sendable is TypeKind)
    }
}
