//
//  OnboardViewController.swift
//  VINCIFitness
//
//  Created by David Xu on 8/15/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    let dateFormatter = DateFormatter()
    //    override func viewDidLoad() {
    //        activityIndicator.isHidden = true
    //        if let email = UserDefaults.standard.value(forKey: "email") as? String{
    //            if let password = UserDefaults.standard.value(forKey: "password") as? String{
    //                activityIndicator.isHidden = false
    //                activityIndicator.startAnimating()
    //                loginButton.isEnabled = false
    //                signUpButton.isEnabled = false
    //                UserController.sharedInstance.currentUser.emailAddress = email
    //                UserController.sharedInstance.currentUser.password = password
    //                let apiService = APIService()
    //                apiService.createMutableAnonRequest(URL(string:"https://vincilive.herokuapp.com/login"), method: "POST", parameters: ["email":email as AnyObject,"pass":password as AnyObject], requestCompletionFunction: {responseCode, json in
    //                    //print(json)
    //
    //
    //                    print("THE USER HAS PRESSED LOGIN5")
    //                    print("THE USER HAS PRESSED LOGIN5")
    //                    print("THE USER HAS PRESSED LOGIN5")
    //                    print("THE USER HAS PRESSED LOGIN5")
    //                    print("THE USER HAS PRESSED LOGIN5")
    //                    print("THE USER HAS PRESSED LOGIN5")
    //                    print(email)
    //                    print(password)
    //
    //                    if responseCode/100 == 2{
    //                        if json["userId"].stringValue != ""{
    //                            self.dismiss(animated: true, completion: nil)
    //                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //                            let application = UIApplication.shared
    //                            let window = application.keyWindow
    //                            print(json["userId"].stringValue)
    //                            //set user default
    //                            UserController.sharedInstance.currentUser.userId = json["userId"].stringValue
    //                            UserController.sharedInstance.viewedUser = UserController.sharedInstance.currentUser
    ////                            let userId = UserController.sharedInstance.currentUser.userId
    //                            apiService.createHeaderRequest(URL(string: "https://vinci-server.herokuapp.com/profile/app/testing"), method: "GET", parameters: nil, requestCompletionFunction: {
    //                                responseCode, json in
    //                                self.loginButton.isEnabled = true
    //                                self.signUpButton.isEnabled = true
    //
    //                                print("attempting to get profile data")
    //
    //                                if responseCode/100 == 2{
    //                                    UserController.sharedInstance.currentUser.bio = json["biography"].stringValue
    //                                    UserController.sharedInstance.currentUser.profileImageURL = json["imageProfile"].stringValue
    //                                    UserController.sharedInstance.currentUser.firstName = json["firstName"].stringValue
    //                                    UserController.sharedInstance.currentUser.lastName = json["lastName"].stringValue
    //                                    self.dateFormatter.dateFormat = "yyyy-MM-dd"
    //                                    UserController.sharedInstance.currentUser.birthday = self.dateFormatter.date(from: json["birthday"].stringValue)!
    //                                    UserController.sharedInstance.currentUser.homeAddressFull = json["address"].stringValue
    //                                    UserController.sharedInstance.currentUser.coverImageUrl = json["imageCover"].stringValue
    //                                    UserController.sharedInstance.viewedUser = UserController.sharedInstance.currentUser
    //                                    self.activityIndicator.isHidden = true
    //                                    self.activityIndicator.stopAnimating()
    //                                    window?.rootViewController = appDelegate.initTabBarController()
    //                                }else{
    //                                    print("error")
    //                                }
    //                            })
    //
    //                        }else{
    //
    //                        }
    //
    //                    }else{
    //                        self.loginButton.isEnabled = true
    //                        self.signUpButton.isEnabled = true
    //                        self.activityIndicator.isHidden = true
    //                        self.activityIndicator.stopAnimating()
    //                    }
    //                })
    //
    //            }
    //        }
    //
    //        super.viewDidLoad()
    //        loginButton.setTitleColor(UIColor.white, for: UIControlState())
    //        loginButton.backgroundColor = UIColor.vinciRed()
    //        loginButton.layer.cornerRadius = 5
    //
    //        signUpButton.setTitleColor(UIColor.white, for: UIControlState())
    //        signUpButton.backgroundColor = UIColor.vinciRed()
    //        signUpButton.layer.cornerRadius = 5
    //
    //
    //        // Do any additional setup after loading the view.
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        self.present(LoginViewController(), animated: true, completion: nil)
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        self.present(SignupViewController(), animated: true, completion: nil)
    }
    
}
