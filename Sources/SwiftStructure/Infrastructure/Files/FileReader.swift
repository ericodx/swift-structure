import Foundation

struct FileReader: FileReading {

    // MARK: - FileReading

    func read(at path: String) async throws -> String {
        let url = URL(fileURLWithPath: path)

        guard FileManager.default.fileExists(atPath: path) else {
            throw FileReadingError.fileNotFound(path)
        }

        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch {
            throw FileReadingError.readError(path, error)
        }
    }
}
