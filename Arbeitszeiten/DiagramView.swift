//
//  DiagramView.swift
//  Arbeitszeiten
//
//  Created by Lukas Bischof on 15.03.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import UIKit

let MAX_STOPWATCHES_COUNT = 7
let graphColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)

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
    
    func reload() {
        setup()
        setNeedsDisplay()
        
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    fileprivate func setup() {
        let start = max(stopwatchController.stopwatches.count - MAX_STOPWATCHES_COUNT, 0)
        let end = stopwatchController.stopwatches.count
        data = Array(stopwatchController.stopwatches[start..<end])
        
        if data.count <= 0 {
            let label = UILabel(frame: bounds)
            label.text = "Keine Daten verfügbar"
            label.textAlignment = NSTextAlignment.center
            label.textColor = UIColor.gray
            
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.layer.borderWidth = 1.0
            
            addSubview(label)
            return
        } else {
            self.layer.borderWidth = 0.0
        }
        
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
        if data.count <= 0 {
            return
        }
        
        let ctx = UIGraphicsGetCurrentContext()
        let verticalPadding: CGFloat = 10.0
        let bottomLabelHeight: CGFloat = 20.0
        let leftLabelPadding: CGFloat = 20.0
        let leftDataEntriesPadding: CGFloat = 10.0
        let rightDataEntriesPadding: CGFloat = 10.0
        
        let width = rect.width
        let height = rect.height
        
        let horizontalDist = (height - CGFloat(2.0 * verticalPadding) - bottomLabelHeight) / CGFloat(maximum - minimum)
        UIColor.gray.set()
        for i in 0...(maximum-minimum) {
            ctx?.beginPath()
            ctx?.move(to: CGPoint(x: leftLabelPadding, y: CGFloat(i) * horizontalDist + verticalPadding))
            ctx?.addLine(to: CGPoint(x: width, y: CGFloat(i) * horizontalDist + verticalPadding))
            ctx?.closePath()
            ctx?.setStrokeColor(maximum-i == 8 ? UIColor.red.cgColor : UIColor.gray.cgColor)
            ctx?.strokePath()
            
            let string = NSString(string: "\(maximum-i)h")
            string.draw(at: CGPoint(x: 0.0, y: CGFloat(i) * horizontalDist), withAttributes: nil)
        }
        
        let timeSpan = (Double(maximum) * ONE_HOUR) - (Double(minimum) * ONE_HOUR)
        let verticalDist = (width - leftLabelPadding - rightDataEntriesPadding - leftDataEntriesPadding) / max(CGFloat(data.count - 1), 1.0)
        
        var lastDataEntryY: CGFloat? = nil
        ctx?.setLineWidth(3.0)
        for (index, stopwatch) in data.enumerated() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEEE"
            dateFormatter.locale = Locale(identifier: "de_DE")
            let formatted = NSString(string: dateFormatter.string(from: stopwatch.startDate!))
            
            let x = leftLabelPadding  + leftDataEntriesPadding + (CGFloat(index) * verticalDist)
            formatted.draw(at: CGPoint(x: x, y: height - 13.0), withAttributes: nil)
            
            let dataEntryY = CGFloat((Double(maximum) * ONE_HOUR - stopwatch.duration) / timeSpan) * (height - (2.0 * verticalPadding) - bottomLabelHeight) + verticalPadding
            
            ctx?.beginPath()
            ctx?.addArc(center: CGPoint(x: x, y: dataEntryY), radius: 5.5, startAngle: 0.0, endAngle: CGFloat(2.0 * Double.pi), clockwise: true)
            ctx?.closePath()
            ctx?.setFillColor(graphColor.cgColor)
            ctx?.fillPath()
            
            if let lastDataEntry = lastDataEntryY {
                let lastX = leftLabelPadding + leftDataEntriesPadding + CGFloat(index - 1) * verticalDist
                
                ctx?.beginPath()
                ctx?.move(to: CGPoint(x: lastX, y: lastDataEntry))
                ctx?.addLine(to: CGPoint(x: x, y: dataEntryY))
                ctx?.closePath()
                ctx?.setStrokeColor(graphColor.cgColor)
                ctx?.strokePath()
            }
            
            lastDataEntryY = dataEntryY
        }
    }

}
