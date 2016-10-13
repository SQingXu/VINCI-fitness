//
//  TimePickerTextField.swift
//  VINCIFitness
//
//  Created by David Xu on 8/29/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit

class TimePickerTextField: DatePickerTextField {
    var selectedTime = Date()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func setMode() {
        self.datePicker.datePickerMode = .time
        self.imageView.image = UIImage(named: "time_icon.png")
        self.imageView.tintColor = UIColor.vinciRed()
    }
    override func translateDate() {
        dateFormatter.timeStyle = .short
        let timeString = dateFormatter.string(from: datePicker.date)
        selectedTime = datePicker.date
        self.text = timeString
    }


}
