import SwiftSyntax

struct SyntaxTypeDeclaration {
    let name: String
    let kind: TypeKind
    let line: Int
    let members: [SyntaxMemberDeclaration]
    let memberBlock: MemberBlockSyntax
}
