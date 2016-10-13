//
//  ConfirmPasswordTextField.swift
//  VINCIFitness
//
//  Created by David Xu on 8/17/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit

class ConfirmPasswordTextField: ValidatePasswordField {
    var passwordString: String = ""

    override var isValid: Bool{
        if self.text == passwordString{
            return true
        }else{
            return false
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    


}
