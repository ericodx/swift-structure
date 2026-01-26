import Foundation
import Testing

@testable import SwiftStructure

// MARK: - Diff Generation

func generateDiff(expected: String, actual: String) -> String {
    let expectedLines = expected.components(separatedBy: "\n")
    let actualLines = actual.components(separatedBy: "\n")

    var diff = ""
    let maxLines = max(expectedLines.count, actualLines.count)

    for lineIndex in 0 ..< maxLines {
        let expectedLine = lineIndex < expectedLines.count ? expectedLines[lineIndex] : "<missing>"
        let actualLine = lineIndex < actualLines.count ? actualLines[lineIndex] : "<missing>"

        if expectedLine != actualLine {
            diff += "Line \(lineIndex + 1):\n"
            diff += "  - Expected: \(expectedLine)\n"
            diff += "  + Actual:   \(actualLine)\n"
        }
    }

    return diff.isEmpty ? "Files differ but no line-by-line diff found" : diff
}

func assertSnapshotMatch(
    fixture fixtureContent: String,
    expected expectedContent: String,
    filename: String,
    sourceLocation: SourceLocation = #_sourceLocation
) throws {
    let actualOutput = try applyRewrite(to: fixtureContent)

    if actualOutput != expectedContent {
        let diff = generateDiff(expected: expectedContent, actual: actualOutput)
        Issue.record(
            "Snapshot mismatch for \(filename):\n\(diff)",
            sourceLocation: sourceLocation
        )
    }
}
