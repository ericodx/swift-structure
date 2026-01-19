import Foundation
import Testing

@testable import SwiftStructure

@Suite("Snapshot Tests")
struct SnapshotTests {

    private let fixturesDirectory: URL
    private let expectedDirectory: URL

    init() throws {
        let testFile = URL(fileURLWithPath: #filePath)
        let snapshotsDir = testFile.deletingLastPathComponent()
        fixturesDirectory = snapshotsDir.appendingPathComponent("Fixtures")
        expectedDirectory = snapshotsDir.appendingPathComponent("Expected")
    }

    @Test("SimpleStruct snapshot")
    func simpleStruct() throws {
        try assertSnapshot(for: "SimpleStruct.txt")
    }

    @Test("ClassWithProperties snapshot")
    func classWithProperties() throws {
        try assertSnapshot(for: "ClassWithProperties.txt")
    }

    @Test("MultipleTypes snapshot")
    func multipleTypes() throws {
        try assertSnapshot(for: "MultipleTypes.txt")
    }

    @Test("NestedTypes snapshot")
    func nestedTypes() throws {
        try assertSnapshot(for: "NestedTypes.txt")
    }

    @Test("CommentsPreserved snapshot")
    func commentsPreserved() throws {
        try assertSnapshot(for: "CommentsPreserved.txt")
    }

    @Test("AlreadyOrdered snapshot")
    func alreadyOrdered() throws {
        try assertSnapshot(for: "AlreadyOrdered.txt")
    }

    @Test("AnnotatedMembers snapshot")
    func annotatedMembers() throws {
        try assertSnapshot(for: "AnnotatedMembers.txt")
    }

    // MARK: - Helpers

    private func assertSnapshot(
        for filename: String,
        sourceLocation: SourceLocation = #_sourceLocation
    ) throws {
        let fixturePath = fixturesDirectory.appendingPathComponent(filename).path
        let expectedPath = expectedDirectory.appendingPathComponent(filename).path

        let fixtureContent = try String(contentsOfFile: fixturePath, encoding: .utf8)
        let expectedContent = try String(contentsOfFile: expectedPath, encoding: .utf8)

        try assertSnapshotMatch(
            fixture: fixtureContent,
            expected: expectedContent,
            filename: filename,
            sourceLocation: sourceLocation
        )
    }
}
