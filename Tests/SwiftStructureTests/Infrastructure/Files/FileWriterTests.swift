import Foundation
import Testing

@testable import SwiftStructure

@Suite("FileWriter Tests")
struct FileWriterTests {

    let writer = FileWriter()

    @Test("Writes content to file")
    func writesContent() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let filePath = tempDir.appendingPathComponent("test_write.swift").path

        try writer.write("let x = 1", to: filePath)

        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        #expect(content == "let x = 1")

        try FileManager.default.removeItem(atPath: filePath)
    }

    @Test("Overwrites existing file")
    func overwritesExisting() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let filePath = tempDir.appendingPathComponent("test_overwrite.swift").path

        try writer.write("original", to: filePath)
        try writer.write("updated", to: filePath)

        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        #expect(content == "updated")

        try FileManager.default.removeItem(atPath: filePath)
    }

    @Test("Preserves UTF-8 encoding")
    func preservesUTF8() throws {
        let tempDir = FileManager.default.temporaryDirectory
        let filePath = tempDir.appendingPathComponent("test_utf8.swift").path
        let unicodeContent = "let emoji = \"🎉\"\nlet japanese = \"日本語\""

        try writer.write(unicodeContent, to: filePath)

        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        #expect(content == unicodeContent)

        try FileManager.default.removeItem(atPath: filePath)
    }
}
