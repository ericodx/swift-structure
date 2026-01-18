import Testing

@testable import SwiftStructure

@Suite("TypeKind Tests")
struct TypeKindTests {

    @Test("Raw values match Swift keywords")
    func rawValuesMatchKeywords() {
        #expect(TypeKind.class.rawValue == "class")
        #expect(TypeKind.struct.rawValue == "struct")
        #expect(TypeKind.enum.rawValue == "enum")
        #expect(TypeKind.actor.rawValue == "actor")
        #expect(TypeKind.protocol.rawValue == "protocol")
    }

    @Test("All cases are defined")
    func allCasesDefined() {
        let allCases: [TypeKind] = [.class, .struct, .enum, .actor, .protocol]
        #expect(allCases.count == 5)
    }

    @Test("Is Sendable")
    func isSendable() {
        let kind: TypeKind = .struct
        let sendable: any Sendable = kind

        #expect(sendable is TypeKind)
    }
}
