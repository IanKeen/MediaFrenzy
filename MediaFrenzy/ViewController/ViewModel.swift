//
//  ViewModel.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import UIKit

class ViewModel {
    enum Error: Swift.Error {
        case invalidImageNumber, invalidSize
    }
    
    // MARK: - Private Properties
    private let mediaAuth: MediaAuthorization
    private let imageSource: ImageSource
    private let imageSaver: ImageSaver
    private var operation: Cancellable?
    
    // MARK: - Lifecycle
    init(mediaAuth: MediaAuthorization, imageSource: ImageSource, imageSaver: ImageSaver) {
        self.mediaAuth = mediaAuth
        self.imageSource = imageSource
        self.imageSaver = imageSaver
    }
    
    // MARK: - Public Properties
    func saveImages(
        number: Int,
        sized size: CGSize,
        progress: @escaping (Float) -> Void,
        blocked: @escaping (@escaping () -> Void) -> Void,
        complete: @escaping (Result<Void>) -> Void
        )
    {
        guard number > 0 else { return complete(.failure(Error.invalidImageNumber)) }
        guard size.width > 0, size.height > 0 else { return complete(.failure(Error.invalidSize)) }
        
        mediaAuth.whenAuthorized(
            blocked: blocked,
            complete: { [unowned self] in
                let operations = (0..<number).map { _ in
                    return self.imageSource
                        .retrieveImage(sized: size)
                        .flatMap { self.imageSaver.save(data: $0) }
                    }
                    .allSerially(progress: progress)
                    .map { _ in () }
                
                self.operation = operations.execute(complete)
            }
        )
    }
    func cancel() {
        operation?.cancel()
    }
}
