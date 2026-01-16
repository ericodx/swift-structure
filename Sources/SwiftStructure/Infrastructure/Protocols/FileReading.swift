import Foundation

protocol FileReading {
    func read(at path: String) throws -> String
}
