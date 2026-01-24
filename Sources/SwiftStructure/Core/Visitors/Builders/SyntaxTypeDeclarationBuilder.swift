import SwiftSyntax

struct SyntaxTypeDeclarationBuilder: TypeOutputBuilder {
    let memberBuilder = SyntaxMemberDeclarationBuilder()

    func build(
        from info: TypeDiscoveryInfo<SyntaxMemberDeclaration>,
        using converter: SourceLocationConverter
    ) -> SyntaxTypeDeclaration {
        let location = converter.location(for: info.position)
        return SyntaxTypeDeclaration(
            name: info.name,
            kind: info.kind,
            line: location.line,
            members: info.members,
            memberBlock: info.memberBlock
        )
    }
}
