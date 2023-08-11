//
//  AlarmClockVC.swift
//  AlarmClock
//
//  Created by Andrei Isayenka on 10/08/2023.
//

import UIKit

class AlarmClockVC: UIViewController {
    
    // Constant elements
    @IBOutlet private weak var constantTitleLabel: UILabel!
    @IBOutlet private weak var constantTimeLeftLabel: UILabel!
    @IBOutlet private weak var dividerView1: UIView!
    @IBOutlet private weak var dividerView2: UIView!
    @IBOutlet private weak var dividerView3: UIView!
    @IBOutlet private weak var timeStack: UIStackView!
    @IBOutlet private weak var buttonsStack: UIStackView!
    
    // Changing elements
    @IBOutlet private weak var timeLeftLabel: UILabel!
    @IBOutlet private weak var refreshButton: UIButton!
    @IBOutlet private weak var pickerModeSegmCtrl: UISegmentedControl!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    
    // Properties for the logic
    private var selectedDate: Date?
    private var timer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view
        view.backgroundColor = .white

        // Stacks
        timeStack.backgroundColor = view.backgroundColor
        buttonsStack.backgroundColor = view.backgroundColor
        
        // Title
        
        // Dividers
        dividerView1.backgroundColor = .black
        dividerView2.backgroundColor = .black
        dividerView3.backgroundColor = .black
        
        // Date picker
        datePicker.setDate(.now, animated: true)
        
        // Segmetned control
        pickerModeSegmCtrl.selectedSegmentIndex = 0
        
        // Buttons
        stopButton.isEnabled = false
        stopButton.alpha = 0.5
        stopButton.layer.cornerRadius = stopButton.frame.height / 4
        stopButton.setTitle("Stop", for: .disabled)
        stopButton.setTitle("Stop", for: .normal)
        
        applyButton.layer.cornerRadius = applyButton.frame.height / 4
        applyButton.setTitle("Start", for: .normal)
    }
    
    
    @IBAction private func pickerModeChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.2) {
            self.datePicker.alpha = 0
        } completion: { _ in
            switch sender.selectedSegmentIndex {
            case 0:
                self.datePicker.datePickerMode = .time
                self.datePicker.setDate(.now, animated: false)
            case 1:
                self.datePicker.datePickerMode = .countDownTimer
            default:
                break
            }
            UIView.animate(withDuration: 0.2) {
                self.datePicker.alpha = 1
            }
        }
    }
    
    @IBAction private func datePickerChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        fillTimeLeftLabelWith(date: sender.date)
    }
    
    @IBAction private func refreshButtonTapped(_ sender: UIButton) {
        timeLeftLabel.text = "00:00:00"
        selectedDate = nil
        timer?.invalidate()
        
        UIView.animate(withDuration: 0.3) {
            self.applyButton.isEnabled = true
            self.applyButton.alpha = 1
            
            self.stopButton.isEnabled = false
            self.stopButton.alpha = 0.5
            self.stopButton.backgroundColor = .systemRed
            self.stopButton.setTitle("Stop", for: .normal)
            
            self.datePicker.isEnabled = true
        }
    }
    
    @IBAction private func applyButtonTapped(_ sender: UIButton) {
        
        // Checking if date was selected
        guard selectedDate != nil else {
            showTheAlert(title: "Missed date!", message: "The date has not been selected")
            return
        }
        
        // Turning off the controls after timer has started
        UIView.animate(withDuration: 0.3) {
            self.applyButton.isEnabled = false
            self.applyButton.alpha = 0.5
            self.stopButton.alpha = 1
            self.stopButton.isEnabled = true
            self.datePicker.isEnabled = false
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    @IBAction private func stopButtonTapped(_ sender: UIButton) {
        if sender.title(for: .normal) == "Stop" {
            self.timer?.invalidate()

            UIView.transition(with: sender, duration: 0.2) {
                sender.setTitle("Continue", for: .normal)
                sender.backgroundColor = .systemGreen
            }
        } else {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)

            UIView.transition(with: sender, duration: 0.2) {
                sender.setTitle("Stop", for: .normal)
                sender.backgroundColor = .red
            }
        }
    
    }
    
    @objc private func timerFired() {
        
        // Decrease date by one second
        var decreaseSecondsComponent = DateComponents()
        decreaseSecondsComponent.second = -1
        
        if let decreasedDate = Calendar.current.date(byAdding: decreaseSecondsComponent, to: selectedDate!) {
            selectedDate = decreasedDate
        } else {
            showTheAlert(title: "Error", message: "Failded to decrease date")
        }
        
        // Put the date in the timeLeftLabel
        fillTimeLeftLabelWith(date: selectedDate!)
    }
    
    
    private func fillTimeLeftLabelWith(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "HH:mm:ss"
        timeLeftLabel.text = dateFormatter.string(from: date)
    }
    
    private func showTheAlert(title: String, message: String) {
        
        // Create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create and add the UIAlertAction
        let closeAlertAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(closeAlertAction)
        
        // Show the alert
        present(alert, animated: true)
    }
}