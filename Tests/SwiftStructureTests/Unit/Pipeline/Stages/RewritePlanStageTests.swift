import Testing

@testable import SwiftStructure

@Suite("RewritePlanStage Tests")
struct RewritePlanStageTests {

    @Test("Creates plan for type needing reorder")
    func createsPlanForReorder() throws {
        let source = """
            struct Foo {
                func doSomething() {}
                init() {}
            }
            """

        let output = try makeRewritePlan(from: source)

        #expect(output.plans.count == 1)
        #expect(output.plans[0].needsRewriting)
        #expect(output.plans[0].typeName == "Foo")
    }

    @Test("No rewrite needed when ordered")
    func noRewriteWhenOrdered() throws {
        let source = """
            struct Foo {
                init() {}
                func doSomething() {}
            }
            """

        let output = try makeRewritePlan(from: source)

        #expect(output.plans.count == 1)
        #expect(!output.plans[0].needsRewriting)
    }

    @Test("Preserves original member order in plan")
    func preservesOriginalOrder() throws {
        let source = """
            struct Foo {
                func b() {}
                func a() {}
                init() {}
            }
            """

        let output = try makeRewritePlan(from: source)
        let originalKinds = output.plans[0].originalMembers.map(\.declaration.kind)

        #expect(originalKinds == [.instanceMethod, .instanceMethod, .initializer])
    }

    @Test("Reorders members in plan")
    func reordersMembers() throws {
        let source = """
            struct Foo {
                func doSomething() {}
                init() {}
            }
            """

        let output = try makeRewritePlan(from: source)
        let reorderedKinds = output.plans[0].reorderedMembers.map(\.declaration.kind)

        #expect(reorderedKinds == [.initializer, .instanceMethod])
    }

    @Test("Handles multiple types")
    func handlesMultipleTypes() throws {
        let source = """
            struct Foo {
                func a() {}
                init() {}
            }

            class Bar {
                init() {}
                func b() {}
            }
            """

        let output = try makeRewritePlan(from: source)

        #expect(output.plans.count == 2)
        #expect(output.plans[0].needsRewriting)
        #expect(!output.plans[1].needsRewriting)
    }

    @Test("needsRewriting reflects overall state")
    func needsRewritingReflectsState() throws {
        let needsRewrite = """
            struct Foo {
                func a() {}
                init() {}
            }
            """

        let noRewrite = """
            struct Foo {
                init() {}
                func a() {}
            }
            """

        let output1 = try makeRewritePlan(from: needsRewrite)
        let output2 = try makeRewritePlan(from: noRewrite)

        #expect(output1.needsRewriting)
        #expect(!output2.needsRewriting)
    }
}
