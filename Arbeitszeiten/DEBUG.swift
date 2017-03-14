//
//  DEBUG.swift
//  Arbeitszeiten
//
//  Created by Lukas Bischof on 14.03.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import Foundation

/* ******************************************************************************** */
/*                              CONFIGURATION                                       */
/* ******************************************************************************** */

let SHOULD_ENTER_TEST_DATA = false

 
 
 
 
 
 








































/* ******************************************************************************** */
/*                              TESTING FUNCTIONS                                   */
/* ******************************************************************************** */


struct _DEBUG {
    static func saveTestData() {
        let ONE_DAY = 24.0 * ONE_HOUR
        let durations = [8.1 * ONE_HOUR, 7.5 * ONE_HOUR, 9.152 * ONE_HOUR, 6.2 * ONE_HOUR]
        let dates = [Date(timeInterval: -4 * ONE_DAY, since: Date()),
                     Date(timeInterval: -3 * ONE_DAY, since: Date()),
                     Date(timeInterval: -2 * ONE_DAY, since: Date()),
                     Date(timeInterval: -1 * ONE_DAY, since: Date())]
        
        for i in 0 ..< durations.count {
            let duration = durations[i]
            let stopwatch = Stopwatch()
            stopwatch.startDate = dates[i]
            stopwatch.endDate = Date(timeInterval: duration, since: stopwatch.startDate!)
            stopwatch.duration = duration
            
            StopwatchController.sharedController.addStopwatch(stopwatch)
        }
        
        StopwatchController.sharedController.save()
        exit(EXIT_SUCCESS)
    }
}


