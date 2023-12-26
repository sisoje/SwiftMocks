import SwiftSyntax
import SwiftSyntaxBuilder

struct MockVariableDeclarationFactory {
    @MemberBlockItemListBuilder
    func mockVariableDeclarations(_ variables: [VariableDeclSyntax]) -> MemberBlockItemListSyntax {
        for variable in variables {
            mockVariableDeclaration(variable)
        }
    }

    @MemberBlockItemListBuilder
    func mockVariableDeclaration(_ variable: VariableDeclSyntax) -> MemberBlockItemListSyntax {
        if let binding = variable.bindings.first, let type = binding.typeAnnotation?.type.description {
            
            let pat: PatternSyntax = "\(raw: binding.pattern)Vars"
            VariableDeclSyntax(
                bindingSpecifier: .keyword(.var),
                bindings: .init(
                    arrayLiteral: PatternBindingSyntax(
                        pattern: pat,
                        typeAnnotation: TypeAnnotationSyntax(type: TypeSyntax(stringLiteral: "MockVariable<\(type)>")),
                        initializer: InitializerClauseSyntax(value: ExprSyntax(stringLiteral: ".init()"))
                    )
                )
            )
        }
    }
    
    @MemberBlockItemListBuilder
    func mockVariableDeclarations2(_ variables: [VariableDeclSyntax]) -> MemberBlockItemListSyntax {
        for variable in variables {
            mockVariableDeclaration2(variable)
        }
    }
    
    @MemberBlockItemListBuilder
    func mockVariableDeclaration2(_ variable: VariableDeclSyntax) -> MemberBlockItemListSyntax {
        if let binding = variable.bindings.first, let type = binding.typeAnnotation?.type.description {
            VariableDeclSyntax(
                bindingSpecifier: .keyword(.var),
                bindings: .init(
                    arrayLiteral: PatternBindingSyntax(
                        pattern: binding.pattern,
                        typeAnnotation: TypeAnnotationSyntax(type: TypeSyntax(stringLiteral: type)),
                        initializer: InitializerClauseSyntax(equal: "", value: ExprSyntax(stringLiteral: "{ get { \( binding.pattern)Vars.getter.record(()) } set { \( binding.pattern)Vars.setter.record((newValue)) }  }"))
                    )
                )
            )
        }
    }
}
