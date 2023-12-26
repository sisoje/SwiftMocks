import SwiftSyntax
import SwiftSyntaxBuilder

struct FunctionMockableDeclarationFactory {
    @MemberBlockItemListBuilder
    func callTrackerDeclarations(_ functions: [FunctionDeclSyntax]) -> MemberBlockItemListSyntax {
        for function in functions {
            let params = function.signature.parameterClause.parameters
                .map { $0.type }
                .map { type in
                    GenericParameterSyntax(name: TokenSyntax(stringLiteral: type.description))
                }
            let returnType = function.signature.returnClause?.type.description ?? "Void"
            
            let voidOne = GenericParameterSyntax(name: TokenSyntax(stringLiteral: "Void"))
            
            let pa = GenericParameterListSyntax(params.count == 0 ? [voidOne] : params).map { p in
                p.description
            }.joined(separator: ", ")
            
            let structName = if isAsyncThrowsFuction(function) {
                "MockAsyncThrowing"
            } else if isThrowingFuction(function) {
                "MockThrowing"
            } else if isAsyncFuction(function) {
                "MockAsync"
            } else {
                "MockNormal"
            }

            VariableDeclSyntax(
                modifiers: DeclModifierListSyntax([.init(name: .identifier(""))]),
                .var,
                name: PatternSyntax(stringLiteral: function.name.text + "Calls = \(structName)<(\(pa)), \(returnType)>()")
            )
        }
    }
    
    @MemberBlockItemListBuilder
    func mockImplementations(for functions: [FunctionDeclSyntax]) -> MemberBlockItemListSyntax {
        for function in functions {
            let paramsValues = function.signature.parameterClause.parameters
                .map {
                    $0.secondName?.text != nil ? $0.secondName!.text : $0.firstName.text
                }
            
            let tryStringLiteral = if isAsyncThrowsFuction(function) {
                "try await "
            } else if isThrowingFuction(function) {
                "try "
            } else if isAsyncFuction(function) {
                "await "
            } else {
                ""
            }
            
            FunctionDeclSyntax(
                attributes: function.attributes,
                modifiers: function.modifiers,
                funcKeyword: function.funcKeyword,
                name: function.name,
                genericParameterClause: function.genericParameterClause,
                signature: function.signature,
                genericWhereClause: function.genericWhereClause
            ) {
                CodeBlockItemSyntax(stringLiteral: tryStringLiteral + function.name.text + "Calls." + "record((\(paramsValues.joined(separator: ", "))))")
            }
        }
    }
    
    @MemberBlockItemListBuilder
    func protoDeclarations(for functions: [FunctionDeclSyntax]) -> MemberBlockItemListSyntax {
        for function in functions {
            FunctionDeclSyntax(
                attributes: function.attributes,
                modifiers: function.modifiers,
                funcKeyword: function.funcKeyword,
                name: function.name,
                genericParameterClause: function.genericParameterClause,
                signature: function.signature,
                genericWhereClause: function.genericWhereClause
            )
        }
    }
    
    @MemberBlockItemListBuilder
    func protoDeclarationsExt(for functions: [FunctionDeclSyntax]) -> MemberBlockItemListSyntax {
        for function in functions {
            FunctionDeclSyntax(
                attributes: function.attributes,
                modifiers: function.modifiers,
                funcKeyword: function.funcKeyword,
                name: function.name,
                genericParameterClause: function.genericParameterClause,
                signature: function.signature,
                genericWhereClause: function.genericWhereClause
            )
            {
                CodeBlockItemSyntax(stringLiteral: " fatalError() ")
            }
        }
    }
    
    private func isThrowingFuction(_ function: FunctionDeclSyntax) -> Bool {
        function.signature.effectSpecifiers?.throwsSpecifier?.text == "throws"
    }
    
    private func isAsyncFuction(_ function: FunctionDeclSyntax) -> Bool {
        function.signature.effectSpecifiers?.asyncSpecifier?.text == "async"
    }
    
    private func isAsyncThrowsFuction(_ function: FunctionDeclSyntax) -> Bool {
        isThrowingFuction(function) && isAsyncFuction(function)
    }
}
