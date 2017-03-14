//
//  SecondViewController.swift
//  Arbeitszeiten
//
//  Created by Lukas Bischof on 09.03.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    let stopwatchController = StopwatchController.sharedController
    var stopwatchesByMonth: [String: [Stopwatch]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
     self.stopwatchesByMonth = stopwatchController.getStopwatchesByMonth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.stopwatchesByMonth = stopwatchController.getStopwatchesByMonth()
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

