import Foundation
import Yams

struct ConfigurationLoader {

    func parse(_ content: String) throws -> RawConfiguration {
        let yaml = try Yams.load(yaml: content) as? [String: Any] ?? [:]

        let version = yaml["version"] as? Int ?? 1
        let memberRules = parseOrderingRules(from: yaml)
        let (strategy, respectBoundaries) = parseExtensions(from: yaml)

        return RawConfiguration(
            version: version,
            memberRules: memberRules,
            extensionsStrategy: strategy,
            respectBoundaries: respectBoundaries
        )
    }

    private func parseOrderingRules(from yaml: [String: Any]) -> [RawMemberRule] {
        guard let orderingDict = yaml["ordering"] as? [String: Any],
            let members = orderingDict["members"] as? [Any]
        else {
            return []
        }

        return members.compactMap { parseRule(from: $0) }
    }

    private func parseRule(from value: Any) -> RawMemberRule? {
        if let simpleKind = value as? String {
            return .simple(simpleKind)
        }

        if let dict = value as? [String: Any] {
            if let propertyDict = dict["property"] as? [String: Any] {
                return .property(
                    annotated: propertyDict["annotated"] as? Bool,
                    visibility: propertyDict["visibility"] as? String
                )
            }
            if let methodDict = dict["method"] as? [String: Any] {
                return .method(
                    kind: methodDict["kind"] as? String,
                    visibility: methodDict["visibility"] as? String,
                    annotated: methodDict["annotated"] as? Bool
                )
            }
        }

        return nil
    }

    private func parseExtensions(from yaml: [String: Any]) -> (String?, Bool?) {
        guard let extensionsDict = yaml["extensions"] as? [String: Any] else {
            return (nil, nil)
        }

        let strategy = extensionsDict["strategy"] as? String
        let respectBoundaries = extensionsDict["respect_boundaries"] as? Bool

        return (strategy, respectBoundaries)
    }
}
