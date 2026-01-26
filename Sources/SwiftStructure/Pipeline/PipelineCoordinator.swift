actor PipelineCoordinator {

    private let fileIO: FileIOActor
    private let configuration: Configuration

    init(fileIO: FileIOActor, configuration: Configuration) {
        self.fileIO = fileIO
        self.configuration = configuration
    }

    // MARK: - Check Operation

    struct CheckResult: Sendable {
        let path: String
        let results: [TypeReorderResult]
        let needsReorder: Bool
    }

    func checkFiles(_ paths: [String]) async throws -> [CheckResult] {
        let pipeline = ParseStage()
            .then(ClassifyStage())
            .then(ReorderStage(configuration: configuration))

        return try await withThrowingTaskGroup(of: CheckResult.self) { group in
            for path in paths {
                group.addTask {
                    let source = try await self.fileIO.read(at: path)
                    let input = ParseInput(path: path, source: source)
                    let output = try pipeline.process(input)
                    let needsReorder = output.results.contains { $0.needsReordering }
                    return CheckResult(path: path, results: output.results, needsReorder: needsReorder)
                }
            }

            var results: [CheckResult] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }
    }

    // MARK: - Fix Operation

    struct FixResult: Sendable {
        let path: String
        let source: String
        let modified: Bool
    }

    func fixFiles(_ paths: [String], dryRun: Bool) async throws -> [FixResult] {
        let pipeline = ParseStage()
            .then(SyntaxClassifyStage())
            .then(RewritePlanStage(configuration: configuration))
            .then(ApplyRewriteStage())

        return try await withThrowingTaskGroup(of: FixResult.self) { group in
            for path in paths {
                group.addTask {
                    let source = try await self.fileIO.read(at: path)
                    let input = ParseInput(path: path, source: source)
                    let output = try pipeline.process(input)

                    if output.modified && !dryRun {
                        try await self.fileIO.write(output.source, to: path)
                    }

                    return FixResult(path: path, source: output.source, modified: output.modified)
                }
            }

            var results: [FixResult] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }
    }
}
