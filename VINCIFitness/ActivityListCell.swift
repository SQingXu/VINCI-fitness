//
//  ActivityListCell.swift
//  VINCIFitness
//
//  Created by David Xu on 9/22/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit

class ActivityListCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var titleCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
