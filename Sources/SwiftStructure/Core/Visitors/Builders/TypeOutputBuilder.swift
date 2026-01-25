import SwiftSyntax

protocol TypeOutputBuilder: Sendable {
    associatedtype MemberBuilder: MemberOutputBuilder
    associatedtype Output: Sendable

    var memberBuilder: MemberBuilder { get }

    func build(from info: TypeDiscoveryInfo<MemberBuilder.Output>, using converter: SourceLocationConverter) -> Output
}
