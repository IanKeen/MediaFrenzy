//
//  View.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import UIKit

class View: UIView {
    enum State {
        case working(Float), waiting
    }
    
    @IBOutlet private(set) var imageCount: UITextField!
    @IBOutlet private(set) var imageWidth: UITextField!
    @IBOutlet private(set) var imageHeight: UITextField!
    
    @IBOutlet private(set) var frenzyProgress: UIProgressView!
    @IBOutlet private(set) var frenzyStatus: UILabel!
    
    @IBOutlet private var actionButton: UIButton!
    
    var state: State = .waiting {
        didSet {
            switch state {
            case .waiting:
                actionButton.setTitle("Start the Frenzy!", for: .normal)
                frenzyProgress.isHidden = true
                frenzyProgress.progress = 0.0
                frenzyStatus.text = nil
                [imageCount, imageWidth, imageHeight].forEach { $0.isUserInteractionEnabled = true }

            case .working(let progress):
                actionButton.setTitle("Stop", for: .normal)
                frenzyProgress.isHidden = false
                frenzyProgress.progress = progress
                frenzyStatus.text = String(format: "Working... (%.2f%%)", (progress * 100.0))
                [imageCount, imageWidth, imageHeight].forEach { $0.isUserInteractionEnabled = false }
            }
        }
    }
}
