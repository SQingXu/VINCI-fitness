//
//  ProfileViewController.swift
//  VINCIFitness
//
//  Created by David Xu on 8/15/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate{

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var joinActivityButton: UIButton!
    @IBOutlet weak var hostActivityButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var homeAddressLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    var imagePicker_profile = UIImagePickerController()
    var imagePicker_cover = UIImagePickerController()
    let dateFormatter = DateFormatter()
    override func viewDidLoad() {
        let user = UserController.sharedInstance.viewedUser
        //firstNameLabel.text = "\(user.firstName) \(user.lastName)"
        if user.profileImageURL != ""{
            let picurl = URL(string: user.profileImageURL)
            profileImageView.downloadedFrom(url: picurl!, contentMode: .scaleAspectFill)
        }
        if user.coverImageUrl != ""{
            let picurl = URL(string: user.coverImageUrl)
            coverImageView.downloadedFrom(url: picurl!, contentMode: .scaleAspectFill)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imagePicker_profile.delegate = self
        imagePicker_cover.delegate = self
        bioLabel.lineBreakMode = .byWordWrapping
        bioLabel.numberOfLines = 0
        bioLabel.textColor = UIColor.vinciRed()
        homeAddressLabel.lineBreakMode = .byWordWrapping
        homeAddressLabel.numberOfLines = 0
        homeAddressLabel.textColor = UIColor.vinciRed()
        for label in labels{
            label.textColor = UIColor.vinciRed()
        }
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(self.selectImage_profile))
        let gestureRec2 = UITapGestureRecognizer(target: self, action: #selector(self.selectImage_cover))
        coverImageView.addGestureRecognizer(gestureRec2)
        profileImageView.addGestureRecognizer(gestureRec)
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.vinciRed().cgColor
        profileImageView.layer.cornerRadius = 90
        let user = UserController.sharedInstance.viewedUser
        firstNameLabel.text = "\(user.firstName) \(user.lastName)"
//        if user.profileImageURL != ""{
//            let picurl = URL(string: user.profileImageURL)
//            profileImageView.downloadedFrom(url: picurl!, contentMode: .scaleAspectFill)
//        }
//        if user.coverImageUrl != ""{
//            let picurl = URL(string: user.coverImageUrl)
//            coverImageView.downloadedFrom(url: picurl!, contentMode: .scaleAspectFill)
//        }
        firstNameLabel.textColor = UIColor.vinciRed()
        emailAddressLabel.textColor = UIColor.vinciRed()
        birthdayLabel.textColor = UIColor.vinciRed()
        dateFormatter.dateStyle = .long
        birthdayLabel.text = dateFormatter.string(from: user.birthday as Date)
        homeAddressLabel.text = user.homeAddressFull
        bioLabel.text = user.bio
        if user.emailAddress == ""{
            emailAddressLabel.text = "Unknown"
        }else{
            emailAddressLabel.text = user.emailAddress
        }
        let boolValue = UserController.sharedInstance.isTabPresented
        if boolValue{
            closeButton.isHidden = true
            hostActivityButton.layer.cornerRadius = 5
            joinActivityButton.layer.cornerRadius = 5
            signOutButton.layer.cornerRadius = 5
        }else{
            closeButton.tintColor = UIColor.vinciRed()
            coverImageView.isUserInteractionEnabled = false
            profileImageView.isUserInteractionEnabled = false
            hostActivityButton.isHidden = true
            joinActivityButton.isHidden = true
            signOutButton.isHidden = true
            
        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        UserController.sharedInstance.isTabPresented = true
        UserController.sharedInstance.viewedUser = UserController.sharedInstance.currentUser
    }
    
    @IBAction func hostActivityButtonPressed(_ sender: UIButton) {
        ActivityController.sharedInstance.currentShownActivities = UserController.sharedInstance.currentUser.hostedActivities
        ActivityController.sharedInstance.profile_activity_list = true
        self.present(ActivityListViewController(), animated: true, completion: nil)
    }
    @IBAction func joinActivityPressed(_ sender: UIButton) {
        ActivityController.sharedInstance.currentShownActivities = UserController.sharedInstance.currentUser.attendedActivities
        ActivityController.sharedInstance.profile_activity_list = true
        self.present(ActivityListViewController(), animated: true, completion: nil)
    }

    @IBAction func signOutPressed(_ sender: AnyObject) {
        UserController.sharedInstance.currentUser.userId = ""
        UserController.sharedInstance.currentUser.password = ""
        UserDefaults.standard.set(nil, forKey: "password")
        UserDefaults.standard.set(nil, forKey: "email")
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        UserController.sharedInstance.clearOut()
        MakerController.sharedInstance.clearOut()
        let application = UIApplication.shared
        let window = application.keyWindow
        window?.rootViewController = OnboardViewController()
        
    }
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func selectImage_profile(){
        imagePicker_profile.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker_profile, animated: true, completion: nil)
    }
    func selectImage_cover(){
        imagePicker_cover.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker_cover, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var link = ""
        var fileName = ""
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            if picker == imagePicker_profile{
                link = "https://vincilive2.herokuapp.com/profile/app/upload-profile"
                fileName = "profilePic"
            }else{
                link = "https://vincilive2.herokuapp.com/profile/app/upload-cover"
                fileName = "coverPic"
            }
            UserController.sharedInstance.currentUser.imageData = selectedImage
                        let imageData = UIImageJPEGRepresentation(selectedImage,0.5)
                        Alamofire.upload(multipartFormData:{multipartFormData in
                            multipartFormData.append(imageData!, withName: fileName, fileName: "this_is_a_file", mimeType: "image/jpeg")
                            multipartFormData.append(UserController.sharedInstance.currentUser.userId.data(using: String.Encoding.utf8)!, withName: "userId")
                            }, to: link, encodingCompletion: {
            
                                encodingResult in
            
                                switch encodingResult {
                                case .success(let upload, _, _):
                                    print("s")
                                    upload.responseJSON {
                                        response in
                                        print(response.request as Any)  // original URL request
                                        print(response.response as Any) // URL response
                                        print(response.data as Any)     // server data
                                        print(response.result)   // result of response serialization
                                        APIServiceController.sharedInstance.loadCurrentInfo()
                                        APIServiceController.sharedInstance.updatePersonalInfo(userId: UserController.sharedInstance.currentUser.userId)
            
                                        if let JSON = response.result.value {
                                            print("json: \(JSON)")
                                        }
                                    }
                                case .failure(let encodingError):
                                    print(encodingError)
                                    print("error in encoding")
                                }
                        })
            if picker == imagePicker_profile{
               profileImageView.image = selectedImage
               profileImageView.contentMode = .scaleAspectFill
               profileImageView.backgroundColor = UIColor.clear
            }else{
                coverImageView.image = selectedImage
                coverImageView.contentMode = .scaleAspectFill
                coverImageView.backgroundColor = UIColor.clear
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

}
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode) {
        contentMode = mode
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
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
