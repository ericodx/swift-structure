struct ReorderEngine {

    func reorder(_ members: [MemberDeclaration]) -> [MemberDeclaration] {
        let ordering = MemberKind.allCases
        return members.sorted { lhs, rhs in
            let lhsIndex = ordering.firstIndex(of: lhs.kind) ?? 0
            let rhsIndex = ordering.firstIndex(of: rhs.kind) ?? 0
            return lhsIndex < rhsIndex
        }
    }
}
