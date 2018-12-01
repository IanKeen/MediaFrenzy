//
//  EventualResult+Do.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-12-05.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import Foundation

extension EventualResult {
    /// Perform a side effect with a successful value
    ///
    /// - Parameters:
    ///   - queue: `DispatchQueue` the side effect will be performed on. defaults to main
    ///   - sideEffect: The side effect to perform
    func `do`(deliverOn queue: DispatchQueue = .main, _ sideEffect: @escaping (T) -> Void) -> EventualResult {
        return map(deliverOn: queue) { value in
            sideEffect(value)
            return value
        }
    }
    
    /// Perform a side effect with a successful value
    ///
    /// - Parameters:
    ///   - queue: `DispatchQueue` the side effect will be performed on. defaults to main
    ///   - sideEffect: The side effect to perform
    func `do`(deliverOn queue: DispatchQueue = .main, _ sideEffect: @escaping () -> Void) -> EventualResult {
        return map(deliverOn: queue) { value in
            sideEffect()
            return value
        }
    }
}
