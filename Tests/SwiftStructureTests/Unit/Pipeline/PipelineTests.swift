import Testing

@testable import SwiftStructure

@Suite("Pipeline Tests")
struct PipelineTests {

    @Test("Pipeline composes two stages")
    func composeTwoStages() throws {
        let double = DoubleStage()
        let addTen = AddTenStage()

        let pipeline = double.then(addTen)
        let result = try pipeline.process(5)

        #expect(result == 20)
    }

    @Test("Pipeline composes three stages")
    func composeThreeStages() throws {
        let double = DoubleStage()
        let addTen = AddTenStage()
        let toString = ToStringStage()

        let pipeline = double.then(addTen).then(toString)
        let result = try pipeline.process(5)

        #expect(result == "20")
    }

    @Test("Pipeline propagates errors")
    func propagatesErrors() throws {
        let failing = FailingStage()
        let addTen = AddTenStage()

        let pipeline = failing.then(addTen)

        #expect(throws: TestError.intentional) {
            try pipeline.process(5)
        }
    }
}
