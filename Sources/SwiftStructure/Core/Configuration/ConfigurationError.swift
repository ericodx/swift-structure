import Foundation

enum ConfigurationError: Error, LocalizedError {
    case invalidYaml(String)
    case invalidMemberKind(String)

    var errorDescription: String? {
        switch self {
        case .invalidYaml(let message):
            return "Invalid YAML: \(message)"
        case .invalidMemberKind(let kind):
            return "Invalid member kind: '\(kind)'"
        }
    }
}
