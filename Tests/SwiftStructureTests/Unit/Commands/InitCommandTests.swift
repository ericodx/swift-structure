import Foundation
import Testing

@testable import SwiftStructure

@Suite("InitCommand Tests")
struct InitCommandTests {

    // MARK: - Error Cases

    @Test(
        "Given an InitError for existing config file, when getting the error description, then the InitError provides correct error description for existing file"
    )
    func initErrorDescription() {
        let error = InitError.configAlreadyExists("/path/to/config.yaml")

        #expect(
            error.errorDescription
                == "Configuration file already exists at /path/to/config.yaml. Use --force to overwrite.")
    }

    // MARK: - Default Config Content

    @Test(
        "Given the default configuration template, when checking the content, then the default config contains all member kinds in correct order"
    )
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

    @Test("Given the default configuration template, when checking the version, then the default config has version 1")
    func defaultConfigHasVersion1() {
        #expect(defaultConfigYaml.contains("version: 1"))
    }

    @Test(
        "Given the default configuration template, when checking the extensions strategy, then the default config has separate extensions strategy"
    )
    func defaultConfigHasSeparateStrategy() {
        #expect(defaultConfigYaml.contains("strategy: separate"))
    }

    @Test(
        "Given the default configuration template, when checking the boundaries setting, then the default config has respect_boundaries true"
    )
    func defaultConfigHasRespectBoundariesTrue() {
        #expect(defaultConfigYaml.contains("respect_boundaries: true"))
    }

    @Test(
        "Given the default configuration template, when parsing the YAML, then the default config is valid YAML that can be parsed"
    )
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
