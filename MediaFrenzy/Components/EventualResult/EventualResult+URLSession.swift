//
//  EventualResult+URLSession.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import Foundation

extension URLSession {
    func response(from request: URLRequest) -> EventualResult<Data> {
        return .init { resolver in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    resolver.resolveWith(error: error)
                } else {
                    resolver.resolveWith(value: data ?? .init())
                }
            }
            
            task.resume()
            
            return Cancellables.create(task.cancel)
        }
    }
}
