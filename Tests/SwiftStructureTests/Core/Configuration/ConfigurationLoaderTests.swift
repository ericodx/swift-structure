// swiftlint:disable type_body_length
import Foundation
import Testing

@testable import SwiftStructure

@Suite("ConfigurationLoader Tests")
struct ConfigurationLoaderTests {

    let loader = ConfigurationLoader()

    // MARK: - Version Parsing

    @Test("Parses version from config")
    func parsesVersion() throws {
        let yaml = """
            version: 2
            ordering:
              members:
                - initializer
            """
        let config = try loader.parse(yaml)

        #expect(config.version == 2)
    }

    @Test("Defaults to version 1 when not specified")
    func defaultsToVersion1() throws {
        let yaml = """
            ordering:
              members:
                - initializer
            """
        let config = try loader.parse(yaml)

        #expect(config.version == 1)
    }

    // MARK: - Simple Member Ordering

    @Test("Parses simple member kinds")
    func parsesSimpleMemberKinds() throws {
        let yaml = """
            ordering:
              members:
                - typealias
                - initializer
                - instance_property
                - instance_method
            """
        let config = try loader.parse(yaml)

        #expect(config.memberOrderingRules.count == 4)
        #expect(config.memberOrderingRules[0] == .simple(.typealias))
        #expect(config.memberOrderingRules[1] == .simple(.initializer))
        #expect(config.memberOrderingRules[2] == .simple(.instanceProperty))
        #expect(config.memberOrderingRules[3] == .simple(.instanceMethod))
    }

    @Test("Parses all simple member kinds")
    func parsesAllSimpleMemberKinds() throws {
        let yaml = """
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
            """
        let config = try loader.parse(yaml)

        #expect(config.memberOrderingRules.count == 10)
    }

