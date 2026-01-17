import SwiftSyntax

final class MemberReorderingRewriter: SyntaxRewriter {

    init(plans: [TypeRewritePlan]) {
        var dict: [TypeLocation: TypeRewritePlan] = [:]
        for plan in plans where plan.needsRewriting {
            let location = TypeLocation(name: plan.typeName, line: plan.line)
            dict[location] = plan
        }
        self.plansByLocation = dict
        super.init()
    }

    private let plansByLocation: [TypeLocation: TypeRewritePlan]

    override func visit(_ node: StructDeclSyntax) -> DeclSyntax {
        guard let plan = findPlan(for: node.name.text, memberBlock: node.memberBlock) else {
            return super.visit(node)
        }
        let newMemberBlock = reorderMemberBlock(node.memberBlock, using: plan)
        return DeclSyntax(node.with(\.memberBlock, newMemberBlock))
    }

    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        guard let plan = findPlan(for: node.name.text, memberBlock: node.memberBlock) else {
            return super.visit(node)
        }
        let newMemberBlock = reorderMemberBlock(node.memberBlock, using: plan)
        return DeclSyntax(node.with(\.memberBlock, newMemberBlock))
    }

    override func visit(_ node: EnumDeclSyntax) -> DeclSyntax {
        guard let plan = findPlan(for: node.name.text, memberBlock: node.memberBlock) else {
            return super.visit(node)
        }
        let newMemberBlock = reorderMemberBlock(node.memberBlock, using: plan)
        return DeclSyntax(node.with(\.memberBlock, newMemberBlock))
    }

    override func visit(_ node: ActorDeclSyntax) -> DeclSyntax {
        guard let plan = findPlan(for: node.name.text, memberBlock: node.memberBlock) else {
            return super.visit(node)
        }
        let newMemberBlock = reorderMemberBlock(node.memberBlock, using: plan)
        return DeclSyntax(node.with(\.memberBlock, newMemberBlock))
    }

    override func visit(_ node: ProtocolDeclSyntax) -> DeclSyntax {
        guard let plan = findPlan(for: node.name.text, memberBlock: node.memberBlock) else {
            return super.visit(node)
        }
        let newMemberBlock = reorderMemberBlock(node.memberBlock, using: plan)
        return DeclSyntax(node.with(\.memberBlock, newMemberBlock))
    }

    private func findPlan(for name: String, memberBlock: MemberBlockSyntax) -> TypeRewritePlan? {
        for (location, plan) in plansByLocation where location.name == name {
            if membersMatch(memberBlock: memberBlock, plan: plan) {
                return plan
            }
        }
        return nil
    }

    private func membersMatch(memberBlock: MemberBlockSyntax, plan: TypeRewritePlan) -> Bool {
        let blockMembers = Array(memberBlock.members)
        let planMembers = plan.originalMembers.map(\.syntax)

        guard blockMembers.count == planMembers.count else { return false }

        return zip(blockMembers, planMembers).allSatisfy { $0.id == $1.id }
    }

    private func reorderMemberBlock(
        _ memberBlock: MemberBlockSyntax,
        using plan: TypeRewritePlan
    ) -> MemberBlockSyntax {
        guard !plan.reorderedMembers.isEmpty else { return memberBlock }

        let originalFirst = plan.originalMembers.first?.syntax
        let originalFirstTrivia = originalFirst?.leadingTrivia ?? []

        var reorderedItems: [MemberBlockItemSyntax] = []

        for (index, syntaxMember) in plan.reorderedMembers.enumerated() {
            var item = syntaxMember.syntax

            if index == 0 {
                item = item.with(\.leadingTrivia, originalFirstTrivia)
            } else if syntaxMember.syntax.id == originalFirst?.id {
                let normalizedTrivia = inferLeadingTrivia(from: plan.originalMembers)
                item = item.with(\.leadingTrivia, normalizedTrivia)
            }

            reorderedItems.append(item)
        }

        let newMembers = MemberBlockItemListSyntax(reorderedItems)
        return memberBlock.with(\.members, newMembers)
    }

    private func inferLeadingTrivia(from members: [SyntaxMemberDeclaration]) -> Trivia {
        guard members.count > 1 else {
            return .newline
        }

        let secondMember = members[1].syntax
        return secondMember.leadingTrivia
    }
}
