//
//  ValidateTextField.swift
//  VINCIFitness
//
//  Created by David Xu on 8/16/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class ValidatePasswordField: UITextField {
    var imageView = UIImageView()
    var isValid: Bool{
        if self.text?.characters.count < 6{
            return false
        }else{
            return true
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(self.textUpDated), for: .editingChanged)
        self.addSubview(imageView)
        imageView.contentMode = .center
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(self.textUpDated), for: .editingChanged)
        self.addSubview(imageView)
        imageView.contentMode = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageViewHeight = self.frame.height
        let imageViewWidth = imageViewHeight
        let imageViewY:CGFloat = 0.0
        let imageViewX = self.frame.width - imageViewWidth
        imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewWidth, height: imageViewHeight)
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

   
}
