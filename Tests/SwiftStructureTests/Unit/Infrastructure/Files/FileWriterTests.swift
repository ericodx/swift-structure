import Foundation
import Testing

@testable import SwiftStructure

@Suite("FileWriter Tests")
struct FileWriterTests {

    let writer = FileWriter()

    @Test("Given content and a file path, when writing with FileWriter, then writes content to file")
    func writesContent() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let filePath = tempDir.appendingPathComponent("test_write.swift").path

        try writer.write("let x = 1", to: filePath)

        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        #expect(content == "let x = 1")

        try FileManager.default.removeItem(atPath: filePath)
    }

    @Test("Given an existing file and new content, when writing with FileWriter, then overwrites existing file")
    func overwritesExisting() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let filePath = tempDir.appendingPathComponent("test_overwrite.swift").path

        try writer.write("original", to: filePath)
        try writer.write("updated", to: filePath)

        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        #expect(content == "updated")

        try FileManager.default.removeItem(atPath: filePath)
    }

    @Test("Given UTF-8 content and a file path, when writing with FileWriter, then preserves UTF-8 encoding")
    func preservesUTF8() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let filePath = tempDir.appendingPathComponent("test_utf8.swift").path
        let unicodeContent = "let emoji = \"🎉\"\nlet japanese = \"日本語\""

        try writer.write(unicodeContent, to: filePath)

        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        #expect(content == unicodeContent)

        try FileManager.default.removeItem(atPath: filePath)
    }

    // MARK: - Error Description Tests

    @Test(
        "Given a WriteError with underlying error, when getting the error description, then the WriteError provides descriptive message with underlying error"
    )
    func writeErrorDescription() {
        let underlyingError = NSError(
            domain: "TestDomain",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Disk full"]
        )
        let error = FileWritingError.writeError("/path/to/file.swift", underlyingError)

        #expect(error.errorDescription == "Failed to write '/path/to/file.swift': Disk full")
    }
}
