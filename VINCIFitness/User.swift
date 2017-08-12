//
//  User.swift
//  VINCIFitness
//
//  Created by David Xu on 8/17/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import Foundation
import UIKit
enum Gender: String{
    case Male = "Male"
    case Female = "Female"
}
class User{
    var nameString = ""
    var lastName: String = ""
    var firstName: String = ""
    var age: Int?
    var gender: Gender?
    var facebookID: String = ""
    var profileImageURL: String = ""
    var bio: String = ""
    var emailAddress: String
    var homeAddressFull:String = ""
    var birthday = Date()
    var password = ""
    var userId = ""
    var coverImageUrl:String = ""
    var imageData:UIImage?
    
    var hostedActivities = [Activity]()
    var attendedActivities = [Activity]()
    var calendarEventIds = [String]()
    
    init(emailAddress:String){
        self.emailAddress = emailAddress
    }
}
