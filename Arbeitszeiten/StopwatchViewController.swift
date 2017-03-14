//
//  FirstViewController.swift
//  Arbeitszeiten
//
//  Created by Lukas Bischof on 09.03.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController {

    @IBOutlet weak var toggleTimerButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    let stopwatchController = StopwatchController.sharedController
    var timerThread: Thread!
    var shouldStopThread: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toggleTimerButton.layer.cornerRadius = self.toggleTimerButton.frame.width / 2.0
        self.toggleTimerButton.layer.borderWidth = 1.0
        self.toggleTimerButton.layer.borderColor = UIColor.blue.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(StopwatchViewController.applicationDidBecomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reenableToggleTimerButton()
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        reenableToggleTimerButton()
    }
    
    func reenableToggleTimerButton() {
        if !toggleTimerButton.isEnabled {
            toggleTimerButton.setTitle("Start", for: .normal)
            toggleTimerButton.isEnabled = true
            toggleTimerButton.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    @IBAction func toggleTimerButtonPressed(_ sender: UIButton) {
        if !stopwatchController.currentStopwatch.hasStarted {
            startStopwatch(stopwatchController.currentStopwatch)
        } else if !stopwatchController.currentStopwatch.hasStopped {
            stopStopwatch(stopwatchController.currentStopwatch)
        }
    }
    
    internal func startStopwatch(_ stopwatch: Stopwatch) -> Void {
        stopwatch.start()
        timerLabel.textColor = UIColor.black
        timerLabel.text = "00:00:00"
        toggleTimerButton.setTitle("Stop", for: .normal)
        
        shouldStopThread = false
        timerThread = Thread(target: self, selector: #selector(StopwatchViewController.timerThreadMain), object: nil)
        timerThread.start()
    }
    
    internal func stopStopwatch(_ stopwatch: Stopwatch) -> Void {
        shouldStopThread = true
        
        stopwatch.stop()
        toggleTimerButton.setTitle("Gestoppt", for: .normal)
        toggleTimerButton.isEnabled = false
        toggleTimerButton.layer.borderColor = UIColor.lightGray.cgColor
        timerLabel.text = StopwatchController.formatTimeInterval(stopwatch.duration, shouldIncludeTenthSecs: true)
        
        stopwatchController.addStopwatch(stopwatch)
        stopwatchController.currentStopwatch = Stopwatch()
        stopwatchController.save()
    }
    
    internal func timerThreadMain() -> Swift.Void {
        autoreleasepool {
            repeat {
                let seconds = Date().timeIntervalSinceReferenceDate
                let secondsToWait = 0.1 - (seconds - (Double(Int(seconds * 10.0)) / 10.0))
                
                DispatchQueue.main.async(execute: {
                    self.timerLabel.text = StopwatchController.formatTimeInterval(self.stopwatchController.currentStopwatch.passedTime, shouldIncludeTenthSecs: true)
                })
                
                Thread.sleep(forTimeInterval: secondsToWait)
            } while !shouldStopThread
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

