//
//  DetailsViewController.swift
//  Arbeitszeiten
//
//  Created by Lukas Bischof on 14.03.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var pauseDurationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var stopwatch: Stopwatch!
    var stopwatchEditingCopy: Stopwatch?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Details"
        setup()
    }
    
    func setup() {
        self.titleLabel.text = StopwatchController.formatDate(date: stopwatch.startDate!)
        
        self.startLabel.text = StopwatchController.formatTime(date: stopwatch.startDate!)
        self.endLabel.text = StopwatchController.formatTime(date: stopwatch.endDate!)
        self.durationLabel.text = StopwatchController.formatTimeInterval(stopwatch.duration, shouldIncludeTenthSecs: false)
        self.pauseDurationLabel.text = StopwatchController.formatTimeInterval(stopwatch.pauseDuration, shouldIncludeTenthSecs: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(segue: UIStoryboardSegue) {
        StopwatchController.sharedController.save()
        setup()
        stopwatchEditingCopy = nil
    }
    
    @IBAction func cancel(segue: UIStoryboardSegue) {
        stopwatch = stopwatchEditingCopy!
        stopwatchEditingCopy = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editViewControllerSegue" {
            let destination = segue.destination as! EditViewController
            stopwatchEditingCopy = stopwatch.copy() as? Stopwatch
            destination.stopwatch = stopwatch
        }
    }
}
