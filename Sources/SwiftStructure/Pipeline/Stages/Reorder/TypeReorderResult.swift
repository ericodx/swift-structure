struct TypeReorderResult: Sendable {
    let name: String
    let kind: TypeKind
    let line: Int
    let originalMembers: [MemberDeclaration]
    let reorderedMembers: [MemberDeclaration]

    var needsReordering: Bool {
        originalMembers.map(\.kind) != reorderedMembers.map(\.kind)
    }
}
