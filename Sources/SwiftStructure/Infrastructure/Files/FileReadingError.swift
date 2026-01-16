import Foundation

enum FileReadingError: Error {
    case fileNotFound(String)
    case readError(String, Error)
}
