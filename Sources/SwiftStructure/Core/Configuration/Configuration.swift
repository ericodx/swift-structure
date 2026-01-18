struct Configuration: Equatable, Sendable {

    static let `default` = Configuration(
        version: 1,
        memberOrderingRules: MemberKind.allCases.map { .simple($0) },
        extensionsStrategy: .separate,
        respectBoundaries: true
    )

    let version: Int
    let memberOrderingRules: [MemberOrderingRule]
    let extensionsStrategy: ExtensionsStrategy
    let respectBoundaries: Bool
}
