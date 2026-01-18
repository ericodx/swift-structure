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
        let visibility = extractVisibility(from: node.modifiers)
        let isAnnotated = !node.attributes.isEmpty

        for binding in node.bindings {
            let name = binding.pattern.description.trimmingCharacters(in: .whitespaces)
            record(
                MemberRecordInfo(
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

    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(
            MemberRecordInfo(
                name: "init",
                kind: .initializer,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: extractVisibility(from: node.modifiers),
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }

        let isStatic = node.modifiers.contains { $0.name.tokenKind == .keyword(.static) }
        let isClass = node.modifiers.contains { $0.name.tokenKind == .keyword(.class) }
        let kind: MemberKind = (isStatic || isClass) ? .typeMethod : .instanceMethod

        record(
            MemberRecordInfo(
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
            MemberRecordInfo(
                name: "subscript",
                kind: .subscript,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: extractVisibility(from: node.modifiers),
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    override func visit(_ node: TypeAliasDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(
            MemberRecordInfo(
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
            MemberRecordInfo(
                name: node.name.text,
                kind: .associatedtype,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: .internal,
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    override func visit(_ node: DeinitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        guard depth == 0, let item = currentItem else { return .skipChildren }
        record(
            MemberRecordInfo(
                name: "deinit",
                kind: .deinitializer,
                position: node.positionAfterSkippingLeadingTrivia,
                item: item,
                visibility: .internal,
                isAnnotated: !node.attributes.isEmpty
            ))
        return .skipChildren
    }

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        if depth == 0, let item = currentItem {
            record(
                MemberRecordInfo(
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
                MemberRecordInfo(
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
                MemberRecordInfo(
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
                MemberRecordInfo(
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
                MemberRecordInfo(
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

    private func record(_ info: MemberRecordInfo) {
        let location = sourceLocationConverter.location(for: info.position)
        let declaration = MemberDeclaration(
            name: info.name,
            kind: info.kind,
            line: location.line,
            visibility: info.visibility,
            isAnnotated: info.isAnnotated
        )
        members.append(SyntaxMemberDeclaration(declaration: declaration, syntax: info.item))
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
