import SwiftSyntax

final class MemberDiscoveryVisitor: SyntaxVisitor {

    init(sourceLocationConverter: SourceLocationConverter) {
        self.sourceLocationConverter = sourceLocationConverter
        super.init(viewMode: .sourceAccurate)
    }

    private(set) var members: [MemberDeclaration] = []
    private let sourceLocationConverter: SourceLocationConverter
    private var depth = 0

    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0 else { return .skipChildren }

        let isStatic = node.modifiers.contains { $0.name.tokenKind == .keyword(.static) }

        for binding in node.bindings {
            let name = binding.pattern.description.trimmingCharacters(in: .whitespaces)
            let isComputed = binding.accessorBlock != nil
            let kind: MemberKind

            if isStatic {
                kind = .staticProperty
            } else if isComputed {
                kind = .computedProperty
            } else {
                kind = .storedProperty
            }

            record(name: name, kind: kind, position: node.positionAfterSkippingLeadingTrivia)
        }

        return .skipChildren
    }

    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0 else { return .skipChildren }
        record(name: "init", kind: .initializer, position: node.positionAfterSkippingLeadingTrivia)
        return .skipChildren
    }

    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0 else { return .skipChildren }

        let isStatic = node.modifiers.contains { $0.name.tokenKind == .keyword(.static) }
        let kind: MemberKind = isStatic ? .staticMethod : .method

        record(name: node.name.text, kind: kind, position: node.positionAfterSkippingLeadingTrivia)
        return .skipChildren
    }

    override func visit(_ node: SubscriptDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0 else { return .skipChildren }
        record(name: "subscript", kind: .subscript, position: node.positionAfterSkippingLeadingTrivia)
        return .skipChildren
    }

    override func visit(_ node: TypeAliasDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0 else { return .skipChildren }
        record(name: node.name.text, kind: .typeAlias, position: node.positionAfterSkippingLeadingTrivia)
        return .skipChildren
    }

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0 {
            record(name: node.name.text, kind: .nestedType, position: node.positionAfterSkippingLeadingTrivia)
        }
        depth += 1
        return .visitChildren
    }

    override func visitPost(_ node: ClassDeclSyntax) {
        depth -= 1
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0 {
            record(name: node.name.text, kind: .nestedType, position: node.positionAfterSkippingLeadingTrivia)
        }
        depth += 1
        return .visitChildren
    }

    override func visitPost(_ node: StructDeclSyntax) {
        depth -= 1
    }

    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0 {
            record(name: node.name.text, kind: .nestedType, position: node.positionAfterSkippingLeadingTrivia)
        }
        depth += 1
        return .visitChildren
    }

    override func visitPost(_ node: EnumDeclSyntax) {
        depth -= 1
    }

    override func visit(_ node: ActorDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0 {
            record(name: node.name.text, kind: .nestedType, position: node.positionAfterSkippingLeadingTrivia)
        }
        depth += 1
        return .visitChildren
    }

    override func visitPost(_ node: ActorDeclSyntax) {
        depth -= 1
    }

    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0 {
            record(name: node.name.text, kind: .nestedType, position: node.positionAfterSkippingLeadingTrivia)
        }
        depth += 1
        return .visitChildren
    }

    override func visitPost(_ node: ProtocolDeclSyntax) {
        depth -= 1
    }

    private func record(name: String, kind: MemberKind, position: AbsolutePosition) {
        let location = sourceLocationConverter.location(for: position)
        members.append(MemberDeclaration(name: name, kind: kind, line: location.line))
    }
}
