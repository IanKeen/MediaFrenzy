//
//  Errors+LocalizedDescription.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-12-05.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import Foundation

extension ViewModel.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidImageNumber: return "Invalid number of images"
        case .invalidSize: return "Invalid image size"
        }
    }
}

extension ImageSourceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidImage: return "Error processing a received image"
        }
    }
}
