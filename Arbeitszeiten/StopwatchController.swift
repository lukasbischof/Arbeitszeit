//
//  StopwatchController.swift
//  Arbeitszeiten
//
//  Created by Lukas Bischof on 10.03.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import UIKit

let ONE_HOUR = 3_600.0

class StopwatchController: NSObject {
    var stopwatches: [Stopwatch] = []
    static let sharedController = StopwatchController()
    
    var currentStopwatch: Stopwatch = Stopwatch()
    
    override init() {
        super.init()
        self.load()
    }
    
    func addStopwatch(_ stopwatch: Stopwatch) {
        stopwatches.append(stopwatch)
    }
    
    func load() {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)[0]
        let file = NSString(string: dir).appendingPathComponent("save.plist")
        
        if FileManager.default.fileExists(atPath: file) {
            let unarchieved = NSKeyedUnarchiver.unarchiveObject(withFile: file) as? StopwatchControllerSaving
            if let saving = unarchieved {
                self.stopwatches = saving.stopwatches
                self.currentStopwatch = saving.currentStopwatch ?? Stopwatch()
            }
        }
    }
    
    func save() {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)[0]
        let file = NSString(string: dir).appendingPathComponent("save.plist")
        print(file)
        
        let saving = StopwatchControllerSaving(stopwatches: stopwatches, andCurrentStopwatch: currentStopwatch)
        let archived = NSKeyedArchiver.archiveRootObject(saving, toFile: file)
        print(archived)
    }
    
    func getStopwatchesByMonth() -> [String: [Stopwatch]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "de_DE")
        
        var months: Dictionary<String, [Stopwatch]> = [:]
        for stopwatch in stopwatches.sorted(by: { $0.startDate!.timeIntervalSinceReferenceDate < $1.startDate!.timeIntervalSinceReferenceDate }) {
            let formattedMonth = formatter.string(from: stopwatch.startDate!)
            if !months.keys.contains(formattedMonth) {
                months[formattedMonth] = [stopwatch]
            } else {
                months[formattedMonth]!.append(stopwatch)
            }
        }
        
        return months
    }
    
    class func formatTimeInterval(_ interval: TimeInterval, shouldIncludeTenthSecs includeTenth: Bool) -> String {
        let hours = floor(interval / (ONE_HOUR))
        let minutes = floor((interval - (ONE_HOUR * hours)) / 60.0)
        let seconds = floor(fmod(interval, 60.0))
        let tenth = floor(fmod(interval * 10, 10.0))
        
        let hoursString = NSString(format: "%@%.0f", (hours < 10 ? "0" : ""), hours)
        let minutesString = NSString(format: "%@%.0f", (minutes < 10 ? "0" : ""), minutes)
        let secondsString = NSString(format: "%@%.0f", (seconds < 10 ? "0" : ""), seconds)
        let tenthString = NSString(format: "%.0f", tenth)
        
        if includeTenth {
            return "\(hoursString):\(minutesString):\(secondsString):\(tenthString)"
        } else {
            return "\(hoursString):\(minutesString):\(secondsString)"
        }
    }
    
    class func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM (EEEE)"
        formatter.locale = Locale(identifier: "de_DE")
        
        return formatter.string(from: date)
    }
    
    class func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "kk:mm:ss z"
        formatter.locale = Locale(identifier: "de_DE")
        
        return formatter.string(from: date)
    }
}

class StopwatchControllerSaving: NSObject, NSSecureCoding, NSCoding {
    fileprivate private(set) var stopwatches: [Stopwatch] = []
    fileprivate private(set) var currentStopwatch: Stopwatch?
    
    static fileprivate let STOPWATCHES_KEY = "Stpwtchs"
    static fileprivate let CURRENT_STOPWATCH_KEY = "currstpwch"
    
    init(stopwatches: Array<Stopwatch>, andCurrentStopwatch currentStopwatch: Stopwatch?) {
        self.stopwatches = stopwatches
        self.currentStopwatch = currentStopwatch
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let decodedStopwatches = aDecoder.decodeObject(forKey: StopwatchControllerSaving.STOPWATCHES_KEY) as? [Stopwatch] {
            self.stopwatches = decodedStopwatches
        } else {
            return nil
        }
        
        self.currentStopwatch = aDecoder.decodeObject(forKey: StopwatchControllerSaving.CURRENT_STOPWATCH_KEY) as? Stopwatch
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.stopwatches, forKey: StopwatchControllerSaving.STOPWATCHES_KEY)
        
        if currentStopwatch != nil {
            aCoder.encode(self.currentStopwatch!, forKey: StopwatchControllerSaving.CURRENT_STOPWATCH_KEY)
        }
    }
    
    static var supportsSecureCoding: Bool = true
}
