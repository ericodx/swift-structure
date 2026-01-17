import SwiftParser
import SwiftSyntax

@testable import SwiftStructure

func makeParseOutput(source: String, path: String = "Test.swift") -> ParseOutput {
    let syntax = Parser.parse(source: source)
    let converter = SourceLocationConverter(fileName: path, tree: syntax)
    return ParseOutput(path: path, syntax: syntax, locationConverter: converter)
}

func discoverTypes(in source: String) -> [TypeDeclaration] {
    let syntax = Parser.parse(source: source)
    let converter = SourceLocationConverter(fileName: "Test.swift", tree: syntax)
    let visitor = TypeDiscoveryVisitor(sourceLocationConverter: converter)
    visitor.walk(syntax)
    return visitor.declarations
}

func classify(_ source: String) throws -> ClassifyOutput {
    let parseOutput = makeParseOutput(source: source)
    let stage = ClassifyStage()
    return try stage.process(parseOutput)
}

func discoverMembers(in source: String) -> [MemberDeclaration] {
    let wrappedSource = "struct Test {\n\(source)\n}"
    let syntax = Parser.parse(source: wrappedSource)
    let converter = SourceLocationConverter(fileName: "Test.swift", tree: syntax)

    guard let structDecl = syntax.statements.first?.item.as(StructDeclSyntax.self) else {
        return []
    }

    let visitor = MemberDiscoveryVisitor(sourceLocationConverter: converter)
    visitor.walk(structDecl.memberBlock)
    return visitor.members
}

func discoverMembersInProtocol(in source: String) -> [MemberDeclaration] {
    let wrappedSource = "protocol Test {\n\(source)\n}"
    let syntax = Parser.parse(source: wrappedSource)
    let converter = SourceLocationConverter(fileName: "Test.swift", tree: syntax)

    guard let protocolDecl = syntax.statements.first?.item.as(ProtocolDeclSyntax.self) else {
        return []
    }

    let visitor = MemberDiscoveryVisitor(sourceLocationConverter: converter)
    visitor.walk(protocolDecl.memberBlock)
    return visitor.members
}
