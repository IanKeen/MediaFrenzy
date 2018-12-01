//
//  ImageSource.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import UIKit

enum ImageSourceError: Error {
    case invalidImage
}

protocol ImageSource {
    func retrieveImage(sized size: CGSize) -> EventualResult<Data>
}
