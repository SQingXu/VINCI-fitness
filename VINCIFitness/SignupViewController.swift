//
//  SignupViewController.swift
//  VINCIFitness
//
//  Created by David Xu on 8/16/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SignupViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextStepButton: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var signupFacebookButton: UIButton!
    @IBOutlet weak var passwordTextField: ValidatePasswordField!
    @IBOutlet weak var confirmPasswordField:ConfirmPasswordTextField!
    @IBOutlet weak var emailTextField: ValidateEmailTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundView.layer.cornerRadius = 20
        roundView.backgroundColor = UIColor.vinciRed()
        rightView.backgroundColor = UIColor.vinciRed()
        leftView.backgroundColor = UIColor.vinciRed()
        emailView.backgroundColor = UIColor.vinciRed()
        passwordView.backgroundColor = UIColor.vinciRed()
        confirmPasswordView.backgroundColor = UIColor.vinciRed()
        nextStepButton.backgroundColor = UIColor.vinciRed()
        nextStepButton.layer.cornerRadius = 5
        signupFacebookButton.layer.cornerRadius = 5
        backButton.tintColor = UIColor.vinciRed()
        self.hideKeyboardWhenTapped()
        
        passwordTextField.delegate = self
        confirmPasswordField.delegate = self
        

    }

    @IBAction func signupFacebookPressed(_ sender: UIButton) {
         login()
    }
    @IBAction func nextStepPressed(_ sender: UIButton) {
        if passwordTextField.isValid == false || emailTextField.isValid == false || confirmPasswordField.isValid == false{
            let alert = UIAlertController(title: "Unable to go to the next step", message: "The information you entered is invalid. Please check again", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            UserController.sharedInstance.currentUser.emailAddress = emailTextField.text!
            UserController.sharedInstance.currentUser.password = passwordTextField.text!
            self.present(SignUpPageViewController(), animated: true, completion: nil)
        }
        
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTextField{
            confirmPasswordField.passwordString = passwordTextField.text!
        }
    }
    func login(){
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self, handler: {(result, error) in
            if error != nil{
                print("facebook log in error")
            }
            else if (result?.isCancelled)!{
                print("log in cancelled by user")
            }
            else{
                let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, first_name,last_name, picture.type(large),email,gender,age_range"])
                graphRequest.start(completionHandler: {(connection, result, error) -> Void in
                    if error == nil{
                        //print(result)
                        let data:[String:AnyObject] = result as! [String : AnyObject]
                        //let url = result.value(forKey: "picture")?.value(forKey: "data")?.value(forKey: "url")
//                        let url = data["picture"]?["data"]["url"]
////                        if url != nil{
//                            print(url)
//                            UserController.sharedInstance.currentUser.profileImageURL = url as! String
//                        }
                        let picture:[String:AnyObject] = data["picture"] as! [String: AnyObject]
                        let pic_data:[String:AnyObject] = picture["data"] as! [String: AnyObject]
                        let url = pic_data["url"]
                        if url != nil{
                            UserController.sharedInstance.currentUser.profileImageURL = url as! String
                            print(url)
                        }
                    
                        let emailString = data["email"]
                        if emailString != nil{
                            UserController.sharedInstance.currentUser.emailAddress = emailString as! String
                        }
                        let firstName = data["first_name"]
                        if firstName != nil{
                            UserController.sharedInstance.currentUser.firstName = firstName as! String
                        }
                        let lastName = data["last_name"]
                        if lastName != nil{
                            UserController.sharedInstance.currentUser.lastName = lastName as! String
                        }
                        let facebookId = data["id"]
                        if facebookId != nil{
                            UserController.sharedInstance.currentUser.facebookID = facebookId as! String
                            UserController.sharedInstance.currentUser.password = facebookId as! String
                        }
                        
                        
                        let dict = data["age_range"] as? [String:Int]
                        if dict == nil{
                            print("nil")
                        }else{
                            if ((dict?["min"] != nil) && (dict?["max"] != nil)){
                            UserController.sharedInstance.currentUser.age = Int((dict!["max"]! + dict!["min"]!)/2)
                            } else if ((dict?["min"] != nil) && (dict?["max"] == nil)){
                                UserController.sharedInstance.currentUser.age = Int(dict!["min"]!)
                            } else if ((dict?["min"] == nil) && (dict?["max"] != nil)){
                                UserController.sharedInstance.currentUser.age = Int(dict!["max"]!)
                            } else{
                                UserController.sharedInstance.currentUser.age = 0
                            }
                        }
                        let gender = data["gender"]
                        if gender != nil{
                            let genderString = gender as! String
                            if genderString == "male"{
                                UserController.sharedInstance.currentUser.gender = .Male
                            }else if genderString == "female"{
                                UserController.sharedInstance.currentUser.gender = .Female
                            }
                        }
                        self.present(SignUpPageViewController(), animated: true, completion: nil)
                    }else{
                        print(error)
                    }
                })
            }
        })
        
    }


}
