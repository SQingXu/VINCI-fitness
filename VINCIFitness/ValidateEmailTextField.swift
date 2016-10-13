//
//  VlidateEmailTextField.swift
//  VINCIFitness
//
//  Created by David Xu on 8/16/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit

class ValidateEmailTextField: UITextField {
    var imageView = UIImageView()
    
    var isValid: Bool{
        var bol:Bool
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        bol = emailTest.evaluate(with: self.text)
        if bol == true{
            return true
        }else{
        return false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(self.textUpDated), for: .editingDidEnd)
        self.addTarget(self, action: #selector(self.hideValidation), for: .editingDidBegin)
        self.addSubview(imageView)
        imageView.contentMode = .center
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(self.textUpDated), for: .editingDidEnd)
        self.addTarget(self, action: #selector(self.hideValidation), for: .editingDidBegin)
        self.addSubview(imageView)
        imageView.contentMode = .center
    }
    func hideValidation(){
        self.imageView.isHidden = true
    }
    func textUpDated(){
        //handle text change
        self.imageView.isHidden = false
        if !isValid{
            self.imageView.image = UIImage(named: "Invalid.png")
            self.imageView.tintColor = UIColor.vinciRed()
        }
        else{
            self.imageView.image = UIImage(named: "Valid.png")
            self.imageView.tintColor = UIColor.vinciRed()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageViewHeight = self.frame.height
        let imageViewWidth = imageViewHeight
        let imageViewY:CGFloat = 0.0
        let imageViewX = self.frame.width - imageViewWidth
        imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewWidth, height: imageViewHeight)
        
    }

}
