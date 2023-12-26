import SwiftMocks

class KL {}

@Mock
extension KL: MockType2 {}

@Mock
extension KL: MockType {
    var x: Int { 0 }

    func compl(_ int: Int, _ c: String) -> (Float, Double) {
        (0, 0)
    }

    func compl2(_ int: Int) -> Float {
        0
    }
    
    func compl3(_ int: Int) {
        print(int)
    }

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
k.compl3Mock.block = { print($0 + 5) }
k.sayNormalMock.block = { print("") }
k.sayThrowsMock.block = { print("") }
k.sayAsyncMock.block = { print("") }
k.sayAsyncThrowsMock.block = { print("") }
k.sayNormal()
try k.sayThrows()
await k.sayAsync()
try await k.sayAsyncThrows()

print(k.sayAsyncMock.numberOfCalls)
