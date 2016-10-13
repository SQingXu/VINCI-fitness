//
//  PopupView.swift
//  VINCIFitness
//
//  Created by David Xu on 9/21/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit

class PopupView: UIView {
    var tappClosure: ((UIView)->Void)?
    @IBOutlet weak var ActivityLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!

    @IBOutlet weak var ActivityNumLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func InfoTapped(_ sender: AnyObject) {
        tappClosure?(self)
        print("Tapped")
        
        
    }
    

}
