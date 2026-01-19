struct TypeRewritePlan {
    let typeName: String
    let kind: TypeKind
    let line: Int
    let originalMembers: [SyntaxMemberDeclaration]
    let reorderedMembers: [SyntaxMemberDeclaration]

    var needsRewriting: Bool {
        originalMembers.map(\.declaration.kind) != reorderedMembers.map(\.declaration.kind)
    }
}
