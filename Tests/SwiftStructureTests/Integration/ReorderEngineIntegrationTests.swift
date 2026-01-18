import Testing

@testable import SwiftStructure

@Suite("ReorderEngine Integration Tests")
struct ReorderEngineIntegrationTests {

    // MARK: - Simple Ordering

    @Test("Orders by simple member kinds")
    func ordersSimpleMemberKinds() {
        let rules: [MemberOrderingRule] = [
            .simple(.initializer),
            .simple(.instanceProperty),
            .simple(.instanceMethod),
        ]
        let engine = ReorderEngine(rules: rules)

        let members = [
            MemberDeclaration(name: "doSomething", kind: .instanceMethod, line: 1),
            MemberDeclaration(name: "name", kind: .instanceProperty, line: 2),
            MemberDeclaration(name: "init", kind: .initializer, line: 3),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "init")
        #expect(result[1].name == "name")
        #expect(result[2].name == "doSomething")
    }

    @Test("Preserves order for same kind")
    func preservesOrderForSameKind() {
        let rules: [MemberOrderingRule] = [.simple(.instanceMethod)]
        let engine = ReorderEngine(rules: rules)

        let members = [
            MemberDeclaration(name: "methodA", kind: .instanceMethod, line: 1),
            MemberDeclaration(name: "methodB", kind: .instanceMethod, line: 2),
            MemberDeclaration(name: "methodC", kind: .instanceMethod, line: 3),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "methodA")
        #expect(result[1].name == "methodB")
        #expect(result[2].name == "methodC")
    }

    // MARK: - Property Ordering by Annotation

    @Test("Orders annotated properties first")
    func ordersAnnotatedPropertiesFirst() {
        let rules: [MemberOrderingRule] = [
            .property(annotated: true, visibility: nil),
            .property(annotated: false, visibility: nil),
        ]
        let engine = ReorderEngine(rules: rules)

        let members = [
            MemberDeclaration(
                name: "normalProp",
                kind: .instanceProperty,
                line: 1,
                visibility: .internal,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "stateProp",
                kind: .instanceProperty,
                line: 2,
                visibility: .internal,
                isAnnotated: true
            ),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "stateProp")
        #expect(result[1].name == "normalProp")
    }

    // MARK: - Property Ordering by Visibility

    @Test("Orders properties by visibility")
    func ordersPropertiesByVisibility() {
        let rules: [MemberOrderingRule] = [
            .property(annotated: nil, visibility: .public),
            .property(annotated: nil, visibility: .internal),
            .property(annotated: nil, visibility: .private),
        ]
        let engine = ReorderEngine(rules: rules)

        let members = [
            MemberDeclaration(
                name: "privateProp",
                kind: .instanceProperty,
                line: 1,
                visibility: .private,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "publicProp",
                kind: .instanceProperty,
                line: 2,
                visibility: .public,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "internalProp",
                kind: .instanceProperty,
                line: 3,
                visibility: .internal,
                isAnnotated: false
            ),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "publicProp")
        #expect(result[1].name == "internalProp")
        #expect(result[2].name == "privateProp")
    }

    // MARK: - Method Ordering by Kind

    @Test("Orders static methods before instance methods")
    func ordersStaticMethodsFirst() {
        let rules: [MemberOrderingRule] = [
            .method(kind: .static, visibility: nil),
            .method(kind: .instance, visibility: nil),
        ]
        let engine = ReorderEngine(rules: rules)

        let members = [
            MemberDeclaration(name: "instanceMethod", kind: .instanceMethod, line: 1),
            MemberDeclaration(name: "staticMethod", kind: .typeMethod, line: 2),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "staticMethod")
        #expect(result[1].name == "instanceMethod")
    }

    // MARK: - Method Ordering by Visibility

    @Test("Orders methods by visibility")
    func ordersMethodsByVisibility() {
        let rules: [MemberOrderingRule] = [
            .method(kind: nil, visibility: .public),
            .method(kind: nil, visibility: .internal),
            .method(kind: nil, visibility: .private),
        ]
        let engine = ReorderEngine(rules: rules)

        let members = [
            MemberDeclaration(
                name: "privateMethod",
                kind: .instanceMethod,
                line: 1,
                visibility: .private,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "publicMethod",
                kind: .instanceMethod,
                line: 2,
                visibility: .public,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "internalMethod",
                kind: .instanceMethod,
                line: 3,
                visibility: .internal,
                isAnnotated: false
            ),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "publicMethod")
        #expect(result[1].name == "internalMethod")
        #expect(result[2].name == "privateMethod")
    }

