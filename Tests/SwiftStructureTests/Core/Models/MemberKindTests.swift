import Testing

@testable import SwiftStructure

@Suite("MemberKind Tests")
struct MemberKindTests {

    @Test("All cases are defined")
    func allCasesDefined() {
        let allCases = MemberKind.allCases

        #expect(allCases.count == 9)
        #expect(allCases.contains(.storedProperty))
        #expect(allCases.contains(.computedProperty))
        #expect(allCases.contains(.staticProperty))
        #expect(allCases.contains(.initializer))
        #expect(allCases.contains(.method))
        #expect(allCases.contains(.staticMethod))
        #expect(allCases.contains(.subscript))
        #expect(allCases.contains(.typeAlias))
        #expect(allCases.contains(.nestedType))
    }

    @Test("Raw values are human readable")
    func rawValuesReadable() {
        #expect(MemberKind.storedProperty.rawValue == "stored property")
        #expect(MemberKind.computedProperty.rawValue == "computed property")
        #expect(MemberKind.staticProperty.rawValue == "static property")
        #expect(MemberKind.initializer.rawValue == "initializer")
        #expect(MemberKind.method.rawValue == "method")
        #expect(MemberKind.staticMethod.rawValue == "static method")
        #expect(MemberKind.subscript.rawValue == "subscript")
        #expect(MemberKind.typeAlias.rawValue == "typealias")
        #expect(MemberKind.nestedType.rawValue == "nested type")
    }

    @Test("Is Sendable")
    func isSendable() {
        let kind = MemberKind.method
        let sendable: any Sendable = kind

        #expect(sendable is MemberKind)
    }
}
