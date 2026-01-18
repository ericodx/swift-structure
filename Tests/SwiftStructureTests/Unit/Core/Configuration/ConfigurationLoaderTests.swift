import Testing

@testable import SwiftStructure

@Suite("ConfigurationLoader Tests")
struct ConfigurationLoaderTests {

    let loader = ConfigurationLoader()

    // MARK: - Version Parsing

    @Test("Parses version from YAML")
    func parsesVersion() throws {
        let yaml = "version: 2"
        let raw = try loader.parse(yaml)

        #expect(raw.version == 2)
    }

    @Test("Defaults to version 1 when not specified")
    func defaultsToVersion1() throws {
        let yaml = ""
        let raw = try loader.parse(yaml)

        #expect(raw.version == 1)
    }

    // MARK: - Simple Member Rules

    @Test("Parses simple member kind as string")
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

    @Test("Parses multiple simple member kinds")
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

    @Test("Parses property with annotated filter")
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

    @Test("Parses property with visibility filter")
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

    @Test("Parses property with both filters")
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

    @Test("Parses method with kind filter")
    func parsesMethodKind() throws {
        let yaml = """
            ordering:
              members:
                - method:
                    kind: static
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.count == 1)
        #expect(raw.memberRules[0] == .method(kind: "static", visibility: nil))
    }

    @Test("Parses method with visibility filter")
    func parsesMethodVisibility() throws {
        let yaml = """
            ordering:
              members:
                - method:
                    visibility: public
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.count == 1)
        #expect(raw.memberRules[0] == .method(kind: nil, visibility: "public"))
    }

    @Test("Parses method with both filters")
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
        #expect(raw.memberRules[0] == .method(kind: "instance", visibility: "private"))
    }

    // MARK: - Extensions Configuration

    @Test("Parses extensions strategy")
    func parsesExtensionsStrategy() throws {
        let yaml = """
            extensions:
              strategy: merge
            """
        let raw = try loader.parse(yaml)

        #expect(raw.extensionsStrategy == "merge")
    }

    @Test("Parses respect_boundaries")
    func parsesRespectBoundaries() throws {
        let yaml = """
            extensions:
              respect_boundaries: false
            """
        let raw = try loader.parse(yaml)

        #expect(raw.respectBoundaries == false)
    }

    @Test("Returns nil for missing extensions config")
    func returnsNilForMissingExtensions() throws {
        let yaml = "version: 1"
        let raw = try loader.parse(yaml)

        #expect(raw.extensionsStrategy == nil)
        #expect(raw.respectBoundaries == nil)
    }

    // MARK: - Empty/Missing Cases

    @Test("Returns empty rules for missing ordering section")
    func returnsEmptyRulesForMissingOrdering() throws {
        let yaml = "version: 1"
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.isEmpty)
    }

    @Test("Returns empty rules for empty members array")
    func returnsEmptyRulesForEmptyMembers() throws {
        let yaml = """
            ordering:
              members: []
            """
        let raw = try loader.parse(yaml)

        #expect(raw.memberRules.isEmpty)
    }

    // MARK: - Mixed Configuration

    @Test("Parses full complex configuration")
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
        #expect(raw.memberRules[2] == .method(kind: "static", visibility: "public"))
        #expect(raw.extensionsStrategy == "separate")
        #expect(raw.respectBoundaries == true)
    }
}
