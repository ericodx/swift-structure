struct RewritePlanStage: Stage {

    init(configuration: Configuration = .default) {
        self.engine = ReorderEngine(configuration: configuration)
    }

    private let engine: ReorderEngine

    func process(_ input: SyntaxClassifyOutput) throws -> RewritePlanOutput {
        let plans = input.declarations.map { typeDecl -> TypeRewritePlan in
            let reorderedDeclarations = engine.reorder(typeDecl.members.map(\.declaration))
            let reorderedMembers = mapToSyntaxMembers(
                reorderedDeclarations: reorderedDeclarations,
                originalMembers: typeDecl.members
            )

            return TypeRewritePlan(
                typeName: typeDecl.name,
                kind: typeDecl.kind,
                line: typeDecl.line,
                originalMembers: typeDecl.members,
                reorderedMembers: reorderedMembers
            )
        }

        return RewritePlanOutput(path: input.path, syntax: input.syntax, plans: plans)
    }

    private func mapToSyntaxMembers(
        reorderedDeclarations: [MemberDeclaration],
        originalMembers: [SyntaxMemberDeclaration]
    ) -> [SyntaxMemberDeclaration] {
        var membersByLine: [Int: SyntaxMemberDeclaration] = [:]
        for member in originalMembers {
            membersByLine[member.declaration.line] = member
        }

        return reorderedDeclarations.compactMap { decl in
            membersByLine[decl.line]
        }
    }
}
