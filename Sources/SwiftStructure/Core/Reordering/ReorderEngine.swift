struct ReorderEngine {

    init(rules: [MemberOrderingRule] = MemberKind.allCases.map { .simple($0) }) {
        self.rules = rules
    }

    init(configuration: Configuration) {
        self.rules = configuration.memberOrderingRules
    }

    private let rules: [MemberOrderingRule]

    func reorder(_ members: [MemberDeclaration]) -> [MemberDeclaration] {
        members.sorted { lhs, rhs in
            let lhsIndex = ruleIndex(for: lhs)
            let rhsIndex = ruleIndex(for: rhs)
            return lhsIndex < rhsIndex
        }
    }

    private func ruleIndex(for member: MemberDeclaration) -> Int {
        for (index, rule) in rules.enumerated() where rule.matches(member) {
            return index
        }
        return rules.count
    }
}
