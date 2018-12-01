//
//  String+Int.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-12-05.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import Foundation

extension String {
    var intOrZero: Int {
        return Int(self) ?? 0
    }
}

extension Optional where Wrapped == String {
    var intOrZero: Int {
        switch self {
        case let value?: return value.intOrZero
        case nil: return 0
        }
    }
}
