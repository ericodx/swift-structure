import Testing

@testable import SwiftStructure

@Suite("MemberOrderingRule Integration Tests")
struct MemberOrderingRuleIntegrationTests {

    // MARK: - Simple Rules

    @Test("Simple rule matches exact kind")
    func simpleRuleMatchesExactKind() {
        let rule = MemberOrderingRule.simple(.initializer)
        let member = MemberDeclaration(
            name: "init",
            kind: .initializer,
            line: 1
        )

        #expect(rule.matches(member) == true)
    }

    @Test("Simple rule does not match different kind")
    func simpleRuleDoesNotMatchDifferentKind() {
        let rule = MemberOrderingRule.simple(.initializer)
        let member = MemberDeclaration(
            name: "foo",
            kind: .instanceMethod,
            line: 1
        )

        #expect(rule.matches(member) == false)
    }

    @Test("Simple rule matches all member kinds")
    func simpleRuleMatchesAllKinds() {
        for kind in MemberKind.allCases {
            let rule = MemberOrderingRule.simple(kind)
            let member = MemberDeclaration(name: "test", kind: kind, line: 1)
            #expect(rule.matches(member) == true)
        }
    }

    // MARK: - Property Rules - Annotated

    @Test("Property rule matches annotated property")
    func propertyRuleMatchesAnnotated() {
        let rule = MemberOrderingRule.property(annotated: true, visibility: nil)
        let member = MemberDeclaration(
            name: "state",
            kind: .instanceProperty,
            line: 1,
            visibility: .internal,
            isAnnotated: true
        )

        #expect(rule.matches(member) == true)
    }

    @Test("Property rule does not match non-annotated when annotated required")
    func propertyRuleDoesNotMatchNonAnnotated() {
        let rule = MemberOrderingRule.property(annotated: true, visibility: nil)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1,
            visibility: .internal,
            isAnnotated: false
        )

