import SwiftSyntax

struct ClassifyStage: Stage {
    func process(_ input: ParseOutput) throws -> ClassifyOutput {
        let visitor = TypeDiscoveryVisitor(sourceLocationConverter: input.locationConverter)
        visitor.walk(input.syntax)
        return ClassifyOutput(path: input.path, declarations: visitor.declarations)
    }
}
