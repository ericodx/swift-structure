import SwiftSyntax

final class TypeDiscoveryVisitor: SyntaxVisitor {

    init(sourceLocationConverter: SourceLocationConverter) {
        self.sourceLocationConverter = sourceLocationConverter
        super.init(viewMode: .sourceAccurate)
    }

    private(set) var declarations: [TypeDeclaration] = []
    private let sourceLocationConverter: SourceLocationConverter

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        record(name: node.name.text, kind: .class, position: node.positionAfterSkippingLeadingTrivia)
        return .visitChildren
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        record(name: node.name.text, kind: .struct, position: node.positionAfterSkippingLeadingTrivia)
        return .visitChildren
    }

    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        record(name: node.name.text, kind: .enum, position: node.positionAfterSkippingLeadingTrivia)
        return .visitChildren
    }

    override func visit(_ node: ActorDeclSyntax) -> SyntaxVisitorContinueKind {
        record(name: node.name.text, kind: .actor, position: node.positionAfterSkippingLeadingTrivia)
        return .visitChildren
    }

    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        record(name: node.name.text, kind: .protocol, position: node.positionAfterSkippingLeadingTrivia)
        return .visitChildren
    }

    private func record(name: String, kind: TypeKind, position: AbsolutePosition) {
        let location = sourceLocationConverter.location(for: position)
        declarations.append(TypeDeclaration(name: name, kind: kind, line: location.line))
    }
}
