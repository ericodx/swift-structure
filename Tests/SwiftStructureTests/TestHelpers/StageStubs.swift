@testable import SwiftStructure

struct DoubleStage: Stage {
    func process(_ input: Int) throws -> Int {
        input * 2
    }
}

struct AddTenStage: Stage {
    func process(_ input: Int) throws -> Int {
        input + 10
    }
}

struct ToStringStage: Stage {
    func process(_ input: Int) throws -> String {
        "\(input)"
    }
}

struct FailingStage: Stage {
    func process(_ input: Int) throws -> Int {
        throw TestError.intentional
    }
}

enum TestError: Error {
    case intentional
}
