import SwiftParser
import SwiftSyntax
import Testing

@testable import SwiftStructure

@Suite("MemberDeclarationBuilder Tests")
struct MemberDeclarationBuilderTests {

    // MARK: - Properties

    let builder = MemberDeclarationBuilder()

    // MARK: - Tests

    @Test("Given member info, when building, then creates MemberDeclaration with correct name")
    func createsWithCorrectName() {
        let (info, converter) = makeMemberDiscoveryInfoWithConverter(name: "testProperty", kind: .instanceProperty)

        let result = builder.build(from: info, using: converter)

        #expect(result.name == "testProperty")
    }

    @Test("Given member info, when building, then creates MemberDeclaration with correct kind")
    func createsWithCorrectKind() {
        let (info, converter) = makeMemberDiscoveryInfoWithConverter(name: "test", kind: .typeMethod)

        let result = builder.build(from: info, using: converter)

        #expect(result.kind == .typeMethod)
    }

    @Test("Given member info, when building, then creates MemberDeclaration with correct visibility")
    func createsWithCorrectVisibility() {
        let (info, converter) = makeMemberDiscoveryInfoWithConverter(
            name: "test", kind: .instanceProperty, visibility: .private)

        let result = builder.build(from: info, using: converter)

        #expect(result.visibility == .private)
    }

    @Test("Given annotated member info, when building, then creates MemberDeclaration with isAnnotated true")
    func createsWithAnnotatedFlag() {
        let (info, converter) = makeMemberDiscoveryInfoWithConverter(
            name: "test", kind: .instanceProperty, isAnnotated: true)

        let result = builder.build(from: info, using: converter)

        #expect(result.isAnnotated == true)
    }

    @Test("Given member info, when building, then creates MemberDeclaration with correct line")
    func createsWithCorrectLine() {
        let (info, converter) = makeMemberDiscoveryInfoWithConverter(name: "test", kind: .instanceProperty)

        let result = builder.build(from: info, using: converter)

        #expect(result.line >= 1)
    }

    @Test("Given public member info, when building, then creates MemberDeclaration with public visibility")
    func createsWithPublicVisibility() {
        let (info, converter) = makeMemberDiscoveryInfoWithConverter(
            name: "test", kind: .instanceMethod, visibility: .public)

        let result = builder.build(from: info, using: converter)

        #expect(result.visibility == .public)
    }

    @Test("Given internal member info, when building, then creates MemberDeclaration with internal visibility")
    func createsWithInternalVisibility() {
        let (info, converter) = makeMemberDiscoveryInfoWithConverter(
            name: "test", kind: .instanceProperty, visibility: .internal)

        let result = builder.build(from: info, using: converter)

        #expect(result.visibility == .internal)
    }
}
