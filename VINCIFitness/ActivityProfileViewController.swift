//
//  ActivityProfileViewController.swift
//  VINCIFitness
//
//  Created by David Xu on 9/29/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit
import ImageLoader

class ActivityProfileViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    let myNavigationController = UINavigationController()

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
    var activty = ActivityController.sharedInstance.currentActivity
    var host = User(emailAddress: "")
    var dateFormatter = DateFormatter()
    var joined = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for label in indicateLabels{
            label.textColor = UIColor.vinciRed()
        }
        hostLabel.textColor = UIColor.vinciRed()
        titleLabel.textColor = UIColor.vinciRed()
        dateLabel.textColor = UIColor.vinciRed()
        toTimeLabel.textColor = UIColor.vinciRed()
        fromTimeLabel.textColor = UIColor.vinciRed()
        addressLabel.textColor = UIColor.vinciRed()
        closeButton.tintColor = UIColor.vinciRed()
        descriptionLabel.textColor = UIColor.vinciRed()
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.numberOfLines = 0
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 40, height: 40)
        self.collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.register(UINib(nibName: "PartuicipatorCell",bundle: nil), forCellWithReuseIdentifier: "newCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        profileImageView.backgroundColor = UIColor.vinciRed()
        profileImageView.layer.cornerRadius = 40
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(self.knowHost))
        profileImageView.addGestureRecognizer(gestureRec)
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.vinciRed().cgColor
        
        for user in UserController.sharedInstance.users{
            if activty.hostId == user.userId{
                host = user
                break
            }
        }
        for id in activty.participatiorsIds{
            for user in UserController.sharedInstance.users{
                if id == user.userId{
                    participators.append(user)
                    break
                }
            }
            if id == UserController.sharedInstance.currentUser.userId{
                joined = true
            }
        }
        descriptionLabel.text = activty.description
        addressLabel.text = activty.fullAddress
        dateFormatter.dateStyle = .long
        dateLabel.text = dateFormatter.string(from: activty.date as Date)
        dateFormatter.dateFormat = "hh:mm a"
        fromTimeLabel.text = dateFormatter.string(from: activty.startTime as Date)
        toTimeLabel.text = dateFormatter.string(from: activty.endTime as Date)
        titleLabel.text = activty.name
        hostLabel.text = host.firstName + " " + host.lastName
        if joined{
            joinButton.setTitle("joined!", for: UIControlState())
            joinButton.isUserInteractionEnabled = false
        }
        
        if host.userId == UserController.sharedInstance.currentUser.userId{
            joinButton.isHidden = true
        }else{
            editButton.isHidden = true
            deleteButton.isHidden = true
        }
        let picurl = URL(string: host.profileImageURL)
        profileImageView.load(picurl!)
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participators.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "newCell", for: indexPath) as! PartuicipatorCell
        let url = URL(string: participators[(indexPath as NSIndexPath).row].profileImageURL)
        newCell.profileImageView.load(url!)
        return newCell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserController.sharedInstance.viewedUser = participators[(indexPath as NSIndexPath).row]
        UserController.sharedInstance.isTabPresented = false
        self.present(ProfileViewController(), animated: true, completion: nil)
    }
    @IBAction func joinPressed(_ sender: UIButton) {
        let eventId = activty.activityId
        let apiService = APIService()
        let userId = UserController.sharedInstance.currentUser.userId
        apiService.createHeaderRequest(URL(string: "https://vinci-server.herokuapp.com/map/app/event-signup"), method: "PUT", parameters: ["eventId": eventId as AnyObject, "userId": userId as AnyObject], requestCompletionFunction: {responseCode, json in
            if responseCode/100 == 2{
                print(json)
                self.joinButton.setTitle("Joined!", for: UIControlState())
            }else{
                print(json)
                print("error in joining activity")
            }
            
        })
//        apiService.executeRequest(request, requestCompletionFunction: {responseCode, json in
//            if responseCode/100 == 2{
//                print(json)
//                self.joinButton.setTitle("Joined!", for: UIControlState())
//            }else{
//                print(json)
//                print("error in joining activity")
//            }
//            
//        })
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
        apiService.createHeaderRequest(URL(string: "https://vinci-server.herokuapp.com/map/app-delete-event"), method: "POST", parameters: ["eventId": activty.activityId as AnyObject], requestCompletionFunction: {responseCode, json in
            if responseCode/100 == 2{
                print(json)
                self.dismiss(animated: true, completion: nil)
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
    
}
