//
//  EditViewController.swift
//  Arbeitszeiten
//
//  Created by Lukas Bischof on 03.04.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import UIKit

enum CurrentEditingProperty {
    case startDate
    case endDate
    case pauseDuration
    case none
}

class EditViewController: UIViewController {

    var stopwatch: Stopwatch!
    private var currentEditingProperty: CurrentEditingProperty = .none
    @IBOutlet weak var editStartButton: UIButton!
    @IBOutlet weak var editEndButton: UIButton!
    @IBOutlet weak var editDurationButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editStartButton.layer.borderColor = UIColor.gray.cgColor
        editStartButton.layer.borderWidth = 1.0
        editStartButton.layer.cornerRadius = editStartButton.frame.height / 2.0
        
        editEndButton.layer.borderColor = UIColor.gray.cgColor
        editEndButton.layer.borderWidth = 1.0
        editEndButton.layer.cornerRadius = editEndButton.frame.height / 2.0
        
        editDurationButton.layer.borderColor = UIColor.gray.cgColor
        editDurationButton.layer.borderWidth = 1.0
        editDurationButton.layer.cornerRadius = editDurationButton.frame.height / 2.0
        
        updateEditDurationButtonLabel()
        updateEditEndButtonLabel()
        updateEditStartButtonLabel()

        // Do any additional setup after loading the view.
    }
    
    func updateEditStartButtonLabel() {
        editStartButton.setTitle("Start: \(StopwatchController.formatTime(date: stopwatch.startDate!))", for: .normal)
    }
    
    func updateEditEndButtonLabel() {
        editEndButton.setTitle("Ende: \(StopwatchController.formatTime(date: stopwatch.endDate!))", for: .normal)
    }
    
    func updateEditDurationButtonLabel() {
        editDurationButton.setTitle("Pause: \(StopwatchController.formatTimeInterval(stopwatch.pauseDuration, shouldIncludeTenthSecs: false))", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editStartButtonPressed(_ sender: Any) {
        currentEditingProperty = .startDate
        datePicker.maximumDate = stopwatch.endDate
        showPicker(mode: .time, date: stopwatch.startDate!)
    }
    
    @IBAction func editEndButtonPressed(_ sender: Any) {
        currentEditingProperty = .endDate
        datePicker.minimumDate = stopwatch.startDate
        showPicker(mode: .time, date: stopwatch.endDate!)
    }
    
    @IBAction func editDurationButtonPressed(_ sender: Any) {
        currentEditingProperty = .pauseDuration
        showPicker(mode: .countDownTimer, countdown: stopwatch.pauseDuration)
    }
    
    
    func showPicker(mode: UIDatePickerMode, date: Date) {
        datePicker.datePickerMode = mode
        datePicker.date = date
        datePicker.isHidden = false
    }
    
    func showPicker(mode: UIDatePickerMode, countdown: TimeInterval) {
        datePicker.datePickerMode = mode
        datePicker.countDownDuration = countdown
        datePicker.isHidden = false
    }

    @IBAction func pickerValueChanged(_ sender: Any) {
        switch currentEditingProperty {
        case .startDate:
            stopwatch.startDate = datePicker.date
            updateEditStartButtonLabel()
        case .endDate:
            stopwatch.endDate = datePicker.date
            updateEditEndButtonLabel()
        case .pauseDuration:
            stopwatch.pauseDuration = datePicker.countDownDuration > stopwatch.duration ? stopwatch.duration : datePicker.countDownDuration
            
            if datePicker.countDownDuration > stopwatch.pauseDuration {
                datePicker.countDownDuration = stopwatch.pauseDuration
            }
            
            updateEditDurationButtonLabel()
        default:
            break
        }
    }
}
