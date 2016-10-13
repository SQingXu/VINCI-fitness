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

class SecondProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var doneButton: UIButton!
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

    override func viewDidLoad() {
        super.viewDidLoad()
        resultTable.delegate = self
        resultTable.dataSource = self
        searchingField.delegate = self
        searchingField.textColor = UIColor.vinciRed()
        birthdayTextField.textColor = UIColor.vinciRed()
        searchingField.placeholder = "Home Address"
        birthdayTextField.placeholder = "Birthday"
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
            apiService.createHeaderRequest(URL(string:"https://vinci-server.herokuapp.com/profile-creation/app-submit"), method: "POST", parameters: ["email": currentUser.emailAddress as AnyObject,"password":currentUser.password as AnyObject,"address":currentUser.homeAddressFull as AnyObject,"firstName":currentUser.firstName as AnyObject,"lastName":currentUser.lastName as AnyObject,"birthday":birthdayString as AnyObject], requestCompletionFunction: {
                responseCode, json in
                if responseCode/100 == 2{
                    print(json)
                    print(responseCode)
                }else{
                    print(responseCode)
                    print("error")
                }
            })
//        apiService.executeRequest(request, requestCompletionFunction: {
//            responseCode, json in
//            if responseCode/100 == 2{
//                print(json)
//                print(responseCode)
//            }else{
//                print(responseCode)
//                print("error")
//            }
//        })
        }

    }


}
