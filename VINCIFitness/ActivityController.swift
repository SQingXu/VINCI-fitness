//
//  ActivityController.swift
//  VINCIFitness
//
//  Created by David Xu on 10/1/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import Foundation
class ActivityController{
    static var sharedInstance = ActivityController()
    var currentActivity = Activity()
    var currentShownActivities = [Activity]()
    var editingActivity = false
}