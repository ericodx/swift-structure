import SwiftSyntax

final class SyntaxMemberDiscoveryVisitor: SyntaxVisitor {

    init(sourceLocationConverter: SourceLocationConverter) {
        self.sourceLocationConverter = sourceLocationConverter
        super.init(viewMode: .sourceAccurate)
    }

    private(set) var members: [SyntaxMemberDeclaration] = []
    private let sourceLocationConverter: SourceLocationConverter
    private var currentItem: MemberBlockItemSyntax?
    private var depth = 0

    func process(_ item: MemberBlockItemSyntax) {
        currentItem = item
        walk(item)
        currentItem = nil
    }

    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }

        let isStatic = node.modifiers.contains { $0.name.tokenKind == .keyword(.static) }
        let isClass = node.modifiers.contains { $0.name.tokenKind == .keyword(.class) }
        let kind: MemberKind = (isStatic || isClass) ? .typeProperty : .instanceProperty

        for binding in node.bindings {
            let name = binding.pattern.description.trimmingCharacters(in: .whitespaces)
            record(name: name, kind: kind, position: node.positionAfterSkippingLeadingTrivia, item: item)
        }

        return .skipChildren
    }

    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(name: "init", kind: .initializer, position: node.positionAfterSkippingLeadingTrivia, item: item)
        return .skipChildren
    }

    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }

        let isStatic = node.modifiers.contains { $0.name.tokenKind == .keyword(.static) }
        let isClass = node.modifiers.contains { $0.name.tokenKind == .keyword(.class) }
        let kind: MemberKind = (isStatic || isClass) ? .typeMethod : .instanceMethod

        record(name: node.name.text, kind: kind, position: node.positionAfterSkippingLeadingTrivia, item: item)
        return .skipChildren
    }

    override func visit(_ node: SubscriptDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(name: "subscript", kind: .subscript, position: node.positionAfterSkippingLeadingTrivia, item: item)
        return .skipChildren
    }

    override func visit(_ node: TypeAliasDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(name: node.name.text, kind: .typealias, position: node.positionAfterSkippingLeadingTrivia, item: item)
        return .skipChildren
    }

    override func visit(_ node: AssociatedTypeDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(
            name: node.name.text,
            kind: .associatedtype,
            position: node.positionAfterSkippingLeadingTrivia,
            item: item
        )
        return .skipChildren
    }

    override func visit(_ node: DeinitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(name: "deinit", kind: .deinitializer, position: node.positionAfterSkippingLeadingTrivia, item: item)
        return .skipChildren
    }

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0, let item = currentItem {
            record(name: node.name.text, kind: .subtype, position: node.positionAfterSkippingLeadingTrivia, item: item)
        }
        depth += 1
        return .visitChildren
    }

    override func visitPost(_ node: ClassDeclSyntax) {
        depth -= 1
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0, let item = currentItem {
            record(name: node.name.text, kind: .subtype, position: node.positionAfterSkippingLeadingTrivia, item: item)
        }
        depth += 1
        return .visitChildren
    }

    override func visitPost(_ node: StructDeclSyntax) {
        depth -= 1
    }

    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0, let item = currentItem {
            record(name: node.name.text, kind: .subtype, position: node.positionAfterSkippingLeadingTrivia, item: item)
        }
        depth += 1
        return .visitChildren
    }

    override func visitPost(_ node: EnumDeclSyntax) {
        depth -= 1
    }

    override func visit(_ node: ActorDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0, let item = currentItem {
            record(name: node.name.text, kind: .subtype, position: node.positionAfterSkippingLeadingTrivia, item: item)
        }
        depth += 1
        return .visitChildren
    }

    override func visitPost(_ node: ActorDeclSyntax) {
        depth -= 1
    }

    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0, let item = currentItem {
            record(name: node.name.text, kind: .subtype, position: node.positionAfterSkippingLeadingTrivia, item: item)
        }
        depth += 1
        return .visitChildren
    }

    override func visitPost(_ node: ProtocolDeclSyntax) {
        depth -= 1
    }

    private func record(name: String, kind: MemberKind, position: AbsolutePosition, item: MemberBlockItemSyntax) {
        let location = sourceLocationConverter.location(for: position)
        let declaration = MemberDeclaration(name: name, kind: kind, line: location.line)
        members.append(SyntaxMemberDeclaration(declaration: declaration, syntax: item))
    }
}
