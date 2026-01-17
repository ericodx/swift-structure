struct TypeDeclaration: Sendable {

    init(name: String, kind: TypeKind, line: Int, members: [MemberDeclaration] = []) {
        self.name = name
        self.kind = kind
        self.line = line
        self.members = members
    }

    let name: String
    let kind: TypeKind
    let line: Int
    let members: [MemberDeclaration]
}
