//
//  Cancellable.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

/// Represents something that can be cancelled
public protocol Cancellable {
    func cancel()
}

/// Convenience namespace for common `Cancellable` factory functions
public enum Cancellables { }

public extension Cancellables {
    /// Create a `Cancellable` whose `cancel()` function executes the code in the provided closure
    public static func create(_ cancel: @escaping () -> Void) -> Cancellable {
        return AnyCancellable(cancel: cancel)
    }
    
    /// Create a `Cancellable` whose `cancel()` function does nothing
    public static func noop() -> Cancellable {
        return AnyCancellable { }
    }
}

private struct AnyCancellable: Cancellable {
    private let _cancel: () -> Void
    
    public init(cancel: @escaping () -> Void) {
        self._cancel = cancel
    }
    public func cancel() { _cancel() }
}
