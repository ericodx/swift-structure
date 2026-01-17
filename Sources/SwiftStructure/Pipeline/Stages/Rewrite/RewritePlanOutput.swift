import SwiftSyntax

struct RewritePlanOutput {
    let path: String
    let syntax: SourceFileSyntax
    let plans: [TypeRewritePlan]

    var needsRewriting: Bool {
        plans.contains { $0.needsRewriting }
    }
}
