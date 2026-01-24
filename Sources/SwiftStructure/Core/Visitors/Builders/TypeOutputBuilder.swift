import SwiftSyntax

protocol TypeOutputBuilder {
    associatedtype MemberBuilder: MemberOutputBuilder
    associatedtype Output

    var memberBuilder: MemberBuilder { get }

    func build(from info: TypeDiscoveryInfo<MemberBuilder.Output>, using converter: SourceLocationConverter) -> Output
}