    // MARK: - Combined Method Ordering

    @Test("Orders methods by kind and visibility")
    func ordersMethodsByKindAndVisibility() {
        let rules: [MemberOrderingRule] = [
            .method(kind: .static, visibility: .public),
            .method(kind: .static, visibility: .private),
            .method(kind: .instance, visibility: .public),
            .method(kind: .instance, visibility: .private),
        ]
        let engine = ReorderEngine(rules: rules)

        let members = [
            MemberDeclaration(
                name: "instancePrivate",
                kind: .instanceMethod,
                line: 1,
                visibility: .private,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "staticPublic",
                kind: .typeMethod,
                line: 2,
                visibility: .public,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "instancePublic",
                kind: .instanceMethod,
                line: 3,
                visibility: .public,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "staticPrivate",
                kind: .typeMethod,
                line: 4,
                visibility: .private,
                isAnnotated: false
            ),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "staticPublic")
        #expect(result[1].name == "staticPrivate")
        #expect(result[2].name == "instancePublic")
        #expect(result[3].name == "instancePrivate")
    }

    // MARK: - Complex Configuration

    @Test("Full structural order matching config file")
    func fullStructuralOrder() {
        let rules: [MemberOrderingRule] = [
            .simple(.typealias),
            .simple(.associatedtype),
            .property(annotated: true, visibility: nil),
            .simple(.initializer),
            .property(annotated: nil, visibility: .public),
            .property(annotated: nil, visibility: .internal),
            .property(annotated: nil, visibility: .private),
            .simple(.subtype),
            .method(kind: .static, visibility: .public),
            .method(kind: .static, visibility: .private),
            .method(kind: .instance, visibility: .public),
            .method(kind: .instance, visibility: .private),
            .simple(.subscript),
            .simple(.deinitializer),
        ]
        let engine = ReorderEngine(rules: rules)

        let members = [
            MemberDeclaration(
                name: "privateMethod",
                kind: .instanceMethod,
                line: 1,
                visibility: .private,
                isAnnotated: false
            ),
            MemberDeclaration(name: "deinit", kind: .deinitializer, line: 2),
            MemberDeclaration(
                name: "privateProp",
                kind: .instanceProperty,
                line: 3,
                visibility: .private,
                isAnnotated: false
            ),
            MemberDeclaration(name: "init", kind: .initializer, line: 4),
            MemberDeclaration(
                name: "annotatedProp",
                kind: .instanceProperty,
                line: 5,
                visibility: .internal,
                isAnnotated: true
            ),
            MemberDeclaration(name: "ID", kind: .typealias, line: 6),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "ID")
        #expect(result[1].name == "annotatedProp")
        #expect(result[2].name == "init")
        #expect(result[3].name == "privateProp")
        #expect(result[4].name == "privateMethod")
        #expect(result[5].name == "deinit")
    }

    // MARK: - Unmatched Members

    @Test("Unmatched members go to end")
    func unmatchedMembersGoToEnd() {
        let rules: [MemberOrderingRule] = [
            .simple(.initializer)
        ]
        let engine = ReorderEngine(rules: rules)

        let members = [
            MemberDeclaration(name: "method", kind: .instanceMethod, line: 1),
            MemberDeclaration(name: "init", kind: .initializer, line: 2),
            MemberDeclaration(name: "prop", kind: .instanceProperty, line: 3),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "init")
        #expect(result[1].name == "method")
        #expect(result[2].name == "prop")
    }

    // MARK: - Configuration Integration

    @Test("Uses configuration from Configuration struct")
    func usesConfigurationStruct() {
        let config = Configuration(
            version: 1,
            memberOrderingRules: [
                .simple(.instanceMethod),
                .simple(.instanceProperty),
            ],
            extensionsStrategy: .separate,
            respectBoundaries: true
        )
        let engine = ReorderEngine(configuration: config)

        let members = [
            MemberDeclaration(name: "prop", kind: .instanceProperty, line: 1),
            MemberDeclaration(name: "method", kind: .instanceMethod, line: 2),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "method")
        #expect(result[1].name == "prop")
    }

    @Test("Default configuration maintains original MemberKind order")
    func defaultConfigurationOrder() {
        let engine = ReorderEngine(configuration: .default)

        let members = [
            MemberDeclaration(name: "method", kind: .instanceMethod, line: 1),
            MemberDeclaration(name: "init", kind: .initializer, line: 2),
            MemberDeclaration(name: "alias", kind: .typealias, line: 3),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "alias")
        #expect(result[1].name == "init")
        #expect(result[2].name == "method")
    }
}
