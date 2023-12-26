import SwiftMocks

class KL {}

@Mock
extension KL: MockType {
    var x: Int { 0 }
    func sayNormal() {
        print("")
    }
    
    func sayThrows() throws {
        print("")
    }
    
    func sayAsync() async {
        print("")
    }
    
    func sayAsyncThrows() async throws {
        print("")
    }
}

let k = KL.MockTypeMocked()
k.sayNormalCalls.block = { _ in print("") }
k.sayThrowsCalls.block = { _ in print("") }
k.sayAsyncCalls.block = { _ in print("") }
k.sayAsyncThrowsCalls.block = { _ in print("") }
k.sayNormal()
try k.sayThrows()
await k.sayAsync()
try await k.sayAsyncThrows()

print(k.sayAsyncCalls.callsHistory)

// @Mock class MyClass {
//    var priority: Int { mock.priority.getter.record() }
//    func doSomething() { mock.doSomething() }
//    func perform(with param: Int) -> String {
//        mock.perform(with: param)
//    }
// }
//
// let myClass = MyClass()
// myClass.mock.priority.getter.mockCall { 1 }
// print(myClass.priority) // prints `1`
// myClass.doSomething()
// print(myClass.mock.doSomethingCalls.callsCount == 1) // prints `true`
// myClass.mock.performCalls.mockCall { param in
//    "mocked => \(param)"
// }
// print(myClass.perform(with: 1)) // prints `mocked => 1`
