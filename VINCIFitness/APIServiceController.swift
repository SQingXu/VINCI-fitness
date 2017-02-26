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
        apiService.createMutableAnonRequest(URL(string:"https://vincilive.herokuapp.com/map/get-data"), method: "POST", parameters: ["range":"30" as AnyObject,"lat":"35.8" as AnyObject,"lng":"-78.775" as AnyObject], requestCompletionFunction: {responseCode, json in
            if responseCode/100 == 2{
                print(json)
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
        apiService.createMutableAnonRequest(URL(string:"https://vincilive.herokuapp.com/login"), method: "POST", parameters: ["email":"nicdavid@live.unc.edu" as AnyObject,"pass":"" as AnyObject], requestCompletionFunction: {responseCode, json in
            
            print("THE USER HAS PRESSED LOGIN2")
            print("THE USER HAS PRESSED LOGIN2")
            print("THE USER HAS PRESSED LOGIN2")
            print("THE USER HAS PRESSED LOGIN2")
            print("THE USER HAS PRESSED LOGIN2")
            print("THE USER HAS PRESSED LOGIN2")
            
            
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
        apiService.createHeaderRequest(URL(string:"https://vinci-server.herokuapp.com/profile-creation/app-submit"), method: "POST", parameters: ["email":email as AnyObject ,"password":password as AnyObject,"address":address as AnyObject,"firstName": firstName as AnyObject,"lastName":lastName as AnyObject,"birthday":birthday as AnyObject], requestCompletionFunction: {
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
                    apiService.createHeaderRequest(URL(string: "https://vinci-server.herokuapp.com/profile/app/"+userId), method: "GET", parameters: nil, requestCompletionFunction: {
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
            apiService.createHeaderRequest(URL(string: "https://vinci-server.herokuapp.com/profile/app/"+userId), method: "GET", parameters: nil, requestCompletionFunction: {
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
        apiService.createHeaderRequest(URL(string: "https://vinci-server.herokuapp.com/profile/app/"+userId), method: "GET", parameters: nil, requestCompletionFunction: {
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
    func loadCurrentInfo(){
        let userId = UserController.sharedInstance.currentUser.userId
        apiService.createHeaderRequest(URL(string: "https://vinci-server.herokuapp.com/profile/app/" + userId), method: "GET", parameters: nil, requestCompletionFunction: {
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
        apiService.createHeaderRequest(URL(string: "https://vinci-server.herokuapp.com/map/event-signup"), method: "PUT", parameters: ["eventId": eventId as AnyObject, "userId": userId as AnyObject],requestCompletionFunction: {responseCode, json in
            if responseCode/100 == 2{
                print(json)
            }else{
                print("error in joining activity")
            }
            
        })
        
    }
    
    func addActivity(_ activity: Activity, completeClosure: @escaping ()->Void ){
        //        let userId = UserController.sharedInstance.currentUser.userId
        let title = activity.name
        let address = activity.fullAddress
        let description = activity.description
        dateFormatter.dateFormat = "HH:mm:ss"
        let startTime = dateFormatter.string(from: activity.startTime as Date)
        let endTime = dateFormatter.string(from: activity.endTime as Date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: activity.date as Date)
        apiService.createHeaderRequest(URL(string: "https://vincilive.herokuapp.com/map/create"), method: "POST", parameters: ["title": title as AnyObject, "description": description as AnyObject, "address": address as AnyObject, "date":date as AnyObject, "startTime":startTime as AnyObject, "endTime": endTime as AnyObject, "eventPrivacy": "public" as AnyObject, "inviteeEmail": "" as AnyObject, "tag": "Social" as AnyObject], requestCompletionFunction: {responseCode, json in
            
            print(json)
            print(responseCode)
            
            if responseCode/100 == 2{
                print("create activity successfully")
                completeClosure()
                print(json)
            }else{
                print("error")
                print(json)
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
