import ArgumentParser
import Foundation
import Testing

@testable import SwiftStructure

@Suite("FixCommand Tests")
struct FixCommandTests {

    // MARK: - Exit Code Behavior

    @Test("Dry-run throws ExitCode(1) when files need reordering")
    func dryRunExitsWithOneWhenChangesNeeded() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try FixCommand.parse(["--dry-run", "--quiet", tempFile])

        #expect(throws: ExitCode.self) {
            try command.run()
        }
    }

    @Test("Dry-run does not throw when files are already ordered")
    func dryRunDoesNotThrowWhenNoChangesNeeded() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                    func doSomething() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try FixCommand.parse(["--dry-run", "--quiet", tempFile])

        #expect(throws: Never.self) {
            try command.run()
        }
    }

    @Test("Dry-run does not modify files")
    func dryRunDoesNotModifyFiles() throws {
        let originalContent = """
            struct Test {
                func doSomething() {}
                init() {}
            }
            """
        let tempFile = createTempFile(content: originalContent)
        defer { removeTempFile(tempFile) }

        let command = try FixCommand.parse(["--dry-run", "--quiet", tempFile])
        _ = try? command.run()

        let contentAfter = try String(contentsOfFile: tempFile, encoding: .utf8)
        #expect(contentAfter == originalContent)
    }
}
