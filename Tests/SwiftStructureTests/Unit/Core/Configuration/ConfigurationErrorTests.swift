import Testing

@testable import SwiftStructure

@Suite("ConfigurationError Tests")
struct ConfigurationErrorTests {

    // MARK: - Error Cases

    @Test("Given invalidYaml error, when checking case, then is invalidYaml")
    func invalidYamlCase() {
        let error = ConfigurationError.invalidYaml("test message")

        if case .invalidYaml(let message) = error {
            #expect(message == "test message")
        } else {
            Issue.record("Expected invalidYaml case")
        }
    }

    @Test("Given invalidMemberKind error, when checking case, then is invalidMemberKind")
    func invalidMemberKindCase() {
        let error = ConfigurationError.invalidMemberKind("unknown_kind")

        if case .invalidMemberKind(let kind) = error {
            #expect(kind == "unknown_kind")
        } else {
            Issue.record("Expected invalidMemberKind case")
        }
    }

    // MARK: - Error Descriptions

    @Test("Given invalidYaml error, when getting description, then includes message")
    func invalidYamlDescription() {
        let error = ConfigurationError.invalidYaml("parsing failed")

        #expect(error.errorDescription?.contains("Invalid YAML") == true)
        #expect(error.errorDescription?.contains("parsing failed") == true)
    }

    @Test("Given invalidMemberKind error, when getting description, then includes kind")
    func invalidMemberKindDescription() {
        let error = ConfigurationError.invalidMemberKind("bad_kind")

        #expect(error.errorDescription?.contains("Invalid member kind") == true)
        #expect(error.errorDescription?.contains("bad_kind") == true)
    }

    // MARK: - Error Protocol Conformance

    @Test("Given ConfigurationError, when used as LocalizedError, then conforms to LocalizedError")
    func conformsToLocalizedError() {
        let error: any Error = ConfigurationError.invalidYaml("test")

        #expect(error.localizedDescription.contains("Invalid YAML"))
    }
}
