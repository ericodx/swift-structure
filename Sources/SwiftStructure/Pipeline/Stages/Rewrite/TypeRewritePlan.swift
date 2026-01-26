struct TypeRewritePlan: Sendable {
    let typeName: String
    let kind: TypeKind
    let line: Int
    let originalMembers: [SyntaxMemberDeclaration]
    let reorderedMembers: [IndexedSyntaxMember]

    var needsRewriting: Bool {
        originalMembers.map(\.declaration.kind) != reorderedMembers.map(\.member.declaration.kind)
    }
}
