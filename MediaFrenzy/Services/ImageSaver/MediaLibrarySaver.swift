//
//  MediaLibrarySaver.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import AssetsLibrary

final class MediaLibrarySaver: ImageSaver {
    private let library = ALAssetsLibrary()

    func save(data: Data) -> EventualResult<Void> {
        return .init { [library] resolver in
            library.writeImageData(toSavedPhotosAlbum: data, metadata: nil) { _, error in
                if let error = error {
                    resolver.resolveWith(error: error)
                } else {
                    resolver.resolveWith(value: ())
                }
            }
            
            return Cancellables.noop()
        }
    }
}
