//
//  SecondProfileViewController.swift
//  VINCIFitness
//
//  Created by David Xu on 9/27/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlacePicker
import GooglePlaces
import Alamofire

class SecondProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UITextViewDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var birthdayTextField: DatePickerTextField!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var birthdayView: UIView!
    @IBOutlet weak var searchingField: MapAutoCompleteTextField!
    var resultTable = UITableView()
    var resultArray = [GMSAutocompletePrediction]()
    var showResultTable: Bool = true
    var isAnimating: Bool = false
    var previousString = ""
    var fullString = ""
    var placeID = ""
    var placeClient = GMSPlacesClient()
    var birthday:Date?
    let dateFormatter = DateFormatter()
    var tap:UITapGestureRecognizer = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        resultTable.delegate = self
        resultTable.dataSource = self
        searchingField.delegate = self
        bioTextView.delegate = self
        searchingField.textColor = UIColor.vinciRed()
        birthdayTextField.textColor = UIColor.vinciRed()
        searchingField.placeholder = "Home Address"
        birthdayTextField.placeholder = "Birthday"
        self.tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        var label = UILabel()
//        label.lineBreakMode = .ByWordWrapping
        
        showResultTable = false
        mapView.backgroundColor = UIColor.vinciRed()
        birthdayView.backgroundColor = UIColor.vinciRed()
        let mainScreenSize = UIScreen.main.bounds
        birthdayTextField.delegate = self
        searchingField.delegate = self

        //set up result table
        resultTable.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "resultCell")
        resultTable.rowHeight = 45
        resultTable.bounces = false
        resultTable.layer.borderColor = UIColor.vinciGrey().cgColor
        resultTable.layer.borderWidth = 1
        resultTable.backgroundColor = UIColor.clear
        self.edgesForExtendedLayout = UIRectEdge()
        resultTable.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.2 * mainScreenSize.height + 50, width: 0.8 * mainScreenSize.width, height: 0)
        bioTextView.tintColor = UIColor.vinciRed()
        bioTextView.layer.borderColor = UIColor.vinciRed().cgColor
        bioTextView.layer.borderWidth = 2
        bioTextView.layer.cornerRadius = 5
        bioTextView.textColor = UIColor.vinciRed()
        bioLabel.textColor = UIColor.vinciRed()
        
        
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.noFilter
        searchingField.searchingClosure = {(textField) in
            if self.searchingField.text != ""{
                let callback: GMSAutocompletePredictionsCallback = {(results, error)-> Void in
                    guard error == nil else {
                        print("Autocomplete error \(error)")
                        return
                    }
                    self.resultArray = [GMSAutocompletePrediction]()
                    for result in results! {
                        //                    print("Result \(result.attributedFullText) with placeID \(result.placeID)")
                        //                    self.resultArray.append(NSMutableAttributedString(attributedString: result.attributedFullText).string)
                        //                    print(NSMutableAttributedString(attributedString: result.attributedPrimaryText).string)
                        self.resultArray.append(result)
                    }
                    self.resultTable.reloadData()
                    self.showResultTableView()
                }
                self.placeClient.autocompleteQuery(self.searchingField.text!, bounds: nil, filter: filter, callback: callback)
            }
        }
        self.view.addSubview(resultTable)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! SearchTableViewCell
        newCell.addressLabel.text = NSMutableAttributedString(attributedString: resultArray[(indexPath as NSIndexPath).row].attributedPrimaryText).string
        newCell.locationLabel.text = NSMutableAttributedString(attributedString: resultArray[(indexPath as NSIndexPath).row].attributedSecondaryText!).string
        newCell.preservesSuperviewLayoutMargins = false
        
        newCell.separatorInset = UIEdgeInsets.zero
        newCell.layoutMargins = UIEdgeInsets.zero
        return newCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.placeID = resultArray[(indexPath as NSIndexPath).row].placeID!
        self.previousString = NSMutableAttributedString(attributedString: resultArray[(indexPath as NSIndexPath).row].attributedPrimaryText).string
        self.fullString = NSMutableAttributedString(attributedString: resultArray[(indexPath as NSIndexPath).row].attributedFullText).string
        self.searchingField.endEditing(true)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.hideKeyboardWhenTappedWithR(tap)
        animateViewMoving(true, moveValue: 150)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.disableKeyboardWhenTappedWithR(tap)
        animateViewMoving(false, moveValue: 150)
        UserController.sharedInstance.currentUser.bio = textView.text
    }
    func animateViewMoving (_ up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }

    func hideResultTableView(){
        var frame = resultTable.frame
        frame.size.height = 0
        self.animateTableToFrame(frame, completion: {})
        showResultTable = false
    }
    func showResultTableView(){
        var frame = resultTable.frame
        frame.size.height = CGFloat(resultArray.count) * resultTable.rowHeight
        self.animateTableToFrame(frame, completion: {})
        showResultTable = true
    }
    func animateTableToFrame(_ frame: CGRect, completion:() -> Void) {
        if (!isAnimating) {
            isAnimating = true
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in self.resultTable.frame = frame }, completion: { (completed: Bool) -> Void in
                self.isAnimating = false } )
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == searchingField{
            showResultTableView()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchingField{
            hideResultTableView()
            self.searchingField.text = previousString
        }
        if textField == birthdayTextField{
            birthday = birthdayTextField.selectedDate as Date
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    @IBAction func donePressed(_ sender: AnyObject) {
        if birthday == nil || fullString == ""{
            let alert = UIAlertController(title: "Information incomplete", message: "You need to fill all the information we need", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            
        }else{
        UserController.sharedInstance.currentUser.homeAddressFull = fullString
        UserController.sharedInstance.currentUser.birthday = birthday!
        let currentUser = UserController.sharedInstance.currentUser
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let birthdayString = dateFormatter.string(from: currentUser.birthday as Date)
        let apiService = APIService()
            doneButton.isEnabled = false
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            apiService.createHeaderRequest(URL(string:"https://vinci-server.herokuapp.com/profile-creation/app-submit"), method: "POST", parameters: ["email": currentUser.emailAddress as AnyObject,"password":currentUser.password as AnyObject,"address":currentUser.homeAddressFull as AnyObject,"firstName":currentUser.firstName as AnyObject,"lastName":currentUser.lastName as AnyObject,"birthday":birthdayString as AnyObject], requestCompletionFunction: {
                responseCode, json1 in
                if responseCode/100 == 2{
                    //log in with information
                    apiService.createMutableAnonRequest(URL(string:"https://vincilive2.herokuapp.com/login"), method: "POST", parameters: ["email":currentUser.emailAddress as AnyObject,"pass":currentUser.password as AnyObject], requestCompletionFunction: {responseCode, json2 in
                        if responseCode/100 == 2{
                            print(json2)
                            if json2["userId"].stringValue != ""{
                                print(json2["userId"].stringValue)
                                UserController.sharedInstance.currentUser.userId = json2["userId"].stringValue
                                currentUser.userId = json2["userId"].stringValue
                                //upload image profile
                                if currentUser.imageData != nil{
                                    //user did select a image as profile
                                let imageData = UIImageJPEGRepresentation(currentUser.imageData!,0.5)
                                Alamofire.upload(multipartFormData:{multipartFormData in
                                    multipartFormData.append(imageData!, withName: "profilePic", fileName: "this_is_a_file", mimeType: "image/jpeg")
                                    multipartFormData.append(json2["userId"].stringValue.data(using: String.Encoding.utf8)!, withName: "userId")
                                    }, to: "https://vinci-server.herokuapp.com/profile/app/upload-profile", encodingCompletion: {
                                        
                                        encodingResult in
                                        
                                        switch encodingResult {
                                        case .success(let upload, _, _):
//                                            print("s")
                                            upload.responseJSON {
                                                response in
//                                              serialization
                                                
                                                if let JSON = response.result.value {
                                                    print("json: \(JSON)")
                                                }
                                                //upload bio
                                                apiService.createMutableAnonRequest(URL(string:"https://vinci-server.herokuapp.com/profile/app-upload-bio"), method: "POST", parameters: ["bio":currentUser.bio as AnyObject,"userId":currentUser.userId as AnyObject], requestCompletionFunction: {responseCode, json3 in
                                                    if responseCode/100 == 2{
                                                        //log in
                                                        
                                                        apiService.createHeaderRequest(URL(string: "https://vinci-server.herokuapp.com/profile/app/" + currentUser.userId), method: "GET", parameters: nil, requestCompletionFunction: {
                                                            responseCode, json in
                                                            if responseCode/100 == 2{
                                                                print(json)
                                                                UserController.sharedInstance.currentUser.bio = json["biography"].stringValue
                                                                UserController.sharedInstance.currentUser.profileImageURL = json["imageProfile"].stringValue
                                                                UserController.sharedInstance.currentUser.firstName = json["firstName"].stringValue
                                                                UserController.sharedInstance.currentUser.lastName = json["lastName"].stringValue
                                                                self.dateFormatter.dateFormat = "yyyy-MM-dd"
                                                                UserController.sharedInstance.currentUser.birthday = self.dateFormatter.date(from: json["birthday"].stringValue)!
                                                                UserController.sharedInstance.currentUser.homeAddressFull = json["address"].stringValue
                                                                UserController.sharedInstance.viewedUser = UserController.sharedInstance.currentUser
                                                                self.activityIndicator.stopAnimating()
                                                                self.activityIndicator.isHidden = true
                                                                self.dismiss(animated: true, completion: nil)
                                                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                                                let application = UIApplication.shared
                                                                let window = application.keyWindow
                                                                window?.rootViewController = appDelegate.initTabBarController()
                                                            }else{
                                                                print("error")
                                                                
                                                            }
                                                        })

                                                    }else{
                                                        print("uploading bio error")
                                                        self.loginFailed()
                                                    }
                                                
                                                })
                                            }
                                        case .failure(let encodingError):
                                            print(encodingError)
                                            print("error in encoding")
                                            self.loginFailed()
                                        }
                                })
                                }else{
                                    //user did not select a picture
                                    apiService.createMutableAnonRequest(URL(string:"https://vinci-server.herokuapp.com/profile/app-upload-bio"), method: "POST", parameters: ["bio":currentUser.bio as AnyObject,"userId":currentUser.userId as AnyObject], requestCompletionFunction: {responseCode, json3 in
                                        if responseCode/100 == 2{
                                            //log in
                                            self.activityIndicator.stopAnimating()
                                            self.activityIndicator.isHidden = true
                                            self.dismiss(animated: true, completion: nil)
                                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                            let application = UIApplication.shared
                                            let window = application.keyWindow
                                            
                                            APIServiceController.sharedInstance.loadCurrentInfo()
                                            window?.rootViewController = appDelegate.initTabBarController()
                                        }else{
                                            print("uploading bio error")
                                            self.loginFailed()
                                        }
                                        
                                    })
                                }
                                
                            }else{
                                print("userId is empty")
                                print(json2)
                                self.loginFailed()
                            }
                        }else{
                            print("log in error")
                            print(json2)
                            print(responseCode)
                            self.loginFailed()
                        }
                    })

                }else{
                    print(responseCode)
                    print("register error")
                    self.loginFailed()
                }
            })

        }

    }
    
    func loginFailed(){
        let alert = UIAlertController(title: "Connection Error", message: "Please try again", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }


}
