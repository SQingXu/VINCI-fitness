//
//  LoginViewController.swift
//  VINCIFitness
//
//  Created by David Xu on 8/16/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginfacebookButton: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var backButton: UIButton!
    let apiService = APIService()
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up views' color and corner radius
        roundView.layer.cornerRadius = 20
        roundView.backgroundColor = UIColor.vinciRed()
        rightView.backgroundColor = UIColor.vinciRed()
        leftView.backgroundColor = UIColor.vinciRed()
        passwordView.backgroundColor = UIColor.vinciRed()
        emailView.backgroundColor = UIColor.vinciRed()
        loginButton.backgroundColor = UIColor.vinciRed()
        loginButton.layer.cornerRadius = 5
        loginfacebookButton.layer.cornerRadius = 5
        backButton.tintColor = UIColor.vinciRed()
        emailTextField.textColor = UIColor.vinciRed()
        passwordTextField.textColor = UIColor.vinciRed()
        emailTextField.tintColor = UIColor.vinciRed()
        passwordTextField.tintColor = UIColor.vinciRed()
        
        //set up delegate
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //set up extension method
        self.hideKeyboardWhenTapped()
        
    }

    @IBAction func loginFacebookPressed(_ sender: UIButton) {
        login()
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
                        let data:[String:AnyObject] = result as! [String : AnyObject]
                        print(result)
                        print(data["email"])
                        //print(result.value(forKey: "email")!)
                        //print(result.value(forKey: "last_name"))
                        //print(result.value(forKey: "id")!)
                        //print(result.value(forKey: "picture")?.value(forKey: "data")?.value(forKey: "url"))
                        //print(result.value(forKey: "age_range")!["max"])
                        //let dict = result.value(forKey: "age_range") as? [String:Int]
                        //if dict == nil{
                        //   print("nil")
                        //}else{
                            //UserController.sharedInstance.currentUser.age = Int((dict!["max"]! + dict!["min"]!)/2)
                        //}
                        self.apiService.createMutableAnonRequest(URL(string:"https://vinci-server.herokuapp.com/login-app"), method: "POST", parameters: ["email":data["email"]! as AnyObject,"pass":data["id"]! as AnyObject], requestCompletionFunction: {responseCode, json in
                            if responseCode/100 == 2{
                                if json["userId"].stringValue != ""{
                                    self.dismiss(animated: true, completion: nil)
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    let application = UIApplication.shared
                                    let window = application.keyWindow
                                    print(json["userId"].stringValue)
                                    UserController.sharedInstance.currentUser.userId = json["userId"].stringValue
                                    APIServiceController.sharedInstance.loadCurrentInfo()
                                    window?.rootViewController = appDelegate.initTabBarController()
                                }else{
                                    print(json)
                                    self.loginFailed()
                                }
                            }else{
                                print(responseCode)
                                self.loginFailed()
                            }
                        })

//                        self.apiService.executeRequest(request, requestCompletionFunction: {responseCode, json in
//                            if responseCode/100 == 2{
//                                if json["userId"].stringValue != ""{
//                                    self.dismiss(animated: true, completion: nil)
//                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                    let application = UIApplication.shared
//                                    let window = application.keyWindow
//                                    print(json["userId"].stringValue)
//                                    UserController.sharedInstance.currentUser.userId = json["userId"].stringValue
//                                    APIServiceController.sharedInstance.loadCurrentInfo()
//                                    window?.rootViewController = appDelegate.initTabBarController()
//                                }else{
//                                    self.loginFailed()
//                                }
//                            }else{
//                                print(responseCode)
//                                self.loginFailed()
//                            }
//                        })

                    }else{
                        print(error)
                    }
                })
            }
        })
        
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let application = UIApplication.shared
        let window = application.keyWindow
        window?.rootViewController = appDelegate.initTabBarController()
//        apiService.createMutableAnonRequest(URL(string:"https://vinci-server.herokuapp.com/login-app"), method: "POST", parameters: ["email":emailTextField.text! as AnyObject,"pass":passwordTextField.text! as AnyObject], requestCompletionFunction: {responseCode, json in
//            if responseCode/100 == 2{
//                if json["userId"].stringValue != ""{
//                    self.dismiss(animated: true, completion: nil)
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    let application = UIApplication.shared
//                    let window = application.keyWindow
//                    print(json["userId"].stringValue)
//                    UserController.sharedInstance.currentUser.userId = json["userId"].stringValue
//                    UserController.sharedInstance.currentUser.emailAddress = self.emailTextField.text!
//                    UserController.sharedInstance.viewedUser = UserController.sharedInstance.currentUser
//                    APIServiceController.sharedInstance.loadCurrentInfo()
//                    window?.rootViewController = appDelegate.initTabBarController()
//                }else{
//                    self.loginFailed()
//                }
//                
//            }else{
//                print(responseCode)
//                let alert = UIAlertController(title: "Login Failed", message: "Email or password Incorrect", preferredStyle: .alert)
//                let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
//                alert.addAction(alertAction)
//                self.present(alert, animated: true, completion: nil)
//                print("error")
//            }
//        })
//
//        apiService.executeRequest(request, requestCompletionFunction: {responseCode, json in
//            if responseCode/100 == 2{
//                if json["userId"].stringValue != ""{
//                    self.dismiss(animated: true, completion: nil)
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    let application = UIApplication.shared
//                    let window = application.keyWindow
//                    print(json["userId"].stringValue)
//                    UserController.sharedInstance.currentUser.userId = json["userId"].stringValue
//                    UserController.sharedInstance.currentUser.emailAddress = self.emailTextField.text!
//                    UserController.sharedInstance.viewedUser = UserController.sharedInstance.currentUser
//                    APIServiceController.sharedInstance.loadCurrentInfo()
//                    window?.rootViewController = appDelegate.initTabBarController()
//                }else{
//                    self.loginFailed()
//                }
//
//            }else{
//                print(responseCode)
//                let alert = UIAlertController(title: "Login Failed", message: "Email or password Incorrect", preferredStyle: .alert)
//                let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
//                alert.addAction(alertAction)
//                self.present(alert, animated: true, completion: nil)
//                print("error")
//            }
//        })

    }
    func loginFailed(){
        let alert = UIAlertController(title: "Login Failed", message: "Email or password Incorrect", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
        print("error")

    }
    
    
}
extension UIViewController{
    func hideKeyboardWhenTapped(){
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    func hideKeyboardWhenTappedWithR(_ tap: UITapGestureRecognizer){
        self.view.addGestureRecognizer(tap)
    }
    func disableKeyboardWhenTappedWithR(_ tap: UITapGestureRecognizer){
        self.view.removeGestureRecognizer(tap)
    }
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
}
