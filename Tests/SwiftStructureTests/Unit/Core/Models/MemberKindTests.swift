import Testing

@testable import SwiftStructure

@Suite("MemberKind Tests")
struct MemberKindTests {

    // MARK: - Tests

    @Test("Given all MemberKind cases defined, when checking the enum, then all cases are defined")
    func allCasesDefined() {
        let allCases = MemberKind.allCases

        #expect(allCases.count == 10)
        #expect(allCases.contains(.typealias))
        #expect(allCases.contains(.associatedtype))
        #expect(allCases.contains(.initializer))
        #expect(allCases.contains(.typeProperty))
        #expect(allCases.contains(.instanceProperty))
        #expect(allCases.contains(.subtype))
        #expect(allCases.contains(.typeMethod))
        #expect(allCases.contains(.instanceMethod))
        #expect(allCases.contains(.subscript))
        #expect(allCases.contains(.deinitializer))
    }

    @Test("Given MemberKind raw values, when checking the enum, then raw values match structural model")
    func rawValuesMatchModel() {
        #expect(MemberKind.typealias.rawValue == "typealias")
        #expect(MemberKind.associatedtype.rawValue == "associatedtype")
        #expect(MemberKind.initializer.rawValue == "initializer")
        #expect(MemberKind.typeProperty.rawValue == "type_property")
        #expect(MemberKind.instanceProperty.rawValue == "instance_property")
        #expect(MemberKind.subtype.rawValue == "subtype")
        #expect(MemberKind.typeMethod.rawValue == "type_method")
        #expect(MemberKind.instanceMethod.rawValue == "instance_method")
        #expect(MemberKind.subscript.rawValue == "subscript")
        #expect(MemberKind.deinitializer.rawValue == "deinitializer")
    }

    @Test("Given MemberKind, when stored as Sendable, then can be recovered with same value")
    func isSendable() {
        let original = MemberKind.instanceMethod
        let sendable: any Sendable = original

        #expect((sendable as? MemberKind) == original)
    }
}
