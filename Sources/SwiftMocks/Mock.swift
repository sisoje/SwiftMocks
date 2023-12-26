//
//  File.swift
//
//
//  Created by Lazar Otasevic on 25.12.23..
//

import Foundation

public struct MockNormal<ArgumentType, ReturnType> {
    public init() {}
    public var block: ((ArgumentType) -> ReturnType)!
    public var callsHistory: [ArgumentType] = []
    public mutating func record(_ arguments: ArgumentType) -> ReturnType {
        callsHistory.append(arguments)
        return block(arguments)
    }
}

public struct MockThrowing<ArgumentType, ReturnType> {
    public init() {}
    public var block: ((ArgumentType) throws -> ReturnType)!
    public var callsHistory: [ArgumentType] = []
    public mutating func record(_ arguments: ArgumentType) throws -> ReturnType {
        callsHistory.append(arguments)
        return try block(arguments)
    }
}

public struct MockAsyncThrowing<ArgumentType, ReturnType> {
    public init() {}
    public var block: ((ArgumentType) async throws -> ReturnType)!
    public var callsHistory: [ArgumentType] = []
    public mutating func record(_ arguments: ArgumentType) async throws -> ReturnType {
        callsHistory.append(arguments)
        return try await block(arguments)
    }
}

public struct MockAsync<ArgumentType, ReturnType> {
    public init() {}
    public var block: ((ArgumentType) async -> ReturnType)!
    public var callsHistory: [ArgumentType] = []
    public mutating func record(_ arguments: ArgumentType) async -> ReturnType {
        callsHistory.append(arguments)
        return await block(arguments)
    }
}

public struct MockVariable<VarType> {
    public init() {}
    public var setter: MockNormal<VarType, Void> = .init()
    public var getter: MockNormal<Void, VarType> = .init()
}
