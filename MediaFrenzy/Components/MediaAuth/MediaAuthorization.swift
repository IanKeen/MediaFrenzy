//
//  MediaAuthorization.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import Foundation

/// The possible authorization states
///
/// - pending: Authorization has not been requested yet
/// - blocked: User has explicitly rejected or switched off access
/// - granted: Authorization granted
enum MediaAuthorizationStatus {
    case pending, blocked, granted
}

protocol MediaAuthorization {
    typealias MediaBlockedClosure = (@escaping () -> Void) -> Void
    typealias CompleteClosure = () -> Void

    /// Obtain the current authorization status
    func authorizationStatus() -> MediaAuthorizationStatus

    /// Explicitly request authorization and complete with the current status
    func requestAuthorization(_ handler: @escaping (MediaAuthorizationStatus) -> Void)

    /// Ensures authorization has been granted before performing a closure
    ///
    /// - Parameter blocked: Callback called when authorization has been blocked, a function is provided that can be called to retry
    /// - Parameter complete: Callback called only when authorization has been granted
    func whenAuthorized(blocked: @escaping MediaBlockedClosure, complete: @escaping CompleteClosure)
}
