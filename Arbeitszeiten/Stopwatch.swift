//
//  Timer.swift
//  Arbeitszeiten
//
//  Created by Lukas Bischof on 09.03.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import UIKit

let END_DATE_KEY = "e"
let START_DATE_KEY = "s"
let DURATION_KEY = "d"
let HAS_STARTED_KEY = "hs"
let HAS_STOPPED_KEY = "he"
let IS_PAUSED_KEY = "ip"
let PAUSE_DURATION_KEY = "pd"
let LAST_PAUSE_DATE_KEY = "lp"

class Stopwatch: NSObject, NSCoding, NSCopying {
    private(set) var hasStarted = false
    private(set) var hasStopped = false
    internal var startDate: Date?
    internal var endDate: Date?
    internal var pauseDuration: TimeInterval = 0
    internal var lastPauseDate: Date?
    internal private(set) var isPaused: Bool = false
    
    var passedTime: TimeInterval {
        get {
            if let date = startDate {
                return -date.timeIntervalSinceNow - pauseDuration
            } else {
                return 0
            }
        }
    }
    
    internal var duration: TimeInterval {
        get {
            if hasStopped {
                return endDate!.timeIntervalSince(startDate!) - pauseDuration
            } else {
                return 0
            }
        }
    }
    
    override var description: String {
        get {
            return "<Stopwatch: \(duration) secs>"
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.startDate = aDecoder.decodeObject(forKey: START_DATE_KEY) as? Date
        self.endDate = aDecoder.decodeObject(forKey: END_DATE_KEY) as? Date
        self.hasStarted = aDecoder.decodeBool(forKey: HAS_STARTED_KEY)
        self.hasStopped = aDecoder.decodeBool(forKey: HAS_STOPPED_KEY)
        self.lastPauseDate = aDecoder.decodeObject(forKey: LAST_PAUSE_DATE_KEY) as? Date
        self.pauseDuration = aDecoder.decodeDouble(forKey: PAUSE_DURATION_KEY) as TimeInterval
        self.isPaused = aDecoder.decodeBool(forKey: IS_PAUSED_KEY)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(duration, forKey: DURATION_KEY)
        aCoder.encode(startDate, forKey: START_DATE_KEY)
        aCoder.encode(endDate, forKey: END_DATE_KEY)
        aCoder.encode(hasStopped, forKey: HAS_STOPPED_KEY)
        aCoder.encode(hasStarted, forKey: HAS_STARTED_KEY)
        aCoder.encode(lastPauseDate, forKey: LAST_PAUSE_DATE_KEY)
        aCoder.encode(pauseDuration, forKey: PAUSE_DURATION_KEY)
        aCoder.encode(isPaused, forKey: IS_PAUSED_KEY)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Stopwatch()
        copy.startDate = startDate
        copy.endDate = endDate
        copy.hasStopped = hasStopped
        copy.hasStarted = hasStarted
        copy.lastPauseDate = lastPauseDate
        copy.pauseDuration = pauseDuration
        copy.isPaused = isPaused
        return copy
    }
    
    func start() {
        hasStarted = true
        startDate = Date()
    }
    
    func stop() {
        hasStopped = true
        endDate = Date()
    }
    
    func togglePause() {
        if isPaused {
            // Resume
            
            pauseDuration += -lastPauseDate!.timeIntervalSinceNow
            lastPauseDate = nil
        } else {
            // Pause
            
            lastPauseDate = Date()
        }
        
        isPaused = !isPaused
    }
}
