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
    @IBOutlet weak var titleLabel: UILabel!
    
    var stopwatch: Stopwatch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Details"
        self.titleLabel.text = StopwatchController.formatDate(date: stopwatch.startDate!)
        
        self.startLabel.text = StopwatchController.formatTime(date: stopwatch.startDate!)
        self.endLabel.text = StopwatchController.formatTime(date: stopwatch.endDate!)
        self.durationLabel.text = StopwatchController.formatTimeInterval(stopwatch.duration, shouldIncludeTenthSecs: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
