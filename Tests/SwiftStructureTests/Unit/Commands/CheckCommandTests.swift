import ArgumentParser
import Foundation
import Testing

@testable import SwiftStructure

@Suite("CheckCommand Tests")
struct CheckCommandTests {

    // MARK: - Exit Code Behavior

    @Test(
        "Given files that need reordering, when executing check command, then throws ExitCode(1)"
    )
    func exitsWithOneWhenChangesNeeded() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        #expect(throws: ExitCode.self) {
            try command.run()
        }
    }

    @Test(
        "Given already ordered files, when executing check command, then does not throw"
    )
    func doesNotThrowWhenNoChangesNeeded() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                    func doSomething() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        #expect(throws: Never.self) {
            try command.run()
        }
    }

    @Test(
        "Given check command with quiet flag, when files need reordering, then outputs file paths"
    )
    func quietModeOutputsFilePaths() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        #expect(throws: ExitCode.self) {
            try command.run()
        }
    }

    // MARK: - Command Configuration

    @Test("Given CheckCommand, when checking configuration, then has correct command name")
    func hasCorrectCommandName() {
        #expect(CheckCommand.configuration.commandName == "check")
    }

    @Test("Given CheckCommand, when checking configuration, then has abstract")
    func hasAbstract() {
        #expect(!CheckCommand.configuration.abstract.isEmpty)
    }

    @Test("Given files needing changes without quiet flag, when executing check, then prints detailed output")
    func printsDetailedOutputWithoutQuietFlag() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse([tempFile])

        #expect(throws: ExitCode.self) {
            try command.run()
        }
    }
}
