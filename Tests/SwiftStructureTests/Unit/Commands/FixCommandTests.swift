import ArgumentParser
import Foundation
import Testing

@testable import SwiftStructure

@Suite("FixCommand Tests")
struct FixCommandTests {

    // MARK: - Exit Code Behavior

    @Test(
        "Given files that need reordering and dry-run mode, when executing fix command, then dry-run throws ExitCode(1) when files need reordering"
    )
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

    @Test(
        "Given already ordered files and dry-run mode, when executing fix command, then dry-run does not throw when files are already ordered"
    )
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

    @Test(
        "Given dry-run mode with files needing changes, when executing fix command, then dry-run does not modify files")
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
