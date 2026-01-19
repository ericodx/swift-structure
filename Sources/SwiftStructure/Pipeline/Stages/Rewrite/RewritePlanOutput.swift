import SwiftSyntax

struct RewritePlanOutput: Sendable {
    let path: String
    let syntax: SourceFileSyntax
    let plans: [TypeRewritePlan]

    var needsRewriting: Bool {
        plans.contains { $0.needsRewriting }
    }
}
