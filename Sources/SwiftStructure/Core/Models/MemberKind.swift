enum MemberKind: String, Sendable, CaseIterable {
    case storedProperty = "stored property"
    case computedProperty = "computed property"
    case staticProperty = "static property"
    case initializer = "initializer"
    case method = "method"
    case staticMethod = "static method"
    case `subscript` = "subscript"
    case typeAlias = "typealias"
    case nestedType = "nested type"
}
