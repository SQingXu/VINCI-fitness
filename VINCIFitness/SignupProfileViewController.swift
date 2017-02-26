//
//  SignupProfileViewController.swift
//  VINCIFitness
//
//  Created by David Xu on 8/16/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit
import ImageLoader
import GoogleAPIClient
import GTMOAuth2
import Alamofire


class SignupProfileViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate {
    fileprivate let kKeychainItemName = "Drive API"
    fileprivate let kClientID = "820518719195-nmg9uf7b4tqkmghvm2spt369gp1ufj8d.apps.googleusercontent.com"
    fileprivate let scopes = [kGTLAuthScopeDriveMetadataReadonly]
    fileprivate let service = GTLServiceDrive()
    
    var genderPicker = UIPickerView()
    var keyBoardTool = UIToolbar()
    let genderArray = ["Male", "Female"]
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var genderTextField: UITextField!
//    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
//    @IBOutlet weak var nextStepButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderTextField.delegate = self
        ageTextField.delegate = self
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        imagePicker.delegate = self
        
        
        genderTextField.inputView = genderPicker
        lastNameView.backgroundColor = UIColor.vinciRed()
        firstNameView.backgroundColor = UIColor.vinciRed()
        genderView.backgroundColor = UIColor.vinciRed()
        ageView.backgroundColor = UIColor.vinciRed()
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.resign))
        keyBoardTool.frame = CGRect(x: 0, y: 0, width: genderView.frame.width, height: 40)
        keyBoardTool.setItems([space,doneButton], animated: true)
        genderTextField.inputAccessoryView = keyBoardTool
        ageTextField.inputAccessoryView = keyBoardTool
        
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(self.selectImage))
        profileImageView.addGestureRecognizer(gestureRec)
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.cornerRadius = 80
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.vinciRed().cgColor
        
        //load the info if the user already sign up with facebook
        let currentUser = UserController.sharedInstance.currentUser
        firstNameTextField.text = currentUser.firstName
        lastNameTextField.text = currentUser.lastName
        if currentUser.age != nil{
        ageTextField.text = String(currentUser.age!)
        }
        if currentUser.gender == nil{
            genderTextField.text = ""
        }else if currentUser.gender == .Male{
            genderTextField.text = "Male"
        }else if currentUser.gender == .Female{
            genderTextField.text = "Female"
        }
        if currentUser.profileImageURL != ""{
////            let picurl = URL(string: currentUser.profileImageURL)
////            profileImageView.load(picurl!)
//            Alamofire.download(currentUser.profileImageURL).responseData { response in
//                if let data = response.result.value {
//                    self.profileImageView.image = UIImage(data: data)
//                }
//            }
        }
        
        self.hideKeyboardWhenTapped()
    }
//
    override func viewDidAppear(_ animated: Bool) {
        

    }

    //handle the input picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArray[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.genderTextField.text = genderArray[row]
    }
    func resign(){
        ageTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
    }

    //make the screen moving up when editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(true, moveValue: 200)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(false, moveValue: 200)
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
    
    //image selector
    func selectImage(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        UserController.sharedInstance.currentUser.age = Int(ageTextField.text!)
        UserController.sharedInstance.currentUser.firstName = firstNameTextField.text!
        UserController.sharedInstance.currentUser.lastName = lastNameTextField.text!
        if genderTextField.text == "Male"{
            UserController.sharedInstance.currentUser.gender = Gender.Male
        }else{
            UserController.sharedInstance.currentUser.gender = Gender.Female
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            UserController.sharedInstance.currentUser.imageData = selectedImage
//            let imageData = UIImageJPEGRepresentation(selectedImage,0.5)
//            Alamofire.upload(multipartFormData:{multipartFormData in
//                multipartFormData.append(imageData!, withName: "profilePic", fileName: "this_is_a_file", mimeType: "image/jpeg")
//                multipartFormData.append("e1nxesjhlax8jd".data(using: String.Encoding.utf8)!, withName: "userId")
//                }, to: "https://vinci-server.herokuapp.com/profile/app/upload-profile", encodingCompletion: {
//            
//                    encodingResult in
//                    
//                    switch encodingResult {
//                    case .success(let upload, _, _):
//                        print("s")
//                        upload.responseJSON {
//                            response in
//                            print(response.request)  // original URL request
//                            print(response.response) // URL response
//                            print(response.data)     // server data
//                            print(response.result)   // result of response serialization
//                            
//                            if let JSON = response.result.value {
//                                print("json: \(JSON)")
//                            }
//                        }
//                    case .failure(let encodingError):
//                        print(encodingError)
//                        print("error in encoding")
//                    }
//            })
            

            
            print(info[UIImagePickerControllerReferenceURL])
            profileImageView.image = selectedImage
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.backgroundColor = UIColor.clear
            }
        self.dismiss(animated: true, completion: nil)
    }
    
    // Helper for showing an alert
    func showAlert(_ title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    
}

extension UIView {
    
    func round()
    {
        let square = CGSize(width: min(self.bounds.width, self.bounds.height), height: min(self.bounds.width, self.bounds.height))
        let center = CGPoint(x: square.width / 2, y: square.height / 2)
        
        let circlePath = UIBezierPath(arcCenter: center, radius: CGFloat(square.width/2), startAngle: CGFloat(0), endAngle: CGFloat(M_PI * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 1.0
        
        self.layer.mask = shapeLayer
        
    }
    
}

