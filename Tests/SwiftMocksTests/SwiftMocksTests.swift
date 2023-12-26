import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import SwiftMocksMacros
import SwiftMocks

let testMacros: [String: Macro.Type] = [
    "Mock": SwiftMocksMacro.self,
]

final class MockTests: XCTestCase {
    func testMacro() {
        assertMacroExpansion(
            """
            class MyClass {}
            @Mock
            extension MyClass {
                func doAction() {}
            }
            """,
            expandedSource: """
            class MyClass {}
            extension MyClass {
                func doAction() {}
            
                static let mock = MyClassMock()

                class MyClassMock {
                     var doActionCalls = MockNormal<(Void), Void>()
                        func doAction() {
                        doActionCalls.record(())
                    }
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testMacroWithThrows() {
        assertMacroExpansion(
            """
            @Mock
            class MyClass {
                func doAction() throws {}
            }
            """,
            expandedSource: """
            class MyClass {
                func doAction() throws {}
            
                let mock = MyClassMock()
            
                class MyClassMock {
                     var doActionCalls = ThrowingMock<(Void), Void>()
                        func doAction() throws {
                        try doActionCalls.record(())
                    }
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testMacroWithFunctionParameters() {
        assertMacroExpansion(
            """
            @Mock
            class MyClass {
                func doAction(withInteger x: Int) {}
            }
            """,
            expandedSource: """
            class MyClass {
                func doAction(withInteger x: Int) {}
            
                let mock = MyClassMock()
            
                class MyClassMock {
                     var doActionCalls = Mock<(Int), Void>()
                        func doAction(withInteger x: Int) {
                        doActionCalls.record((x))
                    }
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testMacroWithVariables() {
        assertMacroExpansion(
            """
            @Mock
            class MyClass {
                var priority: Int { 0 }
            }
            """,
            expandedSource: """
            class MyClass {
                var priority: Int { 0 }
            
                let mock = MyClassMock()
            
                class MyClassMock {
                    var priority: MockVariable<Int > = .init()
                }
            }
            """,
            macros: testMacros
        )
    }
}
