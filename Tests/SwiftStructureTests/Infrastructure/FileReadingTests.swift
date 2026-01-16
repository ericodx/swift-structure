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
}
