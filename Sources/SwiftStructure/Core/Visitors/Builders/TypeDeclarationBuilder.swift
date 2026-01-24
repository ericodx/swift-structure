import SwiftSyntax

struct TypeDeclarationBuilder: TypeOutputBuilder {
    let memberBuilder = MemberDeclarationBuilder()

    func build(
        from info: TypeDiscoveryInfo<MemberDeclaration>,
        using converter: SourceLocationConverter
    ) -> TypeDeclaration {
        let location = converter.location(for: info.position)
        return TypeDeclaration(
            name: info.name,
            kind: info.kind,
            line: location.line,
            members: info.members
        )
    }
}
