import SwiftSyntax

struct SyntaxClassifyStage: Stage {
    func process(_ input: ParseOutput) throws -> SyntaxClassifyOutput {
        let visitor = SyntaxTypeDiscoveryVisitor(sourceLocationConverter: input.locationConverter)
        visitor.walk(input.syntax)
        return SyntaxClassifyOutput(path: input.path, syntax: input.syntax, declarations: visitor.declarations)
    }
}
