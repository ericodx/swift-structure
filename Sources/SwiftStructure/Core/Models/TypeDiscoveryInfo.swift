import SwiftSyntax

struct TypeDiscoveryInfo<MemberOutput> {
    let name: String
    let kind: TypeKind
    let position: AbsolutePosition
    let members: [MemberOutput]
    let memberBlock: MemberBlockSyntax
}
