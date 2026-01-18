import Foundation
import Yams

struct ConfigurationLoader {

    init(fileReader: FileReading = FileReader()) {
        self.fileReader = fileReader
    }

    private let fileReader: FileReading
    private let configFileName = ".swift-structure.yaml"

    func load(from directory: String? = nil) throws -> Configuration {
        let startDirectory = directory ?? FileManager.default.currentDirectoryPath

        guard let configPath = findConfigFile(startingFrom: startDirectory) else {
            return .default
        }

        let content = try fileReader.read(at: configPath)
        return try parse(content)
    }

    private func findConfigFile(startingFrom directory: String) -> String? {
        var currentPath = URL(fileURLWithPath: directory).standardized

        while currentPath.path != "/" {
            let configPath = currentPath.appendingPathComponent(configFileName).path
            if FileManager.default.fileExists(atPath: configPath) {
                return configPath
            }
            currentPath = currentPath.deletingLastPathComponent()
        }

        return nil
    }

    func parse(_ content: String) throws -> Configuration {
        let yaml = try Yams.load(yaml: content) as? [String: Any] ?? [:]

        let version = yaml["version"] as? Int ?? 1
        let rules = parseOrderingRules(from: yaml)
        let (strategy, respectBoundaries) = parseExtensions(from: yaml)

        return Configuration(
            version: version,
            memberOrderingRules: rules,
            extensionsStrategy: strategy,
            respectBoundaries: respectBoundaries
        )
    }

    private func parseOrderingRules(from yaml: [String: Any]) -> [MemberOrderingRule] {
        guard let orderingDict = yaml["ordering"] as? [String: Any],
            let members = orderingDict["members"] as? [Any]
        else {
            return MemberKind.allCases.map { .simple($0) }
        }

        var rules: [MemberOrderingRule] = []

        for member in members {
            if let rule = parseRule(from: member) {
                rules.append(rule)
            }
        }

        return rules.isEmpty ? MemberKind.allCases.map { .simple($0) } : rules
    }

    private func parseRule(from value: Any) -> MemberOrderingRule? {
        if let simpleKind = value as? String {
            if let kind = MemberKind(rawValue: simpleKind) {
                return .simple(kind)
            }
            return nil
        }

        if let dict = value as? [String: Any] {
            if let propertyDict = dict["property"] as? [String: Any] {
                return parsePropertyRule(from: propertyDict)
            }
            if let methodDict = dict["method"] as? [String: Any] {
                return parseMethodRule(from: methodDict)
            }
        }

        return nil
    }

    private func parsePropertyRule(from dict: [String: Any]) -> MemberOrderingRule {
        let annotated = dict["annotated"] as? Bool
        let visibility = parseVisibility(from: dict["visibility"])
        return .property(annotated: annotated, visibility: visibility)
    }

    private func parseMethodRule(from dict: [String: Any]) -> MemberOrderingRule {
        let kind = parseMethodKind(from: dict["kind"])
        let visibility = parseVisibility(from: dict["visibility"])
        return .method(kind: kind, visibility: visibility)
    }

    private func parseVisibility(from value: Any?) -> Visibility? {
        guard let str = value as? String else { return nil }
        return Visibility(rawValue: str)
    }

    private func parseMethodKind(from value: Any?) -> MethodKind? {
        guard let str = value as? String else { return nil }
        return MethodKind(rawValue: str)
    }

    private func parseExtensions(from yaml: [String: Any]) -> (ExtensionsStrategy, Bool) {
        guard let extensionsDict = yaml["extensions"] as? [String: Any] else {
            return (.separate, true)
        }

        let strategyStr = extensionsDict["strategy"] as? String ?? "separate"
        let strategy = ExtensionsStrategy(rawValue: strategyStr) ?? .separate
        let respectBoundaries = extensionsDict["respect_boundaries"] as? Bool ?? true

        return (strategy, respectBoundaries)
    }
}
