//
//  ActivityProfileViewController.swift
//  VINCIFitness
//
//  Created by David Xu on 9/29/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit
import ImageLoader
import EventKit

class ActivityProfileViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    let myNavigationController = UINavigationController()

    @IBOutlet weak var descriptionHeadLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet var indicateLabels: [UILabel]!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fromTimeLabel: UILabel!
    @IBOutlet weak var toTimeLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var joinButton: UIButton!
    var participators = [User]()
    var activity: Activity = Activity()
    var host = User(emailAddress: "")
    var dateFormatter = DateFormatter()
    var joined = false
    var apiService = APIService()
    var attendeesIds = [String]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for label in indicateLabels{
            label.textColor = UIColor.vinciRed()
        }
        
        activity = ActivityController.sharedInstance.currentActivity
        activity.participatorsIds = []
        hostLabel.text = ""
        hostLabel.textColor = UIColor.vinciRed()
        titleLabel.textColor = UIColor.vinciRed()
        dateLabel.textColor = UIColor.vinciRed()
        toTimeLabel.textColor = UIColor.vinciRed()
        fromTimeLabel.textColor = UIColor.vinciRed()
        addressLabel.textColor = UIColor.vinciRed()
        closeButton.tintColor = UIColor.vinciRed()
        descriptionHeadLabel.textColor = UIColor.vinciRed()
        descriptionLabel.textColor = UIColor.vinciRed()
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.numberOfLines = 0
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 40, height: 40)

        
        profileImageView.backgroundColor = UIColor.white
        profileImageView.layer.cornerRadius = 50
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(self.knowHost))
        profileImageView.addGestureRecognizer(gestureRec)
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.vinciRed().cgColor
        
        
        descriptionLabel.text = activity.description
        addressLabel.text = activity.fullAddress
        dateFormatter.dateStyle = .long
        dateLabel.text = dateFormatter.string(from: activity.date as Date)
        dateFormatter.dateFormat = "hh:mm a"
        fromTimeLabel.text = dateFormatter.string(from: activity.startTime as Date)
        toTimeLabel.text = dateFormatter.string(from: activity.endTime as Date)
        titleLabel.text = activity.name
        //participators = [User]()
        
        
        apiService.createHeaderRequest(URL(string: "https://vincilive2.herokuapp.com/map/get-event"), method: "POST", parameters: ["eventId": activity.activityId as AnyObject],requestCompletionFunction: {responseCode, json in
            if responseCode/100 == 2{
                print(json)
                self.activity = ActivityController.sharedInstance.currentActivity
                var array = json["array"]
                self.activity.hostId = array["userIdPublic"].stringValue
                self.activity.description = array["description"].stringValue
                self.activity.tag = array["tag"].stringValue
                let privacyTemp = array["privacy"].intValue
                if (privacyTemp == 0){
                    self.activity.privacy = "Private"
                }
                else{
                    self.activity.privacy = "Public"
                }
                self.activity.participatorsIds.append(self.activity.hostId)
                self.attendeesIds = array["attendeesIds"].stringValue.components(separatedBy: ",")
                for userId in self.attendeesIds{
                    if (userId != self.activity.hostId){
                        self.activity.participatorsIds.append(userId)
                    }
                    print(userId)
                }
                
                self.collectionView.setCollectionViewLayout(flowLayout, animated: true)
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.collectionView.register(UINib(nibName: "PartuicipatorCell",bundle: nil), forCellWithReuseIdentifier: "newCell")
                //user setup
                self.participators = [User]()
                for userId in self.activity.participatorsIds{
                    if (!UserController.sharedInstance.userIds.contains(userId)){
                        UserController.sharedInstance.userIds.append(userId)
                        self.apiService.createHeaderRequest(URL(string: "https://vincilive2.herokuapp.com/profile/app/"+userId), method: "POST", parameters: nil, requestCompletionFunction: {
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
                                newUser.status = json["status"].stringValue
                                newUser.facebook = json["facebook"].stringValue
                                newUser.twitter = json["twitter"].stringValue
                                newUser.instagram = json["instagram"].stringValue
                                UserController.sharedInstance.users[userId] = newUser;
                                
                                if self.activity.hostId == newUser.userId{
                                        self.host = newUser
                                    self.hostLabel.text = self.host.firstName + " " + self.host.lastName;
                                    if self.host.userId == UserController.sharedInstance.currentUser.userId{
                                        self.joinButton.isHidden = true
                                    }else{
                                        self.editButton.isHidden = true
                                        self.deleteButton.isHidden = true
                                    }
                                    
                                    let picurl = URL(string: self.host.profileImageURL)
                                    self.profileImageView.downloadedFrom(url: picurl!, contentMode: .scaleAspectFill)
                                    self.downloadedFromHost(url: picurl!)
                                }
                                
                                self.participators.append(newUser)

                                if newUser.userId == UserController.sharedInstance.currentUser.userId{
                                    self.joined = true
                                }
                                
                                
                                if self.joined{
                                    self.joinButton.setTitle("Leave", for: UIControlState())
                                    //joinButton.isUserInteractionEnabled = false
                                }
                                self.collectionView.reloadData()

                                
                                
                            }else{
                                print(responseCode)
                                print(json)
                                print("error")
                                
                            }
                        })
                        
                    } else {
                        let newUser = UserController.sharedInstance.users[userId]
                        if self.activity.hostId == newUser?.userId{
                            self.host = newUser!
                            self.hostLabel.text = self.host.firstName + " " + self.host.lastName;
                            if self.host.userId == UserController.sharedInstance.currentUser.userId{
                                self.joinButton.isHidden = true
                            }else{
                                self.editButton.isHidden = true
                                self.deleteButton.isHidden = true
                            }
                            
                            let picurl = URL(string: self.host.profileImageURL)
                            self.profileImageView.downloadedFrom(url: picurl!, contentMode: .scaleAspectFill)
                            self.downloadedFromHost(url: picurl!)
                        }
                        
                        self.participators.append(newUser!)
                        
                        if newUser?.userId == UserController.sharedInstance.currentUser.userId{
                            self.joined = true
                        }
                        
                        
                        if self.joined{
                            self.joinButton.setTitle("Leave", for: UIControlState())
                            //joinButton.isUserInteractionEnabled = false
                        }
                        self.collectionView.reloadData()
                    }
                    
                    self.collectionView.reloadData()
                    self.joinButton.backgroundColor = UIColor.vinciRed()
                    self.editButton.backgroundColor = UIColor.vinciRed()
                    self.deleteButton.backgroundColor = UIColor.vinciRed()
                }
             
            }else{
                print("error in getting event")
            }
        })

        
        
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(participators.count)
        return participators.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "newCell", for: indexPath) as! PartuicipatorCell
        let url = URL(string: participators[(indexPath as NSIndexPath).row].profileImageURL)
        newCell.profileImageView.downloadedFrom(url: url!, contentMode: .scaleAspectFill)
        return newCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserController.sharedInstance.viewedUser = participators[(indexPath as NSIndexPath).row]
        UserController.sharedInstance.isTabPresented = false
        self.present(ProfileViewController(), animated: true, completion: nil)
        
    }
    @IBAction func joinPressed(_ sender: UIButton) {
        if(joined){
            disjoinActivity()
        }else{
            joinActivity()
        }
    }
    func disjoinActivity(){
        let eventId = activity.activityId
        let apiService = APIService()
        let userId = UserController.sharedInstance.currentUser.userId
        joinButton.isUserInteractionEnabled = false
        apiService.createHeaderRequest(URL(string: "https://vincilive2.herokuapp.com/map/unregister-event"), method: "POST", parameters: ["eventId": eventId as AnyObject, "userId": userId as AnyObject], requestCompletionFunction: {responseCode, json in
            self.joinButton.isUserInteractionEnabled = true
            if responseCode/100 == 2{
                print(json)
                for(index, element) in self.participators.enumerated(){
                    if element.userId == userId{
                        self.participators.remove(at: index)
                        self.collectionView.reloadData()
                    }
                }
                UserController.sharedInstance.removeJoinedActivity(eventId: eventId)
                ActivityController.sharedInstance.removeParticipator(userId: userId, eventId: eventId)
                self.joinButton.setTitle("Join", for: UIControlState())
                self.joined = false
                
                let store : EKEventStore = EKEventStore()
                store.requestAccess(to: .event) {(granted, error) in
                    if (!granted) || (error != nil) { return }
                    let calendar = store.defaultCalendarForNewEvents
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd HH:mm"
                    let searchStartDate = formatter.date(from: "2016/10/08 22:31")
                    let searchEndDate = formatter.date(from: "2020/10/08 22:31")
                    let eventPredicate = store.predicateForEvents(withStart: searchStartDate!, end: searchEndDate!, calendars: [calendar])
                    var events = store.events(matching: eventPredicate)
                    if(events.contains {element  in
                        if ((element.hasNotes)
                            ){
                            if(element.notes!.contains(eventId)){
                                return true
                            }
                            else{
                                return false
                            }
                        } else {
                            return false
                        }
                    }){
                        let index = events.index {element  in
                            if ((element.hasNotes)
                                ){
                                if(element.notes!.contains(eventId)){
                                    return true
                                }
                                else{
                                    return false
                                }
                            } else {
                                return false
                            }
                        }
                        do {
                            try store.remove(events[index!], span: EKSpan.thisEvent)
                        } catch let error as NSError {
                            print("failed to remove event with error : \(error)")
                        }
                    }
                }
            }else{
                print(json)
                
                print("error in disjoining activity")
            }
            
        })
    }
    func joinActivity(){
        let eventId = activity.activityId
        let apiService = APIService()
        let userId = UserController.sharedInstance.currentUser.userId
        joinButton.isUserInteractionEnabled = false
        apiService.createHeaderRequest(URL(string: "https://vincilive2.herokuapp.com/map/event-signup/"+eventId), method: "POST", parameters: nil, requestCompletionFunction: {responseCode, json in
            self.joinButton.isUserInteractionEnabled = true
            if responseCode/100 == 2{
                print(json)
                ActivityController.sharedInstance.addParticipator(userId: userId, eventId: eventId)
                UserController.sharedInstance.addJoinedActivity(event: ActivityController.sharedInstance.currentActivity)
                
                self.participators.append(UserController.sharedInstance.currentUser)
                self.collectionView.reloadData()
                self.joinButton.setTitle("Leave", for: UIControlState())
                self.joined = true
            }else{
                print(json)
                print("error in joining activity")
            }
            
        })
    }
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        ActivityController.sharedInstance.editingActivity = true
        self.present(AddActivityViewController(), animated: true, completion: nil)
        
    }
    
    @IBAction func deletePressed(_ sender: AnyObject) {
        let apiService = APIService()
        apiService.createHeaderRequest(URL(string: "https://vincilive2.herokuapp.com/map/app-delete-event"), method: "POST", parameters: ["eventId": activity.activityId as AnyObject], requestCompletionFunction: {responseCode, json in
            if responseCode/100 == 2{
                print(json)
                UserController.sharedInstance.removeHostedActivity(eventId: self.activity.activityId)
                self.dismiss(animated: true, completion: nil)
                
                let store : EKEventStore = EKEventStore()
                store.requestAccess(to: .event) {(granted, error) in
                    if (!granted) || (error != nil) { return }
                    let calendar = store.defaultCalendarForNewEvents
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd HH:mm"
                    let searchStartDate = formatter.date(from: "2016/10/08 22:31")
                    let searchEndDate = formatter.date(from: "2020/10/08 22:31")
                    let eventPredicate = store.predicateForEvents(withStart: searchStartDate!, end: searchEndDate!, calendars: [calendar])
                    var events = store.events(matching: eventPredicate)
                    if(events.contains {element  in
                        if ((element.hasNotes)
                            ){
                            if(element.notes!.contains(self.activity.activityId)){
                                return true
                            }
                            else{
                                return false
                            }
                        } else {
                            return false
                        }
                    }){
                        let index = events.index {element  in
                            if ((element.hasNotes)
                                ){
                                if(element.notes!.contains(self.activity.activityId)){
                                    return true
                                }
                                else{
                                    return false
                                }
                            } else {
                                return false
                            }
                        }
                        do {
                            try store.remove(events[index!], span: EKSpan.thisEvent)
                        } catch let error as NSError {
                            print("failed to remove event with error : \(error)")
                        }
                    }
                }
                print("event is successfully deleted")
            }else{
                print(json)
                print("error in deleting event")
            }
            
        })

//        apiService.executeRequest(request, requestCompletionFunction: {responseCode, json in
//            if responseCode/100 == 2{
//                print(json)
//                self.dismiss(animated: true, completion: nil)
//                print("event is successfully deleted")
//            }else{
//                print(json)
//                print("error in deleting event")
//            }
//            
//        })
    }
    func knowHost(){
        UserController.sharedInstance.viewedUser = host
        UserController.sharedInstance.isTabPresented = false
        self.present(ProfileViewController(), animated: true, completion: nil)
    }
    func downloadedFromHost(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    print("error in downloading image")
                    print(error as Any)
                    return }
            DispatchQueue.main.async() { () -> Void in
                self.host.imageData = image
            }
            }.resume()
    }
    func downloadedFromHost(link: String, contentMode mode: UIViewContentMode) {
        guard let url = URL(string: link) else { return }
        downloadedFromHost(url: url)
    }
    
}
