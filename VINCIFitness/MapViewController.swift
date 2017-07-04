//
//  MapViewController.swift
//  VINCIFitness
//
//  Created by David Xu on 8/15/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController,GMSMapViewDelegate{
    var mapView = GMSMapView()
    var camera = GMSCameraPosition()
    var dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainScreen = UIScreen.main.bounds
        camera = GMSCameraPosition.camera(withLatitude: 35.91, longitude: -79.056, zoom: 15.0)
        let mapFrame = CGRect(x: 0, y: 0, width: mainScreen.width, height: mainScreen.height - 44)
        mapView = GMSMapView.map(withFrame: mapFrame, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
//        let positionButton = UIButton()
//        let position_view = UIImageView()
//        position_view.frame = CGRectMake(10, 10, 30, 30)
//        position_view.image = UIImage(named: "position_icon.png")
//        positionButton.frame = CGRectMake(0.8 * mainScreen.width, 0.7 * mainScreen.height, 50, 50)
//        positionButton.addTarget(self, action: #selector(self.positionButtonPressed), forControlEvents: .TouchUpInside)
//        positionButton.backgroundColor = UIColor.whiteColor()
//        positionButton.layer.cornerRadius = 25
//        positionButton.addSubview(position_view)
        let listButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.listActivities))
        listButton.tintColor = UIColor.vinciRed()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addOneLocation))
        addButton.tintColor = UIColor.vinciRed()
        self.navigationItem.setRightBarButton(listButton, animated: true)
        self.navigationItem.setLeftBarButton(addButton, animated: true)
        self.view.addSubview(mapView)
        

        //create a maker
//        let marker = Maker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.46, longitude: 151)
//        marker.title = "Sydney"
//        marker.map = mapView
//        marker.addIcon()
        
        
    }
    
    func listActivities(){
        var activityList = [Activity]()
        for marker in MakerController.sharedInstance.currentMakers{
            for activity in marker.activityList{
                activityList.append(activity)
            }
        }
        ActivityController.sharedInstance.currentShownActivities = activityList
        self.present(ActivityListViewController(), animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if MakerController.sharedInstance.currentMaker != nil{
            let currentMaker = MakerController.sharedInstance.currentMaker
            currentMaker?.map = mapView
            currentMaker?.addIcon()
            let cameraUpdate = GMSCameraUpdate.setTarget((currentMaker?.position)!, zoom: 15.0)
            mapView.animate(with: cameraUpdate)
            
        }
        getActivities()
    }
    func addOneLocation(){
        self.navigationController?.pushViewController(AddActivityViewController(), animated: true)
        
    }
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let tappedMaker = marker as! Maker
        let infoView = Bundle.main.loadNibNamed("PopupView", owner: self, options: nil)?[0] as! PopupView
        infoView.ActivityNumLabel.text = String(tappedMaker.activityList.count)
        infoView.placeNameLabel.text = tappedMaker.placeName
        return infoView
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let tappedMarker = marker as! Maker
        MakerController.sharedInstance.currentMaker = tappedMarker
        ActivityController.sharedInstance.currentShownActivities = (MakerController.sharedInstance.currentMaker?.activityList)!
        self.present(ActivityListViewController(), animated: true, completion: nil)
    }
    func getActivities(){
        let apiService = APIService()
        apiService.createMutableAnonRequest(URL(string:"https://vincilive.herokuapp.com/map/app-data"), method: "GET", parameters: nil,requestCompletionFunction: {responseCode, json in
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
                    //set up activity
                    let newActivity = Activity()
                    newActivity.name = maker["title"].stringValue
                    //activity id
                    newActivity.activityId = maker["id"].stringValue
                    //addressname
                    newActivity.fullAddress = maker["address"].stringValue
                    //date
                    let dateString = maker["date"].stringValue
                    self.dateFormatter.dateFormat = "yyyy-MM-dd"
                    newActivity.date = self.dateFormatter.date(from: dateString)!
                    //start time
                    let startTimeString = maker["startTime"].stringValue
                    self.dateFormatter.dateFormat = "hh:mm a"
                    newActivity.startTime = self.dateFormatter.date(from: startTimeString)!
                    //end time
                    let endTimeString = maker["endTime"].stringValue
                    newActivity.endTime = self.dateFormatter.date(from: endTimeString)!
                    //description
                    newActivity.description = maker["description"].stringValue
                    //participators
                    var counter = 0
                    var hostId = ""
                    for (_,userId) in maker["attendeesIds"]{
                        let Id  = userId.stringValue
                        if counter == 0{
                            newActivity.hostId = Id
                            hostId = Id
                        }else{
                            newActivity.participatiorsIds.append(Id)
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
                            if activity.activityId == newActivity.activityId{
                                host_activity_matched = true
                                break
                            }
                        }
                        if host_activity_matched{
                        }else{
                            UserController.sharedInstance.currentUser.hostedActivities.append(newActivity)
                        }
                    }
                    for (_,userId) in maker["attendeesIds"]{
                        let Id = userId.stringValue
                        if Id == UserController.sharedInstance.currentUser.userId{
                            var attend_activity_matched = false
                            for activity in UserController.sharedInstance.currentUser.attendedActivities{
                                if activity.activityId == newActivity.activityId{
                                    attend_activity_matched = true
                                    break
                                }
                            }
                            if attend_activity_matched{
                            }else{
                                UserController.sharedInstance.currentUser.attendedActivities.append(newActivity)
                            }
                            
                        }
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
                        newMaker.activityList.append(newActivity)
                        updatedArray.append(newMaker)
                    }else{
                        matchedMarker.activityList.append(newActivity)
                    }
                    print(maker["address"].stringValue)
                    
                }
                MakerController.sharedInstance.currentMakers = updatedArray
                self.mapView.clear()
                for marker in MakerController.sharedInstance.currentMakers{
                    marker.map = self.mapView
                    marker.infoWindowAnchor = CGPoint(x: 0.6, y: 0)
                    marker.addIcon()
                    print(marker.activityList.count)
                }
                //print(json)
                print(responseCode)
            }
            else {
                print(responseCode)
                print("error")
            }
        })

    }
    
}