        #expect(rule.matches(member) == false)
    }

    @Test("Property rule matches non-annotated when annotated is false")
    func propertyRuleMatchesNonAnnotatedExplicit() {
        let rule = MemberOrderingRule.property(annotated: false, visibility: nil)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1,
            visibility: .internal,
            isAnnotated: false
        )

        #expect(rule.matches(member) == true)
    }

    @Test("Property rule matches type property")
    func propertyRuleMatchesTypeProperty() {
        let rule = MemberOrderingRule.property(annotated: nil, visibility: nil)
        let member = MemberDeclaration(
            name: "shared",
            kind: .typeProperty,
            line: 1
        )

        #expect(rule.matches(member) == true)
    }

    @Test("Property rule matches instance property")
    func propertyRuleMatchesInstanceProperty() {
        let rule = MemberOrderingRule.property(annotated: nil, visibility: nil)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1
        )

        #expect(rule.matches(member) == true)
    }

    @Test("Property rule does not match method")
    func propertyRuleDoesNotMatchMethod() {
        let rule = MemberOrderingRule.property(annotated: nil, visibility: nil)
        let member = MemberDeclaration(
            name: "foo",
            kind: .instanceMethod,
            line: 1
        )

        #expect(rule.matches(member) == false)
    }

    // MARK: - Property Rules - Visibility

    @Test("Property rule matches public visibility")
    func propertyRuleMatchesPublicVisibility() {
        let rule = MemberOrderingRule.property(annotated: nil, visibility: .public)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1,
            visibility: .public,
            isAnnotated: false
        )

        #expect(rule.matches(member) == true)
    }

    @Test("Property rule matches private visibility")
    func propertyRuleMatchesPrivateVisibility() {
        let rule = MemberOrderingRule.property(annotated: nil, visibility: .private)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1,
            visibility: .private,
            isAnnotated: false
        )

        #expect(rule.matches(member) == true)
    }

    @Test("Property rule does not match wrong visibility")
    func propertyRuleDoesNotMatchWrongVisibility() {
        let rule = MemberOrderingRule.property(annotated: nil, visibility: .public)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1,
            visibility: .private,
            isAnnotated: false
        )

        #expect(rule.matches(member) == false)
    }

    @Test("Property rule matches all visibility levels")
    func propertyRuleMatchesAllVisibilities() {
        for visibility in Visibility.allCases {
            let rule = MemberOrderingRule.property(annotated: nil, visibility: visibility)
            let member = MemberDeclaration(
                name: "name",
                kind: .instanceProperty,
                line: 1,
                visibility: visibility,
                isAnnotated: false
            )
            #expect(rule.matches(member) == true)
        }
    }

    // MARK: - Property Rules - Combined

    @Test("Property rule matches annotated with specific visibility")
    func propertyRuleMatchesCombined() {
        let rule = MemberOrderingRule.property(annotated: true, visibility: .private)
        let member = MemberDeclaration(
            name: "state",
            kind: .instanceProperty,
            line: 1,
            visibility: .private,
            isAnnotated: true
        )

        #expect(rule.matches(member) == true)
    }

    @Test("Property rule fails when annotated matches but visibility doesn't")
    func propertyRuleCombinedAnnotatedMatchVisibilityFails() {
        let rule = MemberOrderingRule.property(annotated: true, visibility: .public)
        let member = MemberDeclaration(
            name: "state",
            kind: .instanceProperty,
            line: 1,
            visibility: .private,
            isAnnotated: true
        )

        #expect(rule.matches(member) == false)
    }

    @Test("Property rule fails when visibility matches but annotated doesn't")
    func propertyRuleCombinedVisibilityMatchAnnotatedFails() {
        let rule = MemberOrderingRule.property(annotated: true, visibility: .public)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1,
            visibility: .public,
            isAnnotated: false
        )

        #expect(rule.matches(member) == false)
    }

    // MARK: - Method Rules - Kind

    @Test("Method rule matches static method")
    func methodRuleMatchesStaticMethod() {
        let rule = MemberOrderingRule.method(kind: .static, visibility: nil)
        let member = MemberDeclaration(
            name: "create",
            kind: .typeMethod,
            line: 1
        )

        #expect(rule.matches(member) == true)
    }

    @Test("Method rule matches instance method")
    func methodRuleMatchesInstanceMethod() {
        let rule = MemberOrderingRule.method(kind: .instance, visibility: nil)
        let member = MemberDeclaration(
            name: "doSomething",
            kind: .instanceMethod,
            line: 1
        )

        #expect(rule.matches(member) == true)
    }

    @Test("Method rule with static kind does not match instance method")
    func methodRuleStaticDoesNotMatchInstance() {
        let rule = MemberOrderingRule.method(kind: .static, visibility: nil)
        let member = MemberDeclaration(
            name: "doSomething",
            kind: .instanceMethod,
            line: 1
        )

        #expect(rule.matches(member) == false)
    }

    @Test("Method rule with instance kind does not match static method")
    func methodRuleInstanceDoesNotMatchStatic() {
        let rule = MemberOrderingRule.method(kind: .instance, visibility: nil)
        let member = MemberDeclaration(
            name: "create",
            kind: .typeMethod,
            line: 1
        )

        #expect(rule.matches(member) == false)
    }

    @Test("Method rule with nil kind matches both static and instance")
    func methodRuleNilKindMatchesBoth() {
        let rule = MemberOrderingRule.method(kind: nil, visibility: nil)

        let staticMethod = MemberDeclaration(name: "create", kind: .typeMethod, line: 1)
        let instanceMethod = MemberDeclaration(name: "doSomething", kind: .instanceMethod, line: 1)

        #expect(rule.matches(staticMethod) == true)
        #expect(rule.matches(instanceMethod) == true)
    }

    @Test("Method rule does not match property")
    func methodRuleDoesNotMatchProperty() {
        let rule = MemberOrderingRule.method(kind: nil, visibility: nil)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1
        )

        #expect(rule.matches(member) == false)
    }

    // MARK: - Method Rules - Visibility

    @Test("Method rule matches public visibility")
    func methodRuleMatchesPublicVisibility() {
        let rule = MemberOrderingRule.method(kind: nil, visibility: .public)
        let member = MemberDeclaration(
            name: "doSomething",
            kind: .instanceMethod,
            line: 1,
            visibility: .public,
            isAnnotated: false
        )

        #expect(rule.matches(member) == true)
    }

    @Test("Method rule does not match wrong visibility")
    func methodRuleDoesNotMatchWrongVisibility() {
        let rule = MemberOrderingRule.method(kind: nil, visibility: .public)
        let member = MemberDeclaration(
            name: "doSomething",
            kind: .instanceMethod,
            line: 1,
            visibility: .private,
            isAnnotated: false
        )

        #expect(rule.matches(member) == false)
    }

    // MARK: - Method Rules - Combined

    @Test("Method rule matches static public method")
    func methodRuleMatchesStaticPublic() {
        let rule = MemberOrderingRule.method(kind: .static, visibility: .public)
        let member = MemberDeclaration(
            name: "create",
            kind: .typeMethod,
            line: 1,
            visibility: .public,
            isAnnotated: false
        )

        #expect(rule.matches(member) == true)
    }

    @Test("Method rule matches instance private method")
    func methodRuleMatchesInstancePrivate() {
        let rule = MemberOrderingRule.method(kind: .instance, visibility: .private)
        let member = MemberDeclaration(
            name: "helper",
            kind: .instanceMethod,
            line: 1,
            visibility: .private,
            isAnnotated: false
        )

        #expect(rule.matches(member) == true)
    }

    @Test("Method rule fails when kind matches but visibility doesn't")
    func methodRuleCombinedKindMatchVisibilityFails() {
        let rule = MemberOrderingRule.method(kind: .static, visibility: .public)
        let member = MemberDeclaration(
            name: "create",
            kind: .typeMethod,
            line: 1,
            visibility: .private,
            isAnnotated: false
        )

        #expect(rule.matches(member) == false)
    }

    @Test("Method rule fails when visibility matches but kind doesn't")
    func methodRuleCombinedVisibilityMatchKindFails() {
        let rule = MemberOrderingRule.method(kind: .static, visibility: .public)
        let member = MemberDeclaration(
            name: "doSomething",
            kind: .instanceMethod,
            line: 1,
            visibility: .public,
            isAnnotated: false
        )

        #expect(rule.matches(member) == false)
    }

    // MARK: - Edge Cases

    @Test("Property rule does not match initializer")
    func propertyRuleDoesNotMatchInitializer() {
        let rule = MemberOrderingRule.property(annotated: nil, visibility: nil)
        let member = MemberDeclaration(name: "init", kind: .initializer, line: 1)

        #expect(rule.matches(member) == false)
    }

    @Test("Method rule does not match initializer")
    func methodRuleDoesNotMatchInitializer() {
        let rule = MemberOrderingRule.method(kind: nil, visibility: nil)
        let member = MemberDeclaration(name: "init", kind: .initializer, line: 1)

        #expect(rule.matches(member) == false)
    }

    @Test("Simple initializer rule does not match method")
    func simpleInitializerRuleDoesNotMatchMethod() {
        let rule = MemberOrderingRule.simple(.initializer)
        let member = MemberDeclaration(name: "foo", kind: .instanceMethod, line: 1)

        #expect(rule.matches(member) == false)
    }
}
