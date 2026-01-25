import SwiftSyntax

protocol MemberOutputBuilder: Sendable {
    associatedtype Output: Sendable
    func build(from info: MemberDiscoveryInfo, using converter: SourceLocationConverter) -> Output
}
