import SwiftSyntax

final class UnifiedMemberDiscoveryVisitor<Builder: MemberOutputBuilder>: SyntaxVisitor {

    init(sourceLocationConverter: SourceLocationConverter, builder: Builder) {
        self.sourceLocationConverter = sourceLocationConverter
        self.builder = builder
        super.init(viewMode: .sourceAccurate)
    }

    private(set) var members: [Builder.Output] = []
    private let sourceLocationConverter: SourceLocationConverter
    private let builder: Builder
    private var currentItem: MemberBlockItemSyntax?
    private var depth = 0

    func process(_ item: MemberBlockItemSyntax) {
        currentItem = item
        walk(item)
        currentItem = nil
    }

    // MARK: - Properties

    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }

        let isStatic = node.modifiers.contains { $0.name.tokenKind == .keyword(.static) }
        let isClass = node.modifiers.contains { $0.name.tokenKind == .keyword(.class) }
        let kind: MemberKind = (isStatic || isClass) ? .typeProperty : .instanceProperty
        let visibility = extractVisibility(from: node.modifiers)
        let isAnnotated = !node.attributes.isEmpty

        for binding in node.bindings {
            let name = binding.pattern.description.trimmingCharacters(in: .whitespaces)
            record(
                MemberDiscoveryInfo(
                    name: name,
                    kind: kind,
                    position: node.positionAfterSkippingLeadingTrivia,
                    item: item,
                    visibility: visibility,
                    isAnnotated: isAnnotated
                ))
        }

        return .skipChildren
    }

    // MARK: - Initializers

    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(
            MemberDiscoveryInfo(
                name: "init",
                kind: .initializer,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: extractVisibility(from: node.modifiers),
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    override func visit(_ node: DeinitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(
            MemberDiscoveryInfo(
                name: "deinit",
                kind: .deinitializer,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: .internal,
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    // MARK: - Methods

    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }

        let isStatic = node.modifiers.contains { $0.name.tokenKind == .keyword(.static) }
        let isClass = node.modifiers.contains { $0.name.tokenKind == .keyword(.class) }
        let kind: MemberKind = (isStatic || isClass) ? .typeMethod : .instanceMethod

        record(
            MemberDiscoveryInfo(
                name: node.name.text,
                kind: kind,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: extractVisibility(from: node.modifiers),
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    override func visit(_ node: SubscriptDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(
            MemberDiscoveryInfo(
                name: "subscript",
                kind: .subscript,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: extractVisibility(from: node.modifiers),
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    // MARK: - Type Aliases

    override func visit(_ node: TypeAliasDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(
            MemberDiscoveryInfo(
                name: node.name.text,
                kind: .typealias,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: extractVisibility(from: node.modifiers),
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    override func visit(_ node: AssociatedTypeDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(
            MemberDiscoveryInfo(
                name: node.name.text,
                kind: .associatedtype,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: .internal,
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    // MARK: - Nested Types

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0, let item = currentItem {
            record(
                MemberDiscoveryInfo(
                    name: node.name.text,
                    kind: .subtype,
                    position: node.positionAfterSkippingLeadingTrivia,
                    item: item,
                    visibility: extractVisibility(from: node.modifiers),
                    isAnnotated: !node.attributes.isEmpty
                ))
        }
        depth += 1
        return .visitChildren
    }

    override func visitPost(_ node: ClassDeclSyntax) {
        depth -= 1
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0, let item = currentItem {
            record(
                MemberDiscoveryInfo(
                    name: node.name.text,
                    kind: .subtype,
                    position: node.positionAfterSkippingLeadingTrivia,
                    item: item,
                    visibility: extractVisibility(from: node.modifiers),
                    isAnnotated: !node.attributes.isEmpty
                ))
        }
        depth += 1
        return .visitChildren
    }

    override func visitPost(_ node: StructDeclSyntax) {
        depth -= 1
    }

    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0, let item = currentItem {
            record(
                MemberDiscoveryInfo(
                    name: node.name.text,
                    kind: .subtype,
                    position: node.positionAfterSkippingLeadingTrivia,
                    item: item,
                    visibility: extractVisibility(from: node.modifiers),
                    isAnnotated: !node.attributes.isEmpty
                ))
        }
        depth += 1
        return .visitChildren
    }

    override func visitPost(_ node: EnumDeclSyntax) {
        depth -= 1
    }

    override func visit(_ node: ActorDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0, let item = currentItem {
            record(
                MemberDiscoveryInfo(
                    name: node.name.text,
                    kind: .subtype,
                    position: node.positionAfterSkippingLeadingTrivia,
                    item: item,
                    visibility: extractVisibility(from: node.modifiers),
                    isAnnotated: !node.attributes.isEmpty
                ))
        }
        depth += 1
        return .visitChildren
    }

    override func visitPost(_ node: ActorDeclSyntax) {
        depth -= 1
    }

    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0, let item = currentItem {
            record(
                MemberDiscoveryInfo(
                    name: node.name.text,
                    kind: .subtype,
                    position: node.positionAfterSkippingLeadingTrivia,
                    item: item,
                    visibility: extractVisibility(from: node.modifiers),
                    isAnnotated: !node.attributes.isEmpty
                ))
        }
        depth += 1
        return .visitChildren
    }

    override func visitPost(_ node: ProtocolDeclSyntax) {
        depth -= 1
    }

    // MARK: - Private Helpers

    private func record(_ info: MemberDiscoveryInfo) {
        let output = builder.build(from: info, using: sourceLocationConverter)
        members.append(output)
    }

    private func extractVisibility(from modifiers: DeclModifierListSyntax) -> Visibility {
        for modifier in modifiers {
            switch modifier.name.tokenKind {
            case .keyword(.open):
                return .open
            case .keyword(.public):
                return .public
            case .keyword(.internal):
                return .internal
            case .keyword(.fileprivate):
                return .fileprivate
            case .keyword(.private):
                return .private
            default:
                continue
            }
        }
        return .internal
    }
}

// MARK: - Convenience Factory Methods

extension UnifiedMemberDiscoveryVisitor where Builder == MemberDeclarationBuilder {
    static func forDeclarations(
        converter: SourceLocationConverter
    ) -> UnifiedMemberDiscoveryVisitor<MemberDeclarationBuilder> {
        UnifiedMemberDiscoveryVisitor(
            sourceLocationConverter: converter,
            builder: MemberDeclarationBuilder()
        )
    }
}

extension UnifiedMemberDiscoveryVisitor where Builder == SyntaxMemberDeclarationBuilder {
    static func forSyntaxDeclarations(
        converter: SourceLocationConverter
    ) -> UnifiedMemberDiscoveryVisitor<SyntaxMemberDeclarationBuilder> {
        UnifiedMemberDiscoveryVisitor(
            sourceLocationConverter: converter,
            builder: SyntaxMemberDeclarationBuilder()
        )
    }
}
