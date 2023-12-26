import SwiftSyntax
import SwiftSyntaxMacros

public struct SwiftMocksMacro: MemberMacro, PeerMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard let classDecl = declaration.as(ExtensionDeclSyntax.self) else { return [] }
        guard let protocolName = classDecl.inheritanceClause?.inheritedTypes.trimmedDescription else { return [] }
        return [
            DeclSyntax(MockedClassDeclFactory().makeProto(protocname: .identifier(protocolName), from: classDecl)),
            // DeclSyntax(MockedClassDeclFactory().makeProtoExt(protocname: .identifier(protocolName), from: classDecl)),
        ]
    }

    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let classDecl = declaration.as(ExtensionDeclSyntax.self) else { return [] }
        guard let protocolName = classDecl.inheritanceClause?.inheritedTypes.trimmedDescription else { return [] }
        return [
            // DeclSyntax(MockedVariableDeclFactory().make(protocolName: .identifier(protocolName), typeName: mockClassName, from: classDecl)),
            DeclSyntax(MockedClassDeclFactory().make(protocolName: .identifier(protocolName), from: classDecl)),
        ]
    }
}
