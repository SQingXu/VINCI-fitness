//
//  ProfileViewController.swift
//  VINCIFitness
//
//  Created by David Xu on 8/15/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet var Underlineview: [UIView]!
    @IBOutlet weak var joinActivityButton: UIButton!
    @IBOutlet weak var hostActivityButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var homeAddressLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    let dateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        bioLabel.lineBreakMode = .byWordWrapping
        bioLabel.numberOfLines = 0
        homeAddressLabel.lineBreakMode = .byWordWrapping
        homeAddressLabel.numberOfLines = 0
        for view in Underlineview{
            view.backgroundColor = UIColor.vinciRed()
        }
        profileImageView.layer.cornerRadius = 60
        let user = UserController.sharedInstance.viewedUser
        firstNameLabel.text = user.firstName
        lastnameLabel.text = user.lastName
        let picurl = URL(string: user.profileImageURL)
        profileImageView.load(picurl!)
        dateFormatter.dateStyle = .long
        birthdayLabel.text = dateFormatter.string(from: user.birthday as Date)
        homeAddressLabel.text = user.homeAddressFull
        bioLabel.text = user.bio
        if user.emailAddress == ""{
            emailAddressLabel.text = "Email: Unknown"
        }else{
            emailAddressLabel.text = user.emailAddress
        }
        let boolValue = UserController.sharedInstance.isTabPresented
        if boolValue{
            closeButton.isHidden = true
        }else{
            closeButton.tintColor = UIColor.vinciRed()
            hostActivityButton.isHidden = true
            joinActivityButton.isHidden = true
        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        UserController.sharedInstance.isTabPresented = true
        UserController.sharedInstance.viewedUser = UserController.sharedInstance.currentUser
    }
    
    @IBAction func hostActivityButtonPressed(_ sender: UIButton) {
        ActivityController.sharedInstance.currentShownActivities = UserController.sharedInstance.currentUser.hostedActivities
        self.present(ActivityListViewController(), animated: true, completion: nil)
    }
    @IBAction func joinActivityPressed(_ sender: UIButton) {
        ActivityController.sharedInstance.currentShownActivities = UserController.sharedInstance.currentUser.attendedActivities
        self.present(ActivityListViewController(), animated: true, completion: nil)
    }

    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
