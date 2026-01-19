import Foundation

enum FileWritingError: Error, LocalizedError {
    case writeError(String, Error)

    var errorDescription: String? {
        switch self {
        case .writeError(let path, let underlyingError):
            return "Failed to write '\(path)': \(underlyingError.localizedDescription)"
        }
    }
}
