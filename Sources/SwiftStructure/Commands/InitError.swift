import Foundation

enum InitError: Error, LocalizedError {
    case configAlreadyExists(String)

    var errorDescription: String? {
        switch self {
        case .configAlreadyExists(let path):
            return "Configuration file already exists at \(path). Use --force to overwrite."
        }
    }
}
