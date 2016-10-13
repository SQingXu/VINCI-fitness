//
//  MakerController.swift
//  VINCIFitness
//
//  Created by David Xu on 8/26/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import Foundation
class MakerController{
    static var sharedInstance = MakerController()
    fileprivate init(){}
    
    var currentMakers = [Maker]()
    var currentMaker:Maker?
}
