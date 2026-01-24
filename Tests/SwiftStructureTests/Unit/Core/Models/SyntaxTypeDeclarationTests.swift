import SwiftParser
import SwiftSyntax
import Testing

@testable import SwiftStructure

@Suite("SyntaxTypeDeclaration Tests")
struct SyntaxTypeDeclarationTests {

    @Test("Given SyntaxTypeDeclaration, when accessing name, then returns correct name")
    func accessesName() {
        let declaration = makeSyntaxTypeDeclaration(name: "MyStruct", kind: .struct)

        #expect(declaration.name == "MyStruct")
    }

    @Test("Given SyntaxTypeDeclaration, when accessing kind, then returns correct kind")
    func accessesKind() {
        let declaration = makeSyntaxTypeDeclaration(name: "MyClass", kind: .class)

        #expect(declaration.kind == .class)
    }

    @Test("Given SyntaxTypeDeclaration, when accessing line, then returns correct line")
    func accessesLine() {
        let declaration = makeSyntaxTypeDeclaration(name: "Test", kind: .struct, line: 5)

        #expect(declaration.line == 5)
    }

    @Test("Given SyntaxTypeDeclaration with members, when accessing members, then returns all members")
    func accessesMembers() {
        let members = [
            makeSyntaxMember(name: "property"),
            makeSyntaxMember(name: "method"),
        ]
        let declaration = makeSyntaxTypeDeclaration(name: "Test", kind: .struct, members: members)

        #expect(declaration.members.count == 2)
        #expect(declaration.members[0].declaration.name == "property")
        #expect(declaration.members[1].declaration.name == "method")
    }

    @Test("Given SyntaxTypeDeclaration, when accessing memberBlock, then returns MemberBlockSyntax")
    func accessesMemberBlock() {
        let declaration = makeSyntaxTypeDeclaration(name: "Test", kind: .struct)

        #expect(declaration.memberBlock.members.count >= 0)
    }

    @Test("Given SyntaxTypeDeclaration for enum, when checking kind, then is enum")
    func supportsEnum() {
        let declaration = makeSyntaxTypeDeclaration(name: "Status", kind: .enum)

        #expect(declaration.kind == .enum)
    }

    @Test("Given SyntaxTypeDeclaration for actor, when checking kind, then is actor")
    func supportsActor() {
        let declaration = makeSyntaxTypeDeclaration(name: "Worker", kind: .actor)

        #expect(declaration.kind == .actor)
    }

    @Test("Given SyntaxTypeDeclaration for protocol, when checking kind, then is protocol")
    func supportsProtocol() {
        let declaration = makeSyntaxTypeDeclaration(name: "Runnable", kind: .protocol)

        #expect(declaration.kind == .protocol)
    }
}
