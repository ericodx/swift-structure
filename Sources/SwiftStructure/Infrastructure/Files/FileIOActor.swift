import Foundation

actor FileIOActor {

    // MARK: - Read

    func read(at path: String) throws -> String {
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

    // MARK: - Write

    func write(_ content: String, to path: String) throws {
        let url = URL(fileURLWithPath: path)

        do {
            try content.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            throw FileWritingError.writeError(path, error)
        }
    }
}
