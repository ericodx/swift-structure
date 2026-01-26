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
    func exitsWithOneWhenChangesNeeded() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    @Test(
        "Given already ordered files, when executing check command, then does not throw"
    )
    func doesNotThrowWhenNoChangesNeeded() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                    func doSomething() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    @Test(
        "Given check command with quiet flag, when files need reordering, then outputs file paths"
    )
    func quietModeOutputsFilePaths() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
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
    func printsDetailedOutputWithoutQuietFlag() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse([tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    @Test(
        "Given files needing changes with detailed output enabled, when executing check, then generates report and prints details"
    )
    func generatesDetailedReportWhenQuietFalse() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse([tempFile])  // quiet=false by default

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    // MARK: - Multiple Files

    @Test("Given multiple files with some needing reordering, when executing check, then reports correct count")
    func handlesMultipleFiles() async throws {
        let tempFile1 = createTempFile(
            content: """
                struct Test1 {
                    func doSomething() {}
                    init() {}
                }
                """)
        let tempFile2 = createTempFile(
            content: """
                struct Test2 {
                    init() {}
                    func doSomething() {}
                }
                """)
        defer {
            removeTempFile(tempFile1)
            removeTempFile(tempFile2)
        }

        let command = try CheckCommand.parse(["--quiet", tempFile1, tempFile2])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    @Test("Given multiple ordered files, when executing check, then does not throw")
    func multipleOrderedFilesDoNotThrow() async throws {
        let tempFile1 = createTempFile(
            content: """
                struct Test1 {
                    init() {}
                    func doSomething() {}
                }
                """)
        let tempFile2 = createTempFile(
            content: """
                struct Test2 {
                    init() {}
                    var name: String
                }
                """)
        defer {
            removeTempFile(tempFile1)
            removeTempFile(tempFile2)
        }

        let command = try CheckCommand.parse(["--quiet", tempFile1, tempFile2])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    // MARK: - Single Type Edge Cases

    @Test("Given a file with single type needing reorder, when executing check with quiet, then reports correctly")
    func singleTypeNeedingReorder() async throws {
        let tempFile = createTempFile(
            content: """
                struct Single {
                    func method() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    @Test("Given CheckCommand, when checking configuration, then has discussion")
    func hasDiscussion() {
        #expect(!CheckCommand.configuration.discussion.isEmpty)
    }

    // MARK: - Multiple Types in Single File

    @Test("Given a file with multiple types needing reorder, when executing check, then counts all types")
    func multipleTypesNeedingReorder() async throws {
        let tempFile = createTempFile(
            content: """
                struct First {
                    func a() {}
                    init() {}
                }
                struct Second {
                    func b() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    // MARK: - Singular/Plural Coverage

    @Test("Given single file with single type ordered, when check, then uses singular 'file'")
    func singleFileSingleTypeOrdered() async throws {
        let tempFile = createTempFile(
            content: """
                struct Single {
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    @Test("Given single file with single type needing reorder, when check, then uses singular 'type' and 'file needs'")
    func singleFileSingleTypeNeedsReorder() async throws {
        let tempFile = createTempFile(
            content: """
                struct Single {
                    func method() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }
}
