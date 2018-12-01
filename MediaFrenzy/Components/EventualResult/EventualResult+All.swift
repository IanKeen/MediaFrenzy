//
//  EventualResult+All.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import Foundation

extension Collection {
    /// Perform a sequence of `EventualResult`s sequentially
    ///
    /// - Parameters:
    ///   - queue: `DispatchQueue` the result will be delivered on. defaults to main
    ///   - progress: An optional closure that reports the progress of all the `EventualResult`s (0.0 to 1.0)
    /// - Returns: A new `EventualResult` with an array of the values if all were successful, otherwise a failed `EventualResult` with the reason
    func allSerially<T>(
        deliverOn queue: DispatchQueue = .main,
        progress: ((Float) -> Void)? = nil
        ) -> EventualResult<[T]> where Element == EventualResult<T>
    {
        let all: [EventualResult<[T]>] = enumerated().map { item in
            let value = Float(item.offset) / Float(count)
            return item.element
                .map(deliverOn: queue, { [$0] })
                .do(deliverOn: queue) { progress?(value) }
        }
        
        guard let head = all.first else {
            return EventualResult<[T]>(.success([])).do(deliverOn: queue) { progress?(1.0) }
        }
        
        return all.dropFirst().reduce(head) { current, next in
            return current.flatMap(deliverOn: queue) { value in
                return next.map(deliverOn: queue) { value + $0 }
            }
        }.do(deliverOn: queue) { progress?(1.0) }
    }
}
