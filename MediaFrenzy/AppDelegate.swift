//
//  AppDelegate.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let viewModel = ViewModel(
            mediaAuth: PHLibraryAuthorization(),
            imageSource: Unsplash(urlSession: URLSession.shared),
            imageSaver: MediaLibrarySaver()
        )
        
        let viewController = ViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}

