struct ReportStage: Stage {
    func process(_ input: ClassifyOutput) throws -> ReportOutput {
        var lines: [String] = []
        lines.append("\(input.path):")

        if input.declarations.isEmpty {
            lines.append("  (no type declarations)")
        } else {
            for decl in input.declarations {
                lines.append("  \(decl.kind.rawValue) \(decl.name) (line \(decl.line))")
            }
        }

        return ReportOutput(
            path: input.path,
            text: lines.joined(separator: "\n"),
            declarationCount: input.declarations.count
        )
    }
}
