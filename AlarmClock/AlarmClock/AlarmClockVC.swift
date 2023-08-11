//
//  AlarmClockVC.swift
//  AlarmClock
//
//  Created by Andrei Isayenka on 10/08/2023.
//

import UIKit

class AlarmClockVC: UIViewController {
    
    // Constant elements
    @IBOutlet weak var constantTitleLabel: UILabel!
    @IBOutlet weak var constantTimeLeftLabel: UILabel!
    @IBOutlet weak var dividerView1: UIView!
    @IBOutlet weak var dividerView2: UIView!
    @IBOutlet weak var dividerView3: UIView!
    
    // Changing elements
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var pickerModeSegmCtrl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view
        view.backgroundColor = .white
        
        // Title

        
        // Dividers
        dividerView1.backgroundColor = .black
        dividerView2.backgroundColor = .black
        dividerView3.backgroundColor = .black
        
        // Date picker
        
        // Segmetned control
        pickerModeSegmCtrl.selectedSegmentIndex = 0
        
        // Buttons
        stopButton.isEnabled = false
        
    }
    
    @IBAction func pickerModeChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.2) {
            self.datePicker.alpha = 0
        } completion: { _ in
            switch sender.selectedSegmentIndex {
            case 0:
                self.datePicker.datePickerMode = .dateAndTime
            case 1:
                self.datePicker.datePickerMode = .time
            case 2:
                self.datePicker.datePickerMode = .countDownTimer
            default:
                break
            }
            UIView.animate(withDuration: 0.2) {
                self.datePicker.alpha = 1
            }
        }
   }
                
}
