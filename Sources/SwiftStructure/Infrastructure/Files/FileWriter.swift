import Foundation

struct FileWriter: FileWriting {

    func write(_ content: String, to path: String) throws {
        let url = URL(fileURLWithPath: path)

        do {
            try content.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            throw FileWritingError.writeError(path, error)
        }
    }
}
