//
//  EventualResult.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import Foundation

class EventualResult<T> {
    private var result: Result<T>?
    private let operation: (Resolver) -> Cancellable
    
    class Resolver {
        private let resolution: (Result<T>) -> Void
        
        fileprivate init(resolution: @escaping (Result<T>) -> Void) {
            self.resolution = resolution
        }
        
        func resolveWith(error: Error) { resolution(.failure(error)) }
        func resolveWith(value: T) { resolution(.success(value)) }
        func resolveWith(result: Result<T>) { resolution(result) }
    }
    
    // MARK: - Lifecycle
    init(_ operation: @escaping (Resolver) -> Cancellable) {
        self.operation = operation
    }
    convenience init(_ result: Result<T>) {
        self.init { resolver in
            resolver.resolveWith(result: result)
            return Cancellables.noop()
        }
    }
    
    // MARK: - Public
    /// Execute the operation and wait for the `Result<T>`
    ///
    /// - Parameters:
    ///   - queue: `DispatchQueue` the result will be delivered on. defaults to main
    ///   - complete: Callback providing a `Result<T>` representing the result
    func execute(deliverOn queue: DispatchQueue = .main, _ complete: @escaping (Result<T>) -> Void) -> Cancellable {
        if let result = result {
            queue.async { complete(result) }
            return Cancellables.noop()
            
        } else {
            let resolver = Resolver { [weak self] result in
                self?.result = result
                queue.async { complete(result) }
            }
            return operation(resolver)
        }
    }
}

extension EventualResult {
    /// Transforms successful values from one type to another
    ///
    /// - Parameters:
    ///   - queue: `DispatchQueue` the result will be delivered on. defaults to main
    ///   - transform: Closure to attempt to transform `T` to another type
    /// - Returns: A new `EventualResult` with the new value if successful, otherwise a failed `EventualResult` with the reason
    func map<U>(deliverOn queue: DispatchQueue = .main, _ transform: @escaping (T) throws -> U) -> EventualResult<U> {
        return .init { resolver in
            return self.execute(deliverOn: queue, { result in
                resolver.resolveWith(result: result.map(transform))
            })
        }
    }
    
    /// Transforms successful values into a new `EventualResult`
    ///
    /// - Parameters:
    ///   - queue: `DispatchQueue` the result will be delivered on. defaults to main
    ///   - transform: Closure to attempt to transform `T` into a new `EventualResult`
    /// - Returns: A new `EventualResult` if sucessful, otherwise a failed `EventualResult` with the reason
    func flatMap<U>(deliverOn queue: DispatchQueue = .main, _ transform: @escaping (T) -> EventualResult<U>) -> EventualResult<U> {
        return .init { resolver in
            var cancellable: Cancellable?
            
            cancellable = self.execute(deliverOn: queue, { result in
                switch result {
                case .success(let value):
                    cancellable = transform(value).execute(deliverOn: queue, resolver.resolveWith(result:))
                case .failure(let error):
                    resolver.resolveWith(error: error)
                }
            })
            
            return Cancellables.create {
                cancellable?.cancel()
            }
        }
    }
}
