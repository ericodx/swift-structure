struct ReorderStage: Stage {

    init(configuration: Configuration = .default) {
        self.engine = ReorderEngine(configuration: configuration)
    }

    private let engine: ReorderEngine

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
