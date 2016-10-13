//
//  MapAutoCompleteTextField.swift
//  VINCIFitness
//
//  Created by David Xu on 8/28/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit

class MapAutoCompleteTextField: UITextField {
    var searchingClosure: ((UITextField)-> Void)?
    var previousString = ""
    var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(self.startSearching), for: .editingChanged)
        self.addSubview(imageView)
        self.tintColor = UIColor.vinciRed()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(self.startSearching), for: .editingChanged)
        self.addSubview(imageView)
        self.tintColor = UIColor.vinciRed()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageViewHeight = self.frame.height * 0.8
        let imageViewWidth = imageViewHeight * 1.246
        let imageViewY:CGFloat = self.frame.height * 0.1
        let imageViewX = self.frame.width - imageViewWidth
        imageView.frame = CGRect(x: imageViewX, y: imageViewY, width: imageViewWidth, height: imageViewHeight)
        imageView.image = UIImage(named: "location_icon.png")
        imageView.tintColor = UIColor.vinciRed()
    }
    func startSearching(){
        searchingClosure?(self)
    }
    func returnToPrevious(){
        self.text = previousString
    }
}
