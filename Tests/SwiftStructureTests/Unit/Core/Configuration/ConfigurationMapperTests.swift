import Testing

@testable import SwiftStructure

@Suite("ConfigurationMapper Tests")
struct ConfigurationMapperTests {

    let mapper = ConfigurationMapper()

    // MARK: - Version Mapping

    @Test("Maps version directly")
    func mapsVersion() {
        let raw = RawConfiguration(version: 2, memberRules: [], extensionsStrategy: nil, respectBoundaries: nil)
        let config = mapper.map(raw)

        #expect(config.version == 2)
    }

    // MARK: - Simple Rules Mapping

    @Test("Maps valid simple member kind")
    func mapsValidSimpleKind() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.simple("initializer")],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .simple(.initializer))
    }

    @Test("Ignores invalid simple member kind")
    func ignoresInvalidSimpleKind() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.simple("invalid_kind")],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules == Configuration.default.memberOrderingRules)
    }

    @Test("Maps all valid MemberKind values")
    func mapsAllValidMemberKinds() {
        for kind in MemberKind.allCases {
            let raw = RawConfiguration(
                version: 1,
                memberRules: [.simple(kind.rawValue)],
                extensionsStrategy: nil,
                respectBoundaries: nil
            )
            let config = mapper.map(raw)

            #expect(config.memberOrderingRules.count == 1)
            #expect(config.memberOrderingRules[0] == .simple(kind))
        }
    }

    // MARK: - Property Rules Mapping

    @Test("Maps property with annotated filter")
    func mapsPropertyAnnotated() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.property(annotated: true, visibility: nil)],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .property(annotated: true, visibility: nil))
    }

    @Test("Maps property with valid visibility")
    func mapsPropertyValidVisibility() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.property(annotated: nil, visibility: "public")],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .property(annotated: nil, visibility: .public))
    }

    @Test("Maps property with invalid visibility to nil")
    func mapsPropertyInvalidVisibility() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.property(annotated: nil, visibility: "invalid")],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .property(annotated: nil, visibility: nil))
    }

    @Test("Maps all valid Visibility values for property")
    func mapsAllValidVisibilitiesForProperty() {
        for visibility in Visibility.allCases {
            let raw = RawConfiguration(
                version: 1,
                memberRules: [.property(annotated: nil, visibility: visibility.rawValue)],
                extensionsStrategy: nil,
                respectBoundaries: nil
            )
            let config = mapper.map(raw)

            #expect(config.memberOrderingRules.count == 1)
            #expect(config.memberOrderingRules[0] == .property(annotated: nil, visibility: visibility))
        }
    }

    // MARK: - Method Rules Mapping

    @Test("Maps method with static kind")
    func mapsMethodStaticKind() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.method(kind: "static", visibility: nil, annotated: nil)],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .method(kind: .static, visibility: nil, annotated: nil))
    }

    @Test("Maps method with instance kind")
    func mapsMethodInstanceKind() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.method(kind: "instance", visibility: nil, annotated: nil)],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .method(kind: .instance, visibility: nil, annotated: nil))
    }

    @Test("Maps method with invalid kind to nil")
    func mapsMethodInvalidKind() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.method(kind: "invalid", visibility: nil, annotated: nil)],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .method(kind: nil, visibility: nil, annotated: nil))
    }

    @Test("Maps method with valid visibility")
    func mapsMethodValidVisibility() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.method(kind: nil, visibility: "private", annotated: nil)],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules.count == 1)
        #expect(config.memberOrderingRules[0] == .method(kind: nil, visibility: .private, annotated: nil))
    }

    // MARK: - Extensions Strategy Mapping

    @Test("Maps separate strategy")
    func mapsSeparateStrategy() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: "separate",
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.extensionsStrategy == .separate)
    }

    @Test("Maps merge strategy")
    func mapsMergeStrategy() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: "merge",
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.extensionsStrategy == .merge)
    }

    @Test("Defaults to separate for nil strategy")
    func defaultsToSeparateForNilStrategy() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.extensionsStrategy == .separate)
    }

    @Test("Defaults to separate for invalid strategy")
    func defaultsToSeparateForInvalidStrategy() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: "invalid",
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.extensionsStrategy == .separate)
    }

    // MARK: - Respect Boundaries Mapping

    @Test("Maps respect_boundaries true")
    func mapsRespectBoundariesTrue() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: nil,
            respectBoundaries: true
        )
        let config = mapper.map(raw)

        #expect(config.respectBoundaries == true)
    }

    @Test("Maps respect_boundaries false")
    func mapsRespectBoundariesFalse() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: nil,
            respectBoundaries: false
        )
        let config = mapper.map(raw)

        #expect(config.respectBoundaries == false)
    }

    @Test("Defaults to true for nil respect_boundaries")
    func defaultsToTrueForNilRespectBoundaries() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.respectBoundaries == true)
    }

    // MARK: - Default Rules

    @Test("Uses default rules when all rules are invalid")
    func usesDefaultRulesWhenAllInvalid() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [.simple("invalid1"), .simple("invalid2")],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules == Configuration.default.memberOrderingRules)
    }

    @Test("Uses default rules when member rules are empty")
    func usesDefaultRulesWhenEmpty() {
        let raw = RawConfiguration(
            version: 1,
            memberRules: [],
            extensionsStrategy: nil,
            respectBoundaries: nil
        )
        let config = mapper.map(raw)

        #expect(config.memberOrderingRules == Configuration.default.memberOrderingRules)
    }
}
