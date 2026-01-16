import Testing

@testable import SwiftStructure

struct SwiftStructureTests {

    @Test("Exemplo simples de validação")
    func exampleTest() {
        let value = 2 + 2
        let result = value

        #expect(result == 4)
    }

    @Test("Teste assíncrono de exemplo")
    func asyncExampleTest() async throws {
        let value = await computeValue()
        #expect(value == 42)
    }

    // MARK: - Helpers

    private func computeValue() async -> Int {
        42
    }
}
