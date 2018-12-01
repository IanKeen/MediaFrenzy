//
//  ViewController.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Private Properties
    private var customView: View { return view as! View }
    private let viewModel: ViewModel
    
    // MARK: - Lifecycle
    required init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "MediaFrenzy"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.state = .waiting
    }
    
    // MARK: - Private Functions
    private func start() {
        let count = customView.imageCount.text.intOrZero
        let width = customView.imageWidth.text.intOrZero
        let height = customView.imageHeight.text.intOrZero
        
        viewModel.saveImages(
            number: count,
            sized: .init(width: width, height: height),
            progress: { [unowned self] progress in
                self.customView.state = .working(progress)
            },
            blocked: { [unowned self] retry in
                self.showBlocked(retry: retry)
            },
            complete: { [unowned self] result in
                self.customView.state = .waiting
                
                switch result {
                case .success:
                    self.showSuccess()
                case .failure(let error):
                    self.show(error: error)
                }
            }
        )
    }
    
    // MARK: - IBActions
    @IBAction private func actionTouchUpInside(_ sender: UIButton) {
        UIApplication.shared.keyWindow?.endEditing(true)
        
        switch customView.state {
        case .waiting:
            start()
        case .working:
            viewModel.cancel()
            customView.state = .waiting
        }
    }
    
    // MARK: - Prompts
    private func showSuccess() {
        let controller = UIAlertController(title: "Complete", message: "Images saved.", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(controller, animated: true)
    }
    private func show(error: Error) {
        let controller = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel))
        controller.addAction(UIAlertAction(title: "Restart", style: .default, handler: { [unowned self] _ in self.start() }))
        present(controller, animated: true)
    }
    private func showBlocked(retry: @escaping () -> Void) {
        let controller = UIAlertController(
            title: "Error",
            message: "Access to photo libraries to blocked",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in })
        controller.addAction(okAction)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url)
        }
        controller.addAction(settingsAction)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            retry()
        }
        controller.addAction(retryAction)
        
        present(controller, animated: true)
    }
}
