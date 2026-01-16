struct Pipeline<S1: Stage, S2: Stage>: Stage where S1.Output == S2.Input {
    typealias Input = S1.Input
    typealias Output = S2.Output

    init(_ first: S1, _ second: S2) {
        self.first = first
        self.second = second
    }

    private let first: S1
    private let second: S2

    func process(_ input: Input) throws -> Output {
        let intermediate = try first.process(input)
        return try second.process(intermediate)
    }
}
