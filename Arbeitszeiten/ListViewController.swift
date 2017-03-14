//
//  SecondViewController.swift
//  Arbeitszeiten
//
//  Created by Lukas Bischof on 09.03.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import UIKit

let optimalTime = 8.0 * ONE_HOUR

class ListViewController: UITableViewController {

    @IBOutlet weak var overtimeSummary: UIBarButtonItem!
    let stopwatchController = StopwatchController.sharedController
    var stopwatchesByMonth: [String: [Stopwatch]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.stopwatchesByMonth = stopwatchController.getStopwatchesByMonth()
        overtimeSummary.isEnabled = false
        
        self.tableView.register(UINib(nibName: "Header", bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: "headerNib")
        
        
    }
    
    func calculateOvertime() -> TimeInterval {
        var overtime: TimeInterval = 0.0
        
        for month in stopwatchesByMonth {
            month.value.forEach({ (stopwatch) in
                overtime += stopwatch.duration - optimalTime
            })
        }
        
        return overtime
    }
    
    func formatOvertime(_ _overtime: TimeInterval) -> String {
        var overtime = _overtime
        let isNegative = overtime < 0.0
        var prefix = "+"
        if isNegative {
            overtime = -overtime
            prefix = "-"
        }

        return "\(prefix)\(StopwatchController.formatTimeInterval(overtime, shouldIncludeTenthSecs: false))"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let overtime = calculateOvertime()
        
        self.stopwatchesByMonth = stopwatchController.getStopwatchesByMonth()
        self.overtimeSummary.title = formatOvertime(overtime)
        
        if overtime > 0.0 {
            self.overtimeSummary.tintColor = UIColor.red
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return stopwatchesByMonth.count
    }
    
    func monthForSectionIndex(section: Int) -> String {
        var index = stopwatchesByMonth.startIndex
        stopwatchesByMonth.formIndex(&index, offsetBy: section)
        return stopwatchesByMonth.keys[index]
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return monthForSectionIndex(section: section)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerNib") else {
            return nil
        }
        
        var overtime: TimeInterval = 0.0
        let month = monthForSectionIndex(section: section)
        for stopwatch in stopwatchesByMonth[month]! {
            overtime += stopwatch.duration - optimalTime
        }
        
        let detailLabel = header.viewWithTag(2) as? UILabel
        detailLabel?.text = formatOvertime(overtime)
        
        if overtime > 0.0 {
            detailLabel?.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        } else {
            detailLabel?.textColor = UIColor.black
        }
        
        header.contentView.backgroundColor = #colorLiteral(red: 0.9192083333, green: 0.9192083333, blue: 0.9192083333, alpha: 1)
        header.contentView.isOpaque = true
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stopwatchesByMonth[monthForSectionIndex(section: section)]!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let stopwatch = stopwatchesByMonth[monthForSectionIndex(section: indexPath.section)]![indexPath.row]
        
        cell.textLabel?.text = StopwatchController.formatDate(date: stopwatch.startDate!)
        cell.detailTextLabel?.text = "\(StopwatchController.formatTimeInterval(stopwatch.duration, shouldIncludeTenthSecs: false))"
        
        if stopwatch.duration > (8.0 * ONE_HOUR) {
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        } else {
            cell.detailTextLabel?.textColor = UIColor.black
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsSegue" {
            if let targetController = segue.destination as? DetailsViewController {
                let indexPath = self.tableView.indexPathForSelectedRow!
                targetController.stopwatch = stopwatchesByMonth[monthForSectionIndex(section: indexPath.section)]![indexPath.row]
            }
        }
    }
}

