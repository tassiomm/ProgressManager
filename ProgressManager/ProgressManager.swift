//
//  ProgressManager.swift
//
//  Created by Tassio Marques on 14/02/19.
//

import Foundation
import UIKit

protocol ProgressManagerDelegate {
    func progressInfo(forProgressManager progressManager: ProgressManager) -> ProgressInfo
    func progressDidFinish(forProgressManager progressManager: ProgressManager)
}

struct ProgressInfo {
    let text: String
    let startTime: Date
    let timeleft: Double
    let maxTime: Double
}

class ProgressManager {
    enum ProgressDirection {
        case increasing
        case decreasing
    }
    
    enum ProgressSmoothness: Int {
        case veryLow = 10
        case low = 100
        case medium = 500
        case high = 1000
        case veryHigh = 10000
    }
    
    var direction: ProgressDirection = .increasing
    var smoothness: ProgressSmoothness = .high
    var shouldRestartAutomatically: Bool = true
    var delegate: ProgressManagerDelegate?
    
    private var partsPerSecond: Int {
        return smoothness.rawValue
    }
    
    // MARK: - Info
    private var progressInfo: ProgressInfo
    private var label: UILabel
    private var progressView: UIProgressView
    private var progressTimer: Timer?
    
    private init() {
        label = UILabel()
        progressView = UIProgressView()
        progressInfo = ProgressInfo(text: "", startTime: Date(), timeleft: 0.0, maxTime: 0.0)
    }
    
    init(progressInfo: ProgressInfo, label: UILabel, progressView: UIProgressView) {
        self.progressInfo = progressInfo
        self.label = label
        self.progressView = progressView
    }
    
    func start() {
        if progressInfo.timeleft > progressInfo.maxTime || progressInfo.timeleft < 0.0 { return }
        updateLabel()
        runProgressBar(sec: progressInfo.maxTime)
    }
    
    func stop() {
        progressTimer?.invalidate()
    }
    
    func restart(withInfo info: ProgressInfo) {
        stop()
        progressInfo = info
        start()
    }
    
    private func updateLabel() {
        label.text = progressInfo.text
    }
    
    private func runProgressBar(sec seconds: Double) {
        setProgressBarToStartPoint()
        correctProgressBarDelay()
        runTimer(forSeconds: seconds)
    }
    
    private func runTimer(forSeconds seconds: Double) {
        let timeInterval = seconds/Double(partsPerSecond)
        let progInterval: Float = progressionFactor()/Float(partsPerSecond)
        progressTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { timer in
            self.progressView.progress += progInterval
            
            if self.isProgressBarFinished() {
                self.progressTimer?.invalidate()
                self.delegate?.progressDidFinish(forProgressManager: self)
                
                if self.shouldRestartAutomatically,
                    let info = self.delegate?.progressInfo(forProgressManager: self) {
                    self.progressInfo = info
                    self.start()
                }
            }
        })
    }
    
    private func setProgressBarToStartPoint() {
        progressView.progress = direction == .decreasing ? 1.0 : 0.0
    }
    
    private func isProgressBarFinished() -> Bool {
        return direction == .decreasing ? progressView.progress <= 0.0 : progressView.progress >= 1.0
    }
    
    private func progressionFactor() -> Float {
        return direction == .decreasing ? -1.0 : 1.0
    }
    
    private func correctProgressBarDelay() {
        progressView.progress += calcCorrectionTimeForProgressBar() * progressionFactor()
    }
    
    private func calculateLostTime() -> Float {
        let startTime = progressInfo.startTime
        let diffFromCurrent = Date().seconds(from: startTime)
        let lostTime = Int(progressInfo.maxTime) - (Int(progressInfo.timeleft) - diffFromCurrent)
        return Float(lostTime)
    }
    
    private func calcCorrectionTimeForProgressBar() -> Float {
        let lostTime = calculateLostTime()
        return lostTime/Float(progressInfo.maxTime)
    }
    
    deinit {
        print(":: \(String(describing: self)) :: Deallocated from Memory ::")
    }
}

extension Date {
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}
