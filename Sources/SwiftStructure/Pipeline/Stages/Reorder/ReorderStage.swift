struct ReorderStage: Stage {

    // MARK: - Initialization

    init(configuration: Configuration = .default) {
        self.engine = ReorderEngine(configuration: configuration)
    }

    // MARK: - Properties

    private let engine: ReorderEngine

    // MARK: - Stage

    func process(_ input: ClassifyOutput) throws -> ReorderOutput {
        let results = input.declarations.map { decl in
            TypeReorderResult(
                name: decl.name,
                kind: decl.kind,
                line: decl.line,
                originalMembers: decl.members,
                reorderedMembers: engine.reorder(decl.members)
            )
        }
        return ReorderOutput(path: input.path, results: results)
    }
}
