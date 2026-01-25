import Testing

@testable import SwiftStructure

@Suite("ConfigurationLoader Tests")
struct ConfigurationLoaderTests {

    let loader = ConfigurationLoader()

    // MARK: - Version Parsing

    @Test("Given a valid configuration file with a version, when parsing the YAML, then extracts the version")
    func parsesVersion() throws {
        let yaml = "version: 2"
        let raw = try loader.parse(yaml)

        #expect(raw.version == 2)
    }

    @Test("Given a configuration file without a version, when parsing the YAML, then defaults to version 1")
    func defaultsToVersion1() throws {
        let yaml = ""
        let raw = try loader.parse(yaml)

        #expect(raw.version == 1)
    }

    // MARK: - Simple Member Rules

    @Test(
        "Given a configuration with simple member kinds as strings, when parsing the YAML, then parses the simple member kind as string"
    )
    func parsesSimpleMemberKind() throws {
        let yaml = """
            ordering:
              members:
                - initializer
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.count == 1)
        #expect(raw.memberRules[0] == .simple("initializer"))
    }

    @Test(
        "Given a configuration with multiple simple member kinds, when parsing the YAML, then parses multiple simple member kinds"
    )
    func parsesMultipleSimpleKinds() throws {
        let yaml = """
            ordering:
              members:
                - typealias
                - initializer
                - instance_method
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.count == 3)
        #expect(raw.memberRules[0] == .simple("typealias"))
        #expect(raw.memberRules[1] == .simple("initializer"))
        #expect(raw.memberRules[2] == .simple("instance_method"))
    }

    // MARK: - Property Rules

    @Test(
        "Given a configuration with a property rule, when parsing the YAML, then parses property with annotated filter")
    func parsesPropertyAnnotated() throws {
        let yaml = """
            ordering:
              members:
                - property:
                    annotated: true
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.count == 1)
        #expect(raw.memberRules[0] == .property(annotated: true, visibility: nil))
    }

    @Test(
        "Given a configuration with a property rule requiring annotation, when parsing the YAML, then parses property with visibility filter"
    )
    func parsesPropertyVisibility() throws {
        let yaml = """
            ordering:
              members:
                - property:
                    visibility: public
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.count == 1)
        #expect(raw.memberRules[0] == .property(annotated: nil, visibility: "public"))
    }

    @Test(
        "Given a configuration with a property rule with both filters, when parsing the YAML, then parses property with both filters"
    )
    func parsesPropertyBothFilters() throws {
        let yaml = """
            ordering:
              members:
                - property:
                    annotated: false
                    visibility: private
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.count == 1)
        #expect(raw.memberRules[0] == .property(annotated: false, visibility: "private"))
    }

    // MARK: - Method Rules

    @Test("Given a configuration with a method rule, when parsing the YAML, then parses method with kind filter")
    func parsesMethodKind() throws {
        let yaml = """
            ordering:
              members:
                - method:
                    kind: static
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.count == 1)
        #expect(raw.memberRules[0] == .method(kind: "static", visibility: nil, annotated: nil))
    }

    @Test("Given a configuration with a method rule, when parsing the YAML, then parses method with visibility filter")
    func parsesMethodVisibility() throws {
        let yaml = """
            ordering:
              members:
                - method:
                    visibility: public
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.count == 1)
        #expect(raw.memberRules[0] == .method(kind: nil, visibility: "public", annotated: nil))
    }

    @Test(
        "Given a configuration with a method rule with both filters, when parsing the YAML, then parses method with both filters"
    )
    func parsesMethodBothFilters() throws {
        let yaml = """
            ordering:
              members:
                - method:
                    kind: instance
                    visibility: private
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.count == 1)
        #expect(raw.memberRules[0] == .method(kind: "instance", visibility: "private", annotated: nil))
    }

    // MARK: - Extensions Configuration

    @Test("Given a configuration with extensions section, when parsing the YAML, then parses extensions strategy")
    func parsesExtensionsStrategy() throws {
        let yaml = """
            extensions:
              strategy: merge
            """
        let raw = try loader.parse(yaml)

        #expect(raw.extensionsStrategy == "merge")
    }

    @Test("Given a configuration with extensions section, when parsing the YAML, then parses respect_boundaries")
    func parsesRespectBoundaries() throws {
        let yaml = """
            extensions:
              respect_boundaries: false
            """
        let raw = try loader.parse(yaml)

        #expect(raw.respectBoundaries == false)
    }

    @Test(
        "Given a configuration without extensions section, when parsing the YAML, then returns nil for missing extensions config"
    )
    func returnsNilForMissingExtensions() throws {
        let yaml = "version: 1"
        let raw = try loader.parse(yaml)

        #expect(raw.extensionsStrategy == nil)
        #expect(raw.respectBoundaries == nil)
    }

    // MARK: - Empty/Missing Cases

    @Test(
        "Given a configuration without ordering section, when parsing the YAML, then returns empty rules for missing ordering section"
    )
    func returnsEmptyRulesForMissingOrdering() throws {
        let yaml = "version: 1"
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.isEmpty)
    }

    @Test(
        "Given a configuration with empty members array, when parsing the YAML, then returns empty rules for empty members array"
    )
    func returnsEmptyRulesForEmptyMembers() throws {
        let yaml = """
            ordering:
              members: []
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.isEmpty)
    }

    // MARK: - Invalid Rule Cases

    @Test(
        "Given a configuration with an unknown dictionary key, when parsing the YAML, then ignores invalid rule entries"
    )
    func ignoresInvalidRuleEntries() throws {
        let yaml = """
            ordering:
              members:
                - initializer
                - unknown_key:
                    some_value: true
                - instance_method
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.count == 2)
        #expect(raw.memberRules[0] == .simple("initializer"))
        #expect(raw.memberRules[1] == .simple("instance_method"))
    }

    @Test(
        "Given a configuration with method annotated filter, when parsing the YAML, then parses method with annotated filter"
    )
    func parsesMethodAnnotated() throws {
        let yaml = """
            ordering:
              members:
                - method:
                    annotated: true
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.count == 1)
        #expect(raw.memberRules[0] == .method(kind: nil, visibility: nil, annotated: true))
    }

    @Test(
        "Given a configuration with method having all filters, when parsing the YAML, then parses method with all three filters"
    )
    func parsesMethodAllFilters() throws {
        let yaml = """
            ordering:
              members:
                - method:
                    kind: static
                    visibility: public
                    annotated: false
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.count == 1)
        #expect(raw.memberRules[0] == .method(kind: "static", visibility: "public", annotated: false))
    }

    @Test(
        "Given a configuration with ordering but no members key, when parsing the YAML, then returns empty rules"
    )
    func returnsEmptyRulesForMissingMembersKey() throws {
        let yaml = """
            ordering:
              something_else: value
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.isEmpty)
    }

    // MARK: - Mixed Configuration

    @Test(
        "Given a complex configuration with all sections, when parsing the YAML, then parses full complex configuration"
    )
    func parsesFullConfiguration() throws {
        let yaml = """
            version: 1
            ordering:
              members:
                - typealias
                - property:
                    annotated: true
                - method:
                    kind: static
                    visibility: public
            extensions:
              strategy: separate
              respect_boundaries: true
            """
        let raw = try loader.parse(yaml)

        #expect(raw.version == 1)
        #expect(raw.memberRules.count == 3)
        #expect(raw.memberRules[0] == .simple("typealias"))
        #expect(raw.memberRules[1] == .property(annotated: true, visibility: nil))
        #expect(raw.memberRules[2] == .method(kind: "static", visibility: "public", annotated: nil))
        #expect(raw.extensionsStrategy == "separate")
        #expect(raw.respectBoundaries == true)
    }
}
