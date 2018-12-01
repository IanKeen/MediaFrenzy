//
//  PHLibraryAuthorization.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import Photos

private extension MediaAuthorizationStatus {
    init(from status: PHAuthorizationStatus) {
        switch status {
        case .notDetermined: self = .pending
        case .authorized: self = .granted
        case .denied, .restricted: self = .blocked
        }
    }
}

class PHLibraryAuthorization: MediaAuthorization {
    func authorizationStatus() -> MediaAuthorizationStatus {
        return MediaAuthorizationStatus(from: PHPhotoLibrary.authorizationStatus())
    }
    func requestAuthorization(_ handler: @escaping (MediaAuthorizationStatus) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                handler(MediaAuthorizationStatus(from: status))
            }
        }
    }

    func whenAuthorized(blocked: @escaping MediaAuthorization.MediaBlockedClosure, complete: @escaping MediaAuthorization.CompleteClosure) {
        switch authorizationStatus() {
        case .granted:
            complete()
            
        case .blocked:
            blocked { [weak self] in
                self?.requestAuthorization { _ in
                    self?.whenAuthorized(blocked: blocked, complete: complete)
                }
            }

        case .pending:
            requestAuthorization { [weak self] _ in
                self?.whenAuthorized(blocked: blocked, complete: complete)
            }
        }
    }
}
