//
//  Maker.swift
//  VINCIFitness
//
//  Created by David Xu on 8/26/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
class Maker: GMSMarker{
    var activityList = [Activity]()
    var placeID: String = ""
    var placeName: String = ""
    var markerIcon: String = ""
    
    func addIcon(){
        let icon_image = UIImage(named: "MarkerIcons/" + markerIcon)
        let image_view = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        image_view.image = icon_image
        self.iconView = image_view
    }
    
}
