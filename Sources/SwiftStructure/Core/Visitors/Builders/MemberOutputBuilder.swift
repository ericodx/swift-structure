import SwiftSyntax

protocol MemberOutputBuilder {
    associatedtype Output
    func build(from info: MemberDiscoveryInfo, using converter: SourceLocationConverter) -> Output
}
