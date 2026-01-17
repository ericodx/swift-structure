import Foundation

enum FileWritingError: Error {
    case writeError(String, Error)
}
