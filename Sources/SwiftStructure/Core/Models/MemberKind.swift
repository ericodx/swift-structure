enum MemberKind: String, Sendable, CaseIterable {
    case `typealias` = "typealias"
    case `associatedtype` = "associatedtype"
    case initializer = "initializer"
    case typeProperty = "type_property"
    case instanceProperty = "instance_property"
    case subtype = "subtype"
    case typeMethod = "type_method"
    case instanceMethod = "instance_method"
    case `subscript` = "subscript"
    case deinitializer = "deinitializer"
}
