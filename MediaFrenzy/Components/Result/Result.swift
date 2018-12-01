//
//  Result.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

/// Represents the result of an operation that can either succeed or fail
public enum Result<T> {
    case success(T)
    case failure(Error)
    
    /// Create a `Result` from the outcome of a throwing function
    public static func attempt(_ function: () throws -> T) -> Result<T> {
        do { return .success(try function()) }
        catch let error { return .failure(error) }
    }
    
    /// Create a successful `Result`
    public init(_ value: T) {
        self = .success(value)
    }
    
    /// Create a failed `Result`
    public init(_ error: Error) {
        self = .failure(error)
    }
    
    /// Attempt to obtain a successful value from the receiver
    ///
    /// - Returns: The value is this `Result` is successful, otherwise it will throw
    /// - Throws: The `Error` if this `Result` was a failure
    public func value() throws -> T {
        switch self {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
    
    /// Returns a new `Result` mapping successful values with the provided closure,
    /// or passing through existing errors.
    ///
    /// If the provided closure throws the new `Result` will be a failure with the thrown error.
    public func map<U>(_ transform: (T) throws -> U) -> Result<U> {
        return flatMap { try .success(transform($0)) }
    }
    
    /// Returns the `Result` of applying the provided closure to successful values,
    /// or passing through existing errors.
    ///
    /// If the provided closure throws the new `Result` will be a failure with the thrown error.
    public func flatMap<U>(_ transform: (T) throws -> Result<U>) -> Result<U> {
        do { return try transform(value()) }
        catch { return .failure(error) }
    }
}
