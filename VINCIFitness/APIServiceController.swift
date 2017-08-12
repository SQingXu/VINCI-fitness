//
//  APIServiceController.swift
//  VINCIFitness
//
//  Created by David Xu on 9/23/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIServiceController{
    static var sharedInstance = APIServiceController()
    let apiService = APIService()
    var dateFormatter = DateFormatter()
    func getActivities(){
        apiService.createMutableAnonRequest(URL(string:"https://vincilive2.herokuapp.com/map/get-data"), method: "POST", parameters: ["range":"30" as AnyObject,"lat":"35.8" as AnyObject,"lng":"-78.775" as AnyObject], requestCompletionFunction: {responseCode, json in
            if responseCode/100 == 2{
                //print(json)
                var updatedArray = [Maker]()
                for (_,maker) in json["markerArray"]{
                    let newMaker = Maker()
                    newMaker.placeName = maker["address"].stringValue
                    let latitude = Double(maker["position"]["lat"].stringValue)
                    if latitude != nil{
                        newMaker.position.latitude = latitude!
                    }
                    let longitude = Double(maker["position"]["lng"].stringValue)
                    if longitude != nil{
                        newMaker.position.longitude = longitude!
                    }
                    var boolValue = false
                    var matchedMarker:Maker = Maker()
                    for almarker in updatedArray{
                        if (almarker.placeName == newMaker.placeName) && (almarker.position.latitude == newMaker.position.latitude)&&(almarker.position.longitude == newMaker.position.longitude){
                            boolValue = true
                            matchedMarker = almarker
                            break
                        }
                    }
                    if !boolValue{
                        let newActivity = Activity()
                        newActivity.name = maker["title"].stringValue
                        newMaker.activityList.append(newActivity)
                        updatedArray.append(newMaker)
                    }else{
                        let newActivity = Activity()
                        newActivity.name = maker["title"].stringValue
                        matchedMarker.activityList.append(newActivity)
                    }
                    print(maker["address"].stringValue)
                    
                }
                MakerController.sharedInstance.currentMakers = updatedArray
                print(responseCode)
            }
            else {
                print(responseCode)
                print("error")
            }
        })
//        apiService.executeRequest(request, requestCompletionFunction: {responseCode, json in
//            if responseCode/100 == 2{
//                //print(json)
//                var updatedArray = [Maker]()
//                for (_,maker) in json["markerArray"]{
//                    let newMaker = Maker()
//                    newMaker.placeName = maker["address"].stringValue
//                    let latitude = Double(maker["position"]["lat"].stringValue)
//                    if latitude != nil{
//                        newMaker.position.latitude = latitude!
//                    }
//                    let longitude = Double(maker["position"]["lng"].stringValue)
//                    if longitude != nil{
//                        newMaker.position.longitude = longitude!
//                    }
//                    var boolValue = false
//                    var matchedMarker:Maker = Maker()
//                    for almarker in updatedArray{
//                        if (almarker.placeName == newMaker.placeName) && (almarker.position.latitude == newMaker.position.latitude)&&(almarker.position.longitude == newMaker.position.longitude){
//                            boolValue = true
//                            matchedMarker = almarker
//                            break
//                        }
//                    }
//                    if !boolValue{
//                        let newActivity = Activity()
//                        newActivity.name = maker["title"].stringValue
//                        newMaker.activityList.append(newActivity)
//                        updatedArray.append(newMaker)
//                    }else{
//                        let newActivity = Activity()
//                        newActivity.name = maker["title"].stringValue
//                        matchedMarker.activityList.append(newActivity)
//                    }
//                    print(maker["address"].stringValue)
//                    
//                }
//                MakerController.sharedInstance.currentMakers = updatedArray
//                print(json)
//                print(responseCode)
//            }
//            else {
//                print(responseCode)
//                print("error")
//            }
//        })
    }
    func login(_ email: String, password: String){
        apiService.createMutableAnonRequest(URL(string:"https://vincilive2.herokuapp.com/login-app"), method: "POST", parameters: ["email":"vincifitness@vincifitness.com" as AnyObject,"pass":"Vinci!Fit1" as AnyObject], requestCompletionFunction: {responseCode, json in
            if responseCode/100 == 2{
                print(json)
                print(responseCode)
            }else{
                print(responseCode)
                print("error")
            }
        })
        
    }
    func register(_ email: String, password: String, address: String, firstName: String, lastName: String, birthday: String){
        apiService.createHeaderRequest(URL(string:"https://vincilive2.herokuapp.com/profile-creation/app-submit"), method: "POST", parameters: ["email":email as AnyObject ,"password":password as AnyObject,"address":address as AnyObject,"firstName": firstName as AnyObject,"lastName":lastName as AnyObject,"birthday":birthday as AnyObject], requestCompletionFunction: {
            responseCode, json in
            if responseCode/100 == 2{
                print(json)
                print(responseCode)
            }else{
                print(responseCode)
                print("error")
            }
        })


    }
    func updatePersonalInfo(userId:String){
        if UserController.sharedInstance.userIds.contains(userId){
            for (index, key) in UserController.sharedInstance.users.enumerated(){
                if key.userId == userId{
                    apiService.createHeaderRequest(URL(string: "https://vincilive2.herokuapp.com/profile/app/"+userId), method: "GET", parameters: nil, requestCompletionFunction: {
                        responseCode, json in
                        if responseCode/100 == 2{
                            let newUser = User(emailAddress: "")
                            newUser.userId = userId
                            newUser.bio = json["biography"].stringValue
                            newUser.profileImageURL = json["imageProfile"].stringValue
                            newUser.firstName = json["firstName"].stringValue
                            newUser.lastName = json["lastName"].stringValue
                            newUser.coverImageUrl = json["imageCover"].stringValue
                            self.dateFormatter.dateFormat = "yyyy-MM-dd"
                            newUser.birthday = self.dateFormatter.date(from: json["birthday"].stringValue)!
                            newUser.homeAddressFull = json["address"].stringValue
                            UserController.sharedInstance.users[index] = newUser
                        }else{
                            print("error")
                            
                        }
                    })
                    break
                }
            }
        }else{
            //append
            UserController.sharedInstance.userIds.append(userId)
            apiService.createHeaderRequest(URL(string: "https://vincilive2.herokuapp.com/profile/app/"+userId), method: "GET", parameters: nil, requestCompletionFunction: {
                responseCode, json in
                if responseCode/100 == 2{
                    let newUser = User(emailAddress: "")
                    newUser.userId = userId
                    newUser.bio = json["biography"].stringValue
                    newUser.profileImageURL = json["imageProfile"].stringValue
                    newUser.firstName = json["firstName"].stringValue
                    newUser.lastName = json["lastName"].stringValue
                    newUser.coverImageUrl = json["imageCover"].stringValue
                    self.dateFormatter.dateFormat = "yyyy-MM-dd"
                    newUser.birthday = self.dateFormatter.date(from: json["birthday"].stringValue)!
                    newUser.homeAddressFull = json["address"].stringValue
                    UserController.sharedInstance.users.append(newUser)
                }else{
                    print("error")
                    
                }
            })
            
        }
        
    }
    
    func loadingPersonInfo(_ userId: String){
        UserController.sharedInstance.userIds.append(userId)
        apiService.createHeaderRequest(URL(string: "https://vincilive2.herokuapp.com/profile/app/:id"), method: "GET", parameters: ["id": userId as AnyObject], requestCompletionFunction: {
            responseCode, json in
            if responseCode/100 == 2{
                let newUser = User(emailAddress: "")
                newUser.userId = userId
                newUser.bio = json["biography"].stringValue
                newUser.profileImageURL = json["imageProfile"].stringValue
                newUser.firstName = json["firstName"].stringValue
                newUser.lastName = json["lastName"].stringValue
                newUser.coverImageUrl = json["imageCover"].stringValue
                self.dateFormatter.dateFormat = "yyyy-MM-dd"
                newUser.birthday = self.dateFormatter.date(from: json["birthday"].stringValue)!
                newUser.homeAddressFull = json["address"].stringValue
                UserController.sharedInstance.users.append(newUser)
            }else{
                print(responseCode)
                print(json)
                print("error")
                
            }
        })
        
        
    }
    func loadCurrentInfo(){
        let userId = UserController.sharedInstance.currentUser.userId
        apiService.createHeaderRequest(URL(string: "https://vincilive2.herokuapp.com/profile/app/" + userId), method: "GET", parameters: nil, requestCompletionFunction: {
            responseCode, json in
            if responseCode/100 == 2{
                print(json)
                UserController.sharedInstance.currentUser.bio = json["biography"].stringValue
                UserController.sharedInstance.currentUser.profileImageURL = json["imageProfile"].stringValue
                UserController.sharedInstance.currentUser.firstName = json["firstName"].stringValue
                UserController.sharedInstance.currentUser.lastName = json["lastName"].stringValue
                self.dateFormatter.dateFormat = "yyyy-MM-dd"
                UserController.sharedInstance.currentUser.birthday = self.dateFormatter.date(from: json["birthday"].stringValue)!
                UserController.sharedInstance.currentUser.coverImageUrl = json["imageCover"].stringValue
                UserController.sharedInstance.currentUser.homeAddressFull = json["address"].stringValue
                UserController.sharedInstance.viewedUser = UserController.sharedInstance.currentUser
            }else{
                print("error")
                
            }
        })

    }
    func joinActivity(_ eventId: String){
        let userId = UserController.sharedInstance.currentUser.userId
        apiService.createHeaderRequest(URL(string: "https://vincilive2.herokuapp.com/map/event-signup"), method: "PUT", parameters: ["eventId": eventId as AnyObject, "userId": userId as AnyObject],requestCompletionFunction: {responseCode, json in
            if responseCode/100 == 2{
                print(json)
            }else{
                print("error in joining activity")
            }
            
        })

    }
    
    func getEvent(_ eventId:String, _ activity: Activity){
        apiService.createHeaderRequest(URL(string: "https://vincilive2.herokuapp.com/map/get-event"), method: "Get", parameters: ["eventId": eventId as AnyObject],requestCompletionFunction: {responseCode, json in
            if responseCode/100 == 2{
                print(json)
                
                var counter = 0
                var hostId = ""
                for (_,userId) in json["attendeesIds"]{
                    let Id  = userId.stringValue
                    if counter == 0{
                        activity.hostId = Id
                        hostId = Id
                    }else{
                        activity.participatorsIds.append(Id)
                    }
                    print(userId.stringValue)
                    
                    if (!UserController.sharedInstance.userIds.contains(Id)){
                        APIServiceController.sharedInstance.loadingPersonInfo(Id)
                    }
                    counter += 1
                }
                //user setup
                if UserController.sharedInstance.currentUser.userId == hostId{
                    var host_activity_matched = false
                    for activity in UserController.sharedInstance.currentUser.hostedActivities{
                        if activity.activityId == activity.activityId{
                            host_activity_matched = true
                            break
                        }
                    }
                    if host_activity_matched{
                    }else{
                        UserController.sharedInstance.currentUser.hostedActivities.append(activity)
                    }
                }
                for (_,userId) in json["attendeesIds"]{
                    let Id = userId.stringValue
                    if Id == UserController.sharedInstance.currentUser.userId{
                        var attend_activity_matched = false
                        for activity in UserController.sharedInstance.currentUser.attendedActivities{
                            if activity.activityId == activity.activityId{
                                attend_activity_matched = true
                                break
                            }
                        }
                        if attend_activity_matched{
                        }else{
                            UserController.sharedInstance.currentUser.attendedActivities.append(activity)
                        }
                        
                    }
                }
                
            }else{
                print("error in getting event")
            }
            
        })
    }
    
    func addActivity(_ activity: Activity, completeClosure: @escaping ()->Void ){
        //let userId = UserController.sharedInstance.currentUser.userId
        let title = activity.name
        let address = activity.fullAddress
        let description = activity.description
        let privacy = activity.privacy
        let invites = activity.invites
        dateFormatter.dateFormat = "HH:mm:ss"
        let startTime = dateFormatter.string(from: activity.startTime as Date)
        let endTime = dateFormatter.string(from: activity.endTime as Date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: activity.date as Date)
        apiService.createHeaderRequest(URL(string: "https://vincilive2.herokuapp.com/map/create"), method: "POST", parameters: ["title": title as AnyObject, "description": description as AnyObject, "address": address as AnyObject, "date":date as AnyObject, "startTime":startTime as AnyObject, "endTime": endTime as AnyObject, "eventPrivacy": privacy as AnyObject, "inviteeEmail": invites as AnyObject, "eventTag": "Social" as AnyObject], requestCompletionFunction: {responseCode, json in
            if responseCode/100 == 2{
                print("create activity successfully")
                completeClosure()
                print(json)
            }else{
                print("error")
                print(responseCode)
                print(json)
                completeClosure()
            }
        })

//        apiService.executeRequest(request, requestCompletionFunction: {responseCode, json in
//            if responseCode/100 == 2{
//                print("create activity successfully")
//                print(json)
//            }else{
//                print("error")
//                print(json)
//            }
//        })
    }
    
}