    @Test("Ignores invalid member kinds")
    func ignoresInvalidMemberKinds() throws {
        let yaml = """
            ordering:
              members:
                - initializer
                - invalid_kind
                - instance_method
            """
        let config = try loader.parse(yaml)

        #expect(config.memberOrderingRules.count == 2)
        #expect(config.memberOrderingRules[0] == .simple(.initializer))
        #expect(config.memberOrderingRules[1] == .simple(.instanceMethod))
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
        let config = try loader.parse(yaml)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .property(annotated: true, visibility: nil))
    }

    @Test("Parses property with visibility filter")
    func parsesPropertyVisibility() throws {
        let yaml = """
            ordering:
              members:
                - property:
                    visibility: public
                - property:
                    visibility: internal
                - property:
                    visibility: private
            """
        let config = try loader.parse(yaml)

        #expect(config.memberOrderingRules.count == 3)
        #expect(config.memberOrderingRules[0] == .property(annotated: nil, visibility: .public))
        #expect(config.memberOrderingRules[1] == .property(annotated: nil, visibility: .internal))
        #expect(config.memberOrderingRules[2] == .property(annotated: nil, visibility: .private))
    }

    @Test("Parses property with both annotated and visibility")
    func parsesPropertyBothFilters() throws {
        let yaml = """
            ordering:
              members:
                - property:
                    annotated: true
                    visibility: private
            """
        let config = try loader.parse(yaml)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .property(annotated: true, visibility: .private))
    }

    @Test("Parses property with all visibility levels")
    func parsesPropertyAllVisibilities() throws {
        let yaml = """
            ordering:
              members:
                - property:
                    visibility: open
                - property:
                    visibility: public
                - property:
                    visibility: internal
                - property:
                    visibility: fileprivate
                - property:
                    visibility: private
            """
        let config = try loader.parse(yaml)

        #expect(config.memberOrderingRules.count == 5)
        #expect(config.memberOrderingRules[0] == .property(annotated: nil, visibility: .open))
        #expect(config.memberOrderingRules[1] == .property(annotated: nil, visibility: .public))
        #expect(config.memberOrderingRules[2] == .property(annotated: nil, visibility: .internal))
        #expect(config.memberOrderingRules[3] == .property(annotated: nil, visibility: .fileprivate))
        #expect(config.memberOrderingRules[4] == .property(annotated: nil, visibility: .private))
    }

    // MARK: - Method Rules

    @Test("Parses method with kind filter")
    func parsesMethodKind() throws {
        let yaml = """
            ordering:
              members:
                - method:
                    kind: static
                - method:
                    kind: instance
            """
        let config = try loader.parse(yaml)

        #expect(config.memberOrderingRules.count == 2)
        #expect(config.memberOrderingRules[0] == .method(kind: .static, visibility: nil))
        #expect(config.memberOrderingRules[1] == .method(kind: .instance, visibility: nil))
    }

    @Test("Parses method with visibility filter")
    func parsesMethodVisibility() throws {
        let yaml = """
            ordering:
              members:
                - method:
                    visibility: public
                - method:
                    visibility: private
            """
        let config = try loader.parse(yaml)

        #expect(config.memberOrderingRules.count == 2)
        #expect(config.memberOrderingRules[0] == .method(kind: nil, visibility: .public))
        #expect(config.memberOrderingRules[1] == .method(kind: nil, visibility: .private))
    }

    @Test("Parses method with both kind and visibility")
    func parsesMethodBothFilters() throws {
        let yaml = """
            ordering:
              members:
                - method:
                    kind: static
                    visibility: public
                - method:
                    kind: instance
                    visibility: private
            """
        let config = try loader.parse(yaml)

        #expect(config.memberOrderingRules.count == 2)
        #expect(config.memberOrderingRules[0] == .method(kind: .static, visibility: .public))
        #expect(config.memberOrderingRules[1] == .method(kind: .instance, visibility: .private))
    }

    // MARK: - Extensions Configuration

    @Test("Parses extensions strategy separate")
    func parsesExtensionsStrategySeparate() throws {
        let yaml = """
            extensions:
              strategy: separate
              respect_boundaries: true
            """
        let config = try loader.parse(yaml)

        #expect(config.extensionsStrategy == .separate)
        #expect(config.respectBoundaries == true)
    }

    @Test("Parses extensions strategy merge")
    func parsesExtensionsStrategyMerge() throws {
        let yaml = """
            extensions:
              strategy: merge
              respect_boundaries: false
            """
        let config = try loader.parse(yaml)

        #expect(config.extensionsStrategy == .merge)
        #expect(config.respectBoundaries == false)
    }

    @Test("Defaults extensions to separate and respect_boundaries true")
    func defaultsExtensions() throws {
        let yaml = """
            ordering:
              members:
                - initializer
            """
        let config = try loader.parse(yaml)

        #expect(config.extensionsStrategy == .separate)
        #expect(config.respectBoundaries == true)
    }

    // MARK: - Mixed Configuration

    @Test("Parses full complex configuration")
    func parsesFullConfiguration() throws {
        let yaml = """
            version: 1

            ordering:
              members:
                - typealias
                - associatedtype
                - property:
                    annotated: true
                - initializer
                - property:
                    visibility: public
                - property:
                    visibility: private
                - method:
                    kind: static
                    visibility: public
                - method:
                    kind: instance
                    visibility: public
                - subscript
                - deinitializer

            extensions:
              strategy: separate
              respect_boundaries: true
            """
        let config = try loader.parse(yaml)

        #expect(config.version == 1)
        #expect(config.memberOrderingRules.count == 10)
        #expect(config.extensionsStrategy == .separate)
        #expect(config.respectBoundaries == true)
    }

    // MARK: - Empty/Invalid Cases

    @Test("Returns default for empty ordering members")
    func returnsDefaultForEmptyMembers() throws {
        let yaml = """
            ordering:
              members: []
            """
        let config = try loader.parse(yaml)

        #expect(config.memberOrderingRules == Configuration.default.memberOrderingRules)
    }

    @Test("Returns default for missing ordering section")
    func returnsDefaultForMissingOrdering() throws {
        let yaml = """
            version: 1
            """
        let config = try loader.parse(yaml)

        #expect(config.memberOrderingRules == Configuration.default.memberOrderingRules)
    }
}
// swiftlint:enable type_body_length
