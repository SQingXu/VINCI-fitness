//
//  SearchTableViewCell.swift
//  VINCIFitness
//
//  Created by David Xu on 8/28/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.grayColor().CGColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
