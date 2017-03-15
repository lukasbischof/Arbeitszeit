//
//  DiagramView.swift
//  Arbeitszeiten
//
//  Created by Lukas Bischof on 15.03.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import UIKit

let MAX_STOPWATCHES_COUNT = 7

class DiagramView: UIView {
    
    let stopwatchController = StopwatchController.sharedController
    var data: [Stopwatch] = []
    var minimum: Int! = Int.max
    var maximum: Int! = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        let start = max(stopwatchController.stopwatches.count - (MAX_STOPWATCHES_COUNT + 1), 0)
        let end = stopwatchController.stopwatches.count
        data = Array(stopwatchController.stopwatches[start..<end])
        
        for stopwatch in data {
            var hours = Int(floor(stopwatch.duration / ONE_HOUR))
            if hours < minimum {
                minimum = hours
            }
            
            hours = Int(ceil(stopwatch.duration / ONE_HOUR))
            if hours > maximum {
                maximum = hours
            }
        }
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let verticalPadding: CGFloat = 10.0
        let bottomLabelHeight: CGFloat = 20.0
        let leftLabelPadding: CGFloat = 20.0
        let leftDataEntriesPadding: CGFloat = 10.0
        
        let width = rect.width
        let height = rect.height
        let ctx = UIGraphicsGetCurrentContext()
        
        let horizontalDist = (height - CGFloat(2.0 * verticalPadding) - bottomLabelHeight) / CGFloat(maximum - minimum)
        UIColor.gray.set()
        for i in 0...(maximum-minimum) {
            ctx?.beginPath()
            ctx?.move(to: CGPoint(x: leftLabelPadding, y: CGFloat(i) * horizontalDist + verticalPadding))
            ctx?.addLine(to: CGPoint(x: width, y: CGFloat(i) * horizontalDist + verticalPadding))
            ctx?.closePath()
            ctx?.setStrokeColor(UIColor.gray.cgColor)
            ctx?.strokePath()
            
            let string = NSString(string: "\(maximum-i)h")
            string.draw(at: CGPoint(x: 0.0, y: CGFloat(i) * horizontalDist), withAttributes: nil)
        }
        
        let timeSpan = (Double(maximum) * ONE_HOUR) - (Double(minimum) * ONE_HOUR)
        let verticalDist = (width - leftLabelPadding - leftDataEntriesPadding) / CGFloat(data.count)
        UIColor.red.set()
        for (index, stopwatch) in data.enumerated() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEEE"
            dateFormatter.locale = Locale(identifier: "de_DE")
            let formatted = NSString(string: dateFormatter.string(from: stopwatch.startDate!))
            
            let x = leftLabelPadding  + leftDataEntriesPadding + CGFloat(index) * verticalDist
            formatted.draw(at: CGPoint(x: x, y: height - 13.0), withAttributes: nil)
            
            var dataEntryY = CGFloat((Double(maximum) * ONE_HOUR - stopwatch.duration) / timeSpan) * (height - (verticalPadding) - bottomLabelHeight)
            
            ctx?.beginPath()
            ctx?.addArc(center: CGPoint(x: x, y: dataEntryY), radius: 4.0, startAngle: 0.0, endAngle: CGFloat(2.0 * M_PI), clockwise: true)
            ctx?.closePath()
            ctx?.fillPath()
        }
    }

}
