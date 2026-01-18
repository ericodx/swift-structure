import Testing

@testable import SwiftStructure

@Suite("SyntaxClassifyStage Tests")
struct SyntaxClassifyStageTests {

    @Test("Captures syntax nodes for members")
    func capturesSyntaxNodes() throws {
        let source = """
            struct Foo {
                var name: String
                init() {}
            }
            """

        let output = try syntaxClassify(source)

        #expect(output.declarations.count == 1)
        #expect(output.declarations[0].members.count == 2)

        for member in output.declarations[0].members {
            #expect(member.syntax.description.isEmpty == false)
        }
    }

    @Test("Preserves member block reference")
    func preservesMemberBlock() throws {
        let source = """
            struct Foo {
                var name: String
            }
            """

        let output = try syntaxClassify(source)

        #expect(output.declarations[0].memberBlock.members.count == 1)
    }

    @Test("Handles empty member block")
    func handlesEmptyMembers() throws {
        let source = "struct Empty {}"

        let output = try syntaxClassify(source)

        #expect(output.declarations.count == 1)
        #expect(output.declarations[0].members.isEmpty)
    }

    @Test("Classifies all member kinds")
    func classifiesAllKinds() throws {
        let source = """
            struct Foo {
                typealias ID = String
                init() {}
                static var shared: Foo!
                var name: String
                func doSomething() {}
                deinit {}
            }
            """

        let output = try syntaxClassify(source)
        let kinds = output.declarations[0].members.map(\.declaration.kind)

        #expect(kinds.contains(.typealias))
        #expect(kinds.contains(.initializer))
        #expect(kinds.contains(.typeProperty))
        #expect(kinds.contains(.instanceProperty))
        #expect(kinds.contains(.instanceMethod))
        #expect(kinds.contains(.deinitializer))
    }
}
