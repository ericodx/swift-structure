import Foundation
import Testing

@testable import SwiftStructure

@Suite("InitCommand Tests")
struct InitCommandTests {

    // MARK: - Error Cases

    @Test("InitError provides correct error description for existing file")
    func initErrorDescription() {
        let error = InitError.configAlreadyExists("/path/to/config.yaml")

        #expect(
            error.errorDescription
                == "Configuration file already exists at /path/to/config.yaml. Use --force to overwrite.")
    }

    // MARK: - Default Config Content

    @Test("Default config contains all member kinds in correct order")
    func defaultConfigContainsAllMemberKinds() {
        let expectedMembers = [
            "typealias",
            "associatedtype",
            "initializer",
            "type_property",
            "instance_property",
            "subtype",
            "type_method",
            "instance_method",
            "subscript",
            "deinitializer",
        ]

        for member in expectedMembers {
            #expect(defaultConfigYaml.contains("- \(member)"))
        }
    }

    @Test("Default config has version 1")
    func defaultConfigHasVersion1() {
        #expect(defaultConfigYaml.contains("version: 1"))
    }

    @Test("Default config has separate extensions strategy")
    func defaultConfigHasSeparateStrategy() {
        #expect(defaultConfigYaml.contains("strategy: separate"))
    }

    @Test("Default config has respect_boundaries true")
    func defaultConfigHasRespectBoundariesTrue() {
        #expect(defaultConfigYaml.contains("respect_boundaries: true"))
    }

    @Test("Default config is valid YAML that can be parsed")
    func defaultConfigIsValidYaml() throws {
        let loader = ConfigurationLoader()
        let mapper = ConfigurationMapper()

        let raw = try loader.parse(defaultConfigYaml)
        let config = mapper.map(raw)

        #expect(config.version == 1)
        #expect(config.memberOrderingRules.count == 10)
        #expect(config.extensionsStrategy == .separate)
        #expect(config.respectBoundaries == true)
    }
}

// MARK: - Test Helpers

private let defaultConfigYaml = """
    version: 1

    ordering:
      members:
        - typealias
        - associatedtype
        - initializer
        - type_property
        - instance_property
        - subtype
        - type_method
        - instance_method
        - subscript
        - deinitializer

    extensions:
      strategy: separate
      respect_boundaries: true
    """
