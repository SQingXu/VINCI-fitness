//
//  UserController.swift
//  VINCIFitness
//
//  Created by David Xu on 8/17/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import Foundation
class UserController{
    static var sharedInstance = UserController()
    var currentUser = User(emailAddress: "")
    var isTabPresented = true
    var viewedUser = User(emailAddress: "")
    var users = [String: User]()
    var userIds = [String]()
    fileprivate init(){ }
    func removeJoinedActivity(eventId: String){
        for(index, element) in currentUser.attendedActivities.enumerated(){
            if element.activityId == eventId{
                currentUser.attendedActivities.remove(at: index)
            }
        }
        if ActivityController.sharedInstance.profile_activity_list{
            for (index, element) in ActivityController.sharedInstance.currentShownActivities.enumerated(){
                if element.activityId == eventId{
                    ActivityController.sharedInstance.currentShownActivities.remove(at: index)
                }
            }
        }
    }
    func removeHostedActivity(eventId:String){
        for (index,activity) in currentUser.hostedActivities.enumerated(){
            if activity.activityId == eventId{
                currentUser.hostedActivities.remove(at: index)
                break
            }
        }
        for (index, element) in ActivityController.sharedInstance.currentShownActivities.enumerated(){
            if element.activityId == eventId{
                ActivityController.sharedInstance.currentShownActivities.remove(at: index)
                break
            }
        }
    }
    func addJoinedActivity(event: Activity){
        currentUser.attendedActivities.append(event)
        if ActivityController.sharedInstance.profile_activity_list{
            ActivityController.sharedInstance.currentShownActivities.append(event)
        }
    }
    func updateCurrentUserActivity(event: Activity){
        for (index,activity) in currentUser.hostedActivities.enumerated(){
            if activity.activityId == event.activityId{
                currentUser.hostedActivities[index] = event
                break
            }
        }
    }
    func clearOut(){
        currentUser = User(emailAddress: "")
        viewedUser = User(emailAddress: "")
        users = [String: User]()
        userIds = [String]()
    }
}
