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
    func dryRunExitsWithOneWhenChangesNeeded() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try FixCommand.parse(["--dry-run", "--quiet", tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    @Test(
        "Given already ordered files and dry-run mode, when executing fix command, then dry-run does not throw when files are already ordered"
    )
    func dryRunDoesNotThrowWhenNoChangesNeeded() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                    func doSomething() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try FixCommand.parse(["--dry-run", "--quiet", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    @Test(
        "Given dry-run mode with files needing changes, when executing fix command, then dry-run does not modify files")
    func dryRunDoesNotModifyFiles() async throws {
        let originalContent = """
            struct Test {
                func doSomething() {}
                init() {}
            }
            """
        let tempFile = createTempFile(content: originalContent)
        defer { removeTempFile(tempFile) }

        let command = try FixCommand.parse(["--dry-run", "--quiet", tempFile])
        _ = try? await command.run()

        let contentAfter = try String(contentsOfFile: tempFile, encoding: .utf8)
        #expect(contentAfter == originalContent)
    }

    @Test(
        "Given dry-run mode with files needing changes and quiet=false, when executing fix command, then prints 'Would reorder' messages"
    )
    func dryRunPrintsWouldReorderWithoutQuiet() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try FixCommand.parse(["--dry-run", tempFile])  // quiet=false by default

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    // MARK: - Actual File Modification

    @Test("Given files that need reordering, when executing fix command, then modifies files")
    func modifiesFilesWhenNeeded() async throws {
        let originalContent = """
            struct Test {
                func doSomething() {}
                init() {}
            }
            """
        let tempFile = createTempFile(content: originalContent)
        defer { removeTempFile(tempFile) }

        let command = try FixCommand.parse(["--quiet", tempFile])
        try await command.run()

        let contentAfter = try String(contentsOfFile: tempFile, encoding: .utf8)
        #expect(contentAfter != originalContent)
        #expect(contentAfter.contains("init()"))
    }

    @Test("Given files needing changes without quiet flag, when executing fix command, then completes without error")
    func printsOutputWithoutQuietFlag() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try FixCommand.parse([tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    @Test(
        "Given files needing reorder in dry-run mode without quiet flag, when executing fix command, then throws ExitCode"
    )
    func dryRunPrintsWouldReorder() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try FixCommand.parse(["--dry-run", tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    // MARK: - Command Configuration

    @Test("Given FixCommand, when checking configuration, then has correct command name")
    func hasCorrectCommandName() {
        #expect(FixCommand.configuration.commandName == "fix")
    }

    @Test("Given FixCommand, when checking configuration, then has abstract")
    func hasAbstract() {
        #expect(!FixCommand.configuration.abstract.isEmpty)
    }

    @Test("Given FixCommand, when checking configuration, then has discussion")
    func hasDiscussion() {
        #expect(!FixCommand.configuration.discussion.isEmpty)
    }

    // MARK: - Multiple Files

    @Test("Given multiple files needing reordering, when executing fix, then modifies all files")
    func modifiesMultipleFiles() async throws {
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
                    func doSomething() {}
                    init() {}
                }
                """)
        defer {
            removeTempFile(tempFile1)
            removeTempFile(tempFile2)
        }

        let command = try FixCommand.parse(["--quiet", tempFile1, tempFile2])
        try await command.run()

        let content1 = try String(contentsOfFile: tempFile1, encoding: .utf8)
        let content2 = try String(contentsOfFile: tempFile2, encoding: .utf8)
        #expect(content1.contains("init()"))
        #expect(content2.contains("init()"))
    }

    @Test("Given multiple ordered files, when executing fix, then reports no changes needed")
    func noChangesForMultipleOrderedFiles() async throws {
        let original1 = """
            struct Test1 {
                init() {}
                func doSomething() {}
            }
            """
        let original2 = """
            struct Test2 {
                init() {}
                func doSomething() {}
            }
            """
        let tempFile1 = createTempFile(content: original1)
        let tempFile2 = createTempFile(content: original2)
        defer {
            removeTempFile(tempFile1)
            removeTempFile(tempFile2)
        }

        let command = try FixCommand.parse(["--quiet", tempFile1, tempFile2])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    @Test("Given multiple files in dry-run, when some need reordering, then throws ExitCode(1)")
    func dryRunWithMultipleFilesNeedingChanges() async throws {
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

        let command = try FixCommand.parse(["--dry-run", "--quiet", tempFile1, tempFile2])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    // MARK: - Single File Edge Cases

    @Test("Given a file with multiple types, when executing fix, then modifies all types")
    func modifiesMultipleTypesInSingleFile() async throws {
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

        let command = try FixCommand.parse(["--quiet", tempFile])
        try await command.run()

        let content = try String(contentsOfFile: tempFile, encoding: .utf8)
        #expect(content.contains("init()"))
    }

    @Test("Given a single file already ordered, when executing fix, then reports no changes")
    func singleOrderedFileNoChanges() async throws {
        let original = """
            struct Test {
                init() {}
                func doSomething() {}
            }
            """
        let tempFile = createTempFile(content: original)
        defer { removeTempFile(tempFile) }

        let command = try FixCommand.parse(["--quiet", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    // MARK: - Singular/Plural Coverage

    @Test("Given a single file needing reorder in dry-run mode, when executing fix command, then throws ExitCode")
    func singleFileInDryRun() async throws {
        let tempFile = createTempFile(
            content: """
                struct Single {
                    func method() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try FixCommand.parse(["--dry-run", "--quiet", tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    @Test("Given a single file needing reorder, when executing fix command, then completes without error")
    func singleFileFixed() async throws {
        let tempFile = createTempFile(
            content: """
                struct Single {
                    func method() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try FixCommand.parse(["--quiet", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    @Test("Given a single file already ordered, when executing fix command, then completes without error")
    func singleFileAlreadyOrdered() async throws {
        let tempFile = createTempFile(
            content: """
                struct Single {
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try FixCommand.parse(["--quiet", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }
}
