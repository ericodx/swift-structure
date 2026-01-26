protocol Stage<Input, Output>: Sendable {
    associatedtype Input: Sendable
    associatedtype Output: Sendable

    func process(_ input: Input) throws -> Output
}

extension Stage {
    func then<Next: Stage>(_ next: Next) -> Pipeline<Self, Next> where Output == Next.Input {
        Pipeline(self, next)
    }
}
