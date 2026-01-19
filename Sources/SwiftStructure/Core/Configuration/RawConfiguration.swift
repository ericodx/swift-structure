struct RawConfiguration: Equatable, Sendable {
    let version: Int
    let memberRules: [RawMemberRule]
    let extensionsStrategy: String?
    let respectBoundaries: Bool?
}

enum RawMemberRule: Equatable, Sendable {
    case simple(String)
    case property(annotated: Bool?, visibility: String?)
    case method(kind: String?, visibility: String?, annotated: Bool?)
}
