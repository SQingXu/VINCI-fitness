//
//  DatePickerTextField.swift
//  VINCIFitness
//
//  Created by David Xu on 8/29/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit

class DatePickerTextField: UITextField {
    var datePicker = UIDatePicker()
    var imageView = UIImageView()
    var selectedDate = Date()
    var keyBoardTool = UIToolbar()
    var dateFormatter = DateFormatter()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setMode()
        self.addTarget(self, action: #selector(self.changeKeyBoard), for: .editingDidBegin)
        datePicker.addTarget(self, action: #selector(self.translateDate), for: .valueChanged)
        self.addSubview(imageView)
        self.tintColor = UIColor.vinciRed()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setMode()
        self.addTarget(self, action: #selector(self.changeKeyBoard), for: .editingDidBegin)
        datePicker.addTarget(self, action: #selector(self.translateDate), for: .valueChanged)
        self.addSubview(imageView)
        self.tintColor = UIColor.vinciRed()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageHeight = self.frame.height * 0.8
        let imageWidth = imageHeight
        let imageX = self.frame.width - imageWidth
        let imageY:CGFloat = 0.1 * self.frame.height
        imageView.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
    }
    func changeKeyBoard(){
        self.inputView = datePicker
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.donePressed))
        keyBoardTool.frame = CGRect(x: 0, y: 0, width: datePicker.frame.width, height: 35)
        keyBoardTool.setItems([spaceButton,doneButton], animated: true)
        self.inputAccessoryView = keyBoardTool
        
    }
    
    func translateDate(){
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: self.datePicker.date)
        selectedDate = self.datePicker.date
        self.text = dateString
    }
    func setMode(){
        datePicker.datePickerMode = .date
        imageView.image = UIImage(named: "calendar_icon.png")
        imageView.tintColor = UIColor.vinciRed()
    }
    func donePressed(){
        self.resignFirstResponder()
    }

}
