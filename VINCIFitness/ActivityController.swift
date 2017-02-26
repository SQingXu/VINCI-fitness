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
    var profile_activity_list:Bool = false
    var currentActivity = Activity()
    var currentShownActivities = [Activity]()
    var editingActivity = false
    func removeParticipator(userId: String, eventId: String){
        for activity in currentShownActivities{
            if activity.activityId == eventId{
                for (index,element) in activity.participatiorsIds.enumerated(){
                    if element == userId{
                        activity.participatiorsIds.remove(at: index)
                    }
                }
            }
        }
    }
    func addParticipator(userId: String, eventId: String){
        for activity in currentShownActivities{
            if activity.activityId == eventId{
                activity.participatiorsIds.append(userId)
            }
        }
    }
}
