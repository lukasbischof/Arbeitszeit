//
//  ArbeitszeitenTests.swift
//  ArbeitszeitenTests
//
//  Created by Lukas Bischof on 09.03.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import XCTest
@testable import Arbeitszeiten

class ArbeitszeitenTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIfStopwatchStarts() {
        let watch = Stopwatch()
        watch.start()
        XCTAssertTrue(watch.hasStarted, "Stopwatch should have started")
    }
    
}
