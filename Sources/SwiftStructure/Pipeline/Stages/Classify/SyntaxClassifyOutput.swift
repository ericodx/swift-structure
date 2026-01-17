import SwiftSyntax

struct SyntaxClassifyOutput {
    let path: String
    let syntax: SourceFileSyntax
    let declarations: [SyntaxTypeDeclaration]
}
