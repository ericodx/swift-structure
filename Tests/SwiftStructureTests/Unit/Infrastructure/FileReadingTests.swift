import Foundation
import Testing

@testable import SwiftStructure

@Suite("FileReading Tests")
struct FileReadingTests {

    @Test("Reads existing file")
    func readsExistingFile() throws {
        let tempFile = createTempFile(content: "Hello, World!")
        defer { removeTempFile(tempFile) }

        let reader = FileReader()
        let content = try reader.read(at: tempFile)

        #expect(content == "Hello, World!")
    }

    @Test("Throws fileNotFound for missing file")
    func throwsFileNotFound() {
        let reader = FileReader()

        #expect(throws: FileReadingError.self) {
            try reader.read(at: "/nonexistent/path/file.swift")
        }
    }

    @Test("Reads Swift source file")
    func readsSwiftSource() throws {
        let source = """
            struct Test {
                let value: Int
            }
            """
        let tempFile = createTempFile(content: source)
        defer { removeTempFile(tempFile) }

        let reader = FileReader()
        let content = try reader.read(at: tempFile)

        #expect(content.contains("struct Test"))
        #expect(content.contains("let value: Int"))
    }

    @Test("Reads empty file")
    func readsEmptyFile() throws {
        let tempFile = createTempFile(content: "")
        defer { removeTempFile(tempFile) }

        let reader = FileReader()
        let content = try reader.read(at: tempFile)

        #expect(content.isEmpty)
    }

    @Test("Reads UTF-8 content")
    func readsUtf8Content() throws {
        let content = "// ã, é, çã"
        let tempFile = createTempFile(content: content)
        defer { removeTempFile(tempFile) }

        let reader = FileReader()
        let result = try reader.read(at: tempFile)

        #expect(result == content)
    }

    // MARK: - Error Description Tests

    @Test("FileNotFound error provides descriptive message")
    func fileNotFoundErrorDescription() {
        let error = FileReadingError.fileNotFound("/path/to/missing.swift")

        #expect(error.errorDescription == "File not found: /path/to/missing.swift")
    }

    @Test("ReadError provides descriptive message with underlying error")
    func readErrorDescription() {
        let underlyingError = NSError(
            domain: "TestDomain",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Permission denied"]
        )
        let error = FileReadingError.readError("/path/to/file.swift", underlyingError)

        #expect(error.errorDescription == "Failed to read '/path/to/file.swift': Permission denied")
    }
}
