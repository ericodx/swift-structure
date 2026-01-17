import SwiftSyntax

final class TypeDiscoveryVisitor: SyntaxVisitor {

    init(sourceLocationConverter: SourceLocationConverter) {
        self.sourceLocationConverter = sourceLocationConverter
        super.init(viewMode: .sourceAccurate)
    }

    private(set) var declarations: [TypeDeclaration] = []
    private let sourceLocationConverter: SourceLocationConverter

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let members = discoverMembers(in: node.memberBlock)
        let position = node.positionAfterSkippingLeadingTrivia
        record(name: node.name.text, kind: .class, position: position, members: members)
        return .visitChildren
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        let members = discoverMembers(in: node.memberBlock)
        let position = node.positionAfterSkippingLeadingTrivia
        record(name: node.name.text, kind: .struct, position: position, members: members)
        return .visitChildren
    }

    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        let members = discoverMembers(in: node.memberBlock)
        let position = node.positionAfterSkippingLeadingTrivia
        record(name: node.name.text, kind: .enum, position: position, members: members)
        return .visitChildren
    }

    override func visit(_ node: ActorDeclSyntax) -> SyntaxVisitorContinueKind {
        let members = discoverMembers(in: node.memberBlock)
        let position = node.positionAfterSkippingLeadingTrivia
        record(name: node.name.text, kind: .actor, position: position, members: members)
        return .visitChildren
    }

    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        let members = discoverMembers(in: node.memberBlock)
        let position = node.positionAfterSkippingLeadingTrivia
        record(name: node.name.text, kind: .protocol, position: position, members: members)
        return .visitChildren
    }

    private func discoverMembers(in memberBlock: MemberBlockSyntax) -> [MemberDeclaration] {
        let visitor = MemberDiscoveryVisitor(sourceLocationConverter: sourceLocationConverter)
        visitor.walk(memberBlock)
        return visitor.members
    }

    private func record(name: String, kind: TypeKind, position: AbsolutePosition, members: [MemberDeclaration]) {
        let location = sourceLocationConverter.location(for: position)
        declarations.append(TypeDeclaration(name: name, kind: kind, line: location.line, members: members))
    }
}
