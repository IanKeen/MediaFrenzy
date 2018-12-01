//
//  ImageSaver.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import Foundation

protocol ImageSaver {
    func save(data: Data) -> EventualResult<Void>
}
