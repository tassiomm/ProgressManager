//
//  ViewController.swift
//  Progress Bar
//
//  Created by Tassio Marques on 11/03/19.
//  Copyright © 2019 ProgressManager. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupPM()
    }
    
    private func setupPM(){
        let progressInfo = ProgressInfo(text: "111111", startTime: Date(), timeleft: 10.0, maxTime: 10.0)
        let progManager = ProgressManager(progressInfo: progressInfo, label: label, progressView: progressView)
        
        progManager.smoothness = .high
        progManager.direction = .increasing
        progManager.shouldResetAutomatically = false
        progManager.delegate = self
        
        progManager.start()
    }
    
    func getRandomStringNumber() -> String {
        return String(arc4random_uniform(900000) + 100000)
    }
}

extension ViewController: ProgressManagerDelegate {
    func progressInfo(forProgressManager progressManager: ProgressManager) -> ProgressInfo {
        return ProgressInfo(text: getRandomStringNumber(), startTime: Date(), timeleft: 9.0, maxTime: 10.0)
    }
    
    func progressDidFinish(forProgressManager progressManager: ProgressManager) {
        print(":: Did finish progress ::")
        progressManager.reset(withInfo: ProgressInfo(text: getRandomStringNumber(), startTime: Date(), timeleft: 5.0, maxTime: 10.0))
    }
}

