//
//  PartuicipatorCell.swift
//  VINCIFitness
//
//  Created by David Xu on 9/30/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit

class PartuicipatorCell: UICollectionViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 20
        profileImageView.backgroundColor = UIColor.vinciRed()
        // Initialization code
    }

}
