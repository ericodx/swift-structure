import Testing

@testable import SwiftStructure

@Suite("MemberReorderingRewriter Tests")
struct MemberReorderingRewriterTests {

    @Test("Reorders members in struct")
    func reordersStructMembers() throws {
        let source = """
            struct Foo {
                func doSomething() {}
                init() {}
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result.contains("init()"))
        #expect(result.contains("func doSomething()"))

        guard let initRange = result.range(of: "init()"),
            let funcRange = result.range(of: "func doSomething()")
        else {
            Issue.record("Expected strings not found")
            return
        }
        #expect(initRange.lowerBound < funcRange.lowerBound)
    }

    @Test("Preserves comments with members")
    func preservesComments() throws {
        let source = """
            struct Foo {
                // Method comment
                func doSomething() {}

                // Init comment
                init() {}
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result.contains("// Init comment"))
        #expect(result.contains("// Method comment"))
    }

    @Test("No change when already ordered")
    func noChangeWhenOrdered() throws {
        let source = """
            struct Foo {
                init() {}
                func doSomething() {}
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result == source)
    }

    @Test("Deterministic output")
    func deterministic() throws {
        let source = """
            struct Foo {
                func b() {}
                func a() {}
                var prop: Int
                init() {}
            }
            """

        let result1 = try applyRewrite(to: source)
        let result2 = try applyRewrite(to: source)

        #expect(result1 == result2)
    }

    @Test("Idempotent rewriting")
    func idempotent() throws {
        let source = """
            struct Foo {
                func doSomething() {}
                var name: String
                init() {}
            }
            """

        let result1 = try applyRewrite(to: source)
        let result2 = try applyRewrite(to: result1)

        #expect(result1 == result2)
    }

    @Test("Handles multiple types")
    func handlesMultipleTypes() throws {
        let source = """
            struct Foo {
                func a() {}
                init() {}
            }

            class Bar {
                func b() {}
                init() {}
            }
            """

        let result = try applyRewrite(to: source)

        guard let initRange = result.range(of: "init()"),
            let funcRange = result.range(of: "func a()")
        else {
            Issue.record("Expected strings not found")
            return
        }
        #expect(initRange.lowerBound < funcRange.lowerBound)
    }

    @Test("Preserves nested type structure")
    func preservesNestedTypes() throws {
        let source = """
            struct Outer {
                func outerMethod() {}
                init() {}

                struct Inner {
                    func innerMethod() {}
                }
            }
            """

        let result = try applyRewrite(to: source)

        #expect(result.contains("struct Inner"))
        #expect(result.contains("func innerMethod()"))
    }
}
