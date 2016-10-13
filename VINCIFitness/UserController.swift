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
    var currentUser = User(emailAddress: "xsq4525")
    var isTabPresented = true
    var viewedUser = User(emailAddress: "")
    var users = [User]()
    var userIds = [String]()
    fileprivate init(){ }
}
